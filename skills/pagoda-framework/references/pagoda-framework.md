# Pagoda Framework Reference

Use this reference when a Pagoda task needs detailed vocabulary, artifact
shapes, or output guidance beyond the main `SKILL.md`.

## Routing

Load only the section needed for the task:

- Artifact and Workbench source-of-truth questions: read **Repository Artifact
  Model** and **Agentis Workbench Conventions**.
- Scenario-family, generator, invariant, or counterexample work: read
  **Evidence Scenario Thinking** and **Evidence Scenario Family Guidance**.
- LLM wording, semantic output, or presentation checks: read **LLM Output
  Variance Rule** and **Assistant Presentation Contract Pattern**.
- Contract/schema/oracle implementation: read **Outcome Contract Shape**,
  **Evidence Obligation Shape**, **Trace Contract Fields**, and **Oracle Clause
  Format**.
- Legacy EventStorming or storm JSON conversion: read **Legacy Storm
  Interpretation**.
- Coding-agent implementation instructions: read **Implementation Guidance for
  Pagoda Contract Failures**, **Evidence Scenario Implementation Guidance**, and
  **Minimal Codex Prompt Pattern**.

## One-Paragraph Definition

Pagoda Evidence Mapping is an outcome-first causal proof model for
agent-native software. It uses familiar domain-modeling concepts such as
actors, commands, policies, bounded contexts, facts, events, relationships, and
views, and extends them with authority, evidence obligations, trust boundaries,
trace contracts, forbidden side effects, recoveries, and scenario oracles.
Evidence Driven Development turns those maps into executable Outcome
Contracts, implementation tasks, runtime harnesses, trace evaluators, and
regression suites so teams can prove that coding agents and runtime agents
achieved intended domain outcomes without relying on transcript wording, model
self-report, or incidental tool attempts.

## Scope Boundary

Pagoda is not the general agent-harness-engineering layer. Pagoda owns independent end-to-end outcome proof through Evidence Maps for executable proof, Outcome Contracts, Evidence Contracts, Fixture Contracts, Trace Contracts, Scenario Oracles, executable EDD harnesses, Evidence Traces, channel parity, and Workbench/platform isolation.

General repository legibility, AGENTS.md topology, docs-as-system-of-record, quality scorecards, technical-debt ledgers, custom architecture lints, structural tests, local worktree bootability, general observability access for Codex, and recurring cleanup loops belong to `agent-harness-engineering` or the relevant architecture/runtime skill.

## Core Primitives

Use these primitives in maps, plans, contracts, scenario families, and reviews:

- **Outcome**: the business result or explicit rejection that must become true.
- **Actor**: a human, system, runtime agent, coding agent, provider, gateway, or
  infrastructure source that initiates intent or contributes evidence.
- **Intent**: normalized actor goal independent of transcript wording,
  transport, language, or model phrasing.
- **Authority**: the bounded context, workflow, aggregate, policy, service, or
  infrastructure layer that may decide, mutate, accept, reject, publish, or
  capture trusted evidence.
- **Command**: request sent to an authority. It expresses intent; it does not
  prove success.
- **Decision**: deterministic policy evaluation from canonical inputs to stable
  output codes and mutually exclusive branches.
- **Constraint**: invariant that must hold before a command, fact, or side
  effect is allowed.
- **Invariant Property**: a rule that must hold across many valid variations of
  inputs, state, channel, timing, policy, dependency behavior, or generated
  scenario cases.
- **Fact**: accepted business truth owned by one context.
- **Event**: published notification that a fact occurred.
- **Side Effect**: mutation, external call, emitted event, notification,
  disclosure, provider operation, ledger append, or user-visible response.
- **Recovery**: valid rejection, clarification, repair, retry, restart, or
  alternate path with its own evidence.
- **Evidence**: observable, correlated proof that a command, decision, fact,
  side effect, recovery, or absence of forbidden side effect occurred.
- **Trace**: ordered runtime record used to evaluate the map.
- **Oracle**: classification rule that evaluates a trace against an Outcome
  Contract.
- **Evidence Scenario**: a concrete or generated path through an Evidence Map
  that attempts to prove or falsify an outcome using trusted evidence,
  forbidden-side-effect checks, trace requirements, and oracle clauses.
- **Scenario Family**: a group of Evidence Scenarios generated from the same
  outcome, authority, causal path, invariant, recovery rule, or forbidden-side
  effect rule.
- **Generator**: a bounded domain-specific producer of scenario variations,
  such as caller identity states, booking preferences, provider schedules,
  channel types, service durations, policy flags, dependency responses, and
  timing cases.
- **Counterexample**: the smallest scenario variation that falsifies an
  invariant, violates a contract, misses required evidence, produces a forbidden
  side effect, or exposes a trace/oracle ambiguity.
