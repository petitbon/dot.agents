# Pagoda Framework Reference

Use this reference when a Pagoda task needs detailed vocabulary, artifact
shapes, or output guidance beyond the main `SKILL.md`.

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
  behavior/
    *.feature
  evidence/
    outcomes/
      *.outcome.md
    maps/
      *.evidence-map.md

contracts/
  evidence/
    <suite-name>/
      <scenario-id>.outcome-contract.json
      <scenario-id>.fixture-contract.json
      <scenario-id>.evidence-contract.json
      <scenario-id>.trace-contract.json

models/
  <domain-area>/
    storm-current.json
    evidence-map.json

src/
  evidence/
    outcome-contract-types.ts
    scenario-oracle.ts
    trace-evaluator.ts
```

The important rule is that business-readable examples, evidence contracts, and
runtime harness logic remain distinguishable.

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
