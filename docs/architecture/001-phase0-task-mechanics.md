# Architecture Note 001: Phase 0 Task Contract Mechanics

**Date**: 2026-02-15
**Status**: APPROVED
**Author**: Project-Architect-Agent

## Context
Phase 0 requires a foundational data model to support the "Task Contract" lifecycle: Definition -> Claiming -> Execution -> Verification. We need to store the current state of tasks, the history of changes (events), and the outputs produced (artifacts).

## Design Decisions

### 1. Hybrid Event Sourcing
We will use a **Hybrid Event Sourcing** pattern for Phase 0.
- **`events` table**: The Source of Truth. Immutable, append-only log of all actions.
- **`tasks` table**: A "Read Model" or "State Projection". Mutable, updated alongside events to allow easy querying of current state (e.g., "Show me all OPEN tasks").
- **Why?**: Pure event sourcing requires complex replaying for simple queries. A maintained state table simplifies MCP interactions for agents.

### 2. Polymorphic Artifacts
Artifacts (code, docs, reports) will be stored using a **Reference Pattern**.
- **`artifacts` table**: Stores metadata (type, uri, hash, agent_id).
- **Storage**: The actual content is stored in the filesystem (or blob storage in future), referenced by URI.
- **Why?**: Keeps the database light; allows distinct storage backends for different artifact types.

### 3. Database Schema Specification

#### A. `tasks` (State Table)
- `id` (UUID): Primary Key
- `title` (VARCHAR): Short description
- `status` (ENUM): `OPEN`, `IN_PROGRESS`, `IN_REVIEW`, `COMPLETED`, `CANCELLED`
- `assignee_id` (VARCHAR): Agent ID (nullable)
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

#### B. `events` (Ledger Table)
- *Already defined in `database-schema.sql`*
- Must enforce `task_id` in `subject` or `data` payload.

#### C. `artifacts` (Output Table)
- `id` (UUID): Primary Key
- `task_id` (UUID): FK to `tasks`
- `agent_id` (VARCHAR): Creator
- `type` (ENUM): `SPECIFICATION`, `PROOF_OF_WORK`, `VERIFICATION_REPORT`
- `uri` (VARCHAR): Location (e.g., `file:///tasks/001/proof.zip`)
- `hash` (VARCHAR): SHA-256 for integrity
- `created_at` (TIMESTAMP)

## Workflow
1. **Creation**: Agent calls MCP `create_task` -> Inserts into `tasks`, Inserts `TaskCreated` into `events`.
2. **Claiming**: Agent calls MCP `claim_task` -> Updates `tasks.status`, `tasks.assignee_id`, Inserts `TaskClaimed` into `events`.
3. **Completion**: Agent calls MCP `submit_work` -> Inserts into `artifacts`, Updates `tasks.status`, Inserts `TaskSubmitted` into `events`.

## Dependencies
- PostgreSQL (via Supabase or local)
- SurrealDB (as MCP interface)
