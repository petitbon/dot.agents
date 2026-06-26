---
name: booking-architecture
description: "Use for booking and scheduling architecture work involving proposal state, active proposal identity, confirmation, conflict recovery, retries, stale state, idempotency, duplicate-safe side effects, terminal commits, realtime booking tool sequencing, or booking evidence scenarios. Prefer canonical re-entrant loops and authority-owned evidence over special-case path logic, transcript wording, or scenario labels."
---

# Booking Architecture Evidence First

Use this skill when changing or reviewing booking, scheduling, workflow, realtime assistant, scenario, evidence, or architecture-decision logic.

The goal is to prevent brittle conversational behavior, stale-state bugs, path explosion, and side-effect duplication.

## Core Principle

Keep the conversational layer tolerant and semantic.

Keep the authority layer strict.

The conversational layer may interpret, clarify, summarize, narrate, and recover naturally.

The authority layer owns proposal truth, active selection, confirmation readiness, booking commit, conflict recovery, terminal completion, and durable side effects.

Do not make assistant text, transcript wording, exact confirmation phrases, scenario labels, trace names, tool-attempt shape, or UI copy the source of booking truth.

A booking is proven by authoritative state and side-effect evidence, not by generated language.

## Authority Ladder

Use the strongest available authority for each fact:

1. Active proposal evidence: proposal identity, current options, validity, correlation, expiration, and invalidation state.
2. Accepted selection evidence: caller acceptance bound to the currently active proposal.
3. Confirmation readiness evidence: selected option, required identity/details, and proof no material change invalidated the confirmation.
4. Commit evidence: governed booking attempt through the authority owner.
5. Side-effect evidence: created appointment, reservation, order, payment, hold, or equivalent durable system-of-record fact.
6. Causal ledger evidence: ordered events, audit records, state transitions, traces, and correlation records.
7. Presentation evidence: assistant text, transcript, logs, UI copy, screenshots, or scenario prose.

Presentation evidence may support understanding, but it must not override stronger authority evidence unless presentation itself is the behavior under test.

## Canonical Loop Bias

Prefer canonical re-entrant loops over one-off special-case paths.

When a flow has recoverable failure, missing information, retry, stale state, conflict, timeout, rejection, or correction, first look for a way to return to a normal stable state instead of creating a new dedicated path.

Good shape:

```text
STABLE_STATE
  -> normal attempt
    -> success -> TERMINAL_STATE
    -> recoverable failure -> recovery action -> STABLE_STATE
```

Bad shape:

```text
normal path
retry path
retry-after-conflict path
retry-after-identity path
retry-after-second-conflict path
special post-recovery path
```

A recoverable exception should usually loop back into the same canonical path with fresh authority state.

A terminal success should exit the loop.

Do not create a special path unless the domain truly has different authority rules, different side-effect ownership, or different invariants.

## Idempotent Side-Effect Rule

Logical recovery loops must be paired with idempotent or duplicate-safe side effects.

A retryable flow must not risk duplicate writes, duplicate commits, duplicate messages, duplicate reservations, duplicate charges, or duplicate state transitions.

Use stable operation identity, active state identity, idempotency keys, conflict detection, terminal-state checks, or authority-owned deduplication as appropriate.

The question is not only:

> Can this be retried?

The question is:

> Can this be retried through the normal path without duplicating or corrupting the authoritative outcome?

## Booking State Pattern

Use a normal booking loop rather than special-case booking paths.

Preferred model:

```text
PROPOSAL_PRESENTED
  -> caller accepts/selects
  -> COMMIT_ATTEMPT
    -> CONFIRMED
       -> COMPLETED_COMMIT terminal
    -> SLOT_CONFLICT
       -> RECOVERY_SEARCH
       -> PROPOSAL_PRESENTED
```

After a conflict, the recovered proposal becomes a normal active proposal.

The next caller acceptance must go through the same normal booking path as any other proposal.

Do not create special conflict-specific commit paths such as:

```text
BOOKING_COMMIT_AFTER_SLOT_CONFLICT
```

There should be one booking commit path.

Conflict recovery returns the system to proposal.

## Conflict Recovery Rules

When a conflict occurs:

1. Clear the stale selected option.
2. Clear stale prepared confirmation.
3. Mark the conflicted proposal or option as no longer commit-eligible.
4. Run recovery search through the normal proposal mechanism.
5. Create a new active proposal identity.
6. Present recovered options as ordinary active proposals.
7. Require the next caller acceptance to bind to the new active proposal.
8. Prevent stale acceptance of the old conflicted slot from retrying the old slot.
9. Support multiple recovery cycles.
10. Enforce a sane maximum recovery count to avoid an infinite bad experience.

A valid recovery flow is:

```text
proposal -> accept -> conflict
proposal -> accept -> conflict
proposal -> accept -> collect missing identity if needed -> commit -> completed
```

Each new proposal is normal.

Each acceptance binds only to the currently active proposal.

A successful commit exits the loop.

## Active Proposal Binding

Caller acceptance must bind to the currently active proposal only.

Never accept a selection against:

