-- Database Schema (Placeholder)
-- Needs full DDL for:
-- 1. task_contracts
-- 2. agent_profiles
-- 3. events (immutable)
-- 4. verification_reports (immutable)
-- 5. agent_artifacts (immutable)
-- 6. reference_documentation

CREATE TABLE events (
  id UUID PRIMARY KEY,
  type TEXT NOT NULL,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  payload JSONB NOT NULL
);

-- TODO: Complete schema definition