- **View**: human-facing or system-facing representation, such as assistant
  response, transcript, UI state, read model, BDD scenario, or report.
- **Presentation Meaning**: normalized meaning communicated by an assistant,
  UI, transcript, notification, or generated message, independent of exact
  wording unless exact wording is itself the outcome.

Facts and events are not synonyms:

```text
Fact = accepted business truth owned by a context.
Event = published representation of that fact for consumers.
```

Evidence scenarios are not synonyms for transcript scripts:

```text
Transcript script = brittle wording expectation.
Evidence Scenario = outcome probe evaluated through authority, evidence, trace,
forbidden-side-effect rules, and oracle classification.
```

## Artifact Responsibilities

| Artifact | Responsibility |
| --- | --- |
| Evidence Map | Domain model and causal proof structure. |
| Outcome Scenario | Human-readable outcome explanation. |
| BDD Feature | Business-readable example view. |
| Outcome Contract | Machine-evaluable success/failure contract. |
| Fixture Contract | Required setup state and setup failure semantics. |
| Intent Contract | Normalized actor input. |
| Evidence Contract | Required facts, events, decisions, and outcomes. |
| Forbidden Side-Effect Contract | Actions, claims, or mutations that must not occur. |
| Trace Contract | Required observability sources and correlation model. |
| Scenario Oracle | Deterministic classification rules. |
| Evidence Trace | Runtime proof collected from execution. |

## Repository Artifact Model

Preserve existing repository conventions when they are already established. A
Pagoda repository may organize artifacts like this:

```text
docs/
  pagoda/
    evidence-mapping.md
    evidence-driven-development.md
    agent-trust-boundaries.md
    scenarios/
      <scenario-id>.scenario.json
    evidence-maps/
      <scenario-id>.evidence-map.json
    contracts/
      <scenario-id>.outcome-contract.json

src/
  evidence/
    outcome-contract-types.ts
    scenario-oracle.ts
    trace-evaluator.ts
```

The important rule is that business-readable examples, evidence contracts, and
runtime harness logic remain distinguishable.

## Agentis Workbench Conventions

In the Agentis workspace, the current Pagoda/EventStorming owner is:

```text
agentis-pagoda-workbench/
  docs/pagoda/
    scenarios/<scenario-id>.scenario.json
    evidence-maps/<scenario-id>.evidence-map.json
    contracts/<scenario-id>.outcome-contract.json
  server/
    pagodaCli.ts
    pagodaModelService.ts
  server/simulation-ai/
    cli.ts
    simulation-ai-realtime.ts
    simulation-ai-realtime-edd.ts
    simulation-ai-storm-trace.ts
  artifacts/
    <edd-suite>/<channel-or-run>.json
```

Use these conventions when interpreting or changing Agentis workbench,
EDD-registry, storm, and simulation harness behavior:

- All Pagoda testing framework files, harness code, fixtures, trace/oracle
  code, EDD registry files, storm files, Workbench context, and generated
  artifacts are owned by `agentis-pagoda-workbench`.
- Agentis platform repos must stay agnostic of Pagoda. They must not import,
  depend on, copy, generate, or persist Pagoda-specific harness code, storm
  context, EDD registry context, oracle logic, fixture definitions, generated
  artifacts, or testing-only contracts.
- The Workbench may observe the platform through normal product contracts,
  logs, events, APIs, traces, dependency ledgers, and runtime evidence. This
  observation does not make Pagoda a platform dependency.
- If a proposed change requires platform code to know about Pagoda-specific
  terms or files, treat it as a boundary violation and move that logic back
  into `agentis-pagoda-workbench`.
- `docs/pagoda/scenarios/*.scenario.json` is the scenario source of truth.
- `docs/pagoda/evidence-maps/*.evidence-map.json` is the Pagoda-native
  causal/evidence model source of truth.
- `docs/pagoda/contracts/*.outcome-contract.json` is the generated contract
  projection.
- `server/pagodaModelService.ts` loads, validates, and projects Pagoda
  scenarios and evidence maps.
- `server/simulation-ai/**` is the executable EDD harness and oracle code.
- `artifacts/**` is run output evidence, not source-of-truth design input,
  unless a specific run is being diagnosed.
- `agentis-scripts-local` no longer owns `simulation-ai`.

For implementation plans, always connect workbench model changes to the
corresponding harness/oracle tests when executable EDD behavior changes.

## Outcome Contract Shape

