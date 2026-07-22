---
name: run-realtime-scenarios
description: "Use as the primary skill for executing and evidencing Agentis realtime capability scenarios against deployed dev phone or browser-chat surfaces, including synthetic Twilio calls, live chat turns, proposal and governed mutation flows, Conversations/Session Ledger correlation, recordings, bounded retries, cleanup, and the persisted latest-run Markdown outcome. Trigger when a user asks Codex to run, fake, exercise, or verify a realtime capability end to end. Do not use for unit tests, prompt design, capability-registry design, or architecture-only review."
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

### 5. Decide And Bound Retries

Evaluate every required scenario assertion as `Pass`, `Fail`, or `Skipped`.
`Skipped` requires a concrete reason and next validation step. Allow at most one
corrective retry for a fixture unless the user expressly authorizes more. Stop
when failures repeat, calls terminate progressively earlier, correlation is
missing, or evidence cannot distinguish success from narration.

### 6. Verify And Clean Up

For writes, verify the exact Scheduling/Booking result before cleanup. Use only
the owner-orchestrated dev cleanup command named by the current runbook. Preview
the exact target, run the cleanup once, and verify removal. If the user
explicitly asks to preserve the dev fixture, leave it intact and report its
identity and cleanup obligation.

### 7. Record The Latest Outcome

After every attempted scenario reaches `Pass`, `Fail`, or `Blocked`, overwrite
`docs/capabilities/scenarios/last-run.md` with the latest result. Do this after
the cleanup decision and before the final user handoff. If later evidence
changes the verdict, update the same file. Follow the required schema and
sanitization rules in `references/evidence-and-cleanup.md`.

The latest-run file is an operational evidence summary, not business authority
or authorization. Do not silently omit it when execution or evidence fails. If
the file cannot be updated, report the scenario verdict and the outcome-record
write failure separately; the scenario task remains incomplete.

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
- Never finish a scenario run without updating the canonical latest-run file.

## Required Handoff

Lead with the verdict. Include scenario, environment, channel, timestamps,
transport/session ids, heard transcript summary, backend evidence, writes,
cleanup, retries, and gaps. Use the evidence-table format in
`references/evidence-and-cleanup.md`, and link the updated latest-run file.
