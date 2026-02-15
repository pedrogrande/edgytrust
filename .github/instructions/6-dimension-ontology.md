# 6-Dimension Ontology Framework

This framework structures all tasks, agents, verification, and knowledge.

## 1. Capability (What can be done)
- **Agent Capabilities**: Skills possessed (e.g., `typescript`, `sql`).
- **Task Requirements**: Skills needed.
- **Matching**: Intersection of agent skills and task needs.

## 2. Accountability (Who is responsible)
- **RACI**: Responsible, Accountable, Consulted, Informed.
- **Roles**: Explicit assignments for every workflow step.
- **Escalation**: Clear paths for blockers or ambiguity.

## 3. Quality (How well is it done)
- **Verification Rubric**: 100-point scale across 6 dimensions.
- **Sanctuary Culture**: Tone and approach matter as much as code.
- **Gates**: Minimum score (80) required for completion.

## 4. Temporality (When and in what sequence)
- **Dependencies**: Prerequisite tasks must be complete.
- **State Transitions**: OPEN -> CLAIMED -> SUBMITTED -> VERIFIED.
- **Event Log**: Immutable record of all timing and sequences.

## 5. Context (What information is needed)
- **3-Tier Hierarchy**: Always-loaded, Conditional, On-demand.
- **Scope**: Minimum necessary context to reduce token usage.
- **Pruning**: Removing irrelevant info.

## 6. Artifact (What is produced)
- **Polymorphism**: Canonical source + generated views (SQL, TS types, Docs).
- **Immutability**: Versioned, never modified in place.
- **Traceability**: Linked to task, agent, and requirements.
