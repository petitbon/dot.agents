# Authority, Confirmation, And Side Effects

Use this reference for authority evidence, confirmation readiness, caller wishes,
Scheduling truth, side-effect ownership, and idempotency.

## Authority Ladder

Use the strongest available authority for each fact:

1. Active proposal evidence: proposal identity, current options, validity,
   correlation, expiration, and invalidation state.
2. Accepted selection evidence: caller acceptance bound to the currently active
   proposal.
3. Confirmation readiness evidence: selected option, required identity/details,
   and proof no material change invalidated the confirmation.
4. Commit evidence: governed booking attempt through the authority owner.
5. Side-effect evidence: created appointment, reservation, order, payment, hold,
   or equivalent durable system-of-record fact.
6. Causal ledger evidence: ordered events, audit records, state transitions,
   traces, and correlation records.
7. Presentation evidence: assistant text, transcript, logs, UI copy,
   screenshots, or scenario prose.

Presentation evidence may support understanding, but it must not override
stronger authority evidence unless presentation itself is the behavior under
test.

## Idempotent Side-Effect Rule

Logical recovery loops must be paired with idempotent or duplicate-safe side
effects.

A retryable flow must not risk duplicate writes, duplicate commits, duplicate
messages, duplicate reservations, duplicate charges, or duplicate state
transitions.

Use stable operation identity, active state identity, idempotency keys, conflict
detection, terminal-state checks, or authority-owned deduplication as
appropriate.

The question is not only:

```text
Can this be retried?
```

The question is:

```text
Can this be retried through the normal path without duplicating or corrupting
the authoritative outcome?
```

## Confirmation Readiness Rule

A caller selecting a proposed slot is not always enough to commit.

Before any governed booking write, the authority layer must know:

- selected option;
- active proposal identity;
- required caller identity and contact details;
- required service, provider, time, and location details;
- required policy, payment, deposit, or consent evidence when applicable;
- proof that no material fact changed after proposal selection;
- proof that the caller authorized the exact commit-ready booking facts.

Do not infer confirmation readiness from friendly assistant language, transcript
shape, or scenario names.

## Identity And Missing Detail Rule

Missing required details should not create a parallel booking path.

If the caller accepts a valid active proposal but required identity or material
details are missing:

1. preserve the accepted current proposal only if still valid;
2. ask for the missing required detail;
3. bind the returned detail to the same active confirmation context;
4. commit through the same normal booking path once preconditions are satisfied.

If a conflict or material change occurs while collecting the missing detail,
invalidate the stale confirmation and return to proposal recovery.

## Caller Wishes Are Not Truth

Caller preferences are wishes unless salon policy or scheduling authority makes
them hard constraints.

Examples of caller wishes:

- "next week";
- "morning if possible";
- "with Maria";
- "earliest available";
- "back to back";
- "same stylist as last time";
- "not too expensive."

Use wishes to guide search, ranking, clarification, and explanation.

Do not let wishes override Scheduling truth, salon policy, service rules,
provider eligibility, duration rules, or commit preconditions.

## Scheduling Truth Rule

Scheduling owns availability and appointment truth.

The model, realtime adapter, workflow layer, and SDK must not invent:

- available times;
- unavailable times;
- providers;
- provider eligibility;
- prices;
- service durations;
- appointment IDs;
- booking outcomes;
- cancellation or reschedule outcomes.

They may request, rank, transform, present, and narrate Scheduling-owned facts,
but they must not become the source of those facts.

## Side-Effect Ownership Rule

Governed booking writes must happen only through the authority owner.

Conversational, realtime, adapter, UI, or scenario layers may request or narrate
a booking, but they must not own the booking write.

The authority owner must enforce:

- active proposal validity;
- confirmation readiness;
- conflict safety;
- duplicate prevention;
- idempotency;
- policy compliance;
- durable side-effect creation.
