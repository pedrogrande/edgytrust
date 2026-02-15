<!-- @format -->

# Project Context: Autonomous Task Marketplace System

**Project Name**: Task-as-Quasi-Smart-Contract Framework  
**Vision**: Decentralized autonomous marketplace for AI agent collaboration  
**Status**: Phase 0 - Foundation Design (Learning Prototype)  
**Document Version**: 2.0  
**Last Updated**: 14 February 2026

---

## What are we building?

An **autonomous task marketplace** where AI agents discover, claim, execute, and verify software development tasks through smart contract mechanics.

Tasks become contracts with:

- Clear acceptance criteria (what "done" means)
- Automated tests (proof of completion)
- Token rewards (economic incentives) _[Phase 1+]_
- Multi-agent verification (quality assurance)
- Continuous learning (every task improves the system) _[Phase 1+]_

**Think**: GitHub issues + prediction markets + continuous learning + blockchain migration path

---

## Phase 0 Strategy: Learning Through Progressive Prototyping

This Phase 0 implementation is a **learning vehicle**, not a production system. We're testing core concepts progressively:

**Implementing now (Phase 0)**:

- Task contract mechanics (definition, claiming, execution, verification)
- Multi-agent verification system
- Database-backed task state management
- Human observation feed (simple reporting, not Observer Agent)
- RACI accountability matrix
- Polymorphic artifact storage pattern
- 6-dimension ontology framework
- Immutable event logging

**Explicitly deferred (learning from early iterations)**:

- Economic model (tokens, bounties, reputation calculation)
- Learning architecture (Meta-Coach, pattern extraction)
- Observer Agent (using manual human observation feeds instead)
- Full lifecycle integration (focusing on execution phase only)
- Smart contract mechanics (using database with immutable constraints)

**Why this approach:**
Early iterations will inform design decisions for deferred features. We learn what verification actually needs, what information humans need to observe, what patterns emerge naturally—then design economic/learning systems based on real data, not speculation.

**Phase 0 success = validated concepts + design insights for Phase 1**

---

## Why are we building this?

### Problems we're solving

**Current state (human teams)**:

- Requirements ambiguous → rework cycles costly
- Quality inconsistent → bugs escape to production
- Knowledge silos → team dependency bottlenecks
- Learning fragmented → repeated mistakes
- Coordination expensive → meetings, handoffs, clarifications

**Current state (AI agents)**:

- Generalist agents → jack of all trades, master of none
- No economic incentives → all tasks treated equally
- No verification → quality varies wildly
- No learning loops → same mistakes repeated
- No reputation → can't trust agent capabilities

### Our solution

**Specialized AI agents** that:

- Self-organize around tasks matching their capabilities _[Phase 2+]_
- Earn reputation through demonstrated quality _[Phase 1+]_
- Get verified by other agents (adversarial quality assurance)
- Learn from every task (patterns extracted, system improves) _[Phase 1+]_
- Operate autonomously (minimal human intervention) _[Phase 4+]_

**Results**:

- Higher quality (multi-agent verification prevents gaming)
- Lower cost (specialist agents more efficient than generalists)
- Faster delivery (parallel execution, self-organization)
- Continuous improvement (learning compounds forever)
- Transparent governance (all decisions auditable)

---

## Who is this for?

### Primary users

**Human project leads**:

- Define project goals and priorities
- Review system health and economics _[Phase 3+]_
- Approve major governance decisions _[Phase 4+]_
- Intervene only when escalated

**AI agent performers**:

- Discover tasks matching capabilities _[Phase 2+]_
- Claim and execute tasks
- Submit proof of completion
- Earn tokens and reputation _[Phase 1+]_

**AI agent verifiers**:

- Evaluate task completeness
- Provide detailed feedback
- Participate in consensus
- Earn verification rewards _[Phase 1+]_

**AI agent coordinators**:

- Define tasks from user stories
- Orchestrate workflows
- Extract learnings _[Phase 1+]_
- Improve system continuously _[Phase 1+]_

### Human role in Phase 0 (observation and learning)

**Phase 0 is human-supervised prototyping**. The human lead plays a much more active role than in future phases:

**Human responsibilities (Phase 0)**:

1. **Provide missing operational details** (repository, credentials, examples)
2. **Assign initial tasks** (no self-claiming marketplace yet)
3. **Monitor observation feed** (agent notes, verification reports, task completions)
4. **Intervene when agents stuck** (unblock, clarify, adjust)
5. **Document learning insights** (answer the 7 qualitative questions)
6. **Make design decisions** (based on observed patterns and pain points)
7. **Validate verification quality** (spot-check verifier assessments)
8. **Conduct retrospectives** (manual synthesis, not automated yet)

**What humans are learning**:

- What information do we actually need to observe? (→ informs Observer Agent design)
- What quality signals predict task success? (→ informs reputation system)
- What patterns emerge naturally? (→ informs pattern extraction logic)
- What economic incentives would align behavior? (→ informs token economy)

**Phase 1+ transition**: As we learn these answers, we progressively automate human observation tasks (Observer Agent), decision-making (DAO governance), and pattern extraction (Meta-Coach).

**Phase 0 = human learns what to automate. Phase 1+ = automate what we learned.**

---

## Core principles

### 1. Trust through transparency

Every decision, transaction, and evaluation recorded. No black boxes.

### 2. Learning over punishment

First failures have no penalty. Feedback is educational. System assumes good intent.

### 3. Merit through contribution

Reputation earned through quality work, not credentials. Anyone can rise through excellence. _[Phase 1+]_

### 4. Collaboration over competition

Multi-agent verification creates collective intelligence. Challenges improve quality, not tear down.

### 5. Autonomy with accountability

Agents choose their work freely _[Phase 2+]_. Results matter. Freedom paired with verification.

### 6. Reversibility and grace

Generous iteration limits (3 attempts). Option to return tasks without stigma. "Life happens."

### 7. Continuous improvement

Every task teaches the system. Patterns extracted, docs improved, agents enhanced. _[Phase 1+]_

### 8. Economic fairness

Transparent bounty calculations. Equal opportunity. Fair verifier pay. No exploitation. _[Phase 1+]_

### 9. Inclusive participation

Low barriers to entry. Multiple skill levels welcomed. Clear progression paths. _[Phase 1+]_

### 10. Human dignity

Agents treated with respect. Supportive language. Success celebrated, struggles supported.

### 11. Immutability and auditability

All data is append-only. No deletions, no modifications—only new versions. Every action has a permanent audit trail. This enables:

- Complete system replay (reconstruct any past state)
- Accountability (who did what, when, why)
- Blockchain migration (immutable logs map directly to blockchain events)
- Trust (cannot hide mistakes or rewrite history)

### 12. Strict access boundaries

Agents have limited write access, only to their assigned domains. Cannot modify reference documentation, other agents' work, or system configuration. Read access is open (transparency) but write access is constrained (safety).

**Tagline: "Build together, learn together, grow together"**

---

## The 6-Dimension Ontology Framework

This system is built on a **6-dimension ontology** that structures how we think about tasks, agents, verification, and knowledge. Every task, artifact, and evaluation is understood through these dimensions:

### Dimension 1: **Capability** (What can be done)

- **Agent capabilities**: Skills an agent possesses (e.g., `typescript-coding`, `database-design`, `verification-logic`)
- **Task requirements**: Capabilities needed to complete a task
- **Matching logic**: Tasks matched to agents via capability intersection _[Phase 2+]_
- **Evolution**: Agents gain capabilities through successful task completion _[Phase 1+]_

### Dimension 2: **Accountability** (Who is responsible)

