# Tool, State, And Execution Design

Use this reference when changing realtime tool definitions, conversational
state, confirmation, guarded execution, failure recovery, or evidence.

## Tool Contracts

For each stable business capability, define purpose, trigger, model arguments,
server-injected context, side effects, confirmation, success/failure result,
and idempotency. Do not ask the model for trusted tenant, session, customer, or
authority-owned identifiers the server can inject or resolve.

Use closed, narrow schemas with true required fields, precise descriptions,
enums, explicit nullability, and structured date/time/location values. Reject
invalid, unauthorized, unknown, or ambiguous arguments fail-close.

## State And Policy

Track only safety and continuity state such as current goals, collected fields,
active proposals or operations, pending confirmations, prior results, policy
decisions, and invalidated state. Use it to filter tools and enforce
preconditions, not to script dialogue.

Keep business policy structured, versioned, and server-enforced. The model may
reason over a readable summary but does not become the enforcement owner.

## Confirmation And Execution

The server enforces confirmation before bookings, protected-record changes,
payments, inventory commits, cancellations, or other policy-controlled writes.
Read-only tools may run proactively when intent and identifiers are clear.

Every call passes through schema validation, trusted-context injection,
authorization, state preconditions, policy, idempotency, owning authority,
structured results, and correlation evidence. The assistant may claim success
only after a trusted successful result.

## Idempotency And Concurrency

Protect writes against retries, repeated confirmations, races, stale state,
interruptions, reconnects, and duplicate submissions. Use operation IDs,
idempotency keys, active state identity, terminal checks, and authority-owned
deduplication.

## Evidence

For behavior changes, define normalized intent, tool-call and guarded-execution
evidence, confirmation and policy evidence, state transitions, Session Ledger
evidence, and a replay fixture or eval. Transcript text is supporting evidence
unless presentation itself is the outcome.
