# Booking Repair And Review

Use this reference for scenario failure classification, forbidden repair shapes,
review questions, and expected architecture or repair output.

## Observability Rule

Traces, logs, scenario labels, and assistant messages should describe the causal
path, not define it.

If the system booked correctly but the trace label is wrong, fix the trace
classification.

If the scenario expected the wrong proof shape, fix the oracle.

If transcript phrasing changed but authority evidence is correct, do not make
the system more brittle just to satisfy transcript matching.

## Forbidden Fix Shapes

Stop and redesign if a proposed change:

- treats assistant text as proof of booking;
- treats transcript wording as confirmation truth;
- accepts stale proposal selections;
- retries an old conflicted slot after recovery;
- keeps stale prepared confirmation after conflict;
- creates a special booking path only because a conflict happened;
- allows booking commit before required confirmation evidence;
- allows booking commit before required identity or material details are
  collected;
- reopens availability after a completed commit without explicit caller intent;
- fixes a scenario by hardcoding exact language;
- weakens authority evidence to make the conversation look cleaner;
- lets a non-owner layer create, confirm, cancel, reschedule, or otherwise
  commit governed booking changes.

## Preferred Repair Shape

When a booking scenario fails:

1. Classify the failure:
   - product behavior;
   - stale state;
   - active proposal binding;
   - confirmation readiness;
   - conflict recovery;
   - terminal commit handling;
   - side-effect ownership;
   - evidence mapping;
   - stale scenario oracle;
   - observability label;
   - presentation wording.

2. Map the causal chain:
   - caller request;
   - normalized intent;
   - active proposal;
   - selection;
   - confirmation readiness;
   - required details;
   - commit attempt;
   - conflict or success;
   - recovery proposal or terminal completion;
   - durable side effect;
   - user-facing disclosure.

3. Fix the weakest correct layer:
   - interpretation if caller meaning was misunderstood;
   - proposal state if active/stale binding is wrong;
   - confirmation state if stale or incomplete confirmation was accepted;
   - recovery state if conflict does not loop back cleanly;
   - terminal state if completion reopens the flow accidentally;
   - authority owner if invalid side effects are possible;
   - evidence mapping if the trace is interpreted incorrectly;
   - scenario oracle if the expected proof shape is stale;
   - presentation only if the caller-facing message is wrong.

4. Add assertions around authority-owned evidence, not just text.

## Review Questions

Before approving a booking or scheduling change, ask:

- What is the currently active proposal?
- What proposal identity does the caller acceptance bind to?
- What clears stale selected options and prepared confirmation?
- What happens after a conflict?
- Does recovery return to the normal stable state?
- Are side effects idempotent or duplicate-safe across retries?
- What prevents retrying an old conflicted slot?
- What terminal state prevents accidental reopening?
- What evidence proves required identity, details, and confirmation were
  collected?
- What evidence proves the booking write happened through the governed authority
  owner?
- Are logs, transcripts, assistant text, or scenario labels being treated as
  truth?
- Are we adding a new path because the business requires it, or because
  implementation history leaked into control flow?
- Would this still work if the caller accepted using different words?
- Would this still work after two consecutive conflicts?

## Output

For architecture work, produce:

- target workflow state model;
- owning authority for each fact, decision, command, side effect, and state;
- active proposal lifecycle;
- confirmation readiness rules;
- recovery-to-stable-state rules;
- idempotency and duplicate-safety design;
- terminal-state handling;
- service-boundary implications;
- deterministic integration evidence, when relevant.

For repair work, produce:

- failure classification;
- causal chain;
- weakest correct layer to fix;
- forbidden fix shapes to avoid;
- proposed normal-path loopback design;
- implementation steps by owner;
- tests or evidence scenarios needed to prevent regression.