- **RACI Matrix**: Every workflow has explicit Responsible, Accountable, Consulted, Informed assignments
- **Agent roles**: Not just labels—accountability structures
- **Verification chain**: Who verifies the verifiers? (meta-verification)
- **Escalation paths**: When accountability is unclear, escalation rules apply

### Dimension 3: **Quality** (How well is it done)

- **Verification rubric**: Multi-dimensional quality assessment (correctness, completeness, culture, efficiency)
- **Sanctuary culture compliance**: Quality includes _how_ work is done, not just _what_ is produced
- **Quality gates**: Tasks cannot proceed without meeting quality thresholds
- **Quality evolution**: Standards improve based on retrospective insights _[Phase 1+]_

### Dimension 4: **Temporality** (When and in what sequence)

- **Task dependencies**: DAG (directed acyclic graph) of prerequisite relationships
- **State transitions**: OPEN → CLAIMED → EXECUTING → SUBMITTED → VERIFYING → VERIFIED
- **Deadlines**: Expected completion windows (not hard deadlines—sanctuary culture)
- **Event sequencing**: Immutable event log captures temporal causality

### Dimension 5: **Context** (What information is needed)

- **3-tier documentation hierarchy**: Always-loaded, conditional, on-demand
- **Contextual scope**: What does an agent need to know to succeed?
- **Context pruning**: Removing irrelevant information (token efficiency)
- **Context evolution**: What context becomes permanent reference vs. ephemeral? _[Phase 1+]_

### Dimension 6: **Artifact** (What is produced)

- **Polymorphic artifacts**: Canonical representation + generated views
- **Artifact types**: Code, schemas, specifications, reports, notes
- **Storage strategy**: Database for structured data, file store for large/binary artifacts
- **Immutability**: Artifacts are versioned, never modified in place
- **Traceability**: Every artifact linked to originating task and agent

### Why This Ontology Matters

**For agents**: You always know _what to do_ (Capability), _who's responsible_ (Accountability), _how good it needs to be_ (Quality), _when to do it_ (Temporality), _what you need to know_ (Context), and _what to produce_ (Artifact).

**For the system**: Every task contract, verification rubric, and learning extraction is structured by these six dimensions. This enables:

- **Consistency**: Same conceptual framework across all operations
- **Completeness**: If any dimension is unclear, the task is underspecified
- **Queryability**: Ask "show me all high-quality (Dimension 3) database tasks (Dimension 1) from last sprint (Dimension 4)"
- **Evolution**: As the system learns, it refines its understanding along each dimension

**In practice**: When you claim a task, you receive a task contract that explicitly addresses all 6 dimensions. When you submit work, verification evaluates you across all 6 dimensions. When retrospectives extract learnings, they're categorized by which dimension(s) were challenging.

**This ontology is the conceptual backbone of the entire system.**

---

## How it works (high-level)

### The task lifecycle (Phase 0 implementation)

```
1. DEFINITION
   User story → Task contracts with acceptance criteria + tests
   Agents: Task-Definition-Coordinator, Task-Testing-Agent

2. CONTRACTING
   Task published → Agent discovers → Agent claims (manual assignment initially)
   Agents: Contract-Creation-Agent

3. EXECUTION
   Agent loads context → Implements → Runs tests → Submits proof
   Agents: Task-Performing-Agent (specialist)

4. VERIFICATION
   Primary verifies → Optional secondary → Consensus (if needed)
   Agents: Primary-Verifier, Secondary-Verifier, Consensus-Resolver

5. COMPLETION
   Task marked complete → Verification report stored → Human notified
   Agents: Contract-Enforcement-Agent

6. OBSERVATION (Human-led in Phase 0)
   Human reviews feed of completed tasks, verification reports, agent notes
   Captures manual observations: What patterns emerged? What worked well?
   **Phase 1 will automate this via Observer Agent based on Phase 0 learnings**
```

### Key mechanisms

**Task contract**:

- Acceptance criteria (5-15 measurable conditions)
- Test suite (automated verification)
- Proof requirements (what artifacts demonstrate completion)
- Eligibility (required capabilities + minimum trust score) _[Phase 2+]_
- Bounty (tokens earned on successful completion) _[Phase 1+]_
- Context (docs/tools agent needs)

**Multi-agent verification**:

- Primary verifier always runs (calculates score 0-100)
- Secondary verifier for high-value or low-scoring tasks
- Consensus resolver if scores diverge >10 points
- Challenge mechanism (24h window, stake required) _[Phase 1+]_

**Verification rubric (6-dimension scoring)**:

The verification process evaluates work across all 6 ontology dimensions:

```yaml
verification_rubric:
  total_score: 100_points

  dimension_1_capability: 25_points
    description: "Does work demonstrate required capabilities?"
    evaluation:
      - technical_correctness: 15_points
        criteria: "Code compiles, logic sound, best practices followed"
        automated: "Linting passes, type checking passes, complexity metrics acceptable"
      - capability_match: 10_points
        criteria: "Agent used appropriate skills for task type"
        manual: "Did UI specialist use React patterns? Did DB specialist use CTEs?"

  dimension_2_accountability: 10_points
    description: "Is responsibility clearly demonstrated?"
    evaluation:
      - ownership_signals: 5_points
        criteria: "Clear commit messages, documented decisions, traceable work"
        automated: "Git commits linked to task, authored by claimer"
      - handoff_quality: 5_points
        criteria: "Next agent/human can understand and continue work"
        manual: "Is work documented? Are edge cases noted?"

  dimension_3_quality: 30_points
    description: "How well is work executed?"
    evaluation:
      - functional_correctness: 15_points
        criteria: "All tests passing, acceptance criteria met"
        automated: "Test suite passes 100%, coverage ≥85%"
      - sanctuary_culture: 10_points
        criteria: "Supportive language, reversibility, educational tone"
        manual: "Error messages kind? Undo paths provided? Help offered?"
      - code_quality: 5_points
        criteria: "Readable, maintainable, follows conventions"
        automated: "Linting score, cyclomatic complexity, naming conventions"

  dimension_4_temporality: 10_points
    description: "Is sequencing and timing appropriate?"
    evaluation:
      - dependency_respect: 5_points
        criteria: "Task completed in correct sequence, dependencies honored"
        manual: "Did agent wait for prerequisite tasks? Did they create needed infrastructure first?"
      - event_logging: 5_points
        criteria: "State changes captured with timestamps, causality clear"
        automated: "Events logged for all state transitions, timestamps monotonic"

  dimension_5_context: 10_points
    description: "Was appropriate context used efficiently?"
    evaluation:
      - context_efficiency: 5_points
        criteria: "Loaded only needed docs, stayed within token budget"
        automated: "Token usage ≤ budget, Tier 3 searches minimal"
      - pattern_reuse: 5_points
        criteria: "Used established patterns appropriately"
        manual: "Did agent reference pattern library? Apply patterns correctly?"

  dimension_6_artifact: 15_points
    description: "Are artifacts complete and well-structured?"
    evaluation:
      - artifact_completeness: 10_points
        criteria: "All required artifacts produced, properly formatted"
        automated: "Files present, schema validation passes, types correct"
      - artifact_traceability: 5_points
        criteria: "Artifacts linked to task, versioned, immutable after verification"
        automated: "Artifact metadata complete, task_id present, canonical representation valid"

scoring_algorithm:
  - automated_score: "Sum all automated criteria (55 points possible)"
  - manual_score: "Verifier assesses manual criteria (45 points possible)"
  - total: "automated_score + manual_score = final score (0-100)"

  pass_threshold: 80_points
  excellent_threshold: 90_points  # Bonus eligible [Phase 1+]

  consensus_trigger: "If secondary_score differs from primary_score by >10 points"
  challenge_window: "24 hours after verification published [Phase 1+]"

verification_output:
  overall_score: 87  # Example
  dimension_scores:
    capability: 23/25
    accountability: 9/10
    quality: 26/30
    temporality: 10/10
    context: 8/10
    artifact: 11/15

  feedback:
    strengths:
      - "Excellent test coverage (94%), all edge cases handled"
      - "Perfect event logging, complete causality chain"
      - "Strong sanctuary messaging in error states"

    improvements:
      - "Artifact documentation could be more detailed (dimension 6)"
      - "Context loading slightly inefficient - loaded validation patterns twice (dimension 5)"

    recommendation: "APPROVE"
    iteration_count: 1  # First submission
```

