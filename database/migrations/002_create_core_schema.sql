-- Migration: 002_create_core_schema.sql
-- Description: Complete Phase 0 Core Schema (Event Sourcing, Verification, Artifacts)
-- Author: Database-Designer-Agent
-- Date: 2026-02-16
-- Previous Migration: 001_phase0_core_schema.sql

-- ============================================================================
-- CLEANUP / TRANSITION FROM 001 (If needed)
-- ============================================================================

-- Drop placeholder tables from 001 if they exist and we want to replace them with full versions
-- We use DO blocks to avoid errors if they don't exist
DO $$ BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'tasks') THEN
        DROP TABLE tasks CASCADE;
    END IF;
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'artifacts') THEN
        DROP TABLE artifacts CASCADE;
    END IF;
END $$;

-- ============================================================================
-- ENUMS (Ensure they exist)
-- ============================================================================

DO $$ BEGIN
    CREATE TYPE task_status AS ENUM ('OPEN', 'CLAIMED', 'EXECUTING', 'SUBMITTED', 'VERIFYING', 'VERIFIED', 'REJECTED');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE artifact_type AS ENUM ('SPECIFICATION', 'PROOF_OF_WORK', 'VERIFICATION_REPORT', 'database_schema', 'api_specification', 'task_contract', 'component_specification');
EXCEPTION
    WHEN duplicate_object THEN 
        -- If enum exists, we might need to add values if they are missing. 
        -- For simplicity in Phase 0, we assume it's either fresh or compatible enough.
        -- ALTER TYPE artifact_type ADD VALUE IF NOT EXISTS 'database_schema';
        null;
END $$;

-- ============================================================================
-- IMMUTABLE TABLES (Append-Only, Never UPDATE or DELETE)
-- ============================================================================

-- Events Table: Core event sourcing log
-- (001 created this, we ensure it exists and has correct columns/constraints)
CREATE TABLE IF NOT EXISTS events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  specversion VARCHAR(10) NOT NULL DEFAULT '1.0',
  type VARCHAR(100) NOT NULL,
  source VARCHAR(200) NOT NULL,
  subject VARCHAR(200), -- Optional: entity affected (task_id, agent_id)
  time TIMESTAMPTZ NOT NULL DEFAULT now(),
  datacontenttype VARCHAR(50) NOT NULL DEFAULT 'application/json',
  dataschema VARCHAR(500), -- Optional: schema URI
  data JSONB NOT NULL,
  
  -- Constraints
  CONSTRAINT valid_event_type CHECK (type ~ '^taskmarket\.[a-z_]+\.[a-z_]+$'),
  CONSTRAINT non_empty_data CHECK (data != '{}'::jsonb)
);

-- Indexes for events (IF NOT EXISTS)
CREATE INDEX IF NOT EXISTS idx_events_type_time ON events(type, time DESC);
CREATE INDEX IF NOT EXISTS idx_events_subject ON events(subject) WHERE subject IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_events_source ON events(source);
CREATE INDEX IF NOT EXISTS idx_events_data_gin ON events USING GIN(data); -- For JSONB queries
CREATE INDEX IF NOT EXISTS idx_events_time ON events(time DESC); -- For temporal queries

-- Immutability trigger for events (Ensure it's there)
CREATE OR REPLACE FUNCTION reject_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'This table is immutable. Cannot UPDATE or DELETE. Create a new row instead.';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS prevent_event_modification ON events;
CREATE TRIGGER prevent_event_modification
BEFORE UPDATE OR DELETE ON events
FOR EACH ROW
EXECUTE FUNCTION reject_modification();

-- Verification Reports Table: Quality assessments (append-only)
CREATE TABLE IF NOT EXISTS verification_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id VARCHAR(50) NOT NULL, -- TASK-XXX format
  verifier_id VARCHAR(200) NOT NULL, -- agent_id
  verification_type VARCHAR(20) NOT NULL, -- primary|secondary|consensus
  score INTEGER NOT NULL,
  dimension_scores JSONB NOT NULL, -- 6 dimensions: {capability: 15, accountability: 15, ...}
  test_results JSONB, -- Optional: {passed: 10, total: 10, coverage: 87, failures: []}
  feedback TEXT NOT NULL,
  recommendation VARCHAR(20) NOT NULL, -- APPROVE|APPROVE_WITH_NOTES|REVISE|REJECT
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  
  -- Constraints
  CONSTRAINT valid_score CHECK (score >= 0 AND score <= 100),
  CONSTRAINT valid_verification_type CHECK (verification_type IN ('primary', 'secondary', 'consensus')),
  CONSTRAINT valid_recommendation CHECK (recommendation IN ('APPROVE', 'APPROVE_WITH_NOTES', 'REVISE', 'REJECT')),
  CONSTRAINT six_dimensions_present CHECK (
    dimension_scores ?& ARRAY['capability', 'accountability', 'quality', 'temporality', 'context', 'artifact']
  )
);

