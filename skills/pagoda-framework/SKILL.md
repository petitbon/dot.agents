---
name: pagoda-framework
description: "Use for Agentis Pagoda Workbench outcome proof: Evidence Maps, Evidence Scenario Families, invariant properties, Outcome/Evidence/Fixture/Intent/Trace Contracts, Scenario Oracles, Evidence Traces, executable evidence-scenario runs, simulation harness behavior, LLM presentation variance checks, channel parity contracts, governed workflow state proof, authorized outcome evidence, recovery-to-stable-state evidence, run classification, and Workbench/platform isolation. Do not use for general repo governance, ordinary architecture/refactor work, Node service quality, SDK releases, or realtime prompt/tool design unless Pagoda evidence, contracts, traces, scenarios, governed workflow proof, or harness execution are directly affected."
---

# Pagoda Framework

Use this skill for Pagoda-owned outcome proof.

Pagoda proves that governed AI workflows produced authorized outcomes through trusted evidence, trace contracts, scenario oracles, and executable evidence scenarios. It does not prove correctness from what a model says about itself.

## Core Rule

```text
Correctness is proven by trusted evidence that an authorized outcome occurred
without forbidden side effects, not by what an agent says.
```

## LLM Presentation Rule

```text
Do not test exact assistant wording unless exact wording is the regulated,
contractual, safety, legal, or product outcome under test.
```

## Scope

Pagoda owns:

- Evidence Maps;
- Evidence Scenario Families;
- invariant properties;
- Outcome Contracts;
- Evidence Contracts;
- Fixture Contracts;
- Intent Contracts;
- Forbidden Side-Effect Contracts;
- Trace Contracts;
- Scenario Oracles;
- Evidence Traces;
- executable evidence-scenario outcome runs;
- simulation harness behavior;
- channel parity contracts;
- LLM presentation contracts for scenario evaluation;
- governed workflow state proof;
- authorized outcome evidence;
- recovery-to-stable-state evidence;
- run classification;
- Workbench/platform isolation.

Pagoda does not own general repository governance, architecture refactors, Node service quality, SDK releases, ordinary realtime runtime design, or product workflow design unless Pagoda evidence, contracts, traces, scenarios, governed workflow proof, or harness execution are directly affected.

EDD is a legacy alias for evidence-scenario outcome runs. Prefer `evidence scenarios` in new artifacts.

## Reference Loading

Load the narrow reference file when the task needs detail beyond this routing file:

- `references/pagoda-framework.md` for Pagoda vocabulary and artifact responsibility routing.
- `references/workbench-boundaries.md` for Workbench ownership, Agentis paths, and platform isolation.
- `references/scenario-thinking.md` for scenario families, invariant properties, generators, counterexamples, and property-based tests.
- `references/contracts-and-oracles.md` for contract shapes, trace clauses, evidence trust, result semantics, and oracle implementation.
- `references/presentation-variance.md` for assistant wording, semantic presentation checks, and LLM judge protocol.
- `references/implementation-guidance.md` for contract failure repair, implementation prompts, harness rules, channel parity, and Pagoda debt.

## Boundary With Product Architecture Skills

Use product architecture skills, such as `booking-workflow-architecture`, for how Agentis workflows should be designed.

Use `pagoda-framework` for how those workflows are proven correct.

```text
Product architecture owns:
- workflow design;
- state-machine structure;
- recovery loops;
- service boundaries;
- domain-specific invariants;
- product behavior requirements.

Pagoda owns:
- evidence required to prove behavior;
- authorities and trust boundaries;
- trace requirements;
- scenario families;
- deterministic oracle clauses;
- forbidden-side-effect proof;
- recovery-to-stable-state proof;
- channel parity proof;
- harness execution semantics.
```

Do not move general booking architecture, realtime prompt design, SDK release logic, or Node service quality rules into this skill unless they are necessary to define or repair Pagoda proof artifacts.

## Workbench Isolation

For Agentis tasks, `agentis-pagoda-workbench` owns Pagoda model artifacts, testing framework files, executable outcome runs, simulation harness code, trace/oracle code, fixtures, generated artifacts, and Pagoda-specific context.

Platform repos may expose normal product evidence, but must not import, persist, or depend on Pagoda-specific harness concepts.

## Proof Workflow

For Pagoda Evidence Map, Evidence Scenario Family, Outcome Contract, Evidence Contract, Trace Contract, Scenario Oracle, evidence-scenario registry, simulation harness, Workbench evidence-trace work, governed workflow proof, or recovery-to-stable-state proof:

