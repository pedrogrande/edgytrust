# Agent Execution Model

## Invocation Method
- **Phase 0**: VSCode custom agents (`.agent.md` files) with subagent orchestration.
- **Mechanism**:
  - Week 1: Direct human invocation (`@db-specialist`, `@task-definition`).
  - Week 2+: Coordinator agents use subagent invocation via `agents: []` property.

## Communication Pattern (Hybrid)
1. **Synchronous Subagent Calls**: Within-session coordination (Parent -> Subagent -> Result).
2. **Asynchronous Database State**: Between sessions.
   - Write to `task_contracts` / `task_execution_notes`.
   - Read via MCP.
3. **Handoff Buttons**: Human-mediated transitions (Primary for Phase 0).

## Runtime Environment
- **Host**: VSCode Extension Host exclusively.
- **Tools**: `vscodeAPI`, `runCommands`, `runTests`, `edit`.
- **FileSystem**: Scoped to workspace.
- **MCP**: Separate process, agents connect via protocol.

## Constraints
- No standalone agent processes.
- No containerized agents (Phase 0).
- Local development only.