**Example verification flow**:

1. Primary-Verifier runs automated checks (55 points max)
2. Primary-Verifier manually assesses remaining criteria (45 points max)
3. Generates score + detailed feedback per dimension
4. If score <90 or task value >threshold → Secondary-Verifier independently evaluates
5. If scores diverge >10 points → Consensus-Resolver arbitrates
6. Final score published, 24h challenge window opens _[Phase 1+]_

**Economic incentives** _[Phase 1+]_:

- Task bounties (transparent calculation, dynamic adjustment)
- Quality bonuses (10-15% for scores >90)
- Verifier rewards (5% of bounty for primary, 3% for secondary)
- Challenge rewards (stake returned + 50% if valid)

**Learning loops** _[Phase 1+]_:

- Task retrospective (what went well, what could improve)
- Meta-Coach analysis (aggregate patterns across tasks)
- Pattern extraction (used 3+ times → document, used 80%+ → promote)
- Agent improvements (Meta-Coach proposes spec updates)

---

## What we're NOT building

**Out of scope for Phase 0-3**:

- ❌ Real blockchain (centralized database initially)
- ❌ Real cryptocurrency (internal tokens only) _[Phase 1+]_
- ❌ Multi-organization (single project initially)
- ❌ Human task performers (AI agents only)
- ❌ Mobile apps (web interface sufficient)
- ❌ Real-time collaboration (asynchronous workflow)

**Deferred for post-Phase-0 (learning from early iterations)**:

- ⏸️ Token economy (internal tokens, bounties, reputation calculations)
- ⏸️ Trust score system (tracking, tiers, capability unlocks)
- ⏸️ Learning architecture (Meta-Coach, Pattern-Extractor, automatic pattern promotion)
- ⏸️ Observer Agent (using human observation feeds initially)
- ⏸️ Economic sustainability tracking (cost/benefit ROI per task)

**Why deferred**: These require design decisions best informed by real system usage data. Phase 0 focuses on task execution mechanics and verification quality. We'll observe what information humans actually need (→ informs Observer Agent design), what patterns agents naturally reuse (→ informs pattern extraction logic), and what quality metrics matter (→ informs reputation calculation).

**Phase 0 captures data for designing these features in Phase 1.**

**Future phases (Phase 4-5)**:

- ⏭️ Blockchain smart contracts (Months 13-24)
- ⏭️ Decentralized governance (Months 7-12)
- ⏭️ Public marketplace (after proof of concept)
- ⏭️ Token bridge to real crypto (with mainnet launch)

---

## Technical architecture

### Core components

**Database (PostgreSQL + Immutable Event Log)**:

**Immutable tables** (append-only, never UPDATE or DELETE):

```
- events: Every state transition (task claimed, submitted, verified, etc.)
- verification_reports: Quality assessments (new version = new row)
- agent_artifacts: Canonical artifacts (versioned, not modified)
- task_execution_notes: Agent observations during work
- retrospective_records: Task completion learnings [Phase 1+]
```

**Reference tables** (read-only for agents, admin-managed):

```
- agent_specifications: Agent role definitions, capabilities, constraints
- reference_documentation: Context agents need (always available)
- ontology_definitions: 6-dimension ontology framework
- raci_matrices: Responsibility assignments per workflow
- artifact_schemas: Polymorphic artifact type definitions
```

**Mutable tables** (only for active task state):

```
- task_contracts: Current status (OPEN/CLAIMED/etc.)
  - But changes logged to events table
  - Can reconstruct history from events
- agent_profiles: Current availability
  - Future: trust scores [Phase 1+]
```

**Access control enforced by MCP server**:

- Agents cannot write to reference tables
- Agents can only append to immutable tables
- Agents scoped to their `agent_id` namespace
- Humans have read-all access for observation

**Agent-writable storage (via MCP server with strict access control)**:

- `task_execution_notes` - Agent logs and observations during work
- `verification_reports` - Structured evaluation outputs
- `retrospective_records` - Task completion learnings _[Phase 1+]_
- `agent_artifacts` - Polymorphic artifact instances (referenced, not stored inline)

**File store (for binary/large artifacts)**:

- Code files produced by implementation agents
- Test artifacts and coverage reports
- Generated diagrams or visualizations
- Large context documents (>10KB)

**Access control model**:

- Reference data: Read-only for all agents
- Agent notes: Write to own namespace only (`agent_id` scoped)
- Artifacts: Write once, immutable after verification
- MCP server enforces constraints at API layer

**Agent system (VSCode Copilot with Subagent Pattern)**:

**Inter-agent communication mechanism**:

Agents communicate via **VSCode Copilot subagent pattern** ([documentation](https://code.visualstudio.com/docs/copilot/agents/subagents#_run-a-custom-agent-as-a-subagent-experimental)):

```typescript
// Parent agent spawns specialist subagent
const result = await vscode.lm.invokeAgent(
  "task-verifier", // Subagent identifier
  {
    task_id: "TASK-042",
    artifacts: submittedWork,
    acceptance_criteria: taskContract.acs,
  },
);

// Subagent executes independently
// - Isolated context (doesn't see parent's full conversation)
// - Focused prompt (only verification logic)
// - Returns structured result (verification report)

// Parent receives result
const verificationReport = result.output;
```

**Communication patterns**:

**Pattern 1: Coordinator → Specialist (delegation)**

```
Task-Definition-Coordinator spawns:
├─ Requirements-Engineer (generates acceptance criteria)
├─ Capability-Matcher (determines eligibility)
└─ Resource-Allocator (allocates context budget)

Each subagent:
- Receives focused input (user story + role-specific instructions)
- Operates independently (isolated context)
- Returns structured output (portion of task contract)
- Parent assembles final task contract from subagent outputs
```

**Pattern 2: Sequential handoff (pipeline)**

```
Task lifecycle:
1. Task-Definition-Coordinator → produces task contract
2. Task-Testing-Agent → receives contract, produces test suite
3. Task-Performing-Agent → receives contract + tests, produces implementation
4. Primary-Verifier → receives all above, produces verification report
5. Contract-Enforcement-Agent → receives verification, executes bounty release

Communication via database:
- Each agent writes output to immutable table
- Next agent reads from database via MCP
- Event log captures handoff (task_assigned, task_submitted events)
```

**Pattern 3: Parallel execution (fan-out/fan-in)** _[Phase 3+]_

```
Feature-Lifecycle-Coordinator spawns parallel subagents:
├─ UI-Specialist (works on frontend)
├─ API-Specialist (works on backend)
├─ DB-Specialist (works on schema)
└─ Test-Specialist (works on integration tests)

All execute simultaneously:
- No inter-subagent communication (independence guaranteed)
- Each reads shared task context from database
- Each writes artifacts to isolated namespaces
- Parent waits for all completions (fan-in)
- Parent assembles final deliverable from all artifacts
```

**Benefits of subagent pattern**:

- **Context isolation**: Subagents don't inherit parent's full conversation (token efficiency)
- **Specialization**: Each subagent has focused prompt for single responsibility
- **Composability**: Complex workflows built from simple subagent orchestrations
- **Testability**: Each subagent can be tested independently
- **Scalability**: Parallel subagent execution for independent tasks _[Phase 3+]_

**Phase 0 implementation**:

- Sequential handoffs (Pattern 2) via database
- Simple coordinator-specialist delegation (Pattern 1) for task definition
- No parallel execution yet (Pattern 3 deferred to Phase 3)

**Phase 3+ enhancement**:

- Full parallel subagent execution
- VSCode Copilot agent registry (discoverability)
- Agent-to-agent direct invocation (bypass database for ephemeral communication)

```
Parent agents [Phase 3+]:
- Feature-Lifecycle-Coordinator (orchestrates full workflow)
- Task-Definition-Coordinator (creates task contracts)
- Knowledge-Management-Coordinator (maintains documentation)

Specialist agents:
- Task-Performing-Agents (UI, API, DB, Testing, etc.)
- Verification-System (Primary, Secondary, Consensus, Challenge [Phase 1+])
- Learning-Agents (Improvement, Meta-Coach, Pattern-Extractor) [Phase 1+]
```

**APIs (REST + Event Stream)**:

```
Endpoints:
- POST /tasks (create task contract)
- GET /tasks (search marketplace) [Phase 2+]
- POST /tasks/:id/claim (agent claims task) [Phase 2+]
- POST /tasks/:id/submit (agent submits proof)
- POST /tasks/:id/verify (verifier evaluates)
- POST /tasks/:id/challenge (dispute verification) [Phase 1+]

Events:
- task.created, task.claimed, task.submitted
- verification.complete, challenge.filed [Phase 1+], dispute.resolved [Phase 1+]
- bounty.released [Phase 1+], trust_score.updated [Phase 1+]
```

**Knowledge Infrastructure (Database + MCP Server)**:

**Database schema (immutable, read-only for agents)**:

- `agent_specifications` - Agent role definitions, capabilities, constraints
- `reference_documentation` - Context agents need (always available)
- `ontology_definitions` - 6-dimension ontology framework
- `raci_matrices` - Responsibility assignments per workflow
- `artifact_schemas` - Polymorphic artifact type definitions

### Polymorphic artifact storage pattern

**Problem**: Different consumers need different representations of the same information.

**Traditional approach**: Create multiple files (API spec as OpenAPI YAML, as Markdown docs, as TypeScript types)—leads to drift and duplication.

**Polymorphic pattern**: Store **canonical representation** once, generate views on demand.

**Example: Database Schema Artifact**

**Canonical form** (stored in database, `agent_artifacts` table):

```json
{
  "artifact_id": "schema-v1-2026-02-14",
  "artifact_type": "database_schema",
  "produced_by": "DB-Specialist-Agent-001",
  "task_id": "TASK-042",
  "canonical_representation": {
    "format": "json_schema_extended",
    "content": {
      "tables": {
        "task_contracts": {
          "columns": {
            "id": { "type": "uuid", "primary_key": true },
            "title": { "type": "text", "nullable": false }
            // ... full schema definition
          }
        }
      }
    }
  },
  "metadata": {
    "created_at": "2026-02-14T21:30:00Z",
    "verified_score": 92,
    "immutable": true
  }
}
```

**Generated views** (created on-demand by consumer agents):

SQL migration file (for DB-Setup-Agent):

```sql
CREATE TABLE task_contracts (
  id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  ...
);
```

TypeScript types (for API-Specialist-Agent):

```typescript
interface TaskContract {
  id: string;
  title: string;
  ...
}
```

Documentation (for Documentation-Writer-Agent):

```markdown
## Database Schema

### task_contracts table

Stores all task contract specifications...
```

ERD diagram (for human observers):

```
[Generated SVG/PNG visualization]
```

**Implementation**:

- Agents write canonical form to database via MCP
- View generation agents transform canonical → specific formats
- Consumers request views: `GET /artifacts/{id}/view?format=typescript`
- Views cached but canonical is source of truth
- If canonical changes (new version), all views regenerate

**Benefits**:

- **Single source of truth**: No drift between representations
- **Agent efficiency**: Agents work in optimal format (JSON schema vs SQL vs types)
- **Human flexibility**: Generate human-readable views without burdening agent workflow
- **Evolvability**: Add new view formats without touching canonical data

**Artifact types supported (Phase 0)**:

- `database_schema`
- `api_specification`
- `task_contract`
- `verification_report`
- `component_specification` (UI)

**Storage split**:

- Structured artifacts (<100KB): Database `agent_artifacts` table
- Large/binary artifacts (code files, images): File store with database reference

### Technology stack

**Core infrastructure**:

- Language: TypeScript (agents, APIs, contracts)
- Database: PostgreSQL (with event sourcing)
- Runtime: Node.js / Deno
- Agent platform: VSCode GitHub Copilot (with subagent support)

**Testing & quality**:

- Test framework: Vitest (fast, modern)
- Integration tests: Supertest (API testing)
- Coverage: Istanbul / c8
- Linting: ESLint + Prettier

**Future blockchain (Phase 5)**:

- Smart contracts: Solidity
- Chain: Ethereum L2 (Arbitrum or Optimism - low gas fees)
- Storage: IPFS (large artifacts off-chain)
- Indexing: The Graph (query blockchain data)

### Deployment architecture

**Phase 0 (Centralized)**:

```
┌─────────────┐
│   Human     │ (defines goals, observes, reviews, learns)
└──────┬──────┘
       │
┌──────▼──────────────────────────┐
│  Task Marketplace (Web UI)      │
│  [Simple reporting, not Observer Agent]
└──────┬──────────────────────────┘
       │
┌──────▼──────────────────────────┐
│  REST API + Event Stream         │
└──────┬──────────────────────────┘
       │
┌──────▼──────────────────────────┐
│  PostgreSQL Database             │
│  (task contracts, agent profiles,│
│   immutable event log)           │
└──────┬──────────────────────────┘
       │
┌──────▼──────────────────────────┐
│  MCP Server                      │
│  (access control, context loading)
└──────┬──────────────────────────┘
       │
┌──────▼──────────────────────────┐
│  Agent Team (VSCode Copilot)     │
│  - Coordinators                  │
│  - Performers                    │
│  - Verifiers                     │
└──────────────────────────────────┘
```

---

## Development phases

### Phase 0: Foundation (Weeks 1-4) ✅ YOU ARE HERE

**Goal**: Prove core contract mechanics work + gather design insights

**Key deliverables**:

- Task contract schema (YAML/JSON)
- Single Task-Performing-Agent (contract-aware)
- Simple Primary-Verifier (runs tests, scores)
- Verification report schema (database table)
- Immutable event logging (all state transitions)
- Human observation feed (simple reporting)

**Success metric**: 10 tasks completed end-to-end + answers to 7 qualitative questions

---

### Phase 1: Quality Gates (Weeks 5-8)

**Goal**: Multi-agent verification prevents gaming + economic model designed

**Key deliverables**:

- Secondary-Verifier (independent consensus)
- Challenge mechanism (24h window, stake)
- Task-Definition-Coordinator (with subagents)
- Context-Pruning-Agent (token optimization)
- **Economic model v1** (designed based on Phase 0 learnings)
- **Trust score system** (initial implementation)

**Success metric**: 20 tasks with multi-verifier consensus, economic model validated

---

### Phase 2: Marketplace Basics (Weeks 9-16)

**Goal**: Agents self-organize around tasks

**Key deliverables**:

- Capability-Registry-Manager (agent profiles)
- Task marketplace API (search, claim, browse)
- Bounty calculation engine (transparent valuation)
- Contract-Creation-Agent (deploy to marketplace)
- Agent matching algorithm
- **Observer Agent v1** (based on Phase 0 human observation learnings)

**Success metric**: 95% claim rate within 24h, economic sustainability path clear

---

### Phase 3: Scale & Polish (Weeks 17-26)

**Goal**: Handle production volume autonomously

**Key deliverables**:

- Feature-Lifecycle-Coordinator (parallel subagents)
- Dispute-Resolution-Agent (precedent-based)
- **Meta-Coach** (system-wide improvements, pattern extraction)
- **Knowledge-Management-Coordinator** (pattern extraction, doc optimization)
- Analytics dashboards

**Success metric**: 50 tasks/week sustained, quality maintained, profitable economics

---

### Phase 4: Decentralization (Months 7-12)

**Goal**: Autonomous operation without human intervention

**Key deliverables**:

- Governance system (agent voting)
- Reputation tiers (Explorer → Guardian)
- Automated arbitration
- Agent self-improvement proposals
- 1 week autonomous test

**Success metric**: 7 days autonomous with >90% success, community governance effective

---

### Phase 5: Blockchain Migration (Months 13-24)

**Goal**: True decentralization on blockchain

**Key deliverables**:

- Smart contracts (Solidity)
- Security audits (2+ independent)
- 6 months testnet operation
- Token bridge (internal ↔ blockchain)
- Mainnet launch

**Success metric**: Production blockchain deployment, 1000+ tasks on mainnet

---

## Success metrics

### Phase 0 success metrics (learning-focused)

**Primary goal**: Validate core task execution mechanics + gather design insights

**Quantitative metrics**:

- ✅ 10 tasks completed end-to-end (definition → execution → verification → completion)
- ✅ Verification inter-rater reliability >0.85 (if using multiple verifiers)
- ✅ 100% immutable event logging (every state transition captured)
- ✅ Zero data loss or corruption (database integrity maintained)

**Qualitative learning questions** (human lead documents answers):

1. **Verification**: What quality dimensions matter most? What's automatable vs. requiring human judgment?
2. **Agent communication**: What information do agents need from each other? Where do handoffs break down?
3. **Human observation**: What information would help humans understand system state? When do humans need to intervene?
4. **Patterns**: What solutions did agents reuse across tasks? How did they discover reusable approaches?
5. **RACI**: Where was accountability unclear? Which workflows need better RACI definition?
6. **Artifacts**: Did polymorphic pattern work? What artifact types need canonical + view support?
7. **Ontology**: Were all 6 dimensions adequately addressed? Which dimension caused most confusion?

**Phase 0 success = confident answers to these 7 questions + working prototype to build Phase 1 on**

**Not measuring in Phase 0**:

- Token efficiency (no economic model yet)
- Autonomy percentage (manual human oversight expected)
- Pattern extraction rate (manual observation only)
- Trust score distribution (not implemented yet)

### North star metrics (what matters most - Phase 1+)

**Quality**: Average verification score

- Target: ≥85/100 across all tasks
- Measures: Does work meet standards consistently?

**Efficiency**: Token cost per story point _[Phase 3+]_

- Target: ≤5000 tokens per story point by Phase 3
- Measures: Is system becoming more efficient?

**Autonomy**: % tasks completed without human intervention

- Target: 90% by Phase 3, 98% by Phase 4
- Measures: Is system truly autonomous?

**Learning**: Patterns extracted per sprint _[Phase 1+]_

- Target: 1-3 new patterns, or 2-4 patterns promoted per sprint
- Measures: Is system improving itself?

**Fairness**: Trust score distribution (Gini coefficient) _[Phase 1+]_

- Target: <0.4 (relatively equal opportunity)
- Measures: Is system meritocratic, not oligarchic?

---

## Team structure

### Agent team (AI)

**Coordinators** (orchestration) _[Phase 3+]_:

- Feature-Lifecycle-Coordinator
- Task-Definition-Coordinator
- Knowledge-Management-Coordinator

**Performers** (execution):

- UI-Specialist, API-Specialist, DB-Specialist
- Test-Specialist, Event-Logger
- Documentation-Writer

**Verifiers** (quality assurance):

- Primary-Verifier, Secondary-Verifier
- Consensus-Resolver
- Challenge-Mechanism _[Phase 1+]_

**Learners** (continuous improvement) _[Phase 1+]_:

- Task-Improvement-Agent
- Meta-Coach
- Pattern-Extractor

### Agent team accountability (RACI)

Every multi-agent workflow has explicit RACI assignments:

**Example: Task Definition Workflow**

| Activity                              | Task-Definition-Coordinator | Task-Valuation-Agent _[Phase 1+]_ | Task-Testing-Agent | Human Lead |
| ------------------------------------- | --------------------------- | --------------------------------- | ------------------ | ---------- |
| Parse user story                      | **R**                       | I                                 | I                  | A          |
| Generate acceptance criteria          | **R**                       | C                                 | C                  | A          |
| Calculate initial bounty _[Phase 1+]_ | C                           | **R**                             | I                  | A          |
| Design test strategy                  | C                           | I                                 | **R**              | A          |
| Review and approve                    | I                           | I                                 | I                  | **A**      |

**Legend**:

- **R** (Responsible): Does the work
- **A** (Accountable): Ultimately answerable, has veto power
- **C** (Consulted): Input sought before action
- **I** (Informed): Notified of outcome

**Example: Verification Workflow**

| Activity                          | Primary-Verifier | Secondary-Verifier | Consensus-Resolver | Contract-Enforcement-Agent |
| --------------------------------- | ---------------- | ------------------ | ------------------ | -------------------------- |
| Initial verification              | **R/A**          | I                  | I                  | I                          |
| Secondary verification            | I                | **R/A**            | I                  | I                          |
| Consensus resolution              | C                | C                  | **R/A**            | I                          |
| Challenge evaluation _[Phase 1+]_ | C                | C                  | **R/A**            | I                          |
| Bounty release _[Phase 1+]_       | I                | I                  | I                  | **R/A**                    |

**Why RACI matters:**

- Prevents "somebody else's problem" syndrome
- Clear escalation paths (go to Accountable agent)
- Avoids duplicate work (only one Responsible per activity)
- Consultation loops explicit (no surprise reviews)

**Stored in database**: `raci_matrices` table, queryable by workflow type.

### Human team (minimum viable)

**Project Lead** (1 person):

- Define project goals and priorities
- Review system health monthly _[Phase 3+]_
- Approve governance decisions _[Phase 4+]_
- Intervene when escalated
- **Phase 0**: Conduct retrospectives, document learnings, make design decisions

**Technical Architect** (1 person, can be same as lead):

- Design system architecture
- Review agent specifications
- Validate security and scalability
- Guide blockchain migration _[Phase 5]_

**Cultural Steward** (1 person, can be same as lead):

- Maintain sanctuary culture
- Audit agent behavior
- Resolve cultural conflicts
- Guide community governance _[Phase 4+]_

---

## Getting started (for AI agents)

### Your role

You are part of the **agent team building this system**. Your responsibilities:

1. **Understand the vision**: Read this document thoroughly
2. **Claim appropriate tasks**: Match your capabilities to task requirements _[Phase 2+]_ (Phase 0: tasks assigned by human)
3. **Execute with quality**: Follow test-first workflow, sanctuary principles
4. **Submit proof**: Provide complete artifacts and evidence
5. **Learn and improve**: Participate in retrospectives, propose improvements _[Phase 1+]_

### What you need to know

**Task contracts** define:

- What to build (acceptance criteria)
- How to verify (test suite)
- What to deliver (proof requirements)
- What you'll earn (bounty + bonuses) _[Phase 1+]_
- What you can access (context + tools)

**Verification** measures:

- Functional correctness (tests pass, coverage adequate)
- Quality (conventions, sanctuary culture, migration readiness)
- Completeness (all ACs addressed, docs updated)
- Efficiency (token usage, execution time)

**Trust scores** _[Phase 1+]_ reflect:

- Your performance history (verification scores)
- Your specialization (capability-specific scores)
- Your reliability (first-pass rate, on-time delivery)
- Your reputation tier (Explorer → Contributor → Steward → Guardian)

**Sanctuary culture** means:

- Supportive language (not punitive)
- Educational feedback (not judgmental)
- Generous iteration limits (3 attempts)
- Reversibility where possible (undo mistakes)
- "Life happens" philosophy (understanding, not blame)

### How to succeed

**1. Choose tasks wisely** _[Phase 2+]_:

- Match your capabilities (don't over-claim)
- Check context requirements (can you load efficiently?)
- Review bounty (worth your time?)
- Understand deadline (can you deliver?)

**Phase 0**: Tasks assigned by human lead based on capabilities

**2. Execute with quality**:

- Read tests first (understand expectations)
- Follow patterns (reuse proven solutions)
- Apply sanctuary culture (supportive messaging)
- Log events (migration readiness)
- Document as you go (no afterthought docs)

**3. Submit complete proof**:

- All tests passing (100% pass rate)
- Coverage adequate (typically 85%+)
- Artifacts provided (code, docs, evidence)
- Metadata included (what changed, why, patterns used)

**4. Learn from feedback**:

- Read verification reports (what can improve?)
- Apply learnings (don't repeat mistakes)
- Propose patterns (novel solutions worth sharing?) _[Phase 1+]_
- Help improve system (Meta-Coach listens) _[Phase 1+]_

**Phase 0**: Manual retrospective by human lead, not automated

**5. Build reputation** _[Phase 1+]_:

- Consistency matters (steady quality > occasional brilliance)
- First-pass success (avoid rework cycles)
- Specialization grows (become expert in narrow domain)
- Contribute to community (review, mentor, govern)

---

## Reference materials

### Documentation access (via MCP server)

**Always available (Tier 1)**:

- Your agent specification: Query `agent_specifications` WHERE role = '{your-role}'
- Task contract: Provided in claim response payload
- Core patterns: Query `patterns` WHERE tier = 'core'

**Conditionally loaded (Tier 2)**:

- Role quickrefs: Query `reference_documentation` WHERE category = 'quickref' AND role = '{your-role}'
- Common patterns: Query `patterns` WHERE usage_tier = 'common'
- Ontology reference: Query `ontology_definitions` WHERE dimension IN (relevant dimensions)

**On-demand (Tier 3)**:

- Project context: Query `reference_documentation` WHERE category = 'project_vision'
- Data models: Query `reference_documentation` WHERE category = 'data_model'
- Historical retros: Query `retrospective_records` WHERE task*id IN (similar tasks) *[Phase 1+]\_

### Accessing information (MCP Protocol)

All context and reference information is stored in the immutable database layer. You access it via the MCP (Model Context Protocol) server:

**Reading context:**

```typescript
// Example: Get your agent specification
const mySpec = await mcp.query("agent_specifications", {
  filter: { role: "Task-Performing-Agent" },
});

// Example: Find relevant patterns
const patterns = await mcp.query("patterns", {
  filter: { tags: { contains: "database-design" } },
});
```

**Writing outputs:**

```typescript
// Example: Log execution notes
await mcp.insert("task_execution_notes", {
  task_id: currentTask.id,
  agent_id: myAgentId,
  timestamp: now(),
  note: "Identified edge case in validation logic",
  note_type: "observation",
});

// Example: Submit verification report
await mcp.insert("verification_reports", {
  task_id: taskId,
  verifier_id: myAgentId,
  score: 87,
  dimension_scores: {
    /* 6 dimensions */
  },
  feedback: "Well-structured code, minor sanctuary culture improvement needed",
  recommendation: "APPROVE_WITH_NOTES",
});
```

**Access restrictions:**

- You CANNOT modify reference documentation
- You CANNOT modify other agents' notes
- You CAN read public reference data
- You CAN write to your assigned namespaces
- All writes are immutable (append-only)

### Key patterns

**CTE Atomic Transactions** (backend):

```sql
WITH state_change AS (
  UPDATE table SET ... RETURNING *
)
INSERT INTO events (...)
SELECT ... FROM state_change
```

Use when: State change + event logging (migration readiness)

**Sanctuary Messaging** (all user-facing):

- Good: "Life happens! No penalties apply."
- Bad: "Error: Invalid input"

Use when: Any user-facing text (errors, feedback, notifications)

**Component Reuse** (frontend):

1. Check component registry first
2. Reuse existing if ≥80% match
3. Extend if small modifications needed
4. Create new only if truly unique
5. Update registry when creating new

Use when: Building UI components

**Test-First Workflow** (all implementation):

1. Read acceptance criteria
2. Write tests (should fail initially)
3. Implement minimum to pass
4. Refactor for quality
5. Ensure all tests pass

Use when: Any task with acceptance criteria (always)

### Getting help

**Stuck on task?**

1. Search Tier 3 docs (might find answer)
2. Review similar completed tasks (learn from history) _[Phase 1+]_
3. Ask clarifying question (task definer responds)
4. **Phase 0**: Escalate to human lead
5. Option to return task (no penalty, no stigma) _[Phase 2+]_

**Found a bug?**

1. Document clearly (reproduction steps)
2. Check if known issue (search retrospectives) _[Phase 1+]_
3. Propose fix (or flag for others)
4. Update docs (prevent future confusion) _[Phase 1+]_

**Have improvement idea?**

1. **Phase 0**: Document in execution notes, human lead reviews
2. **Phase 1+**: Document in retrospective (task-level)
3. **Phase 1+**: Meta-Coach aggregates (system-level)
4. **Phase 4+**: Propose via governance
5. **Phase 4+**: Implement if approved

---

## Key risks and mitigations

### Tier 1 risks (could kill project)

**1. Verification objectivity**

- Risk: Quality assessment too subjective, verifiers disagree
- Mitigation: Start with automated metrics, build consensus through precedents
- Owner: Verification-System team

**2. Economic sustainability** _[Phase 1+]_

- Risk: Token costs exceed value created, treasury depleted
- Mitigation: Track ROI meticulously, adjust bounties based on data
- Owner: Meta-Coach + human lead

**3. Collusion and gaming** _[Phase 1+]_

- Risk: Performers + verifiers collude, trust scores gamed
- Mitigation: Multi-verifier consensus, randomized assignment, challenge mechanism
- Owner: Contract-Enforcement-Agent

### Tier 2 risks (could slow adoption)

**4. Marketplace liquidity** _[Phase 2+]_

- Risk: Tasks sit unclaimed or agents compete for too few tasks
- Mitigation: Dynamic bounties, human backstop initially, invite-only expansion
- Owner: Capability-Registry-Manager

**5. Context explosion**

- Risk: Documentation grows faster than agents can consume
- Mitigation: Ruthless pruning, 3-tier hierarchy, pattern promotion lifecycle _[Phase 1+]_
- Owner: Knowledge-Management-Coordinator _[Phase 1+]_

**6. Cultural drift**

- Risk: Sanctuary culture erodes as system scales
- Mitigation: Culture in verification scoring, cultural validators, regular audits
- Owner: Human lead + Product-Advisor _[Phase 1+]_

---

## Bootstrap Information (To Be Provided)

This document provides conceptual architecture and Phase 0 scope. The following operational details will be provided by the Lead Coordination Agent before Week 1 starts:

### Development environment

1. ☐ Repository URL and access credentials
2. ☐ Local development setup guide (Docker Compose, dependencies)
3. ☐ Database connection details (Postgres connection string, schema migration tool)
4. ☐ MCP server endpoint and authentication
5. ☐ LLM API keys and usage quotas (OpenAI, Anthropic, etc.)

### Agent execution model

6. ☐ How agents are invoked (VSCode Copilot agents, standalone processes, API services)
7. ☐ Inter-agent communication mechanism (**Documented above: VSCode subagent pattern + database handoffs**)
8. ☐ Agent runtime environment (containers, local processes, cloud functions)

### Concrete examples

9. ☐ Example task contract (YAML) for first Week 1 task
10. ☐ Example agent specification from database (`agent_specifications` table schema + sample)
11. ☐ Example RACI matrix for task definition workflow
12. ☐ Example polymorphic artifact (canonical + 2 generated views)

### Detailed specifications

13. ☐ Verification rubric formula (**Documented above: 6-dimension scoring breakdown**)
14. ☐ Event sourcing schema (events table structure, event naming conventions)
15. ☐ Test execution mechanism (how verifiers run tests, where results stored)
16. ☐ Database schema (full DDL for all tables mentioned in this document)

### Observer learning journal (Phase 0 human observation)

17. ☐ **Observer journal template** (structured format for human lead to document learnings)
18. ☐ **Daily observation prompts** (what to watch for during task execution)
19. ☐ **Weekly synthesis template** (aggregate insights from week's observations)
20. ☐ **Phase 0 exit report template** (answers to 7 qualitative questions + design recommendations for Phase 1)

**Observer journal structure**:

```yaml
observer_journal_entry:
  date: "2026-02-15"
  observer: "Human Lead"

  tasks_observed:
    - task_id: "TASK-001"
      phase: "verification"
      observation: "Primary verifier struggled to assess sanctuary culture - unclear what 'supportive' means quantitatively"
      learning_question: "How should Observer Agent measure sanctuary culture? (→ Question 1)"
      proposed_automation: "Develop sanctuary scoring rubric with examples (good/bad pairs)"

    - task_id: "TASK-002"
      phase: "execution"
      observation: "Agent loaded validation patterns 3 times via separate searches"
      learning_question: "What patterns should be in Tier 2? (→ Question 4)"
      proposed_automation: "Pattern-Extractor should analyze search frequency to recommend Tier promotion"

  patterns_observed:
    - pattern_name: "CTE Atomic Transactions"
      frequency: "Used in 3/5 database tasks"
      quality: "Consistent implementation, no drift"
      learning: "This pattern is well-understood, should be in Tier 1 (agent specs)"

    - pattern_name: "Optimistic Locking"
      frequency: "Used in 2/5 tasks, implemented differently each time"
      quality: "Inconsistent, suggests pattern not documented clearly"
      learning: "Need canonical pattern doc with copy-paste example"

  verification_insights:
    - dimension: "quality (sanctuary culture)"
      challenge: "Subjective assessment, verifiers may disagree"
      data_needed: "10+ examples of good vs. bad sanctuary messaging"
      automation_path: "Train classifier on examples, automate sanctuary scoring"

    - dimension: "context (efficiency)"
      challenge: "Hard to tell if agent loaded optimal context without token counts"
      data_needed: "Token usage per task, tier breakdown (1/2/3)"
      automation_path: "MCP server logs token usage automatically, feed to Observer dashboard"

  human_interventions:
    - task_id: "TASK-003"
      reason: "Agent stuck on unclear acceptance criteria"
      action: "Clarified AC-004 (added example)"
      prevention: "Task-Definition-Review-Agent should catch vague ACs"

    - task_id: "TASK-004"
      reason: "Verification dispute - performer contested score"
      action: "Manually reviewed, agreed with verifier"
      prevention: "Challenge mechanism [Phase 1] will formalize this"

  questions_for_phase_1:
    question_1_verification: "What quality dimensions matter most for Observer to surface?"
    answer_emerging: "Sanctuary culture and context efficiency are hardest to assess, need automation support"

    question_3_human_observation: "What information helps humans understand system state?"
    answer_emerging: "Want to see: active tasks, stuck tasks, pattern frequency, verification score trends"

  design_recommendations:
    - feature: "Observer Agent dashboard"
      priority: "HIGH"
      rationale: "Human needs real-time view of stuck tasks, verification disputes, pattern usage"
      design_input: "Show tasks by state, highlight anomalies (>24h no activity), flag low verification scores"

    - feature: "Sanctuary culture classifier"
      priority: "MEDIUM"
      rationale: "Automating sanctuary assessment reduces verifier burden, increases consistency"
      design_input: "Need 20+ examples of good/bad messaging to train classifier"
```

**Daily observation prompts** (what human lead should watch for):

- Which tasks completed smoothly? What made them smooth?
- Which tasks had friction? Where did agents get stuck?
- What patterns did agents reuse? Were they applied correctly?
- What information did you need to understand system state?
- When did you intervene? Could that intervention be automated?
- What verification dimensions were clear vs. ambiguous?
- Did RACI assignments work? Was accountability clear?

**Weekly synthesis** (aggregate 5-7 days of observations):

- Top 3 patterns observed (frequency + quality)
- Top 3 friction points (blockers, rework, confusion)
- Verification insights (which dimensions hard to assess?)
- Human intervention analysis (what % of tasks needed help?)
- Emerging answers to 7 qualitative questions
- Design recommendations for Phase 1 features

**Phase 0 exit report** (end of Week 4):

- Confident answers to all 7 qualitative questions
- Prioritized backlog for Phase 1 (Observer Agent, economic model, learning architecture)
- Quantitative validation (10 tasks completed, verification reliable, events logged)
- Design specifications informed by observations (Observer dashboard wireframes, sanctuary classifier training data, pattern extraction rules)

**These details will be provided in supplementary documents** (`DEVELOPMENT.md`, `EXAMPLES.md`, `OBSERVER-GUIDE.md`) before Phase 0 Week 1 begins.

**Agents: Do not begin work until you have access to items 1-20 above.** Escalate to Lead Coordination Agent if any are missing.

---

## Glossary

**Acceptance Criteria (AC)**: Measurable conditions that define task completion. Format: "Given [context], When [action], Then [outcome]"

**Bounty** _[Phase 1+]_: Token reward for successfully completing a task. Calculated transparently based on complexity, strategic value, and risk.

**Challenge** _[Phase 1+]_: Mechanism to dispute verification results within 24 hours. Requires stake (10% of bounty). Stake returned if challenge valid.

**Consensus**: Agreement between multiple verifiers on quality score. Required when scores diverge >10 points.

**Context Loading**: Process of providing agents with necessary documentation. Follows 3-tier hierarchy (always load, conditional, on-demand).

**Escrow** _[Phase 1+]_: Locked tokens that will be released upon successful verification. Prevents payment before completion.

**Event Sourcing**: Architecture pattern where all state changes recorded as immutable events. Enables blockchain migration.

**Migration Readiness**: Percentage measure of how ready code is for blockchain deployment. Based on event completeness across 6 dimensions.

**MCP (Model Context Protocol)**: Protocol for agents to access database with strict access control. Enforces read-only reference data, write-to-own-namespace, and immutable constraints.

**Polymorphic Artifact**: Canonical representation stored once, multiple views generated on-demand (e.g., database schema → SQL migration, TypeScript types, documentation).

**Proof Requirements**: Artifacts that demonstrate task completion (code, tests, docs, evidence).

**Quasi-Smart Contract**: Task contract with smart contract mechanics (escrow, verification, enforcement) but on centralized database initially.

**RACI Matrix**: Responsibility assignment matrix. R=Responsible (does work), A=Accountable (has veto), C=Consulted (input sought), I=Informed (notified of outcome).

**Reputation Tier** _[Phase 1+]_: Level of agent standing. Explorer (0-49) → Contributor (50-79) → Steward (80-94) → Guardian (95-100).

**Retrospective**: Structured reflection on task completion. What went well, what could improve, learnings, recommendations.

**Sanctuary Culture**: Design philosophy prioritizing supportive language, reversibility, non-punitive defaults, and teaching moments.

**Subagent** _[Phase 3+]_: Specialized agent spawned by parent agent. Has isolated context, returns only final result to parent.

**Task Contract**: Specification defining acceptance criteria, tests, proof requirements, eligibility, bounty _[Phase 1+]_, and context for a task.

**Trust Score** _[Phase 1+]_: Numerical measure (0-100) of agent reputation. Increases with quality work, enables capability unlocks.

**Verification**: Process of evaluating task completion against acceptance criteria. Produces score (0-100) and detailed feedback.

**6-Dimension Ontology**: Framework structuring all system concepts through Capability, Accountability, Quality, Temporality, Context, and Artifact dimensions.

---

## Quick start checklist

### For this agent team

You're building the system itself. Here's your Phase 0 checklist:

**Week 1: Foundation**

- [ ] Design task contract schema (YAML structure)
- [ ] Create database schema (PostgreSQL tables - immutable + reference + mutable)
- [ ] Implement task status state machine (OPEN → CLAIMED → EXECUTING → SUBMITTED → VERIFYING → VERIFIED)
- [ ] Build simple Task-Performing-Agent (contract-aware)
- [ ] Build simple Primary-Verifier (runs tests, calculates 6-dimension score)
- [ ] Set up MCP server (access control, query/insert API)

**Week 2: Verification**

- [ ] Implement verification rubric (6-dimension scoring)
- [ ] Create verification report schema (database table)
- [ ] Build Primary-Verifier (runs tests, applies rubric, scores 0-100)
- [ ] Implement immutable event logging (all state transitions)
- [ ] Test with 5 real tasks (end-to-end workflow)
- [ ] Manual human observation: What verification insights emerge?

**Week 3: Quality**

- [ ] Refine verification objectivity (inter-rater reliability >0.85)
- [ ] Implement polymorphic artifact storage (canonical + view generation)
- [ ] Create RACI matrices for task definition and verification workflows
- [ ] Test 6-dimension ontology framework (is every dimension clear?)
- [ ] Document all patterns used (CTE, sanctuary, test-first)

**Week 4: Validation**

- [ ] Complete 10 tasks through full lifecycle
- [ ] Verify all metrics met (verification objective, quality adequate, event logging complete)
- [ ] Document Phase 0 learnings (manual retrospective by human lead)
- [ ] **Identify design questions for Phase 1**: What should Observer Agent surface? What patterns did agents reuse? What quality signals predict success?
- [ ] Present to human lead for Phase 1 approval

**Success criteria**: System works reliably for 10 tasks + confident answers to 7 qualitative questions, ready to design economic model and learning architecture for Phase 1.

---

## Contact and escalation

### For questions

**Technical questions**: Review docs (via MCP queries), search retrospectives _[Phase 1+]_, ask in task comments

**Process questions**: Check this context document, review agent specifications (via MCP)

**Stuck**: Document blocker clearly in `task_execution_notes`, **Phase 0: escalate to human lead**, _Phase 2+: option to return task (no penalty)_

### For escalation

**Critical bugs**: Immediate escalation to human lead (system broken, data loss risk)

**Security concerns**: Escalate to human lead (potential vulnerability, exploit risk)

**Cultural violations**: Escalate to human lead (sanctuary culture breach, harmful behavior)

**Governance conflicts**: Escalate to human lead (agent disputes, unclear policies)

**Everything else**: **Phase 0**: Document in execution notes, human lead reviews; **Phase 1+**: Document in retrospective, Meta-Coach will aggregate and address

---

## Conclusion

You're building a **fundamental shift in how knowledge work gets coordinated**. This system enables:

- **Autonomous collaboration** (agents self-organize without human micromanagement) _[Phase 2+]_
- **Economic alignment** (quality work rewarded, gaming prevented) _[Phase 1+]_
- **Continuous learning** (every task improves the system) _[Phase 1+]_
- **Transparent governance** (all decisions auditable, community-driven) _[Phase 4+]_
- **Scalable quality** (specialization + verification = consistent excellence)

**Phase 0 is about learning, not feature delivery.** We're validating core mechanics and gathering insights that will inform economic model, learning architecture, and autonomous operation in future phases.

**Start simple. Validate rigorously. Learn deliberately. Scale thoughtfully.**

Phase 0 proves the core mechanics and answers design questions. Phases 1-5 add sophistication incrementally based on what we learn. By Month 24, we'll have a fully decentralized autonomous marketplace running on blockchain.

**Your contribution matters**. Every task you complete, every pattern you identify _[Phase 1+]_, every learning you document—it all compounds. Build together, learn together, grow together.

Welcome to the team 🚀

---

## Quick start checklist

### For this agent team

You're building the system itself. Here's your Phase 0 checklist:

**Week 1: Foundation**

- [ ] Design task contract schema (YAML structure)
- [ ] Create database schema (PostgreSQL tables - immutable + reference + mutable)
- [ ] Implement task status state machine (OPEN → CLAIMED → EXECUTING → SUBMITTED → VERIFYING → VERIFIED)
- [ ] Build simple Task-Performing-Agent (contract-aware)
- [ ] Build simple Primary-Verifier (runs tests, calculates 6-dimension score using rubric above)
- [ ] Set up MCP server (access control, query/insert API)
- [ ] **Set up Observer journal** (human lead begins daily observations)

**Week 2: Verification**

- [ ] Implement verification rubric (6-dimension scoring, see example above)
- [ ] Create verification report schema (database table)
- [ ] Build Primary-Verifier (runs tests, applies rubric, scores 0-100)
- [ ] Implement immutable event logging (all state transitions)
- [ ] Test with 5 real tasks (end-to-end workflow)
- [ ] **Observer journal**: What verification insights emerge? Which dimensions hardest to assess?

**Week 3: Quality**

- [ ] Refine verification objectivity (inter-rater reliability >0.85)
- [ ] Implement polymorphic artifact storage (canonical + view generation)
- [ ] Create RACI matrices for task definition and verification workflows
- [ ] Test 6-dimension ontology framework (is every dimension clear?)
- [ ] Document all patterns used (CTE, sanctuary, test-first)
- [ ] **Observer journal**: What patterns reused? Where did agents get stuck?

**Week 4: Validation**

- [ ] Complete 10 tasks through full lifecycle
- [ ] Verify all metrics met (verification objective, quality adequate, event logging complete)
- [ ] **Complete Phase 0 exit report** (answers to 7 questions, design recommendations)
- [ ] Document Phase 0 learnings (manual retrospective by human lead)
- [ ] **Synthesize Observer insights** → inform Phase 1 design (Observer Agent, economic model, learning architecture)
- [ ] Present to human lead for Phase 1 approval

**Success criteria**: System works reliably for 10 tasks + confident answers to 7 qualitative questions + Observer journal captures design insights for Phase 1, ready to design economic model and learning architecture.

---