```ts
export type EvidenceScenarioStatus =
  | 'PASS'
  | 'FAIL'
  | 'SETUP_FAILED'
  | 'OBSERVABILITY_FAILED'
  | 'SCENARIO_INVALID';

export type EvidenceChannel =
  | 'browser-chat'
  | 'phone'
  | 'api'
  | 'coding-agent'
  | 'runtime-agent';

export type OutcomeContract = {
  readonly id: string;
  readonly mapId: string;
  readonly sourceBddId?: string;
  readonly sourceFeaturePath?: string;
  readonly sourceStormIds: readonly string[];
  readonly title: string;
  readonly outcome: string;
  readonly channels: readonly EvidenceChannel[];
  readonly fixture: FixtureContract;
  readonly intent: IntentContract;
  readonly requiredEvidence: RequiredEvidenceContract;
  readonly forbiddenSideEffects: ForbiddenSideEffectContract;
  readonly trace: TraceContract;
  readonly oracle: ScenarioOracleContract;
};

export type FixtureContract = {
  readonly requiredState: readonly string[];
  readonly requiredFixtures: readonly string[];
  readonly setupFailureConditions: readonly string[];
};

export type IntentContract = {
  readonly actor: string;
  readonly channel: EvidenceChannel;
  readonly normalizedIntent: Record<string, unknown>;
};

export type RequiredEvidenceContract = {
  readonly requiredFacts: readonly string[];
  readonly requiredEvents: readonly string[];
  readonly requiredCommands: readonly string[];
  readonly requiredWorkflowOutcomes: readonly string[];
  readonly acceptedEvidenceCodes: readonly string[];
  readonly rejectedEvidenceCodes: readonly string[];
  readonly repairCodes: readonly string[];
};

export type ForbiddenSideEffectContract = {
  readonly forbiddenToolNames: readonly string[];
  readonly forbiddenEvents: readonly string[];
  readonly forbiddenClaims: readonly string[];
  readonly forbiddenBeforeEvidence: readonly string[];
};

export type TraceContract = {
  readonly requiredSources: readonly TraceSource[];
  readonly orderingModel: 'canonical' | 'best_effort';
  readonly missingTraceClassification: 'OBSERVABILITY_FAILED' | 'FAIL';
};

export type TraceSource =
  | 'transcript'
  | 'runtime_tool_calls'
  | 'dependency_calls'
  | 'session_ledger'
  | 'workflow_events'
  | 'domain_events'
  | 'gateway_policy_records'
  | 'storm_trace';

export type ScenarioOracleContract = {
  readonly passRequires: readonly string[];
  readonly failWhen: readonly string[];
  readonly setupFailedWhen: readonly string[];
  readonly observabilityFailedWhen: readonly string[];
  readonly scenarioInvalidWhen: readonly string[];
};
```

For production code, replace `Record<string, unknown>` with domain-specific
normalized intent types whenever possible.

## Evidence Obligation Shape

Use typed evidence obligations instead of plain strings when defining detailed
contracts:

```json
{
  "id": "evidence.providerPreferenceReady",
  "proves": "fact.providerPreferenceEvidenceReady",
  "source": "session_ledger",
  "owner": "context.realtimeSdk",
  "capturedBy": "context.callSessionLedger",
  "trust": "trusted",
  "agentMutable": false,
  "outOfBand": true,
  "correlation": {
    "callSessionId": "required",
    "callerTurnId": "required",
    "correlationId": "required"
  },
  "missingClassifiesAs": "FAIL"
}
```

## Trace Contract Fields

A trace contract should specify:

- required sources;
- optional sources;
- ordering model;
- correlation fields;
- evidence trust level;
- missing evidence classification;
- whether transcript evidence is supporting or primary;
- whether agent-produced evidence is allowed;
- whether out-of-band capture is required.

Example:

```json
{
  "requiredSources": [
    "session_ledger",
    "workflow_events",
    "domain_events",
    "gateway_policy_records"
  ],
  "orderingModel": "canonical",
  "correlation": [
    "callSessionId",
    "callerTurnId",
    "workflowRunId",
    "correlationId"
  ],
  "transcriptUse": "supporting_only",
  "agentSelfReportAllowed": false,
  "missingTraceClassification": "OBSERVABILITY_FAILED"
}
```

## Oracle Clause Format

Prefer clause-level oracles instead of a single boolean:

```json
{
  "clauses": [
    {
      "id": "setup.fixture.bookingSession.exists",
      "classificationIfMissing": "SETUP_FAILED"
    },
    {
      "id": "evidence.providerPreference.ready",
      "classificationIfMissing": "FAIL"
    },
    {
      "id": "evidence.workflow.providerAwareSelectionOutcome",
      "classificationIfMissing": "FAIL"
    },
    {
      "id": "forbidden.appointmentCreated.beforeConfirmation",
      "classificationIfObserved": "FAIL"
    },
    {
      "id": "trace.sessionLedger.available",
      "classificationIfMissing": "OBSERVABILITY_FAILED"
    }
  ]
}
```

