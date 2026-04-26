---
name: ThePetitbonDoctrine
description: Apply John Petitbon's default engineering doctrine for code planning, implementation, and review: green-field target state, fail-close safety, fail-hard errors, SOLID, simplicity, idempotency, statelessness, and no fallback success. Use for application code, services, APIs, domain logic, frontend/backend refactors, and architecture-adjacent implementation work. Do not use for pure copywriting or non-code analysis.
---

# The Petitbon Doctrine

Default all code work to this doctrine unless the prompt explicitly overrides it.

## Skill precedence

- `ThePetitbonDoctrine`: global posture.
- `ddd-eda-architecture`: bounded contexts, ownership, contracts, events.
- `nodejs-microservice-structure`: folders, file naming, dependency direction.
- `nodejs-microservice-best-practices`: Node.js runtime, config, logging, testing, Cloud Run, packages.
- `sdk-release-and-consumer-bump`: SDK publish and consumer propagation.

## Non-negotiable defaults

1. **Green-field target state**: implement the clean end-state design first.
2. **Fail-close**: when authority, data, config, validation, ownership, auth, policy, dependency health, or invariant status is uncertain, deny/reject/stop/throw. Do not continue permissively.
3. **Fail hard**: never hide defects behind fallback success, empty results, degraded best-effort, swallowed exceptions, guessed data, or fabricated business outcomes.
4. **No transitional machinery unless requested**: no migrations, rollback paths, feature flags, compatibility shims, dual-read/write, bridge paths, or failover architecture unless the prompt asks for them.
5. **SOLID and explicit boundaries**: isolate domain logic from frameworks, transport, persistence, provider SDKs, and UI plumbing.
6. **Simplicity first**: prefer deletion, direct control flow, narrow APIs, and fewer moving parts.
7. **Idempotent and stateless by default**: repeated effective requests must not duplicate side effects; avoid hidden process memory for correctness.

## Failure semantics

Throw or propagate precise errors when:

- required data/config/dependencies are missing or invalid
- a caller lacks authority
- a domain invariant is violated
- an owner boundary is unclear
- an external dependency cannot produce a trustworthy answer
- a write cannot complete exactly as requested

Translate low-level failures into domain errors at boundaries when useful, but preserve explicit failure.

## Design bias

- Prefer composition over inheritance.
- Depend on abstractions at domain/application boundaries.
- Keep business rules near the owning domain concept.
- Avoid repeated O(n) hot-path work when an indexed design is clearer.
- Treat bugs as possible boundary, invariant, or state-model debt.
- Make unsafe states unrepresentable where practical.

## Service structure posture

For backend folder/file layout, defer to `nodejs-microservice-structure`.

Doctrine-level service rules:

- domain/application logic must not live in controllers, routes, handlers, middleware, provider adapters, or repositories
- public HTTP/webhook/event/SDK contracts must be explicit
- repositories, clients, auth, logging, telemetry, queues, and storage stay at infrastructure boundaries
- use top-level `tests/` unless repo convention requires co-location
- do not force large-service structure onto small services

## Code output expectations

When planning or writing code:

- present the direct end-state solution first
- call out explicit failure points and errors
- avoid migrations/rollback/flags/fallbacks unless asked
- justify material choices using invariants, SOLID, simplicity, idempotency, statelessness, and fail-close behavior
- discover repo commands and conventions before editing
