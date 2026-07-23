# Evidence, Verdict, And Preservation

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
- explicit preservation decision and retained fixture identities.

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
| Scenario records were preserved | Owner read-after-write and retained opaque ids | Owner APIs | Pass/Fail/Skipped |

`Skipped` must identify the missing surface and the next exact validation step.

## Preservation

For every scenario-created or changed dev record:

1. verify the exact owner-domain state;
2. retain the client, appointment, visit, proposal, operation, follow-up, and
   session records;
3. record the opaque identities needed to inspect the retained fixture;
4. write the preservation decision into the fixed CSV `cleanup` field;
5. do not invoke `clear-bookings`, an owner cleanup command, direct deletion,
   acknowledgment-as-cleanup, or a reset.

Preservation applies to `Pass`, `Fail`, and `Blocked` attempts. If a write may
have occurred but owner state is unavailable, report the retained state as
unverified and name the next owner read; never delete to remove the ambiguity.

## Final Report

Lead with `Pass`, `Fail`, or `Blocked`, then provide:

- capability, scenario, channel, environment, location label;
- UTC and local timestamps;
- opaque Call/Recording/Session/Proposal/Visit ids as applicable;
- concise caller and assistant turn summary;
- writes and preservation;
- retry count;
- evidence table;
- observability or harness gaps;
- credential-rotation notice if exposure occurred.

Never report “booked,” “canceled,” or “rescheduled” without owner-domain
terminal evidence.

## Per-Scenario Latest-Run CSV Record

After every attempted phone or browser-chat scenario and its preservation
decision, upsert one row in:

`docs/capabilities/scenarios/last-runs.csv`

Treat scenario identity as the normalized `(scenario, channel)` pair. Replace
the matching row in place and preserve every unrelated row. Append only when no
matching pair exists. A failed preflight after a run label is assigned still
produces a `Blocked` row. If later evidence changes the verdict, replace that
same row.

The CSV header is fixed and ordered:

```csv
scenario,operation,channel,environment,run_label,result,session_id,transport_id,recording_id,request_summary,tool_calls,authority_outcome,caller_visible_result,writes,cleanup,gaps
```

Populate every field. Use `unavailable`, `not started`, `not applicable`,
`None.`, or another explicit safe summary instead of leaving ambiguous blanks.
Keep detailed timestamps, evidence tables, and retry explanations in the user
handoff; use `run_label` for the compact row's run correlation.

Invoke the bundled helper from the workspace root with all fields:

```bash
python3 .agents/skills/run-realtime-scenarios/scripts/upsert_last_run_csv.py \
  --csv docs/capabilities/scenarios/last-runs.csv \
  --scenario "<human name>" \
  --operation "<CANONICAL_OPERATION>" \
  --channel "<phone|browser-chat>" \
  --environment dev \
  --run-label "<label>" \
  --result "<Pass|Fail|Blocked>" \
  --session-id "<opaque id or unavailable>" \
  --transport-id "<opaque id or unavailable>" \
  --recording-id "<opaque id or not applicable>" \
  --request-summary "<concise natural-language request>" \
  --tool-calls "<names and counts>" \
  --authority-outcome "<declared outcome or unavailable>" \
  --caller-visible-result "<concise grounded summary>" \
  --writes "<verified writes or none>" \
  --cleanup "<verified preservation, expiry, or not applicable>" \
  --gaps "<none or concrete missing evidence>"
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

Treat each row as a replaceable operational index to the latest evidence for
one scenario/channel pair, not as domain truth, confirmation, authorization, or
a historical audit ledger.

Upsert this CSV after every attempted scenario. When scenario execution is part
of an active implementation, debugging, or validation task, the result may
guide proportionate source inspection, remediation, another evidence run, and
normal publication of the task's scoped changes. Do not broaden the active task
or treat the CSV as authority for unrelated actions.