1. Name the outcome or explicit rejection.
2. Assign the authority for each outcome, fact, decision, command, side effect, state transition, recovery step, and evidence source.
3. Normalize intent independently from transcript wording, transport, language, or model phrasing.
4. Map the causal path from actor intent to command, decision, fact, state, side effect, recovery, rejection, and outcome.
5. Identify stable states, branch discriminators, terminal states, retry loops, conflict paths, restart paths, clarification paths, rejection paths, and recovery-to-stable-state paths.
6. Derive scenario families from the outcome path, including concrete examples, generated variations, invariant properties, negative paths, recovery paths, forbidden-side-effect probes, stale-state probes, and counterexamples.
7. Attach invariants to the authorities that enforce them.
8. Name stable rejection, repair, clarification, retry, restart, recovery, approval, or escalation paths.
9. Define allowed side effects, forbidden side effects, and side effects forbidden before evidence, identity, policy, confirmation, payment, authorization, or Workflow approval.
10. Define trusted evidence for each important command, decision, fact, state, transition, recovery, side effect, outcome, and absence of forbidden side effects.
11. Define the trace contract: sources, correlation, ordering, trust, setup/action partitioning, state-transition visibility, and missing-evidence classification.
12. Define deterministic oracle clauses for PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, and SCENARIO_INVALID.
13. Add a semantic presentation contract and strict JSON judge only when assistant meaning is part of the outcome.

## Governed Workflow Proof Pattern

Use this pattern when a Pagoda artifact evaluates an agentic workflow that must move through stable states, produce authorized outcomes, recover from conflicts, and avoid forbidden side effects.

A governed workflow agent is not proven correct by conversational completion. It is proven correct by evidence that the workflow:

1. entered the expected state;
2. used the correct authority for facts, decisions, and side effects;
3. proposed only authorized options;
4. collected required confirmation, approval, payment, identity, policy, or authorization evidence before restricted side effects;
5. committed only through the owning workflow or service authority;
6. recovered from conflicts by returning to a stable allowed state;
7. emitted trace evidence for every important command, decision, recovery, transition, side effect, outcome, and absence of forbidden side effects.

For governed workflows, scenario families should include:

- happy path;
- explicit rejection path;
- clarification path;
- conflict recovery path;
- retry path;
- stale proposal path;
- missing confirmation path;
- invalid authorization path;
- forbidden-side-effect-before-authorization path;
- recovery-to-stable-state path;
- channel parity path;
- observability failure path;
- malformed or missing evidence path.

Do not prove governed workflow correctness from assistant wording, model self-report, attempted tool calls, raw tool-attempt counts, rejected tool calls, malformed tool calls, or final user-facing text alone.

## State Machine Proof Guidance

When the behavior under test is a stateful workflow, the proof must distinguish:

- current state;
- proposed next state;
- accepted transition;
- rejected transition;
- terminal state;
- recovery state;
- retryable state;
- stable state returned to after recovery;
- side effects allowed in each state;
- side effects forbidden in each state.

A recovery path is valid only when evidence proves that the workflow returned to a stable allowed state with the normal downstream rules restored.

Example state proof shape:

```text
PROPOSAL_PRESENTED
  -> caller accepts/selects
  -> CONFIRMATION_EVIDENCE_COLLECTED
  -> COMMIT_ATTEMPT
      -> CONFIRMED
          -> COMPLETED_COMMIT terminal
      -> SLOT_CONFLICT
          -> RECOVERY_SEARCH
          -> PROPOSAL_PRESENTED
```

The recovered proposal is not a special successful commit. It becomes a normal active proposal and must satisfy the same confirmation, authorization, commit, and trace obligations as the original proposal.

## Evidence Scenario Thinking

Evidence scenarios are not exact transcript tests. They are outcome-proof tests.

Build scenario families around invariant properties, not around one expected assistant phrase. The same governed outcome should pass across valid differences in wording, channel, language, turn shape, and model phrasing when trusted evidence proves the same authorized outcome and absence of forbidden side effects.

Use generated variations to probe:

- intent wording variance;
- channel variance;
- locale or language variance;
- caller preference variance;
- fixture data variance;
- authority boundary variance;
- missing or stale evidence;
- conflict timing;
- retry timing;
- ambiguous input;
- invalid input;
- malformed tool responses;
- transport-specific presentation differences;
- forbidden side-effect attempts;
- recovery-to-stable-state behavior.

Use counterexamples to make the oracle sharper. A scenario family is weak if it only proves the expected happy path and does not prove that nearby invalid paths fail for the correct reason.

## Authority Rules

Every important fact, decision, command, state transition, recovery step, side effect, and outcome must have one clear owning authority.

Examples:

- Scheduling owns availability and appointment truth.
- Workflow owns governed booking writes and approval gates.
- Salon configuration owns policy, service, provider, duration, price, and operating-rule truth when applicable.
- Channel adapters own transport delivery evidence, not domain truth.
- The model may normalize intent and present information, but model statements are not authoritative proof of domain facts or side effects.

Do not allow setup fixtures, assistant messages, model self-report, or raw tool attempts to satisfy outcome evidence unless the contract explicitly defines them as trusted evidence for that narrow claim.

## Trace Contract Requirements

A trace contract must define:

- trusted trace sources;
- correlation IDs or equivalent correlation rules;
- required ordering constraints;
- setup/action/result partitioning;
- authority for each trace source;
- evidence required for each important command;
- evidence required for each decision;
- evidence required for each state transition;
- evidence required for each recovery step;
- evidence required for each side effect;
- evidence required for absence of forbidden side effects;
- missing-evidence classification;
- stale-evidence classification;
- malformed-evidence classification;
- observability failure semantics.