- an expired proposal;
- a conflicted proposal;
- a superseded proposal;
- a proposal from before a material constraint change;
- a proposal from a previous booking flow;
- a proposal only mentioned in transcript text but absent from active authority state.

Selection phrases such as “yes,” “that one,” “the second one,” “2:30,” “with Jen,” or “earliest” must be resolved against active proposal state, not free-floating transcript memory.

## Stale State Invalidation

Clear active proposal and prepared confirmation whenever a material booking fact changes.

Material changes include:

- date;
- time window;
- service;
- provider or staff preference;
- location;
- duration-affecting choice;
- price-affecting choice where confirmation depends on price;
- required caller identity;
- policy-relevant constraint;
- availability conflict;
- explicit rejection of current options.

Invalidated state must not remain commit-eligible.

## Terminal Commit Rule

A successful booking commit is terminal for that booking flow.

Once the system reaches `COMPLETED_COMMIT`:

- disclose the committed booking facts;
- do not reopen availability automatically;
- do not re-enter proposal search unless the caller explicitly starts a new booking or asks to change the committed booking;
- do not treat post-commit small talk, silence, or acknowledgement as a reason to search again;
- do not keep stale proposal state alive after commit.

The post-commit state must protect the completed booking from accidental reopening.

## One Normal Path Bias

Prefer one normal path with loopback over many special-case paths.

Good architecture:

```text
proposal -> acceptance -> precondition check -> commit attempt -> success terminal
                                      |
                                      -> recoverable conflict -> new proposal
```

Bad architecture:

```text
normal booking path
conflict booking path
post-conflict booking path
identity-after-conflict path
phone-after-conflict path
second-conflict path
```

If multiple branches differ only by how the system arrived there, collapse them into one canonical path.

Arrival history may be evidence or metadata.

It should not create a new business path unless the authority rules are different.

## Identity and Missing Detail Rule

Missing required details should not create a parallel booking path.

If the caller accepts a valid active proposal but required identity or material details are missing:

1. Preserve the accepted current proposal only if still valid.
2. Ask for the missing required detail.
3. Bind the returned detail to the same active confirmation context.
4. Commit through the same normal booking path once preco[118;1:3unditions are satisfied.

If a conflict or material change occurs while collecting the missing detail, invalidate the stale confirmation and return to proposal recovery.

## Side-Effect Ownership Rule

Governed booking writes must happen only through the authority owner.

Conversational, realtime, adapter, UI, or scenario layers may request or narrate a booking, but they must not become the owner of the booking write.

The authority owner must enforce:

- active proposal validity;
- confirmation readiness;
- conflict safety;
- duplicate prevention;
- idempotency;
- policy compliance;
- durable side-effect creation.

## Observability Rule

Traces, logs, scenario labels, and assistant messages should describe the causal path, not define it.

If the system booked correctly but the trace label is wrong, fix the trace classification.

If the scenario expected the wrong proof shape, fix the oracle.

If the transcript phrasing changed but authority evidence is correct, do not make the system more brittle just to satisfy transcript matching.

## Forbidden Fix Shapes

Stop and redesign if a proposed change:

- treats assistant text as proof of booking;
- treats transcript wording as the source of confirmation truth;
- accepts stale proposal selections;
- retries an old conflicted slot after recovery;
- keeps stale prepared confirmation after conflict;
- creates a special booking path only because a conflict happened;
- allows booking commit before required confirmation evidence;
- allows booking commit before required identity or material details are collected;
- reopens availability after a completed commit without explicit caller intent;
- fixes a scenario by hardcoding exact language;
- weakens authority evidence to make the conversation look cleaner;
- lets a non-owner layer create, confirm, cancel, reschedule, or otherwise commit governed booking changes.

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
- What proposal identity does the caller’s acceptance bind to?
- Could this acceptance accidentally bind to an old proposal?
- What clears stale selected options?
- What clears stale prepared confirmation?
- What happens after a conflict?
- Does recovery return to the normal stable state?
- Can the next attempt reuse the same validation and commit path?
- Are side effects idempotent or duplicate-safe across retries?
- What prevents retrying an old conflicted slot?
- What is the terminal state?
- What prevents the loop from continuing after success?
- Is there a maximum retry or recovery count?
- What evidence proves required identity or material details were collected?
- What evidence proves confirmation happened after the current proposal was selected?
- What evidence proves the booking write happened through the governed authority owner?
- Are logs, transcripts, assistant text, or scenario labels being treated as truth?
- Are we adding a new path because the business requires it, or because implementation history leaked into control flow?
- Would this still work if the caller accepted using different words?
- Would this still work after two consecutive conflicts?
- Would this still work if the caller repeats an old time after conflict recovery?

## Summary

Booking architecture should be forgiving in conversation and strict in authority.

Conflict recovery should not create a new booking universe.

A conflicted option dies.

A recovered proposal becomes the active proposal.

The next acceptance follows the same normal path.

Side effects must be idempotent or duplicate-safe.

A successful commit is terminal.

Truth comes from authority evidence, not from the words used to describe it.
