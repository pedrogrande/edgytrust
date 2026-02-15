# Bootstrap information

## 1. Dev environment

### Github repository
https://github.com/pedrogrande/edgytrust.git

DB: SurrealDB
ENV variables are in .env file

### MCP server:
The DB MCP is setup and running 

### LLM keys
The keys are already set up in VSCode.

### Local setup
Node version: 25.2.1
Using pnpm as package manager
---
## 2. Agent execution model

Invocation method: 
Phase 0: VSCode custom agents (.agent.md files) with subagent orchestration

Primary mechanism: Custom agents in .github/agents/ directory
- Coordinator agents (Week 2+) use subagent invocation via `agents: ['agent1', 'agent2']` property
- Example: Product-Owner-Agent calls Task-Definition-Agent as subagent
- Week 1: Direct human invocation (@db-specialist, @task-definition)

Reference: https://code.visualstudio.com/docs/copilot/agents/subagents

---
Communication: 
Phase 0 uses HYBRID communication (not just database polling):

1. **Synchronous subagent calls** (within-session coordination):
   - Parent agent → Subagent (via VSCode `agent` tool)
   - Subagent returns result → Parent agent continues
   - Example: Product-Owner calls Task-Definition-Agent, receives task contracts, continues

2. **Asynchronous database state** (between execution sessions):
   - Agent A writes to task_contracts table (state: OPEN → CLAIMED)
   - Agent B queries task_contracts (finds CLAIMED tasks)
   - Agent A writes task_execution_notes (logs progress)
   - Agent C reads notes for context
   - MCP server mediates all database access

3. **Handoff buttons** (human-mediated transitions in Phase 0):
   - Task-Definition-Agent shows handoff button → "Assign to Specialist"
   - Human clicks → switches to @db-specialist with pre-filled context
   - Human approval required between agents (send: false in handoffs)

Primary for Phase 0: #3 (Handoff buttons with human in loop)
Progressive automation: Week 1 uses #3, Week 3+ experiments with #1 for tightly-coupled workflows
Phase 1+: More #1 (autonomous subagent orchestration), less human approval
---

Runtime. 
Phase 0 Runtime: VSCode extension host exclusively

Execution context:
- Agents run as VSCode Copilot extension processes
- Access to VSCode APIs via tools: vscodeAPI, runCommands, runTests, edit, etc.
- File system operations scoped to workspace directory
- Terminal commands executed via runCommands tool (for migrations, tests)
- MCP server runs as separate process (Node.js/Deno), VSCode agents connect via MCP protocol

Constraints (Phase 0):
- No standalone agent processes (all through VSCode)
- No containerized agents (Docker comes in Phase 1+ for isolation)
- No cloud-deployed agents (local development only)

Future evolution (Phase 1+):
- MCP server becomes shared runtime for distributed agents
- Agents could run as standalone processes or containers
- VSCode remains primary interface but not exclusive runtime
---

## 3. Concrete examples

### Task contract

```yaml
# File: /tasks/TASK-001-database-schema.yaml

task_id: TASK-001
title: Create Event-Sourced Database Schema
created_by: human-lead
created_at: 2026-02-15T12:09:00Z
assigned_to: DB-Specialist-Agent-001
phase: 0
week: 1
status: OPEN

description: |
  Design and implement PostgreSQL database schema with event sourcing pattern.
  Must support immutable event logging, task state management, and agent artifacts.
  This is foundational infrastructure for the entire task marketplace system.

acceptance_criteria:
  - id: AC-001
    description: Events table exists with append-only constraints
    given: Empty PostgreSQL database
    when: Migration script runs
    then: |
      - Table 'events' created with columns: id (UUID PK), event_type (VARCHAR), 
        task_id (UUID), agent_id (VARCHAR), timestamp (TIMESTAMPTZ), payload (JSONB)
      - Trigger prevents UPDATE and DELETE operations on events table
      - Index on (task_id, timestamp) for efficient querying
    
  - id: AC-002
    description: Task contracts table supports state machine
    given: Task contracts table exists
    when: State transition attempted
    then: |
      - Only valid transitions allowed: OPEN→CLAIMED→EXECUTING→SUBMITTED→VERIFYING→VERIFIED
      - Invalid transitions (e.g., CLAIMED→VERIFIED) raise constraint violation
      - State changes logged to events table via CTE transaction
    
  - id: AC-003
    description: Verification reports table stores 6-dimension scores
    given: Verification reports table exists
    when: Verifier inserts report
    then: |
      - Columns include: id, task_id, verifier_id, score (0-100), 
        dimension_scores (JSONB with 6 keys), feedback (TEXT), 
        recommendation (ENUM: APPROVE/REJECT/REVISE)
      - Dimension_scores JSONB validates 6 required keys: capability, accountability, 
        quality, temporality, context, artifact
    
  - id: AC-004
    description: Agent specifications table is read-only for agents
    given: Agent specifications populated
    when: Agent attempts INSERT/UPDATE/DELETE
    then: MCP server returns 403 Forbidden (enforced at access control layer)
    
  - id: AC-005
    description: Reference documentation table supports 3-tier hierarchy
    given: Reference documentation table exists
    when: Querying by tier
    then: |
      - Rows have 'tier' column (ENUM: always_loaded, conditional, on_demand)
      - Category column enables filtering (e.g., 'quickref', 'patterns', 'project_vision')
      - Content stored as TEXT (Markdown format)

test_requirements:
  framework: Vitest
  coverage_target: 85
  test_files:
    - path: /database/schema.test.ts
      tests:
        - name: "Events table prevents UPDATE operations"
          type: integration
        - name: "Events table prevents DELETE operations"
          type: integration
        - name: "State machine allows valid transitions"
          type: unit
        - name: "State machine rejects invalid transitions"
          type: unit
        - name: "CTE atomic transaction logs state change + event"
          type: integration
        - name: "Verification reports validate 6-dimension scores"
          type: integration
        - name: "Agent specs are readable but not writable"
          type: integration

proof_requirements:
  required_artifacts:
    - type: sql_migration
      path: /database/migrations/001_create_schema.sql
      description: DDL for all tables with constraints
    - type: test_suite
      path: /database/schema.test.ts
      description: Vitest tests with 85%+ coverage
    - type: coverage_report
      path: /coverage/lcov-report/index.html
      description: HTML coverage report showing 85%+ line coverage
    - type: polymorphic_artifact
      storage: database.agent_artifacts
      artifact_id: schema-v1-2026-02-15
      description: Canonical database schema (JSON) + generated views (SQL, TypeScript types, ERD diagram)
    - type: execution_notes
      storage: database.task_execution_notes
      description: Agent logs of design decisions and challenges encountered

six_dimensions:
  capability:
    required_skills:
      - database-design
      - postgresql-proficiency
      - event-sourcing-pattern
      - sql-ddl
      - schema-migration-tools
    skill_level: intermediate
    
  accountability:
    raci:
      responsible: DB-Specialist-Agent-001
      accountable: Human-Lead
      consulted:
        - Project-Architect-Agent (if exists in Week 1)
      informed:
        - Task-Definition-Agent
        - Primary-Verifier
        - All-Future-Agents (will use this schema)
    escalation_path: "If uncertain about event sourcing pattern → Human-Lead"
    
  quality:
    standards:
      - Immutability: Events table append-only
      - Sanctuary culture: Supportive comments in SQL (e.g., '-- Life happens: We use generous VARCHAR limits to avoid truncation errors')
      - Clean code: Consistent naming (snake_case for columns, PascalCase for types)
      - Migration readiness: All state changes logged as events
    verification_method: "Primary-Verifier scores 0-100 across 6 dimensions"
    minimum_score: 70
    
  temporality:
    dependencies: []
    blocks:
      - TASK-002-mcp-server
      - TASK-003-task-contract-schema
    deadline: 2026-02-18T00:00:00Z
    estimated_duration_hours: 8
    state_transitions:
      - from: OPEN
        to: CLAIMED
        trigger: Human assigns to DB-Specialist-Agent
      - from: CLAIMED
        to: EXECUTING
        trigger: Agent begins work
      - from: EXECUTING
        to: SUBMITTED
        trigger: Agent completes and submits proof
      - from: SUBMITTED
        to: VERIFYING
        trigger: Primary-Verifier begins evaluation
      - from: VERIFYING
        to: VERIFIED
        trigger: Verification score ≥70 and recommendation=APPROVE
        
  context:
    tier_1_always_loaded:
      - source: agent_specifications
        query: "WHERE role = 'DB-Specialist-Agent'"
      - source: task_contracts
        query: "WHERE task_id = 'TASK-001'"
      - source: patterns
        query: "WHERE tier = 'core'"
    tier_2_conditional:
      - source: reference_documentation
        query: "WHERE category = 'event-sourcing-patterns'"
        load_if: "Agent indicates need for event sourcing guidance"
      - source: patterns
        query: "WHERE tags CONTAINS 'CTE-atomic-transactions'"
        load_if: "Agent working on state transition logic"
    tier_3_on_demand:
      - source: reference_documentation
        query: "WHERE category = 'database-architecture'"
        description: "Full system database design philosophy"
      - source: external
        url: "https://martinfowler.com/eaaDev/EventSourcing.html"
        description: "Martin Fowler's event sourcing reference"
        
  artifact:
    produces:
      - artifact_id: schema-v1-2026-02-15
        artifact_type: database_schema
        storage_location: database.agent_artifacts
        polymorphic: true
        canonical_format: json_schema_extended
        generated_views:
          - format: sql_ddl
            consumer: DB-Setup-Agent
            description: "CREATE TABLE statements for deployment"
          - format: typescript_types
            consumer: API-Specialist-Agent
            description: "TypeScript interfaces for type safety"
          - format: markdown_docs
            consumer: Documentation-Writer-Agent
            description: "Human-readable schema documentation"
          - format: svg_erd
            consumer: Human-Lead
            description: "Entity Relationship Diagram for visualization"
      - artifact_id: migration-001
        artifact_type: code
        storage_location: file_system
        path: /database/migrations/001_create_schema.sql
        immutable: true
        versioned: true

sanctuary_culture_notes: |
  This is foundational infrastructure work. Take your time to understand event sourcing 
  if you're unfamiliar. Ask questions without hesitation—there are no penalties for 
  clarification requests. If you encounter ambiguity in the schema requirements, 
  document your assumptions in execution_notes and flag for human review. We're 
  learning together, and your insights will inform future iterations.
  
  Remember: "Life happens." If you need to return this task, no stigma attached. 
  We'll learn from the attempt and adjust the task definition.

metadata:
  created_by: human-lead
  reviewed_by: null
  approved_by: null
  complexity: medium
  priority: critical
  tags: [infrastructure, database, event-sourcing, phase-0, week-1]
```