CREATE INDEX IF NOT EXISTS idx_verification_task ON verification_reports(task_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_verification_verifier ON verification_reports(verifier_id);
CREATE INDEX IF NOT EXISTS idx_verification_score ON verification_reports(score);

DROP TRIGGER IF EXISTS prevent_verification_modification ON verification_reports;
CREATE TRIGGER prevent_verification_modification
BEFORE UPDATE OR DELETE ON verification_reports
FOR EACH ROW
EXECUTE FUNCTION reject_modification();

-- Agent Artifacts Table: Polymorphic artifacts (versioned, immutable after verification)
CREATE TABLE IF NOT EXISTS agent_artifacts (
  artifact_id VARCHAR(100) PRIMARY KEY, -- e.g., 'schema-v1-2026-02-15'
  artifact_type VARCHAR(50) NOT NULL, -- database_schema|api_specification|task_contract|etc.
  produced_by VARCHAR(200) NOT NULL, -- agent_id
  task_id VARCHAR(50) NOT NULL,
  canonical_representation JSONB NOT NULL, -- {format: 'json_schema_extended', content: {...}}
  metadata JSONB NOT NULL, -- {created_at, verified_score, immutable, version}
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  
  CONSTRAINT canonical_has_format CHECK (canonical_representation ? 'format'),
  CONSTRAINT canonical_has_content CHECK (canonical_representation ? 'content')
);

CREATE INDEX IF NOT EXISTS idx_artifacts_type ON agent_artifacts(artifact_type);
CREATE INDEX IF NOT EXISTS idx_artifacts_task ON agent_artifacts(task_id);
CREATE INDEX IF NOT EXISTS idx_artifacts_producer ON agent_artifacts(produced_by);

-- Task Execution Notes Table: Agent observations during work (append-only)
CREATE TABLE IF NOT EXISTS task_execution_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id VARCHAR(50) NOT NULL,
  agent_id VARCHAR(200) NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
  note TEXT NOT NULL,
  note_type VARCHAR(50), -- progress|blocker|decision|question|observation
  metadata JSONB, -- Optional: {related_file, related_agent, severity}
  
  -- Constraints
  CONSTRAINT valid_note_type CHECK (note_type IN ('progress', 'blocker', 'decision', 'question', 'observation'))
);