The result report should show each clause and the evidence that satisfied or
violated it.

## Evidence Scenario Thinking

Evidence Scenario Thinking is the Pagoda practice of turning one outcome path
into a family of examples, properties, variations, and counterexamples before
implementation work begins.

Use it whenever an Evidence Map, Outcome Contract, Scenario Oracle, Pagoda
contract repair, or implementation change could affect outcome behavior.

The goal is to make the coding agent reason like a behavioral compiler:

```text
Outcome rule -> invariant properties -> scenario families -> evidence clauses
-> implementation constraints -> oracle proof
```

Evidence Scenario Thinking does not replace Outcome Contracts, Evidence Traces,
or Scenario Oracles. It creates the behavioral shape that those contracts,
traces, and oracles must evaluate.

For each target outcome, ask:

1. **Concrete example**
   - What is one simple valid path that should pass?
   - What trusted evidence proves it?
2. **Invariant**
   - What must always be true across all valid variations?
   - What must never be true?
3. **Variation dimensions**
   - Which inputs may vary without changing the outcome class?
   - Which fields affect branch selection?
   - Which channel differences should normalize away?
   - Which policy, identity, provider, timing, fixture, or dependency states
     matter?
4. **Negative paths**
   - What invalid, unauthorized, incomplete, ambiguous, stale, or conflicting
     inputs must be rejected?
   - What rejection evidence must exist?
5. **Forbidden side effects**
   - What must not happen before identity, confirmation, policy acceptance,
     payment, authorization, or Workflow approval?
   - What evidence proves the side effect did not occur?
6. **Counterexamples**
   - What is the smallest scenario that would disprove the rule?
   - How should the oracle classify it?
7. **Trace proof**
   - Which evidence must appear after the setup boundary?
   - Which evidence source owns the truth?
   - What classification applies when trace evidence is missing?

## Evidence Scenario Family Guidance

An Evidence Scenario Family should define:

```text
Outcome:
  The business result or explicit rejection being proven.

Authority:
  The context, workflow, policy, aggregate, or infrastructure source that owns
  the truth.

Invariant Property:
  The rule that must hold across all generated valid variations.

Generators:
  Domain-specific bounded variation sources.

Concrete Examples:
  Representative examples used for readability and regression explanation.

Negative Examples:
  Inputs or states that must reject, repair, clarify, or fail safely.

Forbidden Side Effects:
  Mutations, external calls, disclosures, events, or provider operations that
  must not occur.

Required Evidence:
  Trusted evidence proving decisions, facts, commands, outcomes, recoveries, and
  absence of forbidden effects.

Oracle:
  PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, or SCENARIO_INVALID clauses.
```

A scenario family is implementation-ready only when:

- all generators are domain-bounded;
- all generated cases map to valid setup or explicit `SCENARIO_INVALID` rules;
- the invariant names the authority that enforces it;
- positive and negative paths both have evidence obligations;
- forbidden side effects are checked independently from positive evidence;
- counterexamples can be traced back to scenario, generator input, evidence
  clause, and oracle clause.

### Scenario Family Example

For booking confirmation:

```text
Outcome:
  Appointment is booked only after explicit caller confirmation.

Authority:
  Workflow owns governed booking writes.
  Scheduling owns availability and appointment truth.

Invariant Property:
  For any valid proposed appointment option, no booking write may occur before
  explicit confirmation evidence exists.

Generators:
  - channel: browser, phone
  - service duration: 15, 30, 45, 60, 90 minutes
  - provider preference: any, preferred provider, unavailable provider
  - caller response: confirms, hesitates, asks question, changes time, rejects
  - identity state: known, unknown, partially known
  - policy state: confirmation required, identity required, provider unavailable

Forbidden Side Effect:
  Scheduling.createAppointment, confirmAppointment, provider booking write, or
  appointment ledger append before confirmation evidence.

Required Evidence:
  - proposed itinerary evidence
  - explicit confirmation evidence
  - Workflow-owned booking command after confirmation
  - Scheduling-owned appointment fact after command
  - no forbidden booking write before confirmation

Oracle:
  PASS only if confirmation evidence precedes booking write and Scheduling owns
  the appointment fact.
  FAIL if any booking write occurs before confirmation.
  OBSERVABILITY_FAILED if command/write ordering cannot be observed.
```

## Property-Based Testing Relationship

Property-based testing is an implementation technique for Evidence Scenario
Thinking.

Use property-based tests when an invariant can be expressed over generated
domain inputs, but do not treat generated test success as sufficient Pagoda
proof unless the run also produces the required evidence trace and oracle
classification.

Property-based tests may validate:

- normalization invariants;
- policy branch exclusivity;
- command preconditions;
- forbidden-side-effect guards;
- ranking stability;
- recovery classification;
- trace ordering;
- channel normalization equivalence;
- presentation meaning consistency with trusted facts.

