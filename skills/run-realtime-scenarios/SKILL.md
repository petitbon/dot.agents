---
name: run-realtime-scenarios
description: "Use as the primary skill for execution and evidence of deployed dev Agentis phone or browser-chat scenarios: synthetic Twilio, live chat, proposals, governed test mutations, Session Ledger correlation, recordings, preserved fixtures, and the per-scenario latest-run CSV record. Development phone scenarios have standing repository-owner authorization and may run when reasonably necessary to implement, debug, validate, or complete the active task. Do not use for unit tests, prompt or registry design, or architecture-only review."
---

# Run Realtime Scenarios

Execute deployed realtime scenarios without confusing transport success,
assistant prose, or mock tests with authority-backed product evidence.

## Reference Loading

- Always load `references/execution-gates.md` before any external call or chat.
- Load `references/synthetic-phone.md` for Twilio or phone scenarios.
- Load `references/browser-chat.md` for deployed browser-chat scenarios.
- Always load `references/evidence-and-cleanup.md` before issuing a verdict or
  recording the preservation decision for a governed write.

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

## Supported Runner

For all canonical dev scenarios, use the maintained `agentis-scripts-local`
runner. Do not recreate its browser HTTP/SSE flow, Twilio request, preflight,
polling, evidence evaluation, or CSV update in ad hoc shell or inline Node
commands:

```bash
cd agentis-scripts-local
yarn cli run --env dev run-realtime-scenario -- \
  --scenario find-bookable-options \
  --channel browser-chat \
  --service-name "<speakable service>" \
  --date-preference "any day in the afternoon"
```

Development phone execution is covered by standing repository-owner
authorization. Do not request confirmation, approval, an exact call count, a
spending limit, or renewed authorization. The phone command uses the same
ordinary scenario inputs as browser execution:

```bash
yarn cli run --env dev run-realtime-scenario -- \
  --scenario find-bookable-options \
  --channel phone \
  --service-name "<speakable service>" \
  --date-preference "any day in the afternoon"
```

The supported phone path automatically resolves the Twilio CallSid through Call
Session's private business/location-scoped correlation API while the call and
recording complete. It then reads the ended debug bundle and evaluates the
phone evidence in the same run. A bounded correlation or evidence timeout is
`Blocked` evidence for the current attempt and must not cause a manual
correlation fallback. A later runner attempt follows evidence-based engineering
judgment under the standing authorization.

Use `--trials` when repeated evidence is reasonably necessary for the active
task. There is no phone call-count or spending gate. The runner reuses one
bounded preflight snapshot, runs sequentially, and stops on the first `Fail` or
`Blocked`. Additional attempts are separate evidence runs and should be made
only when engineering evidence shows they are useful rather than gratuitous.

Bounded polling for correlation, transport completion, recording readiness, or
the ended debug bundle belongs to one declared attempt and is not a scenario
retry. It must never create another session, turn, call, or governed mutation.

## Standing Authorization And Outcome Scope

The repository owner provides standing authorization for Codex to execute
development phone scenarios, including recorded calls that incur charges,
whenever Codex reasonably determines they are needed to implement, debug,
validate, or complete the active task. This authorization persists across
sessions and includes dedicated dev fixture creation, the declared test effect,
evidence collection, and explicit fixture preservation. Do not add or consult an
approval flag, prompt, token, environment gate, acknowledgment file, call-count
limit, or monetary cap.

Treat scenario outcomes as test evidence. Keep execution within dev, the active
task, the selected capability, and dedicated disposable fixtures. A `Fail` or
`Blocked` outcome may be investigated, remediated, and revalidated when that is
reasonably necessary to complete the active task. Do not use standing phone-test
authorization to broaden product scope, run production calls, bypass domain
ownership, or claim success without authority evidence.

## Workflow

### 1. Classify The Run

Record:

- environment and location;
- channel: phone or browser chat;
- capability and exact canonical scenario;
- proposal-only versus governed mutation;
- expected positive fixture and preservation requirement;
- whether the caller is human or synthetic.

Default to dev. Do not run production or a governed mutation merely because the
user asked for generic testing.

### 2. Establish Preconditions

