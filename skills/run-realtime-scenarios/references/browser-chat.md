# Browser-Chat Scenario

Use this reference only for deployed browser-chat scenarios.

## Preconditions

- Use the deployed browser-chat surface for the selected dev location.
- Resolve current installation, origin, channel enablement, and location facts
  through Salon Config and the public/runtime contracts.
- Authenticate through the supported browser flow. Do not bypass user auth with
  internal service credentials.
- Start a fresh session unless the canonical scenario explicitly requires an
  existing active proposal or appointment.
- Use an Alfred Hitchcock film character whenever the scenario supplies a
  client name, and use an email in the `@trimpulse.ai` domain.
- Use one supported open-ended date preference for availability, booking, and
  reschedule scenarios; never type an end date.

## Execution

1. Open the actual deployed widget or application route.
2. Submit the canonical user turn as typed text.
3. Answer only authority-required clarification in a new typed turn.
4. Observe streamed text, but wait for finalized text and authority evidence
   before treating the response as usable.
5. For proposal-only scenarios, stop after the grounded answer. Do not add
   test-control language to the user turn.
6. For mutations, confirm only after the complete finalized proposal and
   warnings are rendered in the current session.
7. Persist the evidence row, then terminalize only the exact active visit
   fixture through Booking and verify Scheduling. Preserve the stable client,
   Session Ledger, Booking, Scheduling, proposal, operation, and terminal
   appointment evidence. Never use broad cleanup or direct deletion.

Do not call Booking, Scheduling, Rules, Service Catalog, Clients, or Salon
Config directly as a substitute for the browser adapter. Owner API reads may be
used for preflight and independent verification only.

## Evidence

Capture:

- browser session and `callSessionId`;
- typed user turns and finalized assistant turns;
- SSE completion/finalization status;
- capability dispatch and strict result status;
- Session Ledger debug bundle;
- Booking/Scheduling read-after-write evidence for mutations.

Partial SSE text, local React state, screenshots, and assistant wording do not
prove domain success. Raw authority ids must not leak into caller-visible text.

## Failure Handling

Stop on malformed or unfinalized output, wrong-location scope, auth ambiguity,
missing session correlation, duplicated dispatch, or a write narrated before
terminal evidence. Apply the shared retry budget from `execution-gates.md`.
