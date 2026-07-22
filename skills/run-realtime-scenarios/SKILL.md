---
name: run-realtime-scenarios
description: "Use as the primary skill for on-demand execution and evidence of deployed dev Agentis phone or browser-chat scenarios: synthetic Twilio, live chat, proposals, explicitly authorized mutations, Session Ledger correlation, recordings, cleanup, and the per-scenario latest-run CSV record. Trigger only when a user asks Codex to run, fake, exercise, or verify a realtime capability end to end. Record and hand off the outcome; never automatically investigate, retry, remediate, change code or architecture, or publish. Do not use for unit tests, prompt or registry design, or architecture-only review."
---

# Run Realtime Scenarios

Execute deployed realtime scenarios without confusing transport success,
assistant prose, or mock tests with authority-backed product evidence.

## Reference Loading

- Always load `references/execution-gates.md` before any external call or chat.
- Load `references/synthetic-phone.md` for Twilio or phone scenarios.
- Load `references/browser-chat.md` for deployed browser-chat scenarios.
- Always load `references/evidence-and-cleanup.md` before issuing a verdict or
  cleaning up a governed write.

## Source Of Truth

1. Read root `WORKSPACE_CONTEXT.md` and the nearest applicable `AGENTS.md`.
2. Read `docs/capabilities/scenarios/README.md` and the exact scenario at
   `docs/capabilities/scenarios/<capability>.md`.
3. Read the parent capability walkthrough in `docs/capabilities/`.
4. Use owner APIs, runtime contracts, Session Ledger evidence, and Scheduling
   or Booking evidence to decide outcomes.
5. Treat recordings and transcripts as presentation evidence only. Never use
   assistant speech as business truth.

Generated maps and copied plans aid navigation only. Current source, contracts,
scenario docs, and backend evidence decide behavior.

## On-Demand And Outcome Isolation

Run a scenario only in direct response to an explicit user request for that
scenario and channel. Never run scenarios automatically after code changes,
deployments, monitoring events, another scenario outcome, or validation work.

Treat the outcome as test evidence only. After collecting required evidence,
upserting the scenario's latest-run CSV row, and completing any already-authorized
cleanup, stop and hand the result to the user. A `Pass`, `Fail`, or `Blocked`
outcome does not authorize:

- root-cause investigation or additional source, log, architecture, or contract
  exploration beyond evidence required by the scenario;
- code, prompt, configuration, data, contract, documentation, infrastructure,
  or architecture changes;
- deployments, releases, issues, pull requests, commits, pushes, cleanup not
  authorized before the run, or another scenario attempt.

Require a separate user request before diagnosing or fixing an outcome. Route
that new task through its own applicable skill and authorization gates.

Outcome handling must have no side effects beyond upserting one row in
`docs/capabilities/scenarios/last-runs.csv`. Do not commit or push that record
unless the user separately requests publication. The scenario execution itself
may perform only the declared test effect of the exact capability the user
requested. A proposal scenario authorizes only its short-lived proposal. Require
separate explicit authorization for client creation, follow-up creation,
booking, cancellation, reschedule, or cleanup.

## Workflow

### 1. Classify The Run

Record:

- environment and location;
- channel: phone or browser chat;
- capability and exact canonical scenario;
- proposal-only versus governed mutation;
- expected positive fixture and cleanup requirement;
- whether the caller is human or synthetic.

Default to dev. Do not run production or a governed mutation merely because the
user asked for generic testing.

### 2. Establish Preconditions

Resolve configuration through authoritative APIs. Confirm active offers,
channel enablement, runtime enablement, timezone, provider/capability facts, and
an expected-valid search window. For writes, prove a dedicated test client and
a safely disposable fixture.

Do not turn an exploratory `NO_AVAILABILITY`, clarification, or runtime failure
into a positive scenario pass. A positive scenario must meet its documented
precondition before execution.