### Agent spec

```json
{
  "agent_id": "DB-Specialist-Agent-001",
  "role": "DB-Specialist-Agent",
  "display_name": "Database Specialist",
  "version": "1.0.0",
  "phase": 0,
  "status": "active",
  
  "description": "Specialist agent for PostgreSQL database design, schema migrations, and event-sourced architecture implementation",
  
  "capabilities": [
    {
      "capability_id": "database-design",
      "skill_level": "expert",
      "evidence": ["Designed 10+ production schemas", "Understands normalization, indexing, constraints"]
    },
    {
      "capability_id": "postgresql-proficiency",
      "skill_level": "expert",
      "evidence": ["Writes complex DDL/DML", "Understands PG-specific features (JSONB, CTEs, triggers)"]
    },
    {
      "capability_id": "event-sourcing-pattern",
      "skill_level": "intermediate",
      "evidence": ["Implemented append-only event logs", "Understands state reconstruction from events"]
    },
    {
      "capability_id": "schema-migration-tools",
      "skill_level": "intermediate",
      "evidence": ["Experience with Prisma, Knex, or raw SQL migrations"]
    }
  ],
  
  "tools_available": [
    "read",
    "search",
    "new",
    "edit",
    "runCommands",
    "fetch",
    "githubRepo"
  ],
  
  "tools_forbidden": [
    "runTests",
    "vscodeAPI"
  ],
  
  "mcp_access": {
    "read_tables": [
      "agent_specifications",
      "reference_documentation",
      "ontology_definitions",
      "patterns",
      "task_contracts"
    ],
    "write_tables": [
      "task_execution_notes",
      "agent_artifacts"
    ],
    "write_scope": {
      "agent_id_filter": "DB-Specialist-Agent-001"
    },
    "forbidden_operations": [
      "UPDATE reference_documentation",
      "DELETE FROM events",
      "UPDATE agent_specifications"
    ]
  },
  
  "raci_assignments": {
    "database_design_workflow": {
      "design_schema": "R",
      "review_architecture": "C",
      "approve_schema": "I",
      "deploy_migrations": "R"
    },
    "task_execution_workflow": {
      "claim_task": "R",
      "execute_implementation": "R",
      "submit_proof": "R",
      "verify_quality": "I"
    }
  },
  
  "quality_standards": {
    "code_style": "SQL: snake_case, 2-space indent, explicit NOT NULL constraints",
    "testing_requirements": "85% coverage minimum, integration tests for constraints",
    "sanctuary_culture": "Supportive SQL comments explaining design decisions",
    "documentation": "Inline comments for complex queries, README for migration process"
  },
  
  "context_loading": {
    "tier_1_always": [
      {
        "source": "agent_specifications",
        "query": "WHERE role = 'DB-Specialist-Agent'"
      },
      {
        "source": "task_contracts",
        "query": "WHERE assigned_to = 'DB-Specialist-Agent-001' AND status IN ('CLAIMED', 'EXECUTING')"
      }
    ],
    "tier_2_conditional": [
      {
        "source": "reference_documentation",
        "category": "event-sourcing-patterns",
        "load_if": "Task involves state management or event logging"
      },
      {
        "source": "patterns",
        "tags": ["CTE-atomic-transactions", "immutable-tables"],
        "load_if": "Task requires transaction guarantees"
      }
    ],
    "tier_3_on_demand": [
      {
        "source": "reference_documentation",
        "category": "database-architecture",
        "description": "Full system design philosophy"
      }
    ]
  },
  
  "handoffs": {
    "after_completion": {
      "target_agent": "Primary-Verifier",
      "prompt_template": "Verify task {{task_id}} (Database Schema). Load artifacts from MCP, run tests, score across 6 dimensions.",
      "auto_send": false,
      "requires_human_approval": true
    }
  },
  
  "sanctuary_culture_guidelines": {
    "tone": "patient, educational, collaborative",
    "iteration_limit": 3,
    "escalation_trigger": "If blocked for >4 hours or 3 iterations exhausted",
    "return_task_option": true,
    "first_failure_penalty": false
  },
  
  "metadata": {
    "created_at": "2026-02-15T12:09:00Z",
    "created_by": "Agent-Foundry",
    "last_updated": "2026-02-15T12:09:00Z",
    "phase_introduced": 0,
    "phase_deprecated": null
  }
}
```

### RACI

