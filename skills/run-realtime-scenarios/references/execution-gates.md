# Realtime Scenario Execution Gates

Read this reference before any external phone call or browser-chat session.

## 1. Standing Authorization And Scope

- Default to the configured dev environment.
- Development phone scenarios have standing repository-owner authorization,
  including recorded calls that incur charges, dedicated fixture creation, the
  declared test effect, evidence preservation, and exact-fixture
  terminalization. Do not ask for renewed authorization or add an
  approval/count/spending gate.
- Standing execution authorization is not booking confirmation evidence. An
  appointment mutation still requires the exact option and warnings to be
  presented and heard before the caller confirms them in the current session.
- Do not expand from one channel, location, client, or capability to another
  without a scenario reason.
- Allow only the declared test effect of the selected capability and its
  dedicated dev fixtures. A proposal scenario creates only its short-lived
  proposal; mutation scenarios follow their governed confirmation contracts.
- Preserve audit evidence and the stable client persona. After evidence is
  durable, terminalize only the exact active visit fixture through Booking and
  verify Scheduling. Never use broad cleanup or direct deletion.

## 2. Credential Safety

- Use the current environment loader in `agentis-scripts-local`; do not parse or
  echo secret files with broad shell searches.
- Load the configured dev profile through the maintained environment loader.
- Keep Telnyx, Firebase, OpenAI, Gemini, and service tokens in memory.
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

Client identities must use names from the runner's Alfred Hitchcock film
character list and emails in the `@trimpulse.ai` domain. Availability, booking,
and reschedule requests must use one supported open-ended date preference and
must not contain an end date.

Fail closed on missing, null, ambiguous, stale, or contradictory facts.

## 4. Environment And Identity

- Synthetic Telnyx ANI is transport identity, not proof of a Client record.
- Resolve it through Clients before appointment mutation.
- For a write, require either an identified dedicated test client or an
  unclaimed synthetic ANI that the scenario intentionally creates as a test
  client.
- Stop on `AMBIGUOUS` or an unexpected existing client match.
- Do not use a salon or provider business phone as an arbitrary client identity;
  use a dedicated fixture identity.

## 5. Recording And Privacy

- Label synthetic calls as synthetic canaries.
- Use recording only in dev for the selected synthetic scenario.
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

- One attempt is the default.
- Make another attempt only when evidence shows it can materially validate a
  fix or resolve a transient condition; do not retry merely to seek a Pass.
- Do not retry a mutation blindly.
- Stop immediately for credential leakage, ambiguous identity, wrong
  environment, unexpected existing data, missing correlation, or evidence of a
  possible unverified write.
- Report runtime termination, silence, missing evidence, or authority failure
  instead of automatically calling again.

## 8. Outcome Isolation

- Standing authorization covers execution, required evidence collection,
  latest-run CSV upsert, dedicated dev fixtures, exact-fixture
  terminalization, and preservation of audit evidence.
- When the active task includes implementation, debugging, or validation, use
  terminal evidence to guide proportionate diagnosis, remediation, and
  revalidation without requesting renewed phone-call authorization.
- Do not broaden the active task, run production, bypass owner APIs, or make
  unrelated product or infrastructure changes because of a scenario outcome.
