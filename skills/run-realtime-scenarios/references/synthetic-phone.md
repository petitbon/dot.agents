# Synthetic Phone Scenario

Use this reference only for deployed phone scenarios.

## Supported Purpose

Use Twilio as the synthetic caller so the provisioned salon number follows its
normal inbound webhook and deployed media-stream path. This is a genuine
Twilio Programmable Voice canary, not proof that a human handset or every PSTN
carrier path was exercised.

Static TwiML is suitable for a proposal-only request. It is not an interactive
booking confirmer because fixed pauses cannot prove what was heard.

## Read-Only Preflight

1. Load the dev environment through `agentis-scripts-local/src/script-env.ts`.
2. Resolve user auth through the configured Firebase browser helper when
   `BEARER=firebase_browser`; never send that sentinel as a literal token.
3. Read Salon Config with
   `GET /v1/config/locations/:locationId/config`.
4. Require `channels.phone.enabled`, `channels.phone.runtime.enabled`, and a
   valid `channels.phone.provisionedNumber`.
5. Confirm the requested display-name offers exist in the returned config.
6. List Twilio Incoming Phone Numbers and choose a different owned number with
   `capabilities.voice=true` as the caller.
7. For writes, resolve that ANI through
   `POST /v1/clients/businesses/:businessId/clients/resolve` and apply the
   identity gates in `execution-gates.md`.

Do not discover the salon number or CallSid mapping through Firestore.

## Proposal-Only Call

Create the call with Twilio's Calls REST API:

- `To`: authoritative Salon Config provisioned number;
- `From`: alternate owned voice-capable number;
- `Twiml`: initial pause, one concise `<Say>` request, bounded `<Pause>`, then
  `<Hangup>`;
- `Record=true`;
- `RecordingChannels=dual`;
- a bounded `TimeLimit`.

Speak exactly one short, natural customer request from the canonical scenario.
Do not add test instructions such as “only find options,” “do not book,” or
“this is optional.” Do not pack multiple hypothetical answers into the first
turn. End a proposal-only call after the grounded response; without a later
explicit confirmation, no mutation may execute.

Poll the Call resource at short intervals until `completed`, `busy`, `failed`,
`no-answer`, or `canceled`. Bound the overall deadline and communicate status at
least once per minute.

## Mutation Calls

Use a human caller or an interactive synthetic media harness that can:

1. hear the complete proposal and warnings;
2. choose an exact presented option;
3. respond after presentation;
4. explicitly acknowledge each warning;
5. wait for terminal success or failure wording.

Do not implement mutation confirmation with a fixed `<Pause>` followed by a
prewritten `<Say>Yes</Say>`. Timing is not evidence that an option was heard.

If no interactive caller is available, stop after the proposal and report that
the mutation scenario is blocked by the confirmation harness.

## Recording Evidence

After completion:

1. fetch recording metadata and require the expected dual-channel shape;
2. transcribe in memory if necessary;
3. distinguish caller words, assistant words, silence, truncation, and overlap;
4. record that audio proves presentation only, not tool or domain success.

A short or truncated recording, missing assistant response, or early call end is
a failure. Do not infer tool success from the assistant's wording.

## Session Correlation

Prefer a supported CallSid-to-session API when one exists. Otherwise locate the
phone session in Conversations using location, channel, and exact start time,
then use its `callSessionId` with:

`GET /v1/conversation/sessions/:callSessionId/debug-bundle`

Do not query `realtime_phone_calls`, timeline collections, transcript
collections, or turn metrics directly. If the Conversations UI cannot expose
the matching session and no supported lookup exists, mark tool-level evidence
`Skipped` and record the missing correlation surface.