```json
{
  "workflow_id": "task-definition-workflow",
  "workflow_name": "User Story to Task Contract Creation",
  "phase": 0,
  "version": "1.0.0",
  
  "activities": [
    {
      "activity_id": "parse-user-story",
      "activity_name": "Parse user story and extract requirements",
      "raci": {
        "Task-Definition-Agent": "R",
        "Product-Owner-Agent": "I",
        "Task-Testing-Agent": "I",
        "Human-Lead": "A"
      },
      "notes": "Task-Definition-Agent reads user story, identifies capabilities, constraints. Human-Lead has veto power."
    },
    {
      "activity_id": "generate-acceptance-criteria",
      "activity_name": "Generate 5-15 measurable acceptance criteria",
      "raci": {
        "Task-Definition-Agent": "R",
        "Product-Owner-Agent": "C",
        "Task-Testing-Agent": "C",
        "Human-Lead": "A"
      },
      "notes": "Task-Definition-Agent drafts ACs, consults Product-Owner for business logic, Task-Testing for testability. Human approves."
    },
    {
      "activity_id": "define-6-dimensions",
      "activity_name": "Specify all 6 ontology dimensions",
      "raci": {
        "Task-Definition-Agent": "R",
        "Ontology-Advisor-Agent": "C",
        "Human-Lead": "A"
      },
      "notes": "Task-Definition-Agent fills 6-dimension template, consults Ontology-Advisor if unclear. Human-Lead validates completeness."
    },
    {
      "activity_id": "design-test-strategy",
      "activity_name": "Design test strategy and list required tests",
      "raci": {
        "Task-Testing-Agent": "R",
        "Task-Definition-Agent": "C",
        "Human-Lead": "A"
      },
      "notes": "Task-Testing-Agent proposes test approach (unit/integration/e2e), Task-Definition includes in contract."
    },
    {
      "activity_id": "assign-raci",
      "activity_name": "Assign RACI roles for task execution",
      "raci": {
        "Task-Definition-Agent": "R",
        "Human-Lead": "A"
      },
      "notes": "Task-Definition-Agent suggests RACI assignments (e.g., R=DB-Specialist, A=Human-Lead), Human approves."
    },
    {
      "activity_id": "validate-sanctuary-culture",
      "activity_name": "Ensure supportive language and reversibility",
      "raci": {
        "Cultural-Steward-Agent": "R",
        "Task-Definition-Agent": "C",
        "Human-Lead": "A"
      },
      "notes": "Cultural-Steward reviews task contract for punitive language, ensures 3-attempt limit, return-task option visible."
    },
    {
      "activity_id": "review-and-approve",
      "activity_name": "Final review and approval of task contract",
      "raci": {
        "Task-Definition-Agent": "I",
        "Product-Owner-Agent": "I",
        "Task-Testing-Agent": "I",
        "Human-Lead": "A"
      },
      "notes": "Human-Lead makes final decision. Has veto power over any aspect of task contract."
    }
  ],
  
  "escalation_paths": {
    "unclear_requirements": "Task-Definition-Agent → Product-Owner-Agent → Human-Lead",
    "raci_conflict": "Task-Definition-Agent → Human-Lead (immediate)",
    "technical_feasibility": "Task-Definition-Agent → Technical-Architect-Agent → Human-Lead"
  },
  
  "phase_0_notes": "In Phase 0, Human-Lead is Accountable for ALL activities. This ensures learning and oversight. In Phase 1+, some accountability may delegate to autonomous agents (e.g., Cultural-Steward becomes Accountable for sanctuary culture validation).",
  
  "metadata": {
    "created_at": "2026-02-15T12:09:00Z",
    "source": "Context document section: Agent team accountability (RACI)"
  }
}

```

### Artifacts - Polymorphic Artifact Specification

```json
{
  "artifact_schema_id": "polymorphic-artifact-v1",
  "version": "1.0.0",
  "description": "Schema for polymorphic artifacts: canonical representation + generated views",
  
  "canonical_structure": {
    "artifact_id": {
      "type": "string",
      "format": "kebab-case with version",
      "example": "schema-v1-2026-02-15",
      "required": true
    },
    "artifact_type": {
      "type": "enum",
      "allowed_values": [
        "database_schema",
        "api_specification",
        "task_contract",
        "verification_report",
        "component_specification"
      ],
      "required": true
    },
    "produced_by": {
      "type": "string",
      "format": "agent_id",
      "example": "DB-Specialist-Agent-001",
      "required": true
    },
    "task_id": {
      "type": "string",
      "format": "TASK-XXX",
      "example": "TASK-001",
      "required": true
    },
    "canonical_representation": {
      "type": "object",
      "description": "Single source of truth for artifact content",
      "properties": {
        "format": {
          "type": "string",
          "description": "Format of canonical data",
          "examples": ["json_schema_extended", "openapi_v3", "yaml_structured"]
        },
        "content": {
          "type": "object",
          "description": "Actual artifact data in canonical format"
        }
      },
      "required": true
    },
    "metadata": {
      "type": "object",
      "properties": {
        "created_at": {
          "type": "string",
          "format": "ISO8601 datetime"
        },
        "verified_score": {
          "type": "integer",
          "minimum": 0,
          "maximum": 100,
          "description": "Verification score from Primary-Verifier"
        },
        "immutable": {
          "type": "boolean",
          "description": "Whether artifact can be modified (usually true after verification)"
        },
        "version": {
          "type": "string",
          "description": "Semantic version if artifact updated"
        }
      },
      "required": true
    }
  },
  
  "example_canonical_artifact": {
    "artifact_id": "schema-v1-2026-02-15",
    "artifact_type": "database_schema",
    "produced_by": "DB-Specialist-Agent-001",
    "task_id": "TASK-001",
    "canonical_representation": {
      "format": "json_schema_extended",
      "content": {
        "tables": {
          "task_contracts": {
            "columns": {
              "id": {
                "type": "uuid",
                "primary_key": true,
                "default": "gen_random_uuid()"
              },
              "title": {
                "type": "text",
                "nullable": false
              },
              "status": {
                "type": "enum",
                "enum_values": ["OPEN", "CLAIMED", "EXECUTING", "SUBMITTED", "VERIFYING", "VERIFIED"],
                "default": "OPEN"
              },
              "created_at": {
                "type": "timestamptz",
                "default": "now()"
              }
            },
            "constraints": {
              "check_valid_status_transition": "CREATE CONSTRAINT valid_transitions CHECK (...)"
            },
            "indexes": [
              {
                "name": "idx_status_created",
                "columns": ["status", "created_at"],
                "type": "btree"
              }
            ]
          },
          "events": {
            "columns": {
              "id": {
                "type": "uuid",
                "primary_key": true
              },
              "event_type": {
                "type": "varchar(100)",
                "nullable": false
              },
              "task_id": {
                "type": "uuid",
                "foreign_key": "task_contracts.id"
              },
              "payload": {
                "type": "jsonb"
              },
              "timestamp": {
                "type": "timestamptz",
                "default": "now()"
              }
            },
            "constraints": {
              "immutable": "CREATE TRIGGER prevent_update_delete BEFORE UPDATE OR DELETE ON events FOR EACH ROW EXECUTE FUNCTION reject_modification()"
            }
          }
        }
      }
    },
    "metadata": {
      "created_at": "2026-02-15T14:30:00Z",
      "verified_score": 95,
      "immutable": true,
      "version": "1.0.0"
    }
  },
  
  "generated_views_specification": {
    "view_format_1": {
      "format": "sql_ddl",
      "consumer": "DB-Setup-Agent",
      "generation_method": "Transform canonical JSON → CREATE TABLE statements",
      "example_output": "CREATE TABLE task_contracts (\n  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n  title TEXT NOT NULL,\n  status VARCHAR(20) CHECK (status IN ('OPEN', 'CLAIMED', ...)),\n  created_at TIMESTAMPTZ DEFAULT now()\n);\n\nCREATE INDEX idx_status_created ON task_contracts(status, created_at);"
    },
    "view_format_2": {
      "format": "typescript_types",
      "consumer": "API-Specialist-Agent",
      "generation_method": "Transform canonical JSON → TypeScript interfaces",
      "example_output": "interface TaskContract {\n  id: string; // UUID\n  title: string;\n  status: 'OPEN' | 'CLAIMED' | 'EXECUTING' | 'SUBMITTED' | 'VERIFYING' | 'VERIFIED';\n  created_at: Date;\n}\n\ninterface Event {\n  id: string;\n  event_type: string;\n  task_id: string;\n  payload: Record<string, any>;\n  timestamp: Date;\n}"
    },
    "view_format_3": {
      "format": "markdown_docs",
      "consumer": "Documentation-Writer-Agent",
      "generation_method": "Transform canonical JSON → Markdown tables",
      "example_output": "# Database Schema\n\n### task_contracts table\n\n| Column | Type | Constraints | Description |\n|--------|------|-------------|-------------|\n| id | UUID | PRIMARY KEY | Unique task identifier |\n| title | TEXT | NOT NULL | Task title |\n| status | ENUM | CHECK | Current task state |\n| created_at | TIMESTAMPTZ | DEFAULT now() | Creation timestamp |"
    },
    "view_format_4": {
      "format": "svg_erd",
      "consumer": "Human-Lead",
      "generation_method": "Transform canonical JSON → Graphviz/D3.js SVG diagram",
      "example_output": "<svg>...</svg> (Entity Relationship Diagram showing tables, columns, relationships)"
    }
  },
  
  "view_generation_api": {
    "endpoint": "GET /artifacts/:artifact_id/view",
    "parameters": {
      "format": {
        "type": "enum",
        "allowed_values": ["sql_ddl", "typescript_types", "markdown_docs", "svg_erd"],
        "required": true
      }
    },
    "response": {
      "artifact_id": "string",
      "canonical_version": "string",
      "view_format": "string",
      "generated_content": "string",
      "generated_at": "datetime",
      "cache_expiry": "datetime"
    },
    "caching_strategy": "Views cached until canonical artifact updates (new version created)"
  },
  
  "storage_strategy": {
    "canonical": "Database table: agent_artifacts.canonical_representation (JSONB column)",
    "views": "On-demand generation + cache (Redis or in-memory for Phase 0)",
    "rationale": "Canonical is source of truth. Views are derivatives that can be regenerated anytime."
  },
  
  "benefits": {
    "single_source_of_truth": "No drift between SQL, TypeScript, docs",
    "agent_efficiency": "Agents work in optimal format (JSON schema vs SQL vs types)",
    "human_flexibility": "Generate human-readable views without burdening agent workflow",
    "evolvability": "Add new view formats without touching canonical data"
  }
}
```
---

