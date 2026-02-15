-- Migration: 001_phase0_core_schema.sql
-- Description: Initial schema for Phase 0 Task Contract Mechanics
-- Author: Database-Designer-Agent
-- Date: 2026-02-15

-- Enable UUID extension if not enabled
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- ENUMS
-- ============================================================================

DO $$ BEGIN
    CREATE TYPE task_status AS ENUM ('OPEN', 'IN_PROGRESS', 'IN_REVIEW', 'COMPLETED', 'CANCELLED');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE artifact_type AS ENUM ('SPECIFICATION', 'PROOF_OF_WORK', 'VERIFICATION_REPORT');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================================================
-- EVENTS TABLE (Immutable Ledger)
-- ============================================================================

CREATE TABLE IF NOT EXISTS events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  specversion VARCHAR(10) NOT NULL DEFAULT '1.0',
  type VARCHAR(100) NOT NULL,
  source VARCHAR(200) NOT NULL,
  subject VARCHAR(200),
  time TIMESTAMPTZ NOT NULL DEFAULT now(),
  datacontenttype VARCHAR(50) NOT NULL DEFAULT 'application/json',
  dataschema VARCHAR(500),
  data JSONB NOT NULL,
  
  CONSTRAINT valid_event_type CHECK (type ~ '^taskmarket\.[a-z_]+\.[a-z_]+$'),
  CONSTRAINT non_empty_data CHECK (data != '{}'::jsonb)
);

CREATE INDEX IF NOT EXISTS idx_events_type_time ON events(type, time DESC);
CREATE INDEX IF NOT EXISTS idx_events_subject ON events(subject) WHERE subject IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_events_source ON events(source);
CREATE INDEX IF NOT EXISTS idx_events_data_gin ON events USING GIN(data);
CREATE INDEX IF NOT EXISTS idx_events_time ON events(time DESC);

-- Immutability trigger for events
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

-- ============================================================================
-- TASKS TABLE (State Projection)
-- ============================================================================

CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  status task_status NOT NULL DEFAULT 'OPEN',
  assignee_id VARCHAR(200), -- Agent ID
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_assignee ON tasks(assignee_id);

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_tasks_timestamp ON tasks;
CREATE TRIGGER update_tasks_timestamp
BEFORE UPDATE ON tasks
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- ============================================================================
-- ARTIFACTS TABLE (Outputs)
-- ============================================================================

CREATE TABLE IF NOT EXISTS artifacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL REFERENCES tasks(id),
  agent_id VARCHAR(200) NOT NULL,
  type artifact_type NOT NULL,
  uri VARCHAR(500) NOT NULL,
  hash VARCHAR(64), -- SHA-256
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_artifacts_task_id ON artifacts(task_id);
CREATE INDEX IF NOT EXISTS idx_artifacts_agent_id ON artifacts(agent_id);
