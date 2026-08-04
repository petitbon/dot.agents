# Booking Policy And Finalization

Use this reference when realtime authority work affects Rules booking-policy
evaluation, booking tools, currentness, finalization, or evidence.

## Rules Placement

Booking Workflow supplies Scheduling candidates and owned facts to Rules. Rules
may deterministically filter, rank, select, and explain using versioned policy.
Return policy identity/version, evaluation and input hashes, candidate-set hash,
selected/ranked options, and reason trace.

Rules must not create availability, mutate appointments, bypass Booking
Workflow, infer facts from prose, or own Salon Config/Scheduling truth.

```text
find_bookable_options -> Authority Runtime -> Booking Workflow
  -> Scheduling candidates -> Clients facts -> Rules evaluation
  -> Booking proposal -> grounded realtime result
```

A Rules-selected option is a proposal decision, not a booking.

## Current Booking Tools

- `find_bookable_options` may create or update a proposal, never an appointment.
- `commit_booking` requires active proposal identity and revision, current
  explicit confirmation, idempotency, fresh policy/candidate facts, Scheduling
  write success, terminal operation state, and evidence.
- Material constraint changes invalidate proposals and pending confirmation.
- Stale, expired, conflicted, superseded, or transcript-only proposals fail
  closed.
- Conflict recovery creates a new active proposal through the normal path.

## Finalization And Evidence

Record synchronous evidence before async projection:

- operation/capability, channel, resolver, and correlation context;
- backend authority and authority result;
- finalization status;
- operation/idempotency identity for writes;
- proposal, policy, and candidate hashes where relevant;
- evidence/outbox event identity.

Do not block realtime turns on timeline projections, analytics, exports, or
debug materialization. Do block user-facing success on required backend
finalization.

## Debug Bundle Review Baselines

- Combined multi-provider presentation such as `with Norman and Norma` is not
  a defect merely because it does not map each service to a provider. Report it
  only when authority evidence is missing, inconsistent, or proves that the
  spoken provider facts are wrong.
- A serialized `timelineEntries` array is not defective merely because its
  `seq` values are not monotonically ordered. Report ordering only when the
  bundle contains concrete missing, duplicated, contradictory, or causally
  invalid evidence.