Setup evidence cannot satisfy outcome evidence. A fixture may prove that the test world was prepared, but it does not prove that the workflow produced the outcome under test.

## Oracle Result Semantics

Use deterministic oracle clauses.

- **PASS**: trusted evidence proves the authorized outcome occurred and forbidden side effects did not occur.
- **FAIL**: trusted evidence proves the outcome was wrong, incomplete, unauthorized, or accompanied by forbidden side effects.
- **SETUP_FAILED**: setup did not create the required test world, fixture state, or preconditions.
- **OBSERVABILITY_FAILED**: the run may have behaved correctly, but required trusted evidence is missing, stale, malformed, uncorrelated, or insufficient.
- **SCENARIO_INVALID**: the scenario definition is contradictory, impossible, underspecified, or does not match the declared contract.

Do not collapse OBSERVABILITY_FAILED into PASS. Missing proof is not proof of success.

## Assistant Presentation Contracts

Add an assistant presentation contract only when user-facing meaning is part of the outcome.

Do not test exact assistant wording unless exact wording is itself the regulated, contractual, safety, legal, or product requirement.

When presentation matters, test semantic obligations such as:

- assistant presented the authorized proposal accurately;
- assistant did not imply an unconfirmed booking;
- assistant did not present unavailable options as available;
- assistant asked for clarification when required;
- assistant communicated rejection or recovery without inventing facts;
- assistant preserved channel-specific meaning.

Use a strict JSON judge only when the contract requires semantic evaluation of assistant meaning. The judge result must not replace domain evidence for facts, commands, side effects, or outcomes.

## Channel Parity Contracts

A channel parity claim is valid only when child contracts and comparison rules are explicit.

Define:

- shared outcome contract;
- channel-specific fixtures;
- channel-specific presentation obligations;
- channel-specific trace sources;
- channel-specific allowed variance;
- evidence that must match across channels;
- evidence that may differ across channels;
- comparison rules for PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, and SCENARIO_INVALID.

Do not claim channel parity from similar assistant wording. Prove parity from shared outcome evidence and channel-specific contract satisfaction.

## Agentic Workflow Measurement

For agentic workflow evaluation, distinguish correctness proof from adoption or productivity signals.

Correctness proof comes from trusted outcome evidence and absence of forbidden side effects.

Adoption/productivity signals may include:

- delegated task complexity;
- active runtime;
- workflow reuse;
- skill reuse;
- concurrency;
- production output;
- human review or correction rate.

These signals may explain workflow maturity, but they do not prove a governed outcome unless the outcome contract explicitly defines them as evidence.

## Quality Gate

A Pagoda artifact is implementation-ready only when:

- each outcome, fact, command, decision, state, transition, recovery step, side effect, and evidence source has one clear owning authority;
- causal paths and branch discriminators are explicit;
- stable states, terminal states, retry states, and recovery-to-stable-state paths are named when the workflow is stateful;
- positive, negative, recovery, retry, stale-state, and forbidden-side-effect paths have evidence obligations;
- fixtures are separate from behavior proof;
- setup evidence cannot satisfy outcome evidence;
- assistant wording, model self-report, raw tool-attempt counts, and rejected or malformed tool calls are not positive proof;
- required trace sources, missing-evidence classification, stale-evidence classification, malformed-evidence classification, and forbidden side effects are explicit;
- channel parity claims define child contracts and comparison rules;
- presentation variance is handled semantically unless exact wording is the outcome under test;
- governed workflow recovery proves return to a stable allowed state before normal downstream rules resume.

If the quality gate is blocked, report the blocking gaps and the exact map, scenario family, contract, oracle, trace, or harness edits required before implementation.

## Implementation Guidance

When a failing evidence scenario indicates a broken governed workflow loop, do not patch only the observed branch. First identify the missing state, authority, evidence obligation, recovery transition, or oracle clause.

Prefer repairs that make the workflow reusable and provable:

- add or clarify state evidence;
- add or clarify transition evidence;
- add or clarify recovery evidence;
- add or clarify forbidden-side-effect evidence;
- repair the authority boundary;
- repair the trace contract;
- repair the oracle clause;
- add counterexamples;
- add generated variation dimensions;
- update the scenario family rather than only the single failing example.

For product repos, preserve platform isolation. Product code may emit normal business evidence, but it must not import Pagoda harness concepts, depend on Pagoda scenario schemas, or persist Pagoda-only trace structures.

## Output

For modeling work, produce the target Evidence Map, authorities, causal path, stable states, branch discriminators, scenario families, invariant properties, generated variation dimensions, counterexamples, evidence obligations, trace/oracle requirements, and validation.

For contract work, produce or update the relevant Outcome, Fixture, Intent, Evidence, Forbidden Side-Effect, Trace, Scenario Oracle, Assistant Presentation, state-transition, recovery, and channel parity contracts.

For repair work, produce spec gate status, target path, invariant properties, scenario families and counterexamples, owner-by-owner implementation steps, contract/schema updates, tests, harness changes, and validation commands.

For blocked work, report the exact missing authority, evidence, trace, oracle, scenario, state, transition, recovery, or isolation rule that prevents safe implementation.
