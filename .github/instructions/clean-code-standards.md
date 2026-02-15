# Clean Code Standards

## General
- **Readability**: Code is for humans first. Clear naming, consistent formatting.
- **Simplicity**: Avoid over-engineering. YAGNI (You Aren't Gonna Need It).
- **DRY**: Don't Repeat Yourself. Extract reusable logic.

## TypeScript
- **Types**: Strict typing. No `any` unless absolutely necessary and documented.
- **Interfaces**: Prefer interfaces for public APIs.
- **Async/Await**: Prefer over `.then()`.

## Testing
- **Test-First**: Write tests before implementation.
- **Coverage**: Aim for high coverage of business logic.
- **Clarity**: Tests should document behavior.

## Documentation
- **Comments**: Explain *why*, not *what*. Code explains *what*.
- **JSDoc**: Document public functions and classes.
- **README**: Every module should have a README.

## Database
- **Migrations**: All schema changes via migration files.
- **Indexing**: Index foreign keys and query fields.
- **Nomenclature**: snake_case for DB, camelCase for JS/TS.
