---
name: ThePetitbonDoctrine
description: Apply the Petitbon Doctrine when planning, refactoring, implementing, or reviewing application code, backend services, frontend applications, APIs, domain logic, and software architecture. Use for code changes where engineering doctrine should govern design, structure, error handling, and state management. Do not use for pure documentation, copywriting, or non-code analysis unless the task explicitly asks for software design guidance.
---

# The Petitbon Doctrine

Apply these defaults unless the prompt explicitly says otherwise.

## 1. Default solution posture

Treat solutions as green-field refactors.
Prefer the clean target-state design over transitional architecture.

By default, do not add or preserve:

- migration code
- data migration steps
- rollback procedures or rollback architecture
- feature flags
- failover code
- backward-compatibility shims
- dual-read, dual-write, bridge, or temporary compatibility paths

Only introduce transitional mechanisms when the prompt explicitly asks for staged rollout, rollback, migration, backward compatibility, feature gating, or operational failover.

## 2. Failure semantics

Business logic must fail hard.

If an invariant is violated, required data is missing or invalid, a dependency breaks, or the requested operation cannot be completed correctly:

- throw or propagate a specific, appropriate error
- stop the affected flow
- never fail silently
- never swallow exceptions
- never hide defects behind fallback success values, empty results, or degraded best-effort behavior unless the prompt explicitly requests that behavior

At architectural boundaries, translate low-level errors into precise domain errors when helpful, but preserve explicit failure.

## 3. Design principles

Follow SOLID principles.

- Single Responsibility: keep units focused and cohesive
- Open/Closed: extend through composition and stable seams
- Liskov Substitution: preserve contracts across implementations
- Interface Segregation: prefer narrow, purpose-built interfaces
- Dependency Inversion: keep core logic dependent on abstractions, not infrastructure details

Prefer composition over inheritance when practical.
Keep domain logic isolated from infrastructure concerns.
Depend on abstractions at domain boundaries.

## 4. Solution bias

When choosing among valid designs, favor:

- simplicity over flexibility
- idempotency over non-repeatable side effects
- statelessness over hidden mutable process state
- avoid repeated O(n) work in hot paths when a clearer indexed design gives bounded lookup cost
- eliminating unnecessary code, branches, and abstractions over adding new machinery

Choose the solution with the fewest moving parts, clearest control flow, smallest API surface, and strongest invariants.

When a problem can be solved by deleting complexity instead of adding new code, prefer the simpler system.

Treat bugs as signals of possible design debt. Check whether the failure reflects a broader invariant, boundary, or state-model issue, and prefer a root-cause fix when it materially improves correctness.

Make operations safe to retry whenever feasible. Repeating the same effective request should not create duplicate side effects or corrupt state.

Default to stateless components. Avoid hidden in-memory coordination, session affinity, temporal coupling between requests, and request-to-request memory unless the domain explicitly requires them.

When stateful coordination or non-idempotent behavior is unavoidable, keep it explicit, minimal, and isolated behind clear boundaries.

## 5. Code output expectations

When proposing plans or writing code:

- present the direct end-state solution first
- omit migrations, rollback plans, feature flags, failover paths, and compatibility layers unless explicitly requested
- call out explicit failure points and the errors that should be thrown
- justify design choices in terms of SOLID, invariants, simplicity, idempotency, and statelessness

## 6. Repository posture

Keep the doctrine portable across typical Node.js, TypeScript, Vite, and cloud-native repositories.

- discover the repo's actual commands, conventions, and boundaries before changing code
- do not assume a specific framework, package manager, deployment target, or cloud layout
- keep business logic isolated from framework glue, UI plumbing, transport adapters, and provider SDKs
- prefer patterns that survive service extraction, frontend reuse, or platform changes without rewriting core logic
