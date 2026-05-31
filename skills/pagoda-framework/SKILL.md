---
name: pagoda-framework
description: Use for Pagoda Evidence Mapping and Evidence Driven Development work across code and architecture updates, refactors, reviews, cleanups, deletions, moves, extractions, consolidations, contract changes, workflow changes, runtime-agent changes, prompt/tool changes, harness changes, and behavior-affecting documentation changes. Use to model agent-native outcomes, replace or interpret EventStorming/storm JSON artifacts, define Evidence Maps, Outcome Contracts, Evidence Contracts, Fixture Contracts, Trace Contracts, Scenario Oracles, evidence trust boundaries, out-of-band evidence, forbidden side effects, channel parity contracts, and coding-agent implementation plans for prompts, tools, workflows, domain services, and runtime harnesses.
---

# Pagoda Framework

Use this skill for Pagoda work. Pagoda is an outcome-first framework for
agent-native software. It combines Evidence Mapping, the modeling method, with
Evidence Driven Development, the engineering discipline.

Core rule:

```text
Correctness is not proven by what an agent says.
Correctness is proven by trusted evidence that an authorized outcome occurred
without forbidden side effects.
```

For detailed vocabulary, artifact shapes, examples, and checklists, read
`references/pagoda-framework.md` when the task needs more than the workflow
below.

## Method Stack

Use this language consistently:

```text
Evidence Mapping
  Models authorized outcomes, causal paths, ownership, constraints, recovery,
  side effects, evidence obligations, trace requirements, and oracles.

Evidence Driven Development
  Turns Evidence Maps into outcome contracts, implementation work, harness
  behavior, trace evaluation, regression protection, and coding-agent tasks.

Outcome Contract
  Machine-evaluable contract for required setup, normalized intent, evidence,
  workflow/domain outcomes, forbidden side effects, trace, and oracle clauses.

Evidence Trace
  Ordered runtime evidence from domain facts, Workflow events, tool calls,
  dependency calls, infrastructure ledgers, and transcript records.

Scenario Oracle
  Deterministic classifier for PASS, FAIL, SETUP_FAILED,
  OBSERVABILITY_FAILED, and SCENARIO_INVALID.
```

Use this center of gravity:

```text
Outcome -> Authority -> Causal Path -> Evidence -> Oracle
```

## EventStorming Replacement Rule

Pagoda replaces event-first modeling with outcome-first Evidence Mapping.

When given EventStorming, storm JSON, storm diagrams, BDD overlays, or legacy
workbench artifacts, do not treat the visual board as the source of truth.
Translate the artifact into an Evidence Map:

- events become published representations of owned facts;
- commands remain intent sent to an authority;
- policies become deterministic decisions with stable output codes;
- bounded contexts become authorities for facts, invariants, commands, and
  contracts;
- relationships become explicit causal edges;
- `schemaRef`, `evidenceShape`, `recoveryShape`, BDD ids, and status labels
  become contract and implementation obligations.

Preserve useful EventStorming concepts, but center the answer on outcome,
authority, evidence, trace, and oracle semantics.

## Core Primitives

Use these primitives in maps, plans, contracts, and reviews:

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
- **Fact**: accepted business truth owned by one context.
- **Event**: published notification that a fact occurred.
- **Side Effect**: mutation, external call, emitted event, notification,
  disclosure, provider operation, ledger append, or user-visible response.
- **Recovery**: valid rejection, clarification, repair, retry, restart, or
  alternate path with its own evidence.
- **Evidence**: observable, correlated proof that a command, decision, fact,
  side effect, or recovery occurred.
- **Trace**: ordered runtime record used to evaluate the map.
- **Oracle**: classification rule that evaluates a trace against an Outcome
  Contract.
- **View**: human-facing or system-facing representation, such as assistant
  response, transcript, UI state, read model, BDD scenario, or report.

Facts and events are not synonyms:

```text
Fact = accepted business truth owned by a context.
Event = published representation of that fact for consumers.
```

## Evidence Mapping Workflow

For architecture, modeling, contract, or implementation-planning tasks, follow
this order:

1. **Name the outcome**: identify the business result or explicit rejection.
2. **Assign authority**: identify who owns each outcome, fact, decision,
   command, side effect, and evidence source.
3. **Normalize intent**: separate actor wording from canonical business fields.
4. **Map the causal path**: encode explicit causal edges from actor intent to
   command, decision, fact, command, and outcome.
5. **Map constraints**: attach invariants to the authorities that enforce them.
6. **Map recovery**: name stable rejection, repair, clarification, retry,
   restart, or approval paths.
7. **Map side effects**: list allowed side effects, forbidden side effects, and
   side effects forbidden before evidence, identity, policy, or confirmation.
8. **Map evidence**: define what proves each important command, decision, fact,
   recovery, and side effect.
9. **Define the trace contract**: specify required sources, correlation,
   ordering, trust, and missing-evidence classification.
10. **Define the oracle**: classify PASS, FAIL, SETUP_FAILED,
    OBSERVABILITY_FAILED, and SCENARIO_INVALID deterministically.

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
- one channel run for a claimed parity scenario.

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