They must not replace Outcome Contracts, Evidence Contracts, Trace Contracts,
Scenario Oracles, trusted runtime evidence, or end-to-end Pagoda outcome proof.

Prefer bounded, domain-specific generators over arbitrary random data. A useful
generator produces plausible business states that can falsify a rule. Random
noise that cannot occur in the domain is not valuable Pagoda evidence.

Property-based tests should produce or preserve counterexamples that can be
translated back into Evidence Scenario failures.

## LLM Output Variance Rule

Pagoda scenarios must not require exact assistant wording unless the precise
wording is itself the regulated, contractual, legal, safety, or product outcome
under test.

LLM output is nondeterministic. Scenario Oracles should evaluate:

- trusted outcome evidence;
- normalized intent;
- canonical domain facts;
- Workflow/domain events;
- required presentation meaning;
- missing or incorrect claims;
- forbidden disclosures;
- forbidden side effects.

Do not use exact transcript strings as the primary oracle for ordinary behavior.

Allowed assistant-output checks include semantic presence of required
information, absence of prohibited information, consistency with trusted domain
facts, required structured fields when the channel supports them,
policy-compliant phrasing classes, refusal/clarification/confirmation/recovery
intent, and correct presentation of confirmation, rejection, next step, or
repair meaning.

Disallowed checks include exact sentence matching, fragile regexes over natural
language, snapshot tests of full LLM responses, pass/fail based only on model
self-report, pass/fail based only on whether a phrase appears, and requiring
deterministic prose from a nondeterministic model when the domain outcome does
not require exact prose.

Exact wording may be required only when the wording itself is the outcome, such
as legal consent, medical or safety disclaimers, required compliance language,
regulated notices, or product copy that must match an approved template.

When exact wording is required, the contract must say so explicitly and explain
which authority owns the approved language.

## Assistant Presentation Contract Pattern

Use this pattern when user-facing language is relevant but exact wording is not:

```text
Assistant Output Contract:
  Required meaning:
    - communicate the canonical outcome class
    - include required confirmed, rejected, repaired, or clarified facts
    - omit unsupported claims
    - avoid prohibited disclosures

  Must be consistent with:
    - trusted domain facts
    - Workflow-owned outcome evidence
    - selected itinerary, policy decision, identity state, or recovery code

  Must not include:
    - wrong provider, service, price, time, identity, status, or policy result
    - unsupported confirmation
    - claim of success before authority-owned success evidence
    - prohibited information or policy-unsafe instruction

  Oracle:
    PASS if semantic meaning is consistent with trusted evidence and no
    prohibited meaning is present.
    FAIL if the assistant claims a wrong or unsupported outcome.
    OBSERVABILITY_FAILED if the assistant output or trusted evidence cannot be
    observed.
```

For generated or LLM-run scenarios, preserve semantic equivalence rather than
sentence identity:

```text
Stable requirement:
  Assistant presentation must be semantically consistent with trusted outcome
  evidence.

Unstable artifact:
  The exact natural-language sentence used by the assistant.
```

## LLM Judge Protocol

Use an LLM judge only for assistant presentation meaning. The judge must be
subordinate to deterministic setup, evidence, trace, oracle, and forbidden-side
effect clauses.

The judge input must include:

- scenario id, generated case id, channel, and normalized intent;
- captured assistant transcript excerpt;
- trusted facts and evidence refs supplied by the harness;
- required presentation meanings;
- forbidden presentation meanings;
- deterministic evidence clause status that the judge must not override.

The judge output must be strict JSON with a closed result enum. A useful shape:

```json
{
  "result": "PASS",
  "requiredMeaningFindings": [
    {
      "meaning": "assistant communicates the trusted public salon address",
      "satisfied": true,
      "evidence": "assistant states the public address from trusted facts"
    }
  ],
  "forbiddenMeaningFindings": [
    {
      "meaning": "assistant must not claim booking availability",
      "present": false,
      "evidence": "no booking or availability claim is present"
    }
  ],
  "evidenceConsistency": "consistent_with_trusted_facts",
  "confidence": "high",
  "rationale": "The response preserves required meaning and no forbidden claim is present."
}
```

Classification rules:

- `PASS`: the presentation meaning is consistent with trusted evidence and no
  forbidden meaning is present.
- `FAIL`: required meaning is absent, forbidden meaning is present, or the
  assistant contradicts trusted evidence.
- `SETUP_FAILED`: judge-required provider configuration is missing before the
  run can execute.
- `OBSERVABILITY_FAILED`: transcript, trusted evidence, judge response, or
  parseable judge output cannot be observed.

The judge must never:

- infer business truth not present in trusted evidence;
- convert failed deterministic evidence into `PASS`;
- accept model self-report as proof;
- treat exact wording as required unless the contract declares exact wording as
  the outcome;
- hide malformed, ambiguous, or unavailable judge output behind fallback
  success.

## Evidence Priority

Prefer evidence in this order:

1. canonical domain events and facts;
2. Workflow-owned commands and outcomes;
3. SDK or shared policy decisions;
4. dependency/tool results accepted by the owning domain policy;
5. explicit rejection, repair, or clarification codes;
6. transcript facts captured by infrastructure;
7. assistant prose only as supporting/debug evidence unless presentation is the
   outcome under test.

Never treat these as positive proof by themselves:

- assistant wording;
- transcript regexes;
- raw tool-attempt counts;
- rejected or malformed tool calls;
- setup calls;
- model self-reports;
- agent-generated audit summaries;
- one channel run for a claimed parity scenario;
- property-based test success without the required evidence trace when the
  scenario claims end-to-end outcome proof.

## Result Semantics

Always preserve these classifications:

```text
PASS
FAIL
SETUP_FAILED
OBSERVABILITY_FAILED
SCENARIO_INVALID
```

Classification order:

```text
1. SCENARIO_INVALID
2. SETUP_FAILED
3. OBSERVABILITY_FAILED
4. FAIL due to forbidden side effect
5. FAIL due to missing required evidence/outcome
6. PASS
```

Do not collapse setup failure, observability failure, invalid scenario
definition, or counterexample discovery into ordinary pass/fail.

Counterexamples classify according to the same result semantics:

- invalid generator or impossible scenario definition: `SCENARIO_INVALID`;
- failed fixture/setup condition: `SETUP_FAILED`;
- missing trace required to prove or disprove the invariant:
  `OBSERVABILITY_FAILED`;
- valid observed violation: `FAIL`;
- valid observed satisfaction of all clauses: `PASS`.

## Preconditions Are Not Proof

Scenario setup may create or verify trusted facts needed before the action under
test, but setup evidence must never satisfy the outcome oracle.

For every scenario with a `Given` precondition, fixture, seed, or setup action:

- mark setup evidence separately from outcome evidence;
- partition the trace into a setup window and an action-under-test window;
- require the outcome evidence to occur after the setup boundary;
- classify missing or failed setup as `SETUP_FAILED`;
- classify missing trusted trace as `OBSERVABILITY_FAILED`;
- classify a valid setup with missing or wrong outcome evidence as `FAIL`;
- define a separate Outcome Contract when the setup behavior itself needs to be
  tested.

For generated scenario families, setup partitioning must be explicit for every
fixture state emitted by the generator.

## Evidence Trust Boundaries

For each evidence obligation, identify:

- what it proves;
- who owns the truth;
- who produced it;
- who captured it;
- whether the agent could read, modify, or omit it;
- whether it was enforced or captured out of band;
- how it correlates to session, turn, command, workflow, scenario family,
  generated case, and outcome;
- what classification applies if it is missing.

Use these trust levels:

```text
Trusted
  Produced or captured by the owning authority or infrastructure outside the
  agent's control.

Partially trusted
  Derived from agent interaction but validated, normalized, or captured by
  infrastructure.

Untrusted
  Produced by the agent and not independently validated or captured.
```

For protected outcomes, prefer out-of-band evidence. Agent-generated language
is not evidence. Agent-supplied metadata is not authority.

For LLM presentation checks, distinguish:

```text
Trusted outcome evidence:
  Authority-owned facts, Workflow outcomes, domain events, policy decisions,
  ledgers, and infrastructure-captured trace.

Presentation meaning evidence:
  Captured assistant output normalized for meaning and checked for consistency
  with trusted outcome evidence.
```

Presentation meaning can support a presentation clause. It must not substitute
for authority-owned proof of a domain outcome.

## Legacy Storm Interpretation

When a task supplies legacy EventStorming Workbench JSON, parse it as data
first and derive an Evidence Map. Use these mappings:

| Legacy Element | Pagoda Interpretation |
| --- | --- |
| Actor | Source of normalized intent or evidence. |
| Command | Intent sent to an authority. |
| Policy | Deterministic decision with stable output codes. |
| Domain event | Usually a published representation of an owned fact. |
| Bounded context | Authority for facts, decisions, commands, invariants, and contracts. |
| External system | Evidence source, dependency, adapter, provider, model, or side-effect executor. |
| Read model | View or projection of accepted facts. |
| Recovery path | Rejection, clarification, repair, retry, restart, or approval path. |
| Relationship | Causal or dependency edge that must be explicit. |
| current / replace / target | Baseline, path to stop using, and intended target state. |
| schemaRef | Contract/schema obligation. |
| evidenceShape | Evidence Contract obligation. |
| recoveryShape | Recovery/rejection contract obligation. |

