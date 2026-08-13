# Delegation And Failure Semantics

Load this reference when delegated-production scope, recovery behavior, or
failure semantics are directly affected.

## Agentic Delegation Contract

Treat Codex work as delegated production, not advice. For non-trivial work,
establish:

- requested outcome;
- allowed files, services, commands, and side effects;
- owning authority for facts and writes;
- non-goals and forbidden changes;
- validation commands or evidence required before claiming completion;
- review handoff artifacts for the human or next agent.

The human role shifts toward delegation, supervision, verification, and
integration. Keep agent work bounded, reviewable, and evidence-backed. Do not
optimize for apparent productivity by skipping verification, inventing success,
hiding uncertainty, or making broad unreviewable changes.

## Explicit Recoverable Failure

Recoverable failure is allowed when it is domain-approved and represented
truthfully. Fail-hard forbids fabricated success, swallowed errors, permissive
continuation, and hidden fallback outcomes; it does not forbid recovery when:

- the failure is explicit;
- no restricted side effect occurred before authorization;
- authority state is updated;
- stale state is invalidated;
- retries are idempotent or duplicate-safe;
- the next attempt re-enters a valid governed path.

Valid examples include booking slot conflicts, missing required information,
validation errors, dependency timeouts with explicit retry states, and
user-corrected input.

## Failure Semantics

Throw, reject, or propagate precise errors when:

- required data, config, credentials, dependencies, or metadata are invalid;
- a caller lacks authority;
- a domain invariant is violated;
- an owner boundary is unclear;
- a dependency cannot produce a trustworthy answer;
- a write cannot complete exactly as authorized;
- a result would require guessing business truth.

Translate low-level failures into domain errors at boundaries when useful, but
preserve explicit failure semantics.
