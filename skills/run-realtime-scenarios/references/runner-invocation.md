# Maintained Realtime Scenario Runner

Load this reference immediately before invoking a deployed scenario.

## Required Runner

Use `agentis-scripts-local`; do not recreate browser HTTP/SSE, Telnyx requests,
preflight, polling, evidence evaluation, correlation, or CSV updates with ad hoc
shell or inline Node commands.

```bash
cd agentis-scripts-local
yarn cli run --env dev run-realtime-scenario -- \
  --scenario find-bookable-options \
  --channel browser-chat \
  --service-name "<speakable service>" \
  --date-preference "any day in the afternoon"
```

For phone, use the same scenario inputs with `--channel phone`. Standing
authorization applies; do not request approval, count, or spending limits.

The phone path resolves the Telnyx inbound call-leg id through Call Session's
private scoped correlation API, waits for call and dual-channel recording
completion, reads the ended debug bundle, and evaluates evidence in the same
run. Correlation or evidence timeout is `Blocked`; never use a manual
correlation fallback.

## Inputs And Preconditions

- Resolve offers, channel/runtime enablement, timezone, provider/capability
  facts, policy, and an expected-valid search window through owner APIs.
- Writes require a dedicated test client and one exact per-trial fixture that
  can be terminalized through its owner after evidence is durable.
- Client identities use the runner's Alfred Hitchcock character list and an
  email in the `@trimpulse.ai` domain.
- Availability, booking, and reschedule use one `--date-preference`: `any day`
  or `next <weekday>`, optionally with morning/afternoon/evening. Never provide
  an end date or use `any <weekday>`.
- Named-provider recovery omits `--date-preference`; maintained preflight finds
  the required recovery branches and derives exact `next <weekday>` wording.
- Provider Availability uses the runner-resolved local date. Appointment
  mutations use the owner-backed ordinal, time, and provider selected by the
  runner.
- A positive scenario must prove its documented precondition; clarification,
  `NO_AVAILABILITY`, or runtime failure is not a positive pass.

Do not send confirmation until the current session has presented the selected
proposal or explicit cancellation prompt and all required warnings.

## Attempts And Polling

Use `--trials` only when repeated evidence is materially useful. Trials run
sequentially and stop on the first `Fail` or `Blocked`; appointment-backed
trials receive separate fixture leases. Bounded polling for correlation,
transport, recording, or debug-bundle readiness belongs to the same attempt and
must not create another session, turn, call, or mutation.

## Faithful Channel Execution

Use only natural customer language from the canonical scenario and answer at
most its allowed clarifications. Proposal-only runs end after the grounded
answer. Mutations require the complete active proposal and warnings before one
current explicit confirmation. Never pre-script blind confirmation for an
option or warning not yet heard or rendered.
