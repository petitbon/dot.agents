---
name: booking-workflow-architecture
description: "Use for Agentis booking and scheduling product architecture: governed booking workflow design, proposal state, active proposal identity, confirmation readiness, conflict recovery, stale-state invalidation, retries, idempotent side effects, duplicate-safe commits, terminal completion, and service authority ownership. Do not use as the primary skill for Pagoda Evidence Maps, scenario families, trace/oracle contracts, or Workbench harness execution; use pagoda-framework for proof artifacts."
---

# Booking Workflow Architecture

Use this skill when changing or reviewing Agentis booking/scheduling product workflow architecture, state-machine behavior, service authority ownership, or booking-specific invariants.

Use `pagoda-framework` when the changed artifact is an Evidence Map, scenario family, contract, oracle, trace, harness, or Workbench proof asset.

## Core Thesis

Agentis booking should not be designed as a conversational bot with scattered special cases. It should be designed as a governed workflow agent:

```text
search -> propose -> collect confirmation evidence -> commit -> recover from conflicts -> return to stable states
```

The assistant can speak naturally, but booking correctness must be governed by state, authority, evidence, and durable side-effect rules.

A booking is proven by authoritative state and side-effect evidence, not by generated language.

## Booking As Delegated Production

A booking flow is delegated production, not chat completion.

The assistant may conduct the conversation, but the workflow must produce a verifiable business outcome:

- valid proposal;
- explicit rejection;
- clarification state;
- recovery to a stable state;
- governed commit;
- terminal completion.

Optimize for contiguous authorized task chains:

```text
wish capture -> scheduling truth -> proposal -> confirmation evidence -> commit or recovery
```

Do not split the flow into dialogue-shaped special cases when one governed workflow can preserve authority and evidence.

## Relationship To Other Skills

Use `booking-workflow-architecture` for product and architecture design decisions:

- booking state-machine structure;
- active proposal ownership;
- confirmation readiness;
- conflict recovery loops;
- idempotent commit design;
- stale state invalidation;
- realtime booking tool sequencing implications;
- service boundary and authority ownership decisions.

Use `pagoda-framework` for behavior-proof artifacts:

- Evidence Maps;
- Evidence Scenario Families;
- Outcome, Evidence, Fixture, and Trace Contracts;
- Scenario Oracles;
- Evidence Traces;
- executable evidence-scenario runs;
- channel parity and presentation-variance proof.

Use `realtime-voice-agent-design` for realtime model prompting, tool schemas, voice behavior, conversational state exposure to the model, and guarded tool execution.

If a task changes both workflow architecture and proof artifacts, apply this skill first for workflow design, then use `pagoda-framework` to prove the behavior.

## Core Principle

Keep the conversational layer tolerant and semantic.

Keep the authority layer strict.

The conversational layer may interpret, clarify, summarize, narrate, and recover naturally.

The authority layer owns proposal truth, active selection, confirmation readiness, booking commit, conflict recovery, terminal completion, and durable side effects.

Do not make assistant text, transcript wording, exact confirmation phrases, scenario labels, trace names, tool-attempt shape, or UI copy the source of booking truth.

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

## Canonical Governed Booking Loop

Use a normal booking loop rather than special-case booking paths.

Preferred model:

```text
CALLER_WISH_CAPTURED
  -> SEARCH_SCHEDULING_TRUTH
  -> PROPOSAL_PRESENTED
  -> caller accepts/selects
  -> CONFIRMATION_EVIDENCE_COLLECTED
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

There should be one booking commit path. Conflict recovery returns the system to proposal.

## Canonical Loop Bias

Prefer canonical re-entrant loops over one-off special-case paths.

When a flow has recoverable failure, missing information, retry, stale state, conflict, timeout, rejection, or correction, first look for a way to return to a normal stable state instead of creating a dedicated path.

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

A recoverable exception should usually loop back into the same canonical path with fresh authority state. A terminal success exits the loop.

## Idempotent Side-Effect Rule

Logical recovery loops must be paired with idempotent or duplicate-safe side effects.

A retryable flow must not risk duplicate writes, duplicate commits, duplicate messages, duplicate reservations, duplicate charges, or duplicate state transitions.

Use stable operation identity, active state identity, idempotency keys, conflict detection, terminal-state checks, or authority-owned deduplication as appropriate.

The question is not only:

```text
Can this be retried?
```

The question is:

```text
Can this be retried through the normal path without duplicating or corrupting the authoritative outcome?
```

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

## Confirmation Readiness Rule

A caller selecting a proposed slot is not always enough to commit.

Before any governed booking write, the authority layer must know:

- selected option;
- active proposal identity;
- required caller identity and contact details;
- required service, provider, time, and location details;
- required policy, payment, deposit, or consent evidence when applicable;
- proof that no material fact changed after proposal selection;
- proof that the caller authorized the exact commit-ready booking facts.

Do not infer confirmation readiness from friendly assistant language, transcript shape, or scenario names.

## Identity And Missing Detail Rule

Missing required details should not create a parallel booking path.

If the caller accepts a valid active proposal but required identity or material details are missing:

1. preserve the accepted current proposal only if still valid;
2. ask for the missing required detail;
3. bind the returned detail to the same active confirmation context;
4. commit through the same normal booking path once preconditions are satisfied.

If a conflict or material change occurs while collecting the missing detail, invalidate the stale confirmation and return to proposal recovery.

## Conflict Recovery Rules

When a conflict occurs:

1. clear the stale selected option;
2. clear stale prepared confirmation;
3. mark the conflicted proposal or option as no longer commit-eligible;
4. run recovery search through the normal proposal mechanism;
5. create a new active proposal identity;
6. present recovered options as ordinary active proposals;
7. require the next caller acceptance to bind to the new active proposal;
8. prevent stale acceptance of the old conflicted slot from retrying the old slot;
9. support multiple recovery cycles;
10. enforce a sane maximum recovery count to avoid an infinite bad experience.

A valid recovery flow is:

```text
proposal -> accept -> conflict
proposal -> accept -> conflict
proposal -> accept -> collect missing identity if needed -> commit -> completed
```

Each new proposal is normal. Each acceptance binds only to the currently active proposal. A successful commit exits the loop.

## Caller Wishes Are Not Truth

Caller preferences are wishes unless salon policy or scheduling authority makes them hard constraints.

Examples of caller wishes:

- “next week”;
- “morning if possible”;
- “with Maria”;
- “earliest available”;
- “back to back”;
- “same stylist as last time”;
- “not too expensive.”

Use wishes to guide search, ranking, clarification, and explanation.

Do not let wishes override Scheduling truth, salon policy, service rules, provider eligibility, duration rules, or commit preconditions.

## Scheduling Truth Rule

Scheduling owns availability and appointment truth.

The model, realtime adapter, workflow layer, and SDK must not invent:

- available times;
- unavailable times;
- providers;
- provider eligibility;
- prices;
- service durations;
- appointment IDs;
- booking outcomes;
- cancellation or reschedule outcomes.

They may request, rank, transform, present, and narrate Scheduling-owned facts, but they must not become the source of those facts.

## Side-Effect Ownership Rule

Governed booking writes must happen only through the authority owner.

Conversational, realtime, adapter, UI, or scenario layers may request or narrate a booking, but they must not own the booking write.

The authority owner must enforce:

- active proposal validity;
- confirmation readiness;
- conflict safety;
- duplicate prevention;
- idempotency;
- policy compliance;
- durable side-effect creation.

## Terminal Commit Rule

A successful booking commit is terminal for that booking flow.

Once the system reaches `COMPLETED_COMMIT`:

- disclose the committed booking facts;
- do not reopen availability automatically;
- do not re-enter proposal search unless the caller explicitly starts a new booking or asks to change the committed booking;
- do not treat post-commit small talk, silence, or acknowledgement as a reason to search again;
- do not keep stale proposal state alive after commit.

The post-commit state must protect the completed booking from accidental reopening.

## Observability Rule

Traces, logs, scenario labels, and assistant messages should describe the causal path, not define it.

If the system booked correctly but the trace label is wrong, fix the trace classification.

If the scenario expected the wrong proof shape, fix the oracle.

If transcript phrasing changed but authority evidence is correct, do not make the system more brittle just to satisfy transcript matching.

## Forbidden Fix Shapes

Stop and redesign if a proposed change:

- treats assistant text as proof of booking;
- treats transcript wording as confirmation truth;
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
- What proposal identity does the caller acceptance bind to?
- What clears stale selected options and prepared confirmation?
- What happens after a conflict?
- Does recovery return to the normal stable state?
- Are side effects idempotent or duplicate-safe across retries?
- What prevents retrying an old conflicted slot?
- What terminal state prevents accidental reopening?
- What evidence proves required identity, details, and confirmation were collected?
- What evidence proves the booking write happened through the governed authority owner?
- Are logs, transcripts, assistant text, or scenario labels being treated as truth?
- Are we adding a new path because the business requires it, or because implementation history leaked into control flow?
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
- evidence needed for Pagoda proof, when relevant.

For repair work, produce:

- failure classification;
- causal chain;
- weakest correct layer to fix;
- forbidden fix shapes to avoid;
- proposed normal-path loopback design;
- implementation steps by owner;
- tests or evidence scenarios needed to prevent regression.

## Summary

Booking architecture should be forgiving in conversation and strict in authority.

Conflict recovery should not create a new booking universe. A conflicted option dies. A recovered proposal becomes the active proposal. The next acceptance follows the same normal path. Side effects must be idempotent or duplicate-safe. A successful commit is terminal. Truth comes from authority evidence, not from the words used to describe it.
