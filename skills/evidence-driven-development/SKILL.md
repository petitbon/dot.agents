---
name: evidence-driven-development
description: Use when creating, reviewing, updating, or maintaining Evidence Driven Development specifications for AI-agent-native software; define outcome scenarios, outcome contracts, canonical evidence, workflow outcomes, forbidden side effects, trace requirements, and scenario-oracle semantics for coding agents, LLM agents, prompts, tools, and domain workflows.
---

# Evidence Driven Development

## Purpose

Use this skill to write, review, update, and maintain Evidence Driven Development specifications for AI-agent-native software.

Evidence Driven Development, or EDD, is a methodology for building systems with coding agents, LLM runtime agents, prompts, tools, policies, workflows, and domain services by defining the intended domain outcome first, then specifying the evidence required to prove that the system achieved it.

EDD does not replace BDD, TDD, integration testing, observability, or model evaluation. EDD connects them through explicit outcome contracts and evidence oracles.

The output of this skill may include:

- human-readable outcome scenarios
- domain behavior contracts
- outcome contracts
- evidence contracts
- fixture contracts
- trace requirements
- forbidden side-effect rules
- scenario-oracle semantics
- review findings for weak or invalid evidence
- recommendations for splitting vague BDD scenarios into executable evidence contracts

This skill does not implement production code, run tests, create step definitions, update CI, choose testing frameworks, write TypeScript tests, or execute model evaluations. Those concerns belong in repo-level instructions, task prompts, CI, test runners, eval harnesses, or implementation work.

## Core Principle

EDD specifications define what evidence proves that an agent-native system achieved the intended domain outcome.

Do not treat assistant wording, transcript regexes, incidental tool attempts, rejected setup calls, or loosely similar responses as sufficient proof of success unless the business requirement is specifically about that user-facing presentation.

For LLM-mediated systems, the observable behavior is not the exact sentence produced by the model. The observable behavior is the domain outcome produced by the combined prompt, model, tool schema, policy layer, workflow, side-effect boundary, and persisted facts.

Use this rule:

```text
BDD describes the behavior.
EDD proves the outcome.
```

## Relationship To BDD

BDD remains useful for business-readable discovery and scenario writing. BDD scenarios describe the behavior that product, domain, QA, architecture, and engineering stakeholders expect.

EDD adds the executable evidence layer beneath or alongside BDD.

Use this distinction:

```text
BDD Scenario
  A human-readable business behavior example.

Outcome Scenario
  A concrete example of an intended domain result under known business state.

Outcome Contract
  A machine-evaluable contract describing required evidence, required outcomes, and forbidden side effects.

Evidence Trace
  The captured runtime proof from transcript facts, normalized intent, tool calls, dependency calls, domain events, workflow commands, workflow outcomes, and side effects.

Scenario Oracle
  The decision rule that classifies a run as PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, or SCENARIO_INVALID.
```

Do not collapse these layers into one vague BDD pass/fail result.

## When To Use

Use this skill when asked to:

- define an EDD methodology or artifact
- convert weak BDD scenarios into evidence-driven outcome contracts
- review whether a scenario is testing the right thing
- define what counts as proof for an LLM or agent outcome
- separate transcript wording from domain evidence
- specify canonical facts, workflow outcomes, and forbidden side effects
- design eval or harness pass/fail semantics without writing harness code
- define fixture requirements for agent scenarios
- diagnose false positives or false negatives in simulation/eval runs
- align event-storming maps with outcome contracts
- define parity contracts across channels such as browser-chat and phone
- create regression protection for prompt, tool, workflow, or model behavior

Do not use this skill to implement production code, write test code, run tests, update CI, create fixtures in code, create Cucumber step definitions, or perform low-level harness implementation.

## Preferred Locations

Use existing repository conventions when already established.

Recommended locations:

```text
docs/behavior/<feature-name>.feature
```

for human-readable BDD or outcome scenarios, and:

```text
contracts/outcomes/<feature-name>/<scenario-id>.contract.json
contracts/evidence/<feature-name>/<scenario-id>.evidence.md
contracts/fixtures/<feature-name>/<scenario-id>.fixture.md
artifacts/evidence/<suite>/<run-id>/<scenario-id>-trace.json
```

for executable or semi-executable EDD artifacts.

If the repository is not ready for JSON contracts, write the contract as Markdown first using the structure in this skill.

## EDD Artifact Types

### Outcome Scenario

An outcome scenario is the human-readable example of what must be achieved.

It should name:

- the actor or agent
- the business state
- the caller or user intent
- the intended domain outcome
- any required policy boundary
- any prohibited side effect

Example:

```gherkin
Scenario: Full-chain named-provider preference with fallback is routed to provider-aware Workflow selection
  Given a booking session exists
  And the caller has selected a start window
  When the caller asks for the full service chain with provider Mother
  And the caller allows fallback to another provider if Mother cannot do the full visit
  Then provider-preference evidence must be validated before Workflow selection
  And accepted evidence must be routed to provider-aware Workflow selection
  And the booking must not be committed before explicit caller confirmation
```

### Outcome Contract

An outcome contract is the machine-evaluable oracle for an outcome scenario.

It should define:

- required setup state
- normalized input or caller intent
- required canonical evidence
- required workflow commands
- required workflow outcomes
- accepted rejection or repair outcomes
- forbidden side effects
- allowed nondeterminism
- pass/fail classification rules

### Evidence Contract

An evidence contract defines the exact facts that count as proof.

It should identify evidence by stable domain meaning, not by fragile prose.

Prefer:

```text
CanonicalProviderPreferenceEvidenceReady
BookingSessionProviderAwareSelectionOutcomeRecorded
ProviderPreferenceEvidenceRejected(reasonCode: MISSING_SELECTED_START)
WorkflowProviderAwareSelectionRequested
AppointmentCreated
CallerConfirmationCaptured
```

Avoid:

```text
assistant said "confirmed"
assistant said "What start time"
bkg_wish was attempted twice
transcript contains provider name
regex matched clarification wording
```

### Fixture Contract

A fixture contract defines the state required before the behavior under test begins.

Setup must not be counted as pass evidence.

If setup cannot be established, the scenario result is SETUP_FAILED, not PASS and not product FAIL.

### Trace Contract

A trace contract defines what runtime evidence must be captured to evaluate the scenario.

It may require:

- transcript facts
- normalized intent facts
- model tool-call requests
- tool-call validation outcomes
- dependency call outcomes
- domain events
- workflow commands
- workflow outcomes
- side-effect records
- rejection or repair codes
- correlation identifiers
- channel metadata

If the required evidence is not captured, the scenario result is OBSERVABILITY_FAILED.

## Evidence Priority

Prefer evidence in this order:

1. Canonical domain events and persisted facts.
2. Workflow-owned commands and outcomes.
3. External dependency calls and accepted/rejected dependency outcomes.
4. Explicit validation, rejection, repair, and clarification codes.
5. Normalized intent facts.
6. Transcript facts and assistant prose.

Transcript wording is supporting evidence. It is not the primary oracle for domain behavior unless the scenario is specifically about the user-visible message.

A tool attempt is not proof of successful behavior. A rejected or malformed tool call is evidence of rejection, repair, setup failure, or product failure depending on the scenario contract.

## Scenario Result Semantics

EDD scenarios must distinguish outcome failure from harness, setup, and observability problems.

Use these statuses:

```text
PASS
FAIL
SETUP_FAILED
OBSERVABILITY_FAILED
SCENARIO_INVALID
```

### PASS

Use PASS only when:

- setup state was valid
- required evidence was captured
- required canonical facts exist
- required workflow outcomes exist
- forbidden side effects did not occur
- the run satisfies the scenario oracle

### FAIL

Use FAIL when:

- setup was valid
- required evidence was observable
- the system did not achieve the intended domain outcome
- a forbidden side effect occurred
- required evidence was rejected or missing in a way that represents product behavior, not harness failure

### SETUP_FAILED

Use SETUP_FAILED when:

- Given state was not established
- a setup dependency call was malformed or rejected
- a fixture was missing
- a seeded proposal, booking session, identity, catalog entry, selected start, provider, or service chain was not available
- live setup accidentally tested unrelated behavior before the actual scenario began

Setup failures must not count as pass evidence.

### OBSERVABILITY_FAILED

Use OBSERVABILITY_FAILED when:

- the system may have behaved correctly
- but the required trace, event, fact, workflow outcome, tool result, or side-effect record was not captured

Do not guess from transcript wording when required canonical evidence is missing.

### SCENARIO_INVALID

Use SCENARIO_INVALID when:

- the scenario name does not match what was executed
- the scenario claims channel parity but only one channel ran
- the scenario mixes multiple unrelated behaviors into one oracle
- the expected outcome contradicts the fixture
- the scenario lacks enough contract detail to classify the run

## Given State Discipline

A Given step describes established business state. It must not hide the behavior being tested.

If a scenario requires an active proposal, selected start, prior booking session, known provider, known service chain, known caller identity, prior confirmation, or existing appointment, prefer a named fixture or explicit fixture contract.

Do not create the critical Given state through the same live behavior that the scenario is supposed to evaluate.

Bad pattern:

```text
Given a mixed-provider proposal exists
```

but the harness tries to create the proposal live through exact-time availability search before testing provider invalidation.

Better pattern:

```text
Given fixture proposal mixed_provider_proposal_001 is active
And the proposal selectedStart is 2026-06-03T09:00:00-04:00
And the proposal assigns the requested service chain across more than one provider
```

## Outcome Contract Structure

Use this structure when writing Markdown outcome contracts:

```markdown
# Outcome Contract: <scenario id> - <name>

## Business Outcome

<The intended domain result.>

## Controlled Setup

- ...

## Normalized Input

- Actor:
- Channel:
- Caller/User intent:
- Relevant entities:

## Required Evidence

- ...

## Required Workflow Outcome

- ...

## Accepted Rejection Or Repair Outcomes

- ...

## Forbidden Evidence And Side Effects

- ...

## Allowed Nondeterminism

- ...

## Result Classification

### PASS
- ...

### FAIL
- ...

### SETUP_FAILED
- ...

### OBSERVABILITY_FAILED
- ...

### SCENARIO_INVALID
- ...

## Trace Requirements

- ...
```

Use this structure when writing JSON-like contracts:

```json
{
  "scenarioId": "EDD-041A",
  "businessOutcome": "Browser-chat produces canonical full-chain provider-preference evidence with fallback allowed.",
  "setup": {
    "required": []
  },
  "input": {
    "channel": "browser-chat",
    "normalizedIntent": {}
  },
  "requiredEvidence": [],
  "requiredWorkflowOutcomes": [],
  "acceptedRepairOutcomes": [],
  "forbiddenEvidence": [],
  "allowedNondeterminism": [],
  "resultClassification": {
    "PASS": [],
    "FAIL": [],
    "SETUP_FAILED": [],
    "OBSERVABILITY_FAILED": [],
    "SCENARIO_INVALID": []
  }
}
```

## Agent-Native Scenario Design

For coding agents and LLM runtime agents, scenarios should account for nondeterminism.

Do not require one exact transcript or one exact internal reasoning path unless that exact output is the product requirement.

Instead, require:

- stable domain outcome
- stable policy decision
- stable tool schema semantics
- stable workflow command
- stable side-effect boundary
- stable evidence trace
- acceptable variation in prose, ordering, or phrasing when business meaning is preserved

Use wording like:

```text
The assistant response must be consistent with the recorded outcome.
```

rather than:

```text
The assistant must say exactly "What start time would you like?"
```

## Channel Parity Contracts

A channel parity scenario must produce and compare evidence from each channel.

Do not claim browser-chat and phone parity from a single browser-chat run.

Prefer three contracts:

```text
EDD-041A: Browser-chat produces canonical evidence.
EDD-041B: Phone produces canonical evidence.
EDD-041C: Normalized browser-chat and phone evidence are equivalent.
```

The parity contract must define:

- fields that must match
- fields that may differ
- normalization rules
- channel-specific metadata to ignore
- required workflow outcome equivalence

Fields that usually must match:

- normalized intent
- domain entities
- policy decision
- fallback flags
- selected start or repair reason
- service chain scope
- validation status
- workflow command class
- workflow outcome class

Fields that may differ:

- channel
- session id
- transport metadata
- timestamps
- transcript phrasing
- speech-to-text artifacts

## Provider-Preference Evidence Guidance

For provider-preference scenarios, prefer canonical evidence over transcript matching.

Relevant evidence may include:

- named provider or resolved provider identity
- whether the preference applies to the full service chain or a service segment
- selected start
- time range
- fallbackAllowed
- active proposal correlation
- caller turn correlation
- call session correlation
- accepted provider-preference evidence
- rejected provider-preference evidence with reason code
- Workflow provider-aware selection request
- Workflow provider-aware selection outcome
- appointment mutation evidence, if applicable
- absence of unsafe booking mutation before validation or confirmation

Do not count these as successful provider-preference evidence:

- malformed booking-wish calls
- rejected booking-wish calls
- generic booking-wish attempts
- assistant prose that happens to contain provider language
- transcript regex matches for clarification wording
- tool-attempt counts without accepted canonical evidence

## Event-Storming Alignment

When an event-storming artifact exists, align outcome contracts to the domain flow:

- actor
- command
- policy
- domain event
- read model
- external system
- workflow command
- workflow outcome
- side effect
- rejection path

Use event-storming maps to identify required evidence. Do not reduce the scenario oracle to the diagram itself.

An event-storming path can suggest the evidence chain:

```text
Actor issues command
Command emits intent event
Intent event triggers validation policy
Policy issues evidence-building command
Evidence command emits canonical evidence event
Accepted evidence triggers workflow policy
Workflow command resolves outcome
Workflow outcome is recorded
```

## Forbidden Evidence Patterns

Flag these as invalid or weak evidence:

- transcript-only pass criteria for domain behavior
- regex-only repair detection
- counting rejected tool calls as success
- counting setup calls as scenario behavior
- generic tool attempts without accepted domain facts
- live setup that entangles unrelated availability, identity, proposal, confirmation, and workflow behavior
- assistant mutation claims without corresponding side-effect facts
- scenario names that claim parity, safety, confirmation, or workflow behavior without evidence for those claims
- pass conditions that can be satisfied before the intended policy or workflow runs

## Review Checklist

Before finishing an EDD update, verify:

- The business outcome is explicit.
- The controlled setup is separate from the behavior under test.
- Setup failure cannot be counted as pass evidence.
- The normalized input or caller intent is clear.
- Required canonical evidence is named.
- Required workflow outcome is named when applicable.
- Accepted rejection or repair outcomes are explicit.
- Forbidden side effects are explicit.
- Transcript wording is not the primary oracle unless the scenario is about wording.
- Tool attempts are not treated as success without accepted evidence.
- Channel parity scenarios actually execute and compare multiple channels.
- PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, and SCENARIO_INVALID are distinguishable.
- The trace requirements are sufficient to evaluate the outcome contract.
- The contract can be understood without reading production code.

## Reporting Format

When creating or updating EDD artifacts, report:

```markdown
## Evidence Driven Development Summary

### Artifacts Changed
- ...

### Business Outcomes Defined
- ...

### Outcome Contracts Added Or Updated
- ...

### Fixture Contracts Added Or Updated
- ...

### Required Evidence Added Or Updated
- ...

### Workflow Outcomes Added Or Updated
- ...

### Forbidden Side Effects Made Explicit
- ...

### Scenario Oracle Semantics Added Or Updated
- ...

### Weak Evidence Removed
- ...

### Event-Storming Alignment
- ...

### Open Questions
- ...
```

## Short Definition

Evidence Driven Development is a methodology for agent-native software development where success is defined by outcome contracts and proven through canonical evidence, workflow outcomes, trace facts, and forbidden-side-effect checks rather than brittle transcript wording or incidental tool attempts.
