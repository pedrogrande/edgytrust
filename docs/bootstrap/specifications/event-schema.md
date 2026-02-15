# Event Schema

This document defines the immutable event log structure.

## Event Structure
- `event_id`: UUID
- `timestamp`: ISO-8601
- `type`: String (e.g., `task.created`, `state.transition`)
- `actor_id`: String (Agent ID)
- `payload`: JSON (Event-specific data)
- `causality_id`: UUID (Parent event ID)

## Event Types
- `task.created`
- `task.claimed`
- `task.submitted`
- `verification.completed`
- `artifact.published`

*Note: Detailed schema definitions needed.*
