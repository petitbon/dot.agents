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

Lead with `Pass`, `Fail`, or `Blocked/Skipped`, then provide:

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