Do not collapse setup failure, observability failure, or invalid scenario
definition into ordinary pass/fail.

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

Example:

```text
Given CallerIdentityAccepted exists before the protected request
When a later protected request is classified
Then CallerIdentityRequirementClassified must record ALREADY_ACCEPTED

CallerIdentityAccepted is setup evidence. It enables the test; it is not PASS
evidence for the later classification outcome.
```

## Evidence Trust Boundaries

For each evidence obligation, identify:

- what it proves;
- who owns the truth;
- who produced it;
- who captured it;
- whether the agent could read, modify, or omit it;
- whether it was enforced or captured out of band;
- how it correlates to session, turn, command, workflow, and outcome;
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

## Outcome Contract Guidance

An Outcome Contract should define:

- id, map id, source BDD id, and legacy storm ids when applicable;
- title and intended outcome;
- channels;
- Fixture Contract;
- Intent Contract;
- Required Evidence Contract;
- required Workflow/domain outcomes;
- Forbidden Side-Effect Contract;
- Trace Contract;
- Scenario Oracle clauses.

Use domain-specific normalized intent types when possible. Avoid loose
`Record<string, unknown>` shapes in production contracts unless the repository
does not yet have a stronger type.

## Harness Rules

A Pagoda-compatible harness evaluates Outcome Contracts, not transcript
strings. It must:

- evaluate setup before outcome behavior;
- classify failed setup as `SETUP_FAILED`;
- evaluate observability before business pass/fail;
- classify missing required trace as `OBSERVABILITY_FAILED`;
- classify mismatched scenario, channel, map, or branch as
  `SCENARIO_INVALID`;
- prevent `PASS` when the run is blocked or invalid;
- require positive evidence for positive paths;
- require rejection evidence for rejection paths;
- require repair codes for repair paths;
- require Workflow outcome evidence when the path reaches Workflow;
- evaluate forbidden side effects independently from positive evidence;
- report clause-level evidence and classification.

## Channel Parity

A parity claim requires separate child contracts plus a comparison contract.

Example:

```text
EDD-041A: Browser-chat produces canonical provider-preference evidence.
EDD-041B: Phone produces canonical provider-preference evidence.
EDD-041C: Browser-chat and phone canonical evidence are equivalent after normalization.
```

The parity contract must define:

- child contracts required;
- fields that must match;
- fields that may differ;
- normalization rules;
- channel-specific metadata exclusions;
- required outcome class;
- classification when a child run is missing.

If one channel did not execute, the parity contract cannot pass.

## Coding-Agent Workflow

When creating implementation guidance for Codex or another coding agent,
include:

```text
Outcome:
  What must become true.

Authority:
  Which context owns the decision, fact, or mutation.

Path:
  Actor -> intent -> command -> decision -> fact -> outcome.

Contracts:
  schemaRef, evidence contract, trace contract, outcome contract.

Forbidden Side Effects:
  What must not happen, and when.

Result Semantics:
  PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, SCENARIO_INVALID.

Validation Commands:
  Typecheck, lint, tests, scenario harness, trace checks.
```

Tell the coding agent to implement the target evidence path, not a transcript
regex or raw tool-attempt heuristic.

## Quality Gate

Before treating a map or legacy storm artifact as implementation-ready, verify:

- each outcome has one owning authority;
- each command has one receiving authority;
- each fact has one owning context;
- each side effect has an owner or execution authority;
- each evidence obligation names an owner and capture source;
- every path has explicit causal relationships;
- same-trigger decisions have mutually exclusive discriminators;
- recovery paths are connected to the constraints that produce them;
- each target path has positive evidence obligations;
- each rejection or repair path has explicit recovery evidence;
- fixtures are separate from behavior proof;
- setup evidence is not counted as outcome evidence;
- tool attempts and rejected/malformed calls are not counted as positive
  evidence;
- transcript wording is not the primary oracle unless presentation is the
  outcome;
- required trace sources are captured out of band when possible;
- missing trace evidence has explicit classification;
- forbidden side effects are explicit and evaluated independently;
- cross-channel parity claims define each channel path and comparison contract.

If the quality gate is blocked, report only the blocking gaps and the exact map,
contract, or legacy storm edits required before implementation.

## Output Shapes

For modeling or architecture work, cover:

- current state if supplied;
- target Evidence Map;
- bounded-context authorities;
- commands, decisions, facts, events, side effects, recoveries;
- impacted contracts and schemas;
- evidence obligations and trust boundaries;
- trace and oracle requirements;
- verification.

For contract work, produce:

- Outcome Contract;
- Fixture Contract;
- Intent Contract;
- Evidence Contract;
- Forbidden Side-Effect Contract;
- Trace Contract;
- Scenario Oracle;
- channel parity contract when needed.

For implementation planning, produce:

- spec gate status;
- target path;
- owner-by-owner implementation steps;
- contract/schema updates;
- tests and harness changes;
- validation commands.

Include migration, rollback, compatibility shims, or feature flags only when
explicitly requested or when the supplied architecture requires them.