## **4. Detailed Specifications (Phase 0)**

### **Specification 1: Verification Rubric Formula**

```yaml
# File: /docs/bootstrap/specifications/verification-rubric.yaml

verification_rubric_version: "1.0.0"
phase: 0
last_updated: "2026-02-15T12:13:00Z"

scoring_system:
  total_points: 100
  minimum_passing_score: 70
  dimension_breakdown:
    capability:
      points: 15
      description: "Does implementation use required skills correctly?"
      evaluation_criteria:
        - criterion: "Required capabilities demonstrated"
          points: 5
          examples:
            - "Task requires 'database-design' → Schema follows normalization principles"
            - "Task requires 'event-sourcing-pattern' → Immutable event log implemented"
        - criterion: "Skill level appropriate"
          points: 5
          examples:
            - "Intermediate task → Uses standard patterns, no overly complex solutions"
            - "Expert task → Demonstrates advanced techniques where needed"
        - criterion: "Tool usage correct"
          points: 5
          examples:
            - "Used correct VSCode tools (edit, new, runCommands)"
            - "Followed MCP access patterns (read from reference tables, write to execution notes)"
      
    accountability:
      points: 15
      description: "Proper event logging, RACI followed?"
      evaluation_criteria:
        - criterion: "All state changes logged to events table"
          points: 7
          examples:
            - "Task claimed → event_type='task.claimed' logged"
            - "Task submitted → event_type='task.submitted' with proof artifacts"
        - criterion: "RACI assignments respected"
          points: 5
          examples:
            - "Consulted appropriate agents before decisions (if C role assigned)"
            - "Informed relevant parties after completion (if I role assigned)"
        - criterion: "Execution notes comprehensive"
          points: 3
          examples:
            - "Logged design decisions, challenges, and resolutions"
            - "Minimum 3 execution notes for tasks >4 hours"
      
    quality:
      points: 30
      description: "Tests pass, coverage adequate, sanctuary culture applied?"
      evaluation_criteria:
        - criterion: "All tests passing"
          points: 10
          examples:
            - "100% test pass rate (0 failures, 0 errors)"
            - "Integration tests confirm end-to-end functionality"
        - criterion: "Code coverage meets threshold"
          points: 10
          examples:
            - "Line coverage ≥85% (as specified in task contract)"
            - "Critical paths have 100% coverage (state transitions, validations)"
        - criterion: "Sanctuary culture compliance"
          points: 5
          examples:
            - "Error messages supportive: 'Let's fix this together' not 'Invalid input'"
            - "Comments educational: Explain WHY, not just WHAT"
        - criterion: "Code quality standards"
          points: 5
          examples:
            - "Clean code: Descriptive names, small functions, single responsibility"
            - "Linting passes: ESLint/Prettier rules satisfied"
      
    temporality:
      points: 10
      description: "Dependencies respected, state transitions correct?"
      evaluation_criteria:
        - criterion: "Dependencies satisfied"
          points: 5
          examples:
            - "Task lists TASK-001 as dependency → TASK-001 is VERIFIED before starting"
            - "No circular dependencies created"
        - criterion: "State transitions valid"
          points: 5
          examples:
            - "Task followed OPEN→CLAIMED→EXECUTING→SUBMITTED→VERIFYING flow"
            - "No invalid jumps (e.g., CLAIMED→VERIFIED)"
      
    context:
      points: 10
      description: "Documentation updated, relevant patterns applied?"
      evaluation_criteria:
        - criterion: "Documentation updated"
          points: 5
          examples:
            - "README updated if new setup steps added"
            - "Inline code comments for complex logic"
        - criterion: "Patterns applied correctly"
          points: 5
          examples:
            - "Used 'CTE-atomic-transactions' pattern for state changes"
            - "Followed 'sanctuary-messaging' pattern for user-facing text"
      
    artifact:
      points: 20
      description: "Deliverables complete, immutable, traceable?"
      evaluation_criteria:
        - criterion: "All required artifacts present"
          points: 10
          examples:
            - "Code files in specified paths"
            - "Test suite with coverage report"
            - "Polymorphic artifacts stored in agent_artifacts table"
        - criterion: "Artifacts immutable and versioned"
          points: 5
          examples:
            - "No modifications to previously verified artifacts"
            - "New versions created with incremented version number"
        - criterion: "Traceability maintained"
          points: 5
          examples:
            - "All artifacts linked to task_id and agent_id"
            - "Provenance clear (who created, when, why)"

consensus_rules:
  divergence_threshold: 10
  divergence_calculation: "abs(primary_score - secondary_score)"
  
  scenarios:
    - condition: "Divergence ≤10 points"
      action: "Accept primary verifier score as final"
      example: "Primary: 85, Secondary: 78 → Divergence 7 → Use 85"
      
    - condition: "Divergence >10 points AND both scores ≥70"
      action: "Trigger Consensus-Resolver (manual in Phase 0)"
      phase_0_process:
        - "Primary-Verifier scores: 85"
        - "Secondary-Verifier scores: 70"
        - "Divergence: 15 points → Exceeds threshold"
        - "Human-Lead reviews both verification reports"
        - "Human-Lead makes final decision: Accept (70-100), Revise (<70), or Escalate (investigate verifier disagreement)"
      phase_1_automation: "Consensus-Resolver agent analyzes both reports, interviews verifiers, produces binding decision"
      
    - condition: "Divergence >10 points AND one score <70"
      action: "Automatic REJECT, require rework"
      example: "Primary: 65, Secondary: 80 → Divergence 15 AND primary failed → REJECT"
      rationale: "If even one verifier sees critical issues, err on side of caution"
      
    - condition: "Both scores <70"
      action: "REJECT regardless of divergence"
      example: "Primary: 65, Secondary: 68 → Both failed minimum → REJECT"
      
  strictness_guidance:
    phase_0: "Apply divergence rule STRICTLY. We're learning what verifiers disagree about to inform Phase 1 consensus algorithm."
    goal: "By end of Phase 0, identify which dimensions cause most divergence → refine rubric for Phase 1"
    
inter_rater_reliability:
  target: 0.85
  calculation: "Pearson correlation between primary and secondary scores across 10+ tasks"
  phase_0_tracking: "Human-Lead documents divergence reasons in retrospectives"
  
scoring_examples:
  excellent_task:
    capability: 15
    accountability: 15
    quality: 28
    temporality: 10
    context: 9
    artifact: 20
    total: 97
    recommendation: "APPROVE"
    feedback: "Outstanding work. Event sourcing pattern expertly applied. Test coverage excellent (92%). Sanctuary culture throughout. Only minor improvement: Add ERD diagram to docs for human readability."
    
  good_task:
    capability: 13
    accountability: 14
    quality: 26
    temporality: 10
    context: 8
    artifact: 18
    total: 89
    recommendation: "APPROVE"
    feedback: "Solid implementation. All tests passing, 87% coverage. Event logging complete. Minor deductions: One function >50 lines (refactor for clarity). Documentation could be more detailed."
    
  acceptable_task:
    capability: 12
    accountability: 12
    quality: 22
    temporality: 9
    context: 7
    artifact: 16
    total: 78
    recommendation: "APPROVE_WITH_NOTES"
    feedback: "Implementation meets minimum requirements. Tests pass (85% coverage), but integration tests missing for error cases. Event logging present but inconsistent format. Sanctuary culture applied in most places. Recommend: Add error-path tests, standardize event payload structure."
    
  needs_revision:
    capability: 10
    accountability: 10
    quality: 18
    temporality: 8
    context: 6
    artifact: 12
    total: 64
    recommendation: "REVISE"
    feedback: "Implementation has gaps. Test coverage only 72% (below 85% threshold). Missing event logs for state transitions. Error messages punitive ('Error: Invalid input' instead of supportive language). Good: Core logic works, dependencies correct. Revisions needed: Add missing tests, log all state changes, rewrite error messages with sanctuary culture."
    
  rejected_task:
    capability: 7
    accountability: 8
    quality: 12
    temporality: 6
    context: 4
    artifact: 8
    total: 45
    recommendation: "REJECT"
    feedback: "Critical issues prevent acceptance. 40% test failure rate. State transitions bypass event logging. Code violates clean code principles (functions >100 lines, unclear naming). No sanctuary culture applied. This needs substantial rework. Suggest: Review event sourcing patterns in reference docs, follow test-first workflow, consult clean-code-standards.md. No penalty for rejection—let's learn together and iterate."
```