### 3. Run One Channel Faithfully

Use the deployed adapter, not a mocked media socket, local unit test, direct
domain API, or fabricated transcript. Follow the documented turns and answer at
most the allowed clarifications.

Use only the natural customer language in the canonical scenario. For
proposal-only runs, end after the grounded answer; absence of confirmation is
the mutation guard under test. For mutations, present and hear the complete
active proposal first, then collect one current explicit confirmation. Never
pre-script a blind confirmation for an option or warning that has not actually
been heard.

### 4. Collect Independent Evidence

Capture transport ids and timestamps, Session Ledger/debug-bundle evidence,
tool dispatch and outcome evidence, finalization evidence, and owner-domain
read-after-write evidence when applicable. Correlate through supported APIs or
the Conversations UI. Never substitute a direct Firestore query.

### 5. Decide And Stop

Evaluate every required scenario assertion as `Pass`, `Fail`, or `Skipped`.
`Skipped` requires a concrete reason and next validation step. Run once by
default. Do not retry because the outcome is `Fail` or `Blocked`; another
attempt requires a new user request. Stop when a call terminates, correlation
is missing, or evidence cannot distinguish success from narration.

### 6. Verify And Clean Up

For writes, verify the exact Scheduling/Booking result before cleanup. Use only
the owner-orchestrated dev cleanup command named by the current runbook. Preview
the exact target, run the cleanup once, and verify removal. If the user
explicitly asks to preserve the dev fixture, leave it intact and report its
identity and cleanup obligation.

### 7. Upsert The Latest Outcome

After every attempted scenario reaches `Pass`, `Fail`, or `Blocked`, upsert its
row in `docs/capabilities/scenarios/last-runs.csv`. Match an existing row by
scenario and channel so a browser-chat rerun does not erase the phone result.
Replace the matching row in place; append only when that scenario/channel pair
does not exist. Do this after the cleanup decision and before the final user
handoff. If later evidence changes the verdict, replace the same row.

Use the bundled CSV-aware helper; do not edit CSV with string concatenation:

```bash
python3 .agents/skills/run-realtime-scenarios/scripts/upsert_last_run_csv.py \
  --csv docs/capabilities/scenarios/last-runs.csv \
  <all required row fields>
```

Follow the exact fields, invocation, and sanitization rules in
`references/evidence-and-cleanup.md`.

The CSV row is an operational evidence summary, not business authority or
authorization. Do not silently omit it when execution or evidence fails. If
the row cannot be updated, report the scenario verdict and outcome-record write
failure separately; the scenario task remains incomplete.

## Non-Negotiable Rules

- Never run `gcloud`.
- Never print, interpolate into logs, or persist secrets or full phone numbers.
- Never recover or execute deleted tooling. Use only an explicitly authorized,
  current credential source.
- Never use Firestore as a substitute for a missing owner/debug API.
- Never invent availability, providers, prices, policy, identity, confirmation,
  correlation, tool success, or booking outcomes.
- Never bypass Booking or the Workflow Engine for appointment writes.
- Never call a proposal booked before terminal Booking and Scheduling evidence.
- Never accept a static future acknowledgment of unknown warnings.
- Never claim a scenario passed from Twilio `completed`, a recording alone, or
  assistant prose.
- Never leave a material dev write unexplained or without a recorded cleanup
  decision.
- Never finish a scenario run without upserting the canonical latest-run CSV row.
- Never investigate, diagnose, remediate, or change code or architecture
  automatically because of a scenario outcome.
- Never commit or push the latest-run CSV without a separate user request.
- Never rerun a scenario automatically after a terminal outcome.

## Required Handoff

Lead with the verdict. Include scenario, environment, channel, timestamps,
transport/session ids, heard transcript summary, backend evidence, writes,
cleanup, retries, and gaps. Use the evidence-table format in
`references/evidence-and-cleanup.md`, and link the updated latest-run CSV.
