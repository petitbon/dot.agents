# Synthetic Phone Scenario

Use this reference only for deployed phone scenarios.

## Supported Purpose

Use the maintained Telnyx Call Control harness as the synthetic caller so the
provisioned salon number follows its normal inbound webhook and deployed media
path. This is a real provider canary, not proof that a human handset or every
PSTN carrier path was exercised.

The harness is interactive: it waits for Session Ledger evidence before each
caller turn, speaks the next canonical utterance through Call Control, and
supports the declared interruption and recovery plans. Do not replace it with
fixed pauses or prerecorded blanket confirmation.

Use an Alfred Hitchcock film character whenever the scenario supplies a client
name, and use an email in the `@trimpulse.ai` domain. Availability, booking,
and reschedule utterances must use one supported open-ended date preference and
must never include an end date.

## Read-Only Preflight

1. Load dev through `agentis-scripts-local/src/script-env.ts`.
2. Resolve user auth through the configured Firebase browser helper when
   `BEARER=firebase_browser`; never send that sentinel as a literal token.
3. Read Salon Config with
   `GET /v1/config/locations/:locationId/config`.
4. Require `channels.phone.enabled`, `channels.phone.runtime.enabled`, and a
   valid `channels.phone.provisionedNumber`.
5. Confirm the requested display-name offers exist in the returned config.
6. Resolve the exact configured Telnyx-owned caller number and require its
   active status, unique scenario role tag, and Voice application connection.
7. Require the caller to differ from the salon target. For writes, resolve the
   ANI through Clients and apply the identity gates in `execution-gates.md`.

Do not discover the salon number or transport correlation through Firestore.

## Call Control Execution

The maintained runner creates one outbound call with:

- the Salon Config number as `to`;
- the role-bound synthetic number as `from`;
- that number's Voice application connection;
- a bounded call timeout and time limit; and
- recording from answer in dual-channel WAV format.

It resolves the paired inbound call leg from scoped Telnyx call events, then
resolves that provider call id through Call Session's private
business/location-scoped API. After initial-greeting playback evidence, it
delivers each short natural caller turn with Telnyx speak actions and advances
only when the required transcript, tool, proposal, clarification, or playback
evidence is present.

Proposal-only runs end after the grounded response. Mutation runs may confirm
only after the complete active proposal or cancellation prompt and all warnings
have been heard in the same live call. The harness must not pre-schedule a
future “yes.”

## Completion And Recording Evidence

After the final required evidence, the runner hangs up the exact call leg and
requires the provider call to terminate. It then requires:

1. the exact phone Session Ledger scope and ended debug bundle;
2. the declared tool/finalization and owner-domain evidence;
3. a completed dual-channel recording bound to the outbound call leg; and
4. exact owner verification for any mutation.

Recording and transcript prove presentation only. They do not override absent
or contradictory Booking, Scheduling, or Session Ledger authority evidence.

## Identity And Teardown

Stable-caller scenarios keep the Phone persona attached through Clients.
Unregistered-caller scenarios prove the stable persona has no active visits,
detach the same dedicated Phone ANI through Clients, run identity acquisition,
then exact-teardown the acquired fixture and restore and verify the original
stable persona. Any ambiguous identity, active-visit conflict, failed restore,
or unresolved owner state is `Blocked`.

Persist evidence before teardown. Preserve Session Ledger, Booking,
Scheduling, proposal, operation, and terminal records. Terminalize only the
exact active visit fixture through Booking and verify Scheduling; never use
broad cleanup or direct deletion.

## Session Correlation

Use the returned `callSessionId` with:

`GET /v1/conversation/sessions/:callSessionId/debug-bundle`

Do not query runtime, transcript, or metric collections directly. Do not fall
back to guessed time-window matching when the supported resolver conflicts or
times out; record the attempt as `Blocked`. Another attempt requires evidence
of a transient condition or a relevant fix worth validating.