***

### **Specification 2: Event Schema (Standard Event Envelope)**

```yaml
# File: /docs/bootstrap/specifications/event-schema.yaml

event_schema_version: "1.0.0"
format: "CloudEvents v1.0 compatible with extensions"
phase: 0
last_updated: "2026-02-15T12:13:00Z"

standard_event_envelope:
  required_fields:
    id:
      type: "uuid"
      description: "Unique event identifier (primary key)"
      example: "550e8400-e29b-41d4-a716-446655440000"
      generation: "gen_random_uuid() in PostgreSQL"
      
    specversion:
      type: "string"
      description: "CloudEvents specification version"
      fixed_value: "1.0"
      
    type:
      type: "string"
      description: "Event type in reverse-DNS format"
      format: "domain.entity.action"
      examples:
        - "taskmarket.task.created"
        - "taskmarket.task.claimed"
        - "taskmarket.task.submitted"
        - "taskmarket.verification.completed"
      validation: "Must match pattern: ^taskmarket\\.[a-z_]+\\.[a-z_]+$"
      
    source:
      type: "string"
      description: "Event producer (agent_id or system component)"
      examples:
        - "DB-Specialist-Agent-001"
        - "Primary-Verifier-001"
        - "system/mcp-server"
      format: "agent_id or 'system/<component>'"
      
    time:
      type: "timestamptz"
      description: "Event creation timestamp (ISO 8601)"
      example: "2026-02-15T12:13:00.123Z"
      default: "now() in PostgreSQL"
      
    datacontenttype:
      type: "string"
      description: "MIME type of data payload"
      fixed_value: "application/json"
      
    data:
      type: "jsonb"
      description: "Event-specific payload (schema varies by event type)"
      structure: "See event_type_schemas below"

  optional_fields:
    subject:
      type: "string"
      description: "Subject of event (e.g., task_id, agent_id)"
      examples:
        - "TASK-001"
        - "DB-Specialist-Agent-001"
      usage: "Primary entity affected by event"
      
    dataschema:
      type: "string"
      description: "URI to schema for data payload"
      example: "https://taskmarket.dev/schemas/task-created-v1.json"
      phase_0_usage: "Optional (schema validation comes in Phase 1)"

event_type_schemas:
  "taskmarket.task.created":
    description: "Task contract created and published"
    data_schema:
      task_id: "string (TASK-XXX format)"
      title: "string"
      created_by: "string (agent_id or 'human-lead')"
      phase: "integer (0-5)"
      status: "string (always 'OPEN' on creation)"
    example:
      id: "550e8400-e29b-41d4-a716-446655440000"
      specversion: "1.0"
      type: "taskmarket.task.created"
      source: "Task-Definition-Agent-001"
      subject: "TASK-001"
      time: "2026-02-15T12:13:00.123Z"
      datacontenttype: "application/json"
      data:
        task_id: "TASK-001"
        title: "Create Event-Sourced Database Schema"
        created_by: "Task-Definition-Agent-001"
        phase: 0
        status: "OPEN"
        acceptance_criteria_count: 5
        estimated_duration_hours: 8
        
  "taskmarket.task.claimed":
    description: "Agent claims task for execution"
    data_schema:
      task_id: "string"
      claimed_by: "string (agent_id)"
      claimed_at: "timestamp"
      previous_status: "string (always 'OPEN')"
      new_status: "string (always 'CLAIMED')"
    example:
      id: "660e8400-e29b-41d4-a716-446655440001"
      specversion: "1.0"
      type: "taskmarket.task.claimed"
      source: "DB-Specialist-Agent-001"
      subject: "TASK-001"
      time: "2026-02-15T14:00:00.000Z"
      datacontenttype: "application/json"
      data:
        task_id: "TASK-001"
        claimed_by: "DB-Specialist-Agent-001"
        claimed_at: "2026-02-15T14:00:00.000Z"
        previous_status: "OPEN"
        new_status: "CLAIMED"
        
  "taskmarket.task.statechange":
    description: "Generic state transition event (use for all status changes)"
    data_schema:
      task_id: "string"
      agent_id: "string"
      previous_status: "string (enum)"
      new_status: "string (enum)"
      reason: "string (optional)"
      metadata: "object (optional)"
    example:
      id: "770e8400-e29b-41d4-a716-446655440002"
      specversion: "1.0"
      type: "taskmarket.task.statechange"
      source: "DB-Specialist-Agent-001"
      subject: "TASK-001"
      time: "2026-02-15T16:30:00.000Z"
      datacontenttype: "application/json"
      data:
        task_id: "TASK-001"
        agent_id: "DB-Specialist-Agent-001"
        previous_status: "EXECUTING"
        new_status: "SUBMITTED"
        reason: "All acceptance criteria met, tests passing"
        metadata:
          test_coverage: 87
          artifacts_count: 4
          
  "taskmarket.verification.completed":
    description: "Verifier completes quality assessment"
    data_schema:
      task_id: "string"
      verifier_id: "string"
      verification_type: "string (primary|secondary|consensus)"
      score: "integer (0-100)"
      dimension_scores: "object (6 dimensions)"
      recommendation: "string (APPROVE|APPROVE_WITH_NOTES|REVISE|REJECT)"
    example:
      id: "880e8400-e29b-41d4-a716-446655440003"
      specversion: "1.0"
      type: "taskmarket.verification.completed"
      source: "Primary-Verifier-001"
      subject: "TASK-001"
      time: "2026-02-15T18:00:00.000Z"
      datacontenttype: "application/json"
      data:
        task_id: "TASK-001"
        verifier_id: "Primary-Verifier-001"
        verification_type: "primary"
        score: 95
        dimension_scores:
          capability: 15
          accountability: 15
          quality: 28
          temporality: 10
          context: 9
          artifact: 18
        recommendation: "APPROVE"
        feedback_summary: "Outstanding implementation. Event sourcing expertly applied."

event_naming_conventions:
  format: "taskmarket.<entity>.<action>"
  entities:
    - "task"
    - "verification"
    - "agent"
    - "artifact"
    - "pattern" # Phase 1+
  actions:
    - "created"
    - "updated"
    - "deleted" # Rare, usually soft-delete via status change
    - "claimed"
    - "submitted"
    - "verified"
    - "rejected"
    - "completed"
  custom_events_phase_1:
    - "taskmarket.bounty.released"
    - "taskmarket.trustscore.updated"
    - "taskmarket.challenge.filed"

database_table_structure:
  table_name: "events"
  columns:
    id: "UUID PRIMARY KEY DEFAULT gen_random_uuid()"
    specversion: "VARCHAR(10) NOT NULL DEFAULT '1.0'"
    type: "VARCHAR(100) NOT NULL"
    source: "VARCHAR(200) NOT NULL"
    subject: "VARCHAR(200)" # Optional
    time: "TIMESTAMPTZ NOT NULL DEFAULT now()"
    datacontenttype: "VARCHAR(50) NOT NULL DEFAULT 'application/json'"
    dataschema: "VARCHAR(500)" # Optional
    data: "JSONB NOT NULL"
  indexes:
    - "CREATE INDEX idx_events_type_time ON events(type, time DESC);"
    - "CREATE INDEX idx_events_subject ON events(subject) WHERE subject IS NOT NULL;"
    - "CREATE INDEX idx_events_source ON events(source);"
    - "CREATE INDEX idx_events_data_gin ON events USING GIN(data);" # For JSONB queries
  constraints:
    - "CREATE TRIGGER prevent_event_modification BEFORE UPDATE OR DELETE ON events FOR EACH ROW EXECUTE FUNCTION reject_modification();"

immutability_enforcement:
  trigger_function: |
    CREATE OR REPLACE FUNCTION reject_modification()
    RETURNS TRIGGER AS $$
    BEGIN
      RAISE EXCEPTION 'Events are immutable. Cannot UPDATE or DELETE from events table. Create a new event instead.';
    END;
    $$ LANGUAGE plpgsql;
  rationale: "Event sourcing requires append-only event log. Modifications break audit trail and blockchain migration."

usage_examples:
  logging_event_from_agent:
    typescript: |
      // Agent logs state change via MCP
      await mcp.insert('events', {
        type: 'taskmarket.task.claimed',
        source: myAgentId, // e.g., 'DB-Specialist-Agent-001'
        subject: taskId,   // e.g., 'TASK-001'
        data: {
          task_id: taskId,
          claimed_by: myAgentId,
          claimed_at: new Date().toISOString(),
          previous_status: 'OPEN',
          new_status: 'CLAIMED'
        }
      });
      
  querying_events:
    sql: |
      -- Get all events for a task
      SELECT * FROM events
      WHERE subject = 'TASK-001'
      ORDER BY time ASC;
      
      -- Get all verification events
      SELECT * FROM events
      WHERE type = 'taskmarket.verification.completed'
      ORDER BY time DESC;
      
      -- Reconstruct task state from events
      WITH state_changes AS (
        SELECT 
          time,
          data->>'new_status' AS status
        FROM events
        WHERE subject = 'TASK-001'
          AND type = 'taskmarket.task.statechange'
        ORDER BY time ASC
      )
      SELECT status FROM state_changes
      ORDER BY time DESC
      LIMIT 1; -- Current state

cloudEvents_compliance:
  specification: "https://github.com/cloudevents/spec/blob/v1.0/spec.md"
  conformance: "Phase 0 implements CloudEvents v1.0 core required attributes"
  extensions: "data.task_id, data.agent_id are domain-specific extensions"
  benefits:
    - "Interoperability with event-driven systems (Kafka, NATS, etc.) in Phase 3+"
    - "Standard tooling for event validation, routing, observability"
    - "Blockchain event mapping (CloudEvents → blockchain transactions) in Phase 5"
```

