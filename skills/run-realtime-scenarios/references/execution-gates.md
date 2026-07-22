# Realtime Scenario Execution Gates

Read this reference before any external phone call or browser-chat session.

## 1. Authorization And Scope

- Default to the configured dev environment.
- Require explicit user authorization before a call that incurs cost, a
  recording, client creation, appointment mutation, cancellation, reschedule,
  or cleanup.
- Treat authorization for a proposal-only test as insufficient for booking.
- Treat authorization to book as insufficient to confirm an option that has not
  yet been presented and heard.
- Do not expand from one channel, location, client, or capability to another
  without a scenario reason.
- Allow only the declared test effect of the exact requested capability. A
  proposal scenario authorizes only its short-lived proposal. Require separate
  explicit authorization for client creation, follow-up creation, booking,
  cancellation, reschedule, or cleanup state.

## 2. Credential Safety

- Use the current environment loader in `agentis-scripts-local`; do not parse or
  echo secret files with broad shell searches.
- Use `dot.dev.env` only when the user explicitly authorizes that source.
- Keep Twilio, Firebase, OpenAI, Gemini, and service tokens in memory.
- Print only sanitized counts, statuses, opaque call/session ids, and offer
  display names. Do not print auth headers or full E.164 numbers.
- If a credential appears in command output, stop exposing it and instruct the
  user to rotate it.
- Never restore or execute a deleted pack merely because it once contained
  usable credentials.

## 3. Authoritative Preconditions

Use owner APIs and current contracts to prove:

- business and location scope;
- enabled channel and deployed runtime;
- canonical offers and automation disposition;
- timezone and explicit search window;
- provider/capability and policy facts required by the scenario;
- expected positive availability for positive-path scenarios;
- dedicated synthetic client identity for writes;
- proposal lifetime, selected option, and required warnings before commit.

Fail closed on missing, null, ambiguous, stale, or contradictory facts.

## 4. Environment And Identity

- Synthetic Twilio ANI is transport identity, not proof of a Client record.
- Resolve it through Clients before appointment mutation.
- For a write, require either an identified dedicated test client or an
  unclaimed synthetic ANI that the scenario intentionally creates as a test
  client.
- Stop on `AMBIGUOUS` or an unexpected existing client match.
- Do not use a salon or provider business phone as an arbitrary client identity
  without explicit fixture ownership.

## 5. Recording And Privacy

- Label synthetic calls as synthetic canaries.
- Use recording only in dev and only with authorization.
- For human participants, establish applicable consent before recording.
- Prefer in-memory transcription. Do not leave downloaded recordings or
  transcripts in the repository.
- Treat transcription errors as possible; compare channel audio and Session
  Ledger transcript when a word affects the verdict.

## 6. Mutation Gate

Before `commit_booking`, cancellation, or reschedule:

1. Prove the current proposal or target appointment through authority evidence.
2. Prove caller-visible facts were finalized and actually heard or rendered.
3. Collect confirmation in a later current turn.
4. Explicitly accept every required warning after it is presented.
5. Let server binding supply ids, revision, trusted scope, and operation
   identity.

Never use a prerecorded blanket “yes,” a timed future confirmation, or a generic
authorization from before option presentation as confirmation evidence.

## 7. Retry Boundary

- One user-requested attempt is the default and maximum.
- Do not rerun after `Pass`, `Fail`, or `Blocked` without a new user request.
- Do not retry a mutation blindly.
- Stop immediately for credential leakage, ambiguous identity, wrong
  environment, unexpected existing data, missing correlation, or evidence of a
  possible unverified write.
- Report runtime termination, silence, missing evidence, or authority failure
  instead of automatically calling again.

## 8. Outcome Isolation

- The scenario request authorizes only execution, required evidence collection,
  the latest-run CSV row upsert, and cleanup explicitly authorized before the
  run.
- Do not inspect additional source or logs to diagnose a terminal result beyond
  the evidence surfaces required by the canonical scenario.
- Do not change code, prompts, contracts, configuration, data, infrastructure,
  or architecture in response to the result.
- Do not create issues, pull requests, commits, pushes, deployments, or follow-up
  investigations from the result.
- Record the outcome, report it, and stop. Diagnosis or remediation requires a
  separate user request.
