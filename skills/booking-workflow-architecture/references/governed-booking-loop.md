# Governed Booking Loop

Use this reference for proposal lifecycle, stale-state invalidation, conflict
recovery, canonical re-entry, and terminal commit behavior.

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

The next caller acceptance must go through the same normal booking path as any
other proposal.

Do not create special conflict-specific commit paths such as:

```text
BOOKING_COMMIT_AFTER_SLOT_CONFLICT
```

There should be one booking commit path. Conflict recovery returns the system to
proposal.

## Canonical Loop Bias

Prefer canonical re-entrant loops over one-off special-case paths.

When a flow has recoverable failure, missing information, retry, stale state,
conflict, timeout, rejection, or correction, first look for a way to return to a
normal stable state instead of creating a dedicated path.

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

A recoverable exception should usually loop back into the same canonical path
with fresh authority state. A terminal success exits the loop.

## Active Proposal Binding

Caller acceptance must bind to the currently active proposal only.

Never accept a selection against:

- an expired proposal;
- a conflicted proposal;
- a superseded proposal;
- a proposal from before a material constraint change;
- a proposal from a previous booking flow;
- a proposal only mentioned in transcript text but absent from active authority
  state.

Selection phrases such as "yes," "that one," "the second one," "2:30," "with
Jen," or "earliest" must be resolved against active proposal state, not
free-floating transcript memory.

## Stale State Invalidation

Clear active proposal and prepared confirmation whenever a material booking fact
changes.

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

Each new proposal is normal. Each acceptance binds only to the currently active
proposal. A successful commit exits the loop.

## Terminal Commit Rule

A successful booking commit is terminal for that booking flow.

Once the system reaches `COMPLETED_COMMIT`:

- disclose the committed booking facts;
- do not reopen availability automatically;
- do not re-enter proposal search unless the caller explicitly starts a new
  booking or asks to change the committed booking;
- do not treat post-commit small talk, silence, or acknowledgement as a reason
  to search again;
- do not keep stale proposal state alive after commit.

The post-commit state must protect the completed booking from accidental
reopening.