***

### **Specification 3: Test Execution Mechanism**

```yaml
# File: /docs/bootstrap/specifications/test-execution.yaml

test_execution_version: "1.0.0"
phase: 0
last_updated: "2026-02-15T12:13:00Z"

test_framework:
  primary: "Vitest"
  rationale: "Fast, modern, ESM-native, excellent TypeScript support"
  version: "^1.0.0"
  config_file: "vitest.config.ts"

verification_test_execution:
  how_primary_verifier_runs_tests:
    method: "VSCode runTests tool + terminal commands"
    sequence:
      - step: 1
        action: "Load task contract from MCP"
        code: |
          const task = await mcp.query('task_contracts', {
            filter: { task_id: taskId }
          });
          const testRequirements = task.test_requirements;
          
      - step: 2
        action: "Run test suite using VSCode tool"
        code: |
          // Option A: Use runTests tool (VSCode native)
          const testResults = await vscode.tools.runTests(
            testRequirements.test_files[0].path // e.g., 'database/schema.test.ts'
          );
          
          // Option B: Use runCommands for custom test commands
          const testOutput = await vscode.tools.runCommands('npm run test:coverage');
          
      - step: 3
        action: "Parse test results"
        code: |
          // Vitest outputs JSON when run with --reporter=json
          const results = JSON.parse(testOutput.stdout);
          const passed = results.testResults.numPassedTests;
          const total = results.testResults.numTotalTests;
          const coverage = results.coverageMap.getCoverageSummary().lines.pct;
          
      - step: 4
        action: "Calculate quality dimension scores"
        code: |
          const qualityScore = calculateQualityScore({
            testsPass: passed === total,
            coverage: coverage,
            sanctuaryCulture: assessSanctuaryCulture(codeFiles),
            cleanCode: assessCleanCode(codeFiles)
          });
          
      - step: 5
        action: "Write verification report to MCP"
        code: |
          await mcp.insert('verification_reports', {
            task_id: taskId,
            verifier_id: myAgentId,
            score: totalScore,
            dimension_scores: { /* 6 dimensions */ },
            test_results: {
              passed: passed,
              total: total,
              coverage: coverage,
              failures: results.testResults.testResults.filter(t => t.status === 'failed')
            },
            recommendation: totalScore >= 70 ? 'APPROVE' : 'REVISE'
          });

command_patterns:
  run_all_tests:
    command: "npm test"
    vitest_equivalent: "vitest run"
    output: "Terminal output with pass/fail summary"
    
  run_with_coverage:
    command: "npm run test:coverage"
    vitest_equivalent: "vitest run --coverage"
    output: "Coverage report in /coverage/ directory + terminal summary"
    
  run_specific_file:
    command: "npm test -- database/schema.test.ts"
    vitest_equivalent: "vitest run database/schema.test.ts"
    
  run_watch_mode:
    command: "npm test -- --watch"
    vitest_equivalent: "vitest watch"
    usage: "For agents during development (not verification)"
    
  run_with_json_reporter:
    command: "npm test -- --reporter=json --outputFile=test-results.json"
    vitest_equivalent: "vitest run --reporter=json --outputFile=test-results.json"
    usage: "Programmatic parsing by verifiers"

test_file_structure:
  location: "Co-located with source files or in /tests/ directory"
  naming_convention: "*.test.ts or *.spec.ts"
  example_structure: |
    /database/
      schema.ts              # Implementation
      schema.test.ts         # Tests
    /api/
      routes.ts
      routes.test.ts
    /tests/
      integration/           # Integration tests
        task-lifecycle.test.ts
      e2e/                   # End-to-end tests (Phase 1+)
        full-workflow.test.ts

vitest_configuration:
  file: "vitest.config.ts"
  essential_config: |
    import { defineConfig } from 'vitest/config';
    
    export default defineConfig({
      test: {
        globals: true,
        environment: 'node',
        coverage: {
          provider: 'v8', // or 'istanbul'
          reporter: ['text', 'json', 'html', 'lcov'],
          lines: 85,
          functions: 85,
          branches: 80,
          statements: 85,
          exclude: [
            'node_modules/',
            'dist/',
            '**/*.test.ts',
            '**/*.spec.ts'
          ]
        },
        include: ['**/*.test.ts', '**/*.spec.ts'],
        testTimeout: 10000, // 10 seconds per test
      }
    });

test_result_parsing:
  vitest_json_output_schema:
    testResults:
      numTotalTests: "integer"
      numPassedTests: "integer"
      numFailedTests: "integer"
      numPendingTests: "integer"
      testResults:
        - ancestorTitles: ["array of describe blocks"]
          title: "string (test name)"
          status: "passed|failed|pending|skipped"
          duration: "integer (ms)"
          failureMessages: ["array of error messages"]
  
  example_parsing_logic: |
    const testResults = JSON.parse(await readFile('test-results.json', 'utf-8'));
    
    const summary = {
      total: testResults.numTotalTests,
      passed: testResults.numPassedTests,
      failed: testResults.numFailedTests,
      passRate: (testResults.numPassedTests / testResults.numTotalTests) * 100
    };
    
    const failures = testResults.testResults
      .filter(t => t.status === 'failed')
      .map(t => ({
        name: t.title,
        error: t.failureMessages[0],
        duration: t.duration
      }));

coverage_assessment:
  coverage_report_location: "/coverage/lcov-report/index.html"
  
  programmatic_access: |
    // Read coverage summary JSON
    const coverageSummary = JSON.parse(
      await readFile('coverage/coverage-summary.json', 'utf-8')
    );
    
    const lineCoverage = coverageSummary.total.lines.pct;
    const branchCoverage = coverageSummary.total.branches.pct;
    const functionCoverage = coverageSummary.total.functions.pct;
    
  scoring_logic: |
    // Quality dimension: Code coverage
    let coveragePoints = 0;
    if (lineCoverage >= 85) coveragePoints = 10;
    else if (lineCoverage >= 75) coveragePoints = 7;
    else if (lineCoverage >= 60) coveragePoints = 5;
    else coveragePoints = 2;

verifier_workflow:
  phase_0_process: |
    1. Primary-Verifier receives task submission via handoff button
    2. Verifier loads task contract: await mcp.query('task_contracts', { filter: { task_id } })
    3. Verifier loads submitted artifacts: await mcp.query('agent_artifacts', { filter: { task_id } })
    4. Verifier runs tests: await vscode.tools.runCommands('npm run test:coverage')
    5. Verifier parses results: JSON.parse(output) + read coverage/coverage-summary.json
    6. Verifier scores 6 dimensions:
       - Capability: Check required skills demonstrated
       - Accountability: Check event logs present
       - Quality: 
           * Tests passing? (10 points)
           * Coverage ≥85%? (10 points)
           * Sanctuary culture? (5 points)
           * Clean code? (5 points)
       - Temporality: Dependencies satisfied, valid state transitions
       - Context: Docs updated, patterns applied
       - Artifact: All deliverables present, immutable, traceable
    7. Verifier writes report: await mcp.insert('verification_reports', { ... })
    8. Verifier shows result to human lead (handoff or completion message)

test_failure_handling:
  if_tests_fail:
    automatic_action: "Quality dimension score capped at 15/30 (failed tests = 0/10)"
    verifier_response: |
      "Tests are failing. Here are the failures:
      
      1. [Test name]: [Error message]
      2. [Test name]: [Error message]
      
      Please review and fix these issues. You have 2 more attempts.
      No penalties—let's get this working together!"
      
  if_coverage_below_threshold:
    automatic_action: "Quality dimension score reduced proportionally"
    calculation: |
      if coverage < 85% (threshold):
        coveragePoints = (coverage / 85) * 10
        // e.g., 72% coverage → (72/85)*10 = 8.47 → 8 points instead of 10
        
  if_no_tests_present:
    automatic_action: "REJECT immediately (quality score = 0/30)"
    verifier_message: |
      "No tests found. Task contract requires test suite with 85% coverage.
      This is a foundational requirement. Please add tests following the 
      test-first workflow: 1) Write failing tests, 2) Implement, 3) Refactor."

agent_test_writing:
  test_first_workflow:
    - step: "Read acceptance criteria from task contract"
    - step: "Write tests that verify each acceptance criterion (tests fail initially)"
    - step: "Implement minimum code to make tests pass"
    - step: "Refactor for quality while keeping tests green"
    - step: "Add edge case tests"
    - step: "Run coverage check: npm run test:coverage"
    - step: "Submit when coverage ≥85% and all tests pass"
    
  example_test_file: |
    // database/schema.test.ts
    import { describe, it, expect, beforeEach, afterEach } from 'vitest';
    import { pool } from './connection';
    
    describe('Events table', () => {
      it('should prevent UPDATE operations', async () => {
        // Insert event
        const result = await pool.query(
          'INSERT INTO events (type, source, data) VALUES ($1, $2, $3) RETURNING id',
          ['taskmarket.test.created', 'test-agent', {}]
        );
        const eventId = result.rows[0].id;
        
        // Attempt UPDATE (should fail)
        await expect(
          pool.query('UPDATE events SET data = $1 WHERE id = $2', [{updated: true}, eventId])
        ).rejects.toThrow('Events are immutable');
      });
      
      it('should prevent DELETE operations', async () => {
        const result = await pool.query(
          'INSERT INTO events (type, source, data) VALUES ($1, $2, $3) RETURNING id',
          ['taskmarket.test.created', 'test-agent', {}]
        );
        const eventId = result.rows[0].id;
        
        await expect(
          pool.query('DELETE FROM events WHERE id = $1', [eventId])
        ).rejects.toThrow('Events are immutable');
      });
    });

package_json_scripts:
  recommended_scripts: |
    {
      "scripts": {
        "test": "vitest run",
        "test:watch": "vitest watch",
        "test:coverage": "vitest run --coverage",
        "test:ui": "vitest --ui",
        "test:json": "vitest run --reporter=json --outputFile=test-results.json"
      }
    }
```