Do not infer business truth from model output, provider DTOs, assistant prose,
tool attempts, or visual proximity.

## Provider Preference Example

Outcome:

```text
Accepted provider preference is routed to provider-aware Workflow selection.
```

Authorities:

```text
Realtime SDK:
  Owns channel-neutral provider-preference policy and canonical evidence
  readiness.

Call Session Ledger:
  Owns runtime observation and turn/session correlation evidence.

Booking Workflow:
  Owns governed booking commands and booking-session outcome facts.

Scheduling:
  Owns availability and slot truth.

Salon Config:
  Owns provider, service, location, and policy facts.
```

Causal path:

```text
Caller
  -> NamedProviderPreferenceIntent
  -> ValidateProviderPreference
  -> ProviderPreferenceAccepted
  -> ProviderPreferenceEvidenceReady
  -> WorkflowProviderAwareSelectionRequested
  -> BookingSessionProviderAwareSelectionOutcomeRecorded
```

Constraints:

```text
Provider identity must be resolvable when required.
Selected start must be present when the active proposal path requires it.
Fallback must be represented as a boolean.
Service chain identity must be captured.
Caller turn id and call session id must be correlated.
No booking write may happen before explicit confirmation.
```

Recovery codes:

```text
MISSING_SELECTED_START
PROVIDER_NOT_RESOLVABLE
INVALID_TIME_RANGE
INVALID_PROVIDER_FLAGS
STALE_PROPOSAL
ASK_FOR_SELECTED_START
```

Required evidence:

```text
FullChainNamedProviderIntentCaptured was recorded.
ProviderPreferenceEvidenceReady was recorded by the SDK-owned policy path.
Runtime observation was persisted by the Session Ledger.
WorkflowProviderAwareSelectionRequested was issued to Booking Workflow.
BookingSessionProviderAwareSelectionOutcomeRecorded was emitted by Workflow.
No AppointmentCreated fact exists before caller confirmation.
```

Forbidden evidence and side effects:

```text
Malformed or rejected bkg_wish setup calls do not count as pass evidence.
Raw bkg_wish attempt count does not prove provider-aware selection.
Assistant wording does not prove booking mutation.
The word "confirmed" does not prove appointment creation.
Booking mutation before explicit confirmation fails the contract.
Provider-aware selection without accepted provider-preference evidence fails the contract.
```

Oracle:

```text
PASS:
  Required setup exists, provider-preference evidence is accepted, Workflow
  selection outcome is recorded, and forbidden booking mutation is absent.

FAIL:
  Setup and trace are valid, but accepted evidence or Workflow outcome is
  missing, or a forbidden side effect occurred.

SETUP_FAILED:
  Booking session, service chain, provider fixture, or active proposal fixture
  could not be established.

OBSERVABILITY_FAILED:
  Required Session Ledger or Workflow evidence was not captured or could not be
  correlated.

SCENARIO_INVALID:
  The run claims channel parity but one declared channel did not execute.
```

## Harness Rules

A Pagoda-compatible harness evaluates Outcome Contracts and Evidence Scenario
Families, not transcript strings. It must:

- evaluate setup before outcome behavior;
- classify failed setup as `SETUP_FAILED`;
- evaluate observability before business pass/fail;
- classify missing required trace as `OBSERVABILITY_FAILED`;
- classify mismatched scenario, channel, map, branch, generator domain, or
  invariant target as `SCENARIO_INVALID`;
- prevent `PASS` when the run is blocked or invalid;
- require positive evidence for positive paths;
- require rejection evidence for rejection paths;
- require repair codes for repair paths;
- require Workflow outcome evidence when the path reaches Workflow;
- evaluate forbidden side effects independently from positive evidence;
- evaluate assistant output semantically when presentation meaning is under
  test;
- avoid exact natural-language matching except where exact wording is explicitly
  required by contract;
- report clause-level evidence and classification;
- preserve generated case inputs and minimized counterexamples when applicable.

## Channel Parity

A parity claim requires separate child contracts plus a comparison contract.

Example:

```text
EDD-041A: Browser-chat produces canonical provider-preference evidence.
EDD-041B: Phone produces canonical provider-preference evidence.
EDD-041C: Browser-chat and phone canonical evidence are equivalent after normalization.
```

The parity contract must define child contracts required, fields that must
match, fields that may differ, normalization rules, channel-specific metadata
exclusions, required outcome class, classification when a child run is missing,
whether assistant presentation meaning must be equivalent or merely
outcome-consistent, and whether exact wording is forbidden, irrelevant, or
explicitly required.

If one channel did not execute, the parity contract cannot pass.

