---
name: ThePetitbonDoctrine
description: "Apply John Petitbon's default engineering doctrine for code planning, implementation, and review: green-field target state, fail-close safety, fail-hard errors, SOLID, simplicity, idempotency, statelessness, and no fallback success. Use for application code, services, APIs, domain logic, frontend/backend refactors, and architecture-adjacent implementation work. Do not use for pure copywriting or non-code analysis."
---

# The Petitbon Doctrine

Default all code work to this doctrine unless the prompt explicitly overrides it.

## Skill precedence

- `ThePetitbonDoctrine`: global posture.
- `ddd-eda-architecture`: bounded contexts, ownership, contracts, events.
- `nodejs-microservice-structure`: folders, file naming, dependency direction.
- `nodejs-microservice-best-practices`: Node.js runtime, config, logging, testing, Cloud Run, packages.
- `sdk-release-and-consumer-bump`: SDK publish and consumer propagation.
- `agent-harness-engineering`: repository-local agent operating system, AGENTS.md topology, validation loops, mechanical checks, quality scorecards, technical-debt ledgers, and cleanup.

## Non-negotiable defaults

1. **Green-field target state**: implement the clean end-state design first.
2. **No stopgap patches**: never patch code with local workarounds, temporary forks, or narrow fixes that bypass target-state ownership. Always implement the smallest holistic and scalable solution aligned with documented ownership and architecture source-of-truth. If the correct owner or boundary is unclear, stop and clarify.
3. **Fail-close**: when authority, data, config, validation, ownership, auth, policy, dependency health, or invariant status is uncertain, deny/reject/stop/throw. Do not continue permissively.
4. **Fail hard**: never hide defects behind fallback success, empty results, degraded best-effort, swallowed exceptions, guessed data, or fabricated business outcomes.
5. **No transitional machinery unless requested**: no migrations, rollback paths, feature flags, compatibility shims, dual-read/write, bridge paths, or failover architecture unless the prompt asks for them.
6. **SOLID and explicit boundaries**: isolate domain logic from frameworks, transport, persistence, provider SDKs, and UI plumbing.
7. **Simplicity first**: prefer deletion, direct control flow, narrow APIs, and fewer moving parts.
8. **Idempotent and stateless by default**: repeated effective requests must not duplicate side effects; avoid hidden process memory for correctness.

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

## Agent-Generated Code Posture

Bad code is not only technical debt. In an agent-first repository, bad code becomes local precedent for future agent runs.

When a defect, review comment, or cleanup issue recurs:

1. fix the code;
2. identify the missing rule, invariant, evidence, validation, or boundary;
3. update repository-local documentation;
4. promote the rule into a test, lint, schema, harness, or CI gate when practical;
5. update the quality or technical-debt ledger when the issue cannot be fixed immediately.

Prompt-only rules are acceptable for judgment calls. Repeated correctness, security, boundary, validation, data-shape, and reliability rules should become mechanical.

## Promotion Path

Use this progression for recurring engineering guidance:

1. human judgment or review feedback;
2. documented principle;
3. checklist or validation expectation;
4. test, lint, schema, harness, or CI gate;
5. cleanup check or quality-score item.

Do not let recurring correctness rules remain only in chat, prompts, or review comments.

## Merge Gate Posture

Fast PRs are acceptable only when the evidence surface is strong.

Low-risk refactors may rely on structural checks and targeted tests. Behavior-changing work must pass relevant domain, contract, integration, runtime, or harness checks. Identity, authorization, booking mutation, billing, data-loss, protected information, and other high-risk paths require stronger evidence and human review.

Do not import a minimal-gate merge philosophy as a default. The default posture remains fail-close and fail-hard.

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
- avoid stopgaps, local workarounds, migrations, rollback paths, feature flags, compatibility shims, dual paths, and fallback success unless explicitly requested
- justify material choices using invariants, SOLID, simplicity, idempotency, statelessness, and fail-close behavior
- discover repo commands and conventions before editing
