# Agent Execution Model

This document defines how agents are invoked, communicate, and operate within the system.

## Invocation Model
- **Platform**: VSCode Copilot Agents / Subagents
- **Trigger**: Human initiation (Phase 0) -> Autonomous triggers (Phase 2+)

## Communication Mechanism
- **Primary**: VSCode Subagent Pattern (Hierarchical)
- **Secondary**: Database Handoffs (Sequential)
- **Protocol**: MCP for state management

## Runtime Environment
- **Local**: VSCode Extension Host
- **Remote**: [To be provided]

## Access Control
- **Reference Data**: Read-only
- **Agent Notes**: Write-only (own namespace)
- **Artifacts**: Immutable (append-only)