CREATE INDEX IF NOT EXISTS idx_execution_notes_task ON task_execution_notes(task_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_execution_notes_agent ON task_execution_notes(agent_id);
CREATE INDEX IF NOT EXISTS idx_execution_notes_type ON task_execution_notes(note_type);

DROP TRIGGER IF EXISTS prevent_notes_modification ON task_execution_notes;
CREATE TRIGGER prevent_notes_modification
BEFORE UPDATE OR DELETE ON task_execution_notes
FOR EACH ROW
EXECUTE FUNCTION reject_modification();

-- ============================================================================
-- REFERENCE TABLES (Read-Only for Agents, Admin-Managed)
-- ============================================================================

-- Agent Specifications Table: Agent role definitions
CREATE TABLE IF NOT EXISTS agent_specifications (
  agent_id VARCHAR(200) PRIMARY KEY,
  role VARCHAR(100) NOT NULL, -- DB-Specialist-Agent, Primary-Verifier, etc.
  display_name VARCHAR(200) NOT NULL,
  version VARCHAR(20) NOT NULL,
  phase INTEGER NOT NULL, -- 0-5
  status VARCHAR(20) NOT NULL, -- active|inactive|deprecated
  description TEXT NOT NULL,
  capabilities JSONB NOT NULL, -- [{capability_id, skill_level, evidence}, ...]
  tools_available JSONB NOT NULL, -- ['read', 'edit', 'new', ...]
  tools_forbidden JSONB, -- ['runTests', ...] (optional)
  mcp_access JSONB NOT NULL, -- {read_tables, write_tables, write_scope, forbidden_operations}
  raci_assignments JSONB, -- {workflow_name: {activity: 'R|A|C|I'}}
  quality_standards JSONB,
  context_loading JSONB, -- {tier_1_always, tier_2_conditional, tier_3_on_demand}
  handoffs JSONB, -- {after_completion: {target_agent, prompt_template, ...}}
  sanctuary_culture_guidelines JSONB,
  metadata JSONB NOT NULL, -- {created_at, created_by, last_updated, ...}
  
  -- Constraints
  CONSTRAINT valid_phase CHECK (phase BETWEEN 0 AND 5),
  CONSTRAINT valid_status CHECK (status IN ('active', 'inactive', 'deprecated'))
);

CREATE INDEX IF NOT EXISTS idx_agent_specs_role ON agent_specifications(role);
CREATE INDEX IF NOT EXISTS idx_agent_specs_phase ON agent_specifications(phase);
CREATE INDEX IF NOT EXISTS idx_agent_specs_status ON agent_specifications(status);

-- Reference Documentation Table: Context for agents (3-tier hierarchy)
CREATE TABLE IF NOT EXISTS reference_documentation (
  doc_id VARCHAR(200) PRIMARY KEY,
  category VARCHAR(100) NOT NULL, -- quickref|patterns|project_vision|data_model|etc.
  tier VARCHAR(20) NOT NULL, -- always_loaded|conditional|on_demand
  title VARCHAR(500) NOT NULL,
  content TEXT NOT NULL, -- Markdown format
  tags JSONB, -- ['event-sourcing', 'database', ...] for filtering
  applicable_roles JSONB, -- ['DB-Specialist-Agent', 'API-Specialist-Agent', ...] (null = all)
  phase INTEGER, -- Null = all phases
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  
  -- Constraints
  CONSTRAINT valid_tier CHECK (tier IN ('always_loaded', 'conditional', 'on_demand'))
);

CREATE INDEX IF NOT EXISTS idx_ref_docs_category ON reference_documentation(category);
CREATE INDEX IF NOT EXISTS idx_ref_docs_tier ON reference_documentation(tier);
CREATE INDEX IF NOT EXISTS idx_ref_docs_tags_gin ON reference_documentation USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_ref_docs_phase ON reference_documentation(phase);

-- Ontology Definitions Table: 6-dimension framework
CREATE TABLE IF NOT EXISTS ontology_definitions (
  dimension VARCHAR(50) PRIMARY KEY,
  description TEXT NOT NULL,
  evaluation_criteria JSONB NOT NULL, -- [{criterion, points, examples}, ...]
  phase INTEGER NOT NULL, -- 0 = foundational, 1+ = evolution
  
  -- Constraints
  CONSTRAINT valid_dimension CHECK (dimension IN (
    'capability', 'accountability', 'quality', 'temporality', 'context', 'artifact'
  ))
);

-- RACI Matrices Table: Responsibility assignments per workflow
CREATE TABLE IF NOT EXISTS raci_matrices (
  workflow_id VARCHAR(200) PRIMARY KEY,
  workflow_name VARCHAR(500) NOT NULL,
  phase INTEGER NOT NULL,
  version VARCHAR(20) NOT NULL,
  activities JSONB NOT NULL, -- [{activity_id, activity_name, raci: {agent: 'R|A|C|I'}, notes}, ...]
  escalation_paths JSONB, -- {conflict_type: 'Agent1 → Agent2 → Human-Lead'}
  metadata JSONB NOT NULL,
  
  -- Constraints
  CONSTRAINT valid_phase CHECK (phase BETWEEN 0 AND 5)
);

CREATE INDEX IF NOT EXISTS idx_raci_phase ON raci_matrices(phase);

-- Artifact Schemas Table: Polymorphic artifact type definitions
CREATE TABLE IF NOT EXISTS artifact_schemas (
  schema_id VARCHAR(200) PRIMARY KEY,
  artifact_type VARCHAR(50) NOT NULL,
  version VARCHAR(20) NOT NULL,
  canonical_format VARCHAR(100) NOT NULL, -- json_schema_extended|openapi_v3|etc.
  schema_definition JSONB NOT NULL, -- JSON Schema or similar
  supported_views JSONB NOT NULL, -- [{format, consumer, generation_method}, ...]
  phase INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_artifact_schemas_type ON artifact_schemas(artifact_type);

-- ============================================================================
-- MUTABLE TABLES (Only for Active Task State, Changes Logged to Events)
-- ============================================================================

-- Task Contracts Table: Current task status (state machine)
CREATE TABLE IF NOT EXISTS task_contracts (
  task_id VARCHAR(50) PRIMARY KEY, -- TASK-XXX format
  title VARCHAR(500) NOT NULL,
  created_by VARCHAR(200) NOT NULL,
  assigned_to VARCHAR(200), -- agent_id (nullable until claimed)
  status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  phase INTEGER NOT NULL,
  week INTEGER,
  description TEXT,
  acceptance_criteria JSONB NOT NULL, -- [{id, description, given, when, then}, ...]
  test_requirements JSONB NOT NULL,
  proof_requirements JSONB NOT NULL,
  six_dimensions JSONB NOT NULL, -- Full 6-dimension specification
  sanctuary_culture_notes TEXT,
  metadata JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  
  -- Constraints
  CONSTRAINT valid_status CHECK (status IN (
    'OPEN', 'CLAIMED', 'EXECUTING', 'SUBMITTED', 'VERIFYING', 'VERIFIED', 'REJECTED'
  )),
  CONSTRAINT valid_phase CHECK (phase BETWEEN 0 AND 5),
  CONSTRAINT six_dimensions_complete CHECK (
    six_dimensions ?& ARRAY['capability', 'accountability', 'quality', 'temporality', 'context', 'artifact']
  )
);

CREATE INDEX IF NOT EXISTS idx_task_status ON task_contracts(status);
CREATE INDEX IF NOT EXISTS idx_task_assigned ON task_contracts(assigned_to);
CREATE INDEX IF NOT EXISTS idx_task_phase_week ON task_contracts(phase, week);

-- Trigger: Log state changes to events table (CTE atomic transaction pattern)
CREATE OR REPLACE FUNCTION log_task_state_change()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.status IS DISTINCT FROM NEW.status THEN
    INSERT INTO events (type, source, subject, data)
    VALUES (
      'taskmarket.task.statechange',
      COALESCE(NEW.assigned_to, 'system'),
      NEW.task_id,
      jsonb_build_object(
        'task_id', NEW.task_id,
        'agent_id', COALESCE(NEW.assigned_to, 'unassigned'),
        'previous_status', OLD.status,
        'new_status', NEW.status,
        'timestamp', now()
      )
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS task_state_change_logger ON task_contracts;
CREATE TRIGGER task_state_change_logger
AFTER UPDATE ON task_contracts
FOR EACH ROW
EXECUTE FUNCTION log_task_state_change();

-- Agent Profiles Table: Current agent availability (Phase 1+ adds trust scores)
CREATE TABLE IF NOT EXISTS agent_profiles (
  agent_id VARCHAR(200) PRIMARY KEY,
  display_name VARCHAR(200) NOT NULL,
  role VARCHAR(100) NOT NULL,
  status VARCHAR(20) NOT NULL, -- available|busy|offline
  current_task_id VARCHAR(50), -- TASK-XXX (nullable)
  trust_score INTEGER DEFAULT 0, -- Phase 1+ (0-100)
  reputation_tier VARCHAR(20) DEFAULT 'Explorer', -- Phase 1+ (Explorer|Contributor|Steward|Guardian)
  capabilities JSONB NOT NULL, -- ['database-design', 'postgresql-proficiency', ...]
  metadata JSONB,
  last_active TIMESTAMPTZ NOT NULL DEFAULT now(),
  
  -- Constraints
  CONSTRAINT valid_status CHECK (status IN ('available', 'busy', 'offline')),
  CONSTRAINT valid_trust_score CHECK (trust_score BETWEEN 0 AND 100),
  CONSTRAINT valid_reputation_tier CHECK (reputation_tier IN ('Explorer', 'Contributor', 'Steward', 'Guardian'))
);

CREATE INDEX IF NOT EXISTS idx_agent_profiles_status ON agent_profiles(status);
CREATE INDEX IF NOT EXISTS idx_agent_profiles_role ON agent_profiles(role);

-- ============================================================================
-- VIEWS (Convenience Queries)
-- ============================================================================

CREATE OR REPLACE VIEW active_tasks AS
SELECT 
  task_id,
  title,
  assigned_to,
  status,
  phase,
  created_at,
  updated_at
FROM task_contracts
WHERE status IN ('OPEN', 'CLAIMED', 'EXECUTING', 'SUBMITTED', 'VERIFYING')
ORDER BY created_at ASC;

CREATE OR REPLACE VIEW task_state_history AS
SELECT 
  subject AS task_id,
  time AS transition_time,
  data->>'previous_status' AS from_status,
  data->>'new_status' AS to_status,
  source AS agent_id
FROM events
WHERE type = 'taskmarket.task.statechange'
ORDER BY subject, time ASC;

CREATE OR REPLACE VIEW latest_verifications AS
SELECT DISTINCT ON (task_id)
  task_id,
  verifier_id,
  verification_type,
  score,
  recommendation,
  created_at
FROM verification_reports
ORDER BY task_id, created_at DESC;

-- ============================================================================
-- SEED DATA (Phase 0 Bootstrap)
-- ============================================================================

-- Insert 6-dimension ontology definitions (On Conflict Do Nothing)
INSERT INTO ontology_definitions (dimension, description, evaluation_criteria, phase) VALUES
('capability', 'What can be done - agent skills and task requirements', '[]'::jsonb, 0),
('accountability', 'Who is responsible - RACI matrix and escalation paths', '[]'::jsonb, 0),
('quality', 'How well is it done - verification rubric and standards', '[]'::jsonb, 0),
('temporality', 'When and in what sequence - dependencies and state transitions', '[]'::jsonb, 0),
('context', 'What information is needed - documentation hierarchy', '[]'::jsonb, 0),
('artifact', 'What is produced - deliverables and traceability', '[]'::jsonb, 0)
ON CONFLICT (dimension) DO NOTHING;
