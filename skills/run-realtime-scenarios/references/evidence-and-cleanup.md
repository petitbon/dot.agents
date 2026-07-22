# Evidence, Verdict, And Cleanup

Read this reference before issuing the final scenario verdict.

## Evidence Precedence

Use this order:

1. owner-domain and Workflow Engine terminal evidence;
2. Session Ledger tool, finalization, transcript, and turn-metric evidence;
3. adapter/runtime correlation and transport metadata;
4. heard recording or finalized browser rendering;
5. transcription or screenshots.

Lower evidence may prove presentation or transport, but cannot override missing
or contradictory authority evidence.

## Required Assertions

Evaluate the exact canonical scenario. At minimum report:

- correct deployed channel and location;
- trusted runtime context injection;
- one valid capability dispatch, subject to documented schema repair;
- owner-authority result and evidence kind;
- correct presentation/finalization ordering;
- confirmation readiness and current-turn binding for mutations;
- domain write count and idempotency;
- absence of forbidden writes;
- recording/rendering actually heard or seen;
- cleanup result or explicit preservation decision.

Transport `completed` means only that the transport completed.
`NO_AVAILABILITY` fails a positive `PROPOSAL_READY` fixture even when the
no-availability response is otherwise governed.

## Verdict Table

Use concrete rows such as:

| Guarantee / Rule | Evidence | Command / File | Result |
| --- | --- | --- | --- |
| Deployed phone path executed | Twilio Call SID, timestamps, dual recording | Twilio REST response | Pass |
| Scheduling supplied candidates | Debug bundle dependency/tool evidence | Session Ledger debug bundle | Pass/Fail/Skipped |
| Proposal was heard before confirmation | Ordered recording/transcript evidence | Recording + Session Ledger | Pass/Fail |
| One governed write occurred | Booking terminal evidence and Scheduling visit | Owner APIs | Pass/Fail/Skipped |
| Cleanup removed the exact fixture | Preview, command, read-after-delete | Owner runbook/script | Pass/Fail/Skipped |

`Skipped` must identify the missing surface and the next exact validation step.

## Cleanup

For a created dev visit:

1. verify the exact visit through Scheduling;
2. locate the current owner-orchestrated cleanup runbook;
3. preview the exact environment, business, location, client, visit, and time;
4. run only the documented `agentis-scripts-local` command through
   `yarn cli run`;
5. verify the visit is absent and no unrelated record changed.

Do not delete through Firestore, the adapter, or an improvised direct service
write. Do not clean up an ambiguous target. If no governed cleanup command
exists, leave the fixture intact, report it, and mark cleanup `Skipped`.

## Final Report

Lead with `Pass`, `Fail`, or `Blocked`, then provide:

- capability, scenario, channel, environment, location label;
- UTC and local timestamps;
- opaque Call/Recording/Session/Proposal/Visit ids as applicable;
- concise caller and assistant turn summary;
- writes and cleanup;
- retry count;
- evidence table;
- observability or harness gaps;
- credential-rotation notice if exposure occurred.

Never report “booked,” “canceled,” or “rescheduled” without owner-domain
terminal evidence.

## Latest-Run Markdown Record

After every attempted phone or browser-chat scenario, overwrite this workspace
file:

`docs/capabilities/scenarios/last-run.md`

Keep only the latest run; do not append history. Update it after the cleanup or
preservation decision and before the final response. A failed preflight after a
run label is assigned still produces a `Blocked` record. If later debug-bundle
or owner evidence changes the verdict, replace the record with the corrected
outcome.

Use this shape:

```markdown
# Last Realtime Scenario Run

- Scenario: <human name>
- Operation: `<CANONICAL_OPERATION>`
- Channel: `phone` | `browser-chat`
- Environment: `dev`
- Run label: `<label>`
- Started: `<UTC>` (`<local time and timezone>`)
- Ended: `<UTC>` (`<local time and timezone>`)
- Result: **Pass** | **Fail** | **Blocked**

## Correlation

- Session: `<opaque id or unavailable>`
- Transport: `<opaque call/chat id or unavailable>`
- Recording: `<opaque id, not a media URL, or not applicable>`

## Outcome

- Customer request: <concise natural-language summary>
- Tool calls: <names and counts>
- Authority outcome: <terminal/declared outcome or unavailable>
- Caller-visible result: <concise grounded summary>
- Writes: <verified writes or none>
- Cleanup: <verified result, preservation decision, expiry, or not applicable>
- Retries: <count and reason>

## Evidence

| Guarantee / Rule | Evidence | Result |
| --- | --- | --- |
| <assertion> | <source> | Pass / Fail / Skipped |

## Gaps

<None, or concrete missing evidence and next validation step.>
```

Sanitize before writing:

- never persist credentials, auth headers, bearer values, full E.164 numbers,
  email addresses, recording media URLs, or raw secret-file paths;
- use opaque call, recording, session, proposal, operation, and visit ids only
  when they materially aid correlation;
- summarize dialogue instead of storing a full transcript;
- identify evidence sources without copying large debug bundles;
- keep `Skipped` inside evidence rows; the overall result remains `Pass`,
  `Fail`, or `Blocked`.

Treat this file as a replaceable operational index to the latest evidence, not
as domain truth, confirmation, authorization, or a historical audit ledger.
