# Pagoda Contracts And Oracles

Use this reference for contract shapes, evidence obligations, trace clauses,
oracle clauses, result semantics, preconditions, and trust boundaries.

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
normalized intent types where possible.

## Evidence Obligation Shape

Prefer typed evidence obligations over plain strings:

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

A trace contract should specify required sources, optional sources, ordering
model, correlation fields, evidence trust level, missing evidence
classification, transcript use, whether agent-produced evidence is allowed, and
whether out-of-band capture is required.

## Oracle Clauses

Prefer clause-level oracles over one boolean:

```json
{
  "clauses": [
    {
      "id": "setup.fixture.bookingSession.exists",
      "classificationIfMissing": "SETUP_FAILED"
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

Result reports should show each clause and the evidence that satisfied or
violated it.

## Result Semantics

Preserve these classifications:

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

## Preconditions Are Not Proof

Scenario setup may create or verify facts needed before the action under test,
but setup evidence must not satisfy the outcome oracle.

For every scenario with setup:

- mark setup evidence separately from outcome evidence;
- partition trace into setup and action-under-test windows;
- require outcome evidence after the setup boundary;
- classify missing or failed setup as `SETUP_FAILED`;
- classify missing trusted trace as `OBSERVABILITY_FAILED`;
- classify valid setup with missing or wrong outcome evidence as `FAIL`.

## Evidence Trust Boundaries

For each evidence obligation, identify what it proves, who owns the truth, who
produced it, who captured it, whether the agent could read/modify/omit it,
whether it was enforced or captured out of band, how it correlates to scenario
and runtime IDs, and what classification applies if it is missing.

Trust levels:

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
and agent-supplied metadata are not authority.