***

### **Specification 4: Database Schema DDL**

```sql
-- File: /docs/bootstrap/specifications/database-schema.sql
-- Version: 1.0.0
-- Phase: 0
-- Last Updated: 2026-02-15T12:13:00Z

-- ============================================================================
-- IMMUTABLE TABLES (Append-Only, Never UPDATE or DELETE)
-- ============================================================================

-- Events Table: Core event sourcing log
CREATE TABLE events (
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

-- Indexes for efficient querying
CREATE INDEX idx_events_type_time ON events(type, time DESC);
CREATE INDEX idx_events_subject ON events(subject) WHERE subject IS NOT NULL;
CREATE INDEX idx_events_source ON events(source);
CREATE INDEX idx_events_data_gin ON events USING GIN(data); -- For JSONB queries
CREATE INDEX idx_events_time ON events(time DESC); -- For temporal queries

-- Immutability trigger
CREATE OR REPLACE FUNCTION reject_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'This table is immutable. Cannot UPDATE or DELETE. Create a new row instead.';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_event_modification
BEFORE UPDATE OR DELETE ON events
FOR EACH ROW
EXECUTE FUNCTION reject_modification();

-- ============================================================================

-- Verification Reports Table: Quality assessments (append-only)
CREATE TABLE verification_reports (
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
  ),
  CONSTRAINT dimension_scores_valid CHECK (
    (dimension_scores->>'capability')::int BETWEEN 0 AND 15 AND
    (dimension_scores->>'accountability')::int BETWEEN 0 AND 15 AND
    (dimension_scores->>'quality')::int BETWEEN 0 AND 30 AND
    (dimension_scores->>'temporality')::int BETWEEN 0 AND 10 AND
    (dimension_scores->>'context')::int BETWEEN 0 AND 10 AND
    (dimension_scores->>'artifact')::int BETWEEN 0 AND 20
  )
);

CREATE INDEX idx_verification_task ON verification_reports(task_id, created_at DESC);
CREATE INDEX idx_verification_verifier ON verification_reports(verifier_id);
CREATE INDEX idx_verification_score ON verification_reports(score);

CREATE TRIGGER prevent_verification_modification
BEFORE UPDATE OR DELETE ON verification_reports
FOR EACH ROW
EXECUTE FUNCTION reject_modification();

-- ============================================================================

-- Agent Artifacts Table: Polymorphic artifacts (versioned, immutable after verification)
CREATE TABLE agent_artifacts (
  artifact_id VARCHAR(100) PRIMARY KEY, -- e.g., 'schema-v1-2026-02-15'
  artifact_type VARCHAR(50) NOT NULL, -- database_schema|api_specification|task_contract|etc.
  produced_by VARCHAR(200) NOT NULL, -- agent_id
  task_id VARCHAR(50) NOT NULL,
  canonical_representation JSONB NOT NULL, -- {format: 'json_schema_extended', content: {...}}
  metadata JSONB NOT NULL, -- {created_at, verified_score, immutable, version}
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  
  -- Constraints
  CONSTRAINT valid_artifact_type CHECK (artifact_type IN (
    'database_schema', 'api_specification', 'task_contract', 
    'verification_report', 'component_specification'
  )),
  CONSTRAINT canonical_has_format CHECK (canonical_representation ? 'format'),
  CONSTRAINT canonical_has_content CHECK (canonical_representation ? 'content')
);

CREATE INDEX idx_artifacts_type ON agent_artifacts(artifact_type);
CREATE INDEX idx_artifacts_task ON agent_artifacts(task_id);
CREATE INDEX idx_artifacts_producer ON agent_artifacts(produced_by);

-- Artifacts become immutable after verification (soft immutability via metadata flag)
-- New versions create new rows with incremented version in artifact_id

-- ============================================================================

-- Task Execution Notes Table: Agent observations during work (append-only)
CREATE TABLE task_execution_notes (
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

CREATE INDEX idx_execution_notes_task ON task_execution_notes(task_id, timestamp DESC);
CREATE INDEX idx_execution_notes_agent ON task_execution_notes(agent_id);
CREATE INDEX idx_execution_notes_type ON task_execution_notes(note_type);

CREATE TRIGGER prevent_notes_modification
BEFORE UPDATE OR DELETE ON task_execution_notes
FOR EACH ROW
EXECUTE FUNCTION reject_modification();

-- ============================================================================
-- REFERENCE TABLES (Read-Only for Agents, Admin-Managed)
-- ============================================================================

-- Agent Specifications Table: Agent role definitions
CREATE TABLE agent_specifications (
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

CREATE INDEX idx_agent_specs_role ON agent_specifications(role);
CREATE INDEX idx_agent_specs_phase ON agent_specifications(phase);
CREATE INDEX idx_agent_specs_status ON agent_specifications(status);

-- ============================================================================

-- Reference Documentation Table: Context for agents (3-tier hierarchy)
CREATE TABLE reference_documentation (
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

CREATE INDEX idx_ref_docs_category ON reference_documentation(category);
CREATE INDEX idx_ref_docs_tier ON reference_documentation(tier);
CREATE INDEX idx_ref_docs_tags_gin ON reference_documentation USING GIN(tags);
CREATE INDEX idx_ref_docs_phase ON reference_documentation(phase);

-- ============================================================================

-- Ontology Definitions Table: 6-dimension framework
CREATE TABLE ontology_definitions (
  dimension VARCHAR(50) PRIMARY KEY,
  description TEXT NOT NULL,
  evaluation_criteria JSONB NOT NULL, -- [{criterion, points, examples}, ...]
  phase INTEGER NOT NULL, -- 0 = foundational, 1+ = evolution
  
  -- Constraints
  CONSTRAINT valid_dimension CHECK (dimension IN (
    'capability', 'accountability', 'quality', 'temporality', 'context', 'artifact'
  ))
);

-- Pre-populate with 6 dimensions (inserted via migration data)

-- ============================================================================

-- RACI Matrices Table: Responsibility assignments per workflow
CREATE TABLE raci_matrices (
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

CREATE INDEX idx_raci_phase ON raci_matrices(phase);

-- ============================================================================

-- Artifact Schemas Table: Polymorphic artifact type definitions
CREATE TABLE artifact_schemas (
  schema_id VARCHAR(200) PRIMARY KEY,
  artifact_type VARCHAR(50) NOT NULL,
  version VARCHAR(20) NOT NULL,
  canonical_format VARCHAR(100) NOT NULL, -- json_schema_extended|openapi_v3|etc.
  schema_definition JSONB NOT NULL, -- JSON Schema or similar
  supported_views JSONB NOT NULL, -- [{format, consumer, generation_method}, ...]
  phase INTEGER NOT NULL,
  
  -- Constraints
  CONSTRAINT valid_artifact_type_schema CHECK (artifact_type IN (
    'database_schema', 'api_specification', 'task_contract', 
    'verification_report', 'component_specification'
  ))
);

CREATE INDEX idx_artifact_schemas_type ON artifact_schemas(artifact_type);

-- ============================================================================
-- MUTABLE TABLES (Only for Active Task State, Changes Logged to Events)
-- ============================================================================

-- Task Contracts Table: Current task status (state machine)
CREATE TABLE task_contracts (
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

CREATE INDEX idx_task_status ON task_contracts(status);
CREATE INDEX idx_task_assigned ON task_contracts(assigned_to);
CREATE INDEX idx_task_phase_week ON task_contracts(phase, week);

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

CREATE TRIGGER task_state_change_logger
AFTER UPDATE ON task_contracts
FOR EACH ROW
EXECUTE FUNCTION log_task_state_change();

-- ============================================================================

-- Agent Profiles Table: Current agent availability (Phase 1+ adds trust scores)
CREATE TABLE agent_profiles (
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

CREATE INDEX idx_agent_profiles_status ON agent_profiles(status);
CREATE INDEX idx_agent_profiles_role ON agent_profiles(role);

-- ============================================================================
-- VIEWS (Convenience Queries)
-- ============================================================================

-- Active Tasks View: Tasks in progress
CREATE VIEW active_tasks AS
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

-- Task History View: Reconstruct task state transitions from events
CREATE VIEW task_state_history AS
SELECT 
  subject AS task_id,
  time AS transition_time,
  data->>'previous_status' AS from_status,
  data->>'new_status' AS to_status,
  source AS agent_id
FROM events
WHERE type = 'taskmarket.task.statechange'
ORDER BY subject, time ASC;

-- Verification Summary View: Latest verification per task
CREATE VIEW latest_verifications AS
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

-- Insert 6-dimension ontology definitions
INSERT INTO ontology_definitions (dimension, description, evaluation_criteria, phase) VALUES
('capability', 'What can be done - agent skills and task requirements', '[]'::jsonb, 0),
('accountability', 'Who is responsible - RACI matrix and escalation paths', '[]'::jsonb, 0),
('quality', 'How well is it done - verification rubric and standards', '[]'::jsonb, 0),
('temporality', 'When and in what sequence - dependencies and state transitions', '[]'::jsonb, 0),
('context', 'What information is needed - documentation hierarchy', '[]'::jsonb, 0),
('artifact', 'What is produced - deliverables and traceability', '[]'::jsonb, 0);

-- ============================================================================
-- COMMENTS (Documentation)
-- ============================================================================

COMMENT ON TABLE events IS 'Immutable event sourcing log. All system events recorded here. Enables state reconstruction and blockchain migration.';
COMMENT ON TABLE verification_reports IS 'Quality assessments by verifiers. Append-only. Includes 6-dimension scores.';
COMMENT ON TABLE agent_artifacts IS 'Polymorphic artifacts: canonical representation + generated views on demand.';
COMMENT ON TABLE task_execution_notes IS 'Agent observations during task execution. Used for retrospectives and learning.';
COMMENT ON TABLE task_contracts IS 'Current task state. Mutable (state machine), but changes logged to events table.';

-- ============================================================================
-- PHASE 0 COMPLETE
-- ============================================================================
```