For LLM channels, parity usually means normalized intent, outcome class,
required facts, recovery meaning, and trusted evidence are equivalent. It does
not mean the assistant said the same words.

## Implementation Guidance for Pagoda Contract Failures

Use this section only when implementation work is needed to satisfy, repair, or
extend a Pagoda Outcome Contract, Evidence Contract, Trace Contract, Scenario
Oracle, EDD registry path, simulation-ai harness behavior, Workbench-owned
evidence trace, Evidence Scenario Family, generated scenario coverage, LLM
output variance rule, or channel parity contract.

When creating implementation guidance for Codex or another coding agent,
include:

```text
Outcome:
  What must become true.

Authority:
  Which context owns the decision, fact, or mutation.

Path:
  Actor -> intent -> command -> decision -> fact -> outcome.

Invariant Properties:
  What must always hold across valid variations.

Scenario Families:
  Concrete examples, generated variations, negative paths, recovery paths, and
  counterexamples that the implementation must satisfy.

Contracts:
  schemaRef, evidence contract, trace contract, outcome contract, scenario
  family, and presentation contract if relevant.

Forbidden Side Effects:
  What must not happen, and when.

LLM Output Variance:
  Whether assistant output is irrelevant, semantically checked, or exact wording
  is explicitly required.

Result Semantics:
  PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, SCENARIO_INVALID.

Validation Commands:
  Typecheck, lint, tests, property-based tests when useful, scenario harness,
  trace checks, oracle checks.
```

Tell the coding agent to implement the target evidence path, invariant, and
authority boundary, not a transcript regex or raw tool-attempt heuristic.

## Evidence Scenario Implementation Guidance

Before changing implementation code, Codex must derive or update the relevant
Evidence Scenario Families.

For each implementation change, Codex should identify:

```text
Target Outcome:
  What business result or rejection must become true.

Invariant Properties:
  What must always hold across valid variations.

Generated Variations:
  Which domain inputs, state combinations, channel differences, dependency
  responses, policy flags, and timing cases should be explored.

Forbidden Side Effects:
  What must not happen before the required authority, evidence, policy,
  identity, confirmation, payment, authorization, or Workflow approval exists.

Counterexamples:
  The smallest cases that would disprove the intended behavior.

Evidence Obligations:
  What trace evidence must prove the behavior.

Implementation Constraints:
  Which guards, policies, commands, schema checks, workflow boundaries, or
  authority calls must exist before code can be considered correct.

Validation:
  Unit tests, property-based tests, contract tests, scenario harness runs, trace
  checks, and oracle classification.
```

Codex must not implement only the happy-path example. It must implement the
invariant and the authority boundary that make the scenario family pass.

## Minimal Codex Prompt Pattern

When asking Codex to implement or repair Pagoda-owned behavior, use this shape:

```text
Use the pagoda-framework skill.

Target Outcome:
  <business result or explicit rejection>

Authority Boundary:
  <which context owns decision/fact/mutation/evidence>

Evidence Map Path:
  <actor -> intent -> command -> decision -> fact/recovery -> outcome>

Invariant Properties:
  <what must always be true>

Evidence Scenario Families:
  <concrete examples, generated variations, negative paths, recovery paths,
  counterexamples>

Forbidden Side Effects:
  <what must not happen, especially before identity/policy/confirmation>

LLM Output Variance:
  Do not match exact assistant wording unless exact wording is explicitly part
  of the outcome. Evaluate semantic presentation meaning against trusted
  evidence.

Contracts To Update:
  <scenario json, evidence map, outcome contract, evidence contract, trace
  contract, oracle, scenario family>

Validation:
  <typecheck, lint, unit tests, property-based tests if useful, scenario
  harness, trace/oracle checks>
```

Do not ask Codex to satisfy only a BDD-style example. Ask it to preserve the
invariant, authority boundary, evidence path, and oracle semantics across the
whole scenario family.

## Pagoda Harness Debt

Track Pagoda-specific debt separately from general repository quality debt:

- missing Outcome Contract clauses;
- missing Evidence Contract obligations;
- trace sources that cannot be correlated;
- transcript-only oracles that should use trusted evidence;
- setup evidence accidentally counted as outcome proof;
- channel parity claims without child contracts;
- Workbench/platform boundary risks;
- scenario runs that collapse SETUP_FAILED, OBSERVABILITY_FAILED, or SCENARIO_INVALID into ordinary FAIL.

General quality scorecards and repository cleanup loops belong to `agent-harness-engineering`.

## Working Principles

```text
Outcome before event.
Authority before mutation.
Fact before event.
Evidence before confidence.
Recovery before fallback.
Trace before trust.
Oracle before pass/fail.
Setup before scenario.
Out-of-band before self-report.
Contract before harness.
```