Resolve configuration through authoritative APIs. Confirm active offers,
channel enablement, runtime enablement, timezone, provider/capability facts, and
an expected-valid search window. For writes, prove a dedicated test client and
a fixture that is safe to retain.

Whenever a scenario supplies a client identity, use an Alfred Hitchcock film
character for the client name and an email in the `@trimpulse.ai` domain. Use
the runner's declared canonical name list and never substitute generic test
labels, staff names, invented names, or another email domain.

For availability, booking, and reschedule requests, use one open-ended
preference through `--date-preference`. Supported forms are `any day` or
`next <weekday>`, optionally followed by `in the morning`, `in the afternoon`,
or `in the evening`. Do not use `any <weekday>` because the current temporal
contract cannot represent all weekday occurrences. Never give the caller a
start/end date range or an end date. Internal preflight may inspect the bounded
authoritative booking horizon; that implementation bound must not become caller
language.

Do not turn an exploratory `NO_AVAILABILITY`, clarification, or runtime failure
into a positive scenario pass. A positive scenario must meet its documented
precondition before execution.

For Provider Availability, let maintained preflight resolve `next <weekday>`
and speak the resulting exact local date. For appointment-backed mutations,
use the owner-backed list ordinal, local date/time, and provider names selected
by the runner. Do not send a final confirmation until the preceding evidence
contains the selected Booking proposal or an explicit cancellation
confirmation prompt.

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

The maintained runner command is mandatory. Do not use an ad hoc manual
fallback. A later runner attempt is appropriate only after evidence identifies
a transient condition or a change worth revalidating.

### 4. Collect Independent Evidence

Capture transport ids and timestamps, Session Ledger/debug-bundle evidence,
tool dispatch and outcome evidence, finalization evidence, and owner-domain
read-after-write evidence when applicable. Correlate through supported APIs;
use the Conversations UI only for capabilities without a maintained supported
resolver. Never substitute a direct Firestore query.

### 5. Decide And Stop

Evaluate every required scenario assertion as `Pass`, `Fail`, or `Skipped`.
`Skipped` requires a concrete reason and next validation step. Run once by
default. Do not retry blindly because an outcome is `Fail` or `Blocked`; inspect
the evidence first and make another attempt only when it can materially validate
a fix or resolve a transient condition. Stop the current attempt when a call
terminates, correlation is missing, or evidence cannot distinguish success
from narration.

### 6. Verify And Preserve

For writes, verify the exact owner-domain result and preserve every created or
changed dev record. Never invoke `clear-bookings`, an owner cleanup command,
fixture deletion, acknowledgment-as-cleanup, or a reset after a scenario.
Record the opaque client, session, proposal, operation, visit, appointment, or
follow-up identities needed to explain what remains. Treat preservation as the
required cleanup decision in the fixed latest-run CSV `cleanup` field.

### 7. Upsert The Latest Outcome

After every attempted scenario reaches `Pass`, `Fail`, or `Blocked`, upsert its
row in `docs/capabilities/scenarios/last-runs.csv`. Match an existing row by
scenario and channel so a browser-chat rerun does not erase the phone result.
Replace the matching row in place; append only when that scenario/channel pair
does not exist. Do this after the preservation decision and before the final user
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
- Never recover or execute deleted tooling. Use only the current configured
  credential source.
- Never use Firestore as a substitute for a missing owner/debug API.
- Never invent availability, providers, prices, policy, identity, confirmation,
  correlation, tool success, or booking outcomes.
- Never bypass Booking or the Workflow Engine for appointment writes.
- Never call a proposal booked before terminal Booking and Scheduling evidence.
- Never accept a static future acknowledgment of unknown warnings.
- Never claim a scenario passed from Twilio `completed`, a recording alone, or
  assistant prose.
- Never run cleanup after a scenario.
- Never leave a material dev write unexplained or without a recorded
  preservation decision and retained fixture identities.
- Never finish a scenario run without upserting the canonical latest-run CSV row.
- Never use a terminal outcome alone as evidence that another call will be
  useful; inspect the active task and available evidence first.

## Required Handoff

Lead with the verdict. Include scenario, environment, channel, timestamps,
transport/session ids, heard transcript summary, backend evidence, writes,
preservation, retries, and gaps. Use the evidence-table format in
`references/evidence-and-cleanup.md`, and link the updated latest-run CSV.