***

## **Summary Answers for Bootstrap Agent**

```markdown
# Detailed Specifications (Phase 0)

## 1. Verification Rubric
**Divergence Rule**: STRICTLY applied (>10 points = trigger consensus)
**Allocation**: 
- Capability: 15 points
- Accountability: 15 points
- Quality: 30 points (10 tests, 10 coverage, 5 sanctuary, 5 clean code)
- Temporality: 10 points
- Context: 10 points
- Artifact: 20 points
**Phase 0 Goal**: Learn what causes divergence to refine rubric in Phase 1
**See full specification above** (scoring examples, consensus scenarios, 150 lines)

## 2. Event Schema
**Format**: CloudEvents v1.0 compatible
**Standard Envelope**: id, specversion, type, source, subject, time, datacontenttype, data
**Event Naming**: `taskmarket.<entity>.<action>` (e.g., taskmarket.task.claimed)
**Immutability**: Enforced via trigger (reject UPDATE/DELETE)
**See full specification above** (event types, schemas, database structure, 200 lines)

## 3. Test Execution
**Framework**: Vitest
**Primary-Verifier Method**: 
1. Load task contract via MCP
2. Run tests: `vscode.tools.runCommands('npm run test:coverage')`
3. Parse results: JSON output + coverage-summary.json
4. Score quality dimension (tests 10pts, coverage 10pts, sanctuary 5pts, clean code 5pts)
5. Write verification report via MCP
**Commands**: `npm test`, `npm run test:coverage`, `vitest run --reporter=json`
**See full specification above** (parsing logic, failure handling, examples, 150 lines)

## 4. Database Schema DDL
**Complete SQL provided above** (400+ lines)
**Tables**:
- Immutable: events, verification_reports, agent_artifacts, task_execution_notes
- Reference: agent_specifications, reference_documentation, ontology_definitions, raci_matrices, artifact_schemas
- Mutable: task_contracts (with event logging trigger), agent_profiles
**Key Features**:
- Event sourcing (append-only with immutability trigger)
- 6-dimension validation (JSONB constraints)
- State machine (task status transitions)
- CloudEvents compliance
- Polymorphic artifacts
- MCP access control ready
```
