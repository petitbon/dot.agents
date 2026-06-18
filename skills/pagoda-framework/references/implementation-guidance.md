# Pagoda Implementation Guidance

Use this reference when implementation work is needed to satisfy, repair, or
extend a Pagoda contract, scenario family, oracle, trace, harness, LLM
presentation rule, or channel parity contract.

## Contract Failure Guidance

Implementation guidance should include:

```text
Outcome:
Authority:
Path:
Invariant Properties:
Scenario Families:
Contracts:
Forbidden Side Effects:
LLM Output Variance:
Result Semantics:
Validation Commands:
```

Tell the coding agent to implement the target evidence path, invariant, and
authority boundary, not a transcript regex or raw tool-attempt heuristic.

## Evidence Scenario Implementation

Before changing implementation code, derive or update the relevant Evidence
Scenario Families.

For each implementation change, identify:

```text
Target Outcome:
Invariant Properties:
Generated Variations:
Forbidden Side Effects:
Counterexamples:
Evidence Obligations:
Implementation Constraints:
Validation:
```

Do not implement only the happy-path example. Implement the invariant and
authority boundary that make the scenario family pass.

## Minimal Codex Prompt Pattern

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
- evaluate forbidden side effects independently from positive evidence;
- evaluate assistant output semantically when presentation meaning is under
  test;
- report clause-level evidence and classification.

## Channel Parity

A parity claim requires separate child contracts plus a comparison contract.

Example:

```text
EDD-041A: Browser-chat produces canonical provider-preference evidence.
EDD-041B: Phone produces canonical provider-preference evidence.
EDD-041C: Browser-chat and phone canonical evidence are equivalent after normalization.
```

The parity contract must define child contracts, fields that match, fields that
may differ, normalization rules, channel-specific metadata exclusions, required
outcome class, classification when a child run is missing, and whether
assistant presentation meaning must be equivalent or outcome-consistent.

For LLM channels, parity usually means normalized intent, outcome class,
required facts, recovery meaning, and trusted evidence are equivalent. It does
not mean the assistant used the same words.

## Pagoda Harness Debt

Track Pagoda-specific debt separately from general repository quality debt:

- missing Outcome Contract clauses;
- missing Evidence Contract obligations;
- trace sources that cannot be correlated;
- transcript-only oracles that should use trusted evidence;
- setup evidence accidentally counted as outcome proof;
- channel parity claims without child contracts;
- Workbench/platform boundary risks;
- scenario runs that collapse SETUP_FAILED, OBSERVABILITY_FAILED, or
  SCENARIO_INVALID into ordinary FAIL.

General quality scorecards and repository cleanup loops belong to
`agent-harness-engineering`.

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
