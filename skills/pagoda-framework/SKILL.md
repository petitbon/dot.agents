---
name: pagoda-framework
description: "Use for Agentis Pagoda Workbench outcome proof: Evidence Mapping, Evidence Scenario Thinking, scenario families, invariant properties, Outcome/Evidence/Fixture/Trace Contracts, Scenario Oracles, Evidence Traces, executable EDD runs, simulation-ai harness behavior, LLM presentation variance checks, channel parity contracts, run classification, and Workbench/platform isolation. Use when a task changes or evaluates Pagoda-owned behavior-proof artifacts, scenario JSON, trace/oracle behavior, or coding-agent constraints derived from Pagoda evidence. Do not use for general repo governance, ordinary architecture/refactor work, Node service quality, SDK releases, or realtime prompt/tool design unless Pagoda evidence, contracts, traces, scenarios, or harness execution are directly affected."
---

# Pagoda Framework

Use this skill for Pagoda-owned outcome proof.

Core rule:

```text
Correctness is proven by trusted evidence that an authorized outcome occurred
without forbidden side effects, not by what an agent says.
```

LLM presentation rule:

```text
Do not test exact assistant wording unless exact wording is the regulated,
contractual, safety, legal, or product outcome under test.
```

## Scope

Pagoda owns Evidence Maps, Evidence Scenario Families, Outcome/Evidence/Fixture/
Trace Contracts, Scenario Oracles, Evidence Traces, executable EDD runs,
simulation-ai harness behavior, channel parity contracts, LLM presentation
contracts for scenario evaluation, run classification, and Workbench/platform
isolation.

Pagoda does not own general repository harness engineering, architecture
refactors, Node service quality, SDK releases, or realtime runtime design unless
Pagoda evidence, contracts, traces, scenarios, or harness execution are directly
affected.

For Agentis tasks, `agentis-pagoda-workbench` owns Pagoda model artifacts,
testing framework files, executable EDD outcome runs, simulation harness code,
trace/oracle code, fixtures, generated artifacts, and Pagoda-specific context.
Platform repos may expose normal product evidence, but must not import, persist,
or depend on Pagoda-specific harness concepts.

## Reference Routing

Load only the reference needed:

- `references/pagoda-framework.md`: vocabulary, artifact responsibilities, and
  routing index.
- `references/workbench-boundaries.md`: Agentis Workbench paths, ownership, and
  platform isolation.
- `references/scenario-thinking.md`: Evidence Scenario Families, invariant
  properties, generators, counterexamples, and property-based test relationship.
- `references/contracts-and-oracles.md`: Outcome Contract shape, evidence
  obligations, trace contracts, oracle clauses, result semantics, and trust
  boundaries.
- `references/presentation-variance.md`: LLM output variance, assistant
  presentation contracts, and LLM judge protocol.
- `references/implementation-guidance.md`: implementation prompts, contract
  repair guidance, harness rules, channel parity, and debt tracking.

## Workflow

For Pagoda Evidence Map, Evidence Scenario Family, Outcome Contract, Evidence
Contract, Trace Contract, Scenario Oracle, EDD registry, simulation-ai harness,
or Workbench-owned evidence-trace work:

1. Name the outcome or explicit rejection.
2. Assign the authority for each outcome, fact, decision, command, side effect,
   and evidence source.
3. Normalize intent independently from transcript wording, transport, language,
   or model phrasing.
4. Map the causal path from actor intent to command, decision, fact, side effect,
   recovery, and outcome.
5. Derive scenario families from the outcome path, including concrete examples,
   generated variations, invariant properties, negative paths, recovery paths,
   forbidden-side-effect probes, and counterexamples.
6. Attach invariants to the authorities that enforce them.
7. Name stable rejection, repair, clarification, retry, restart, or approval
   paths.
8. Define allowed side effects, forbidden side effects, and side effects
   forbidden before evidence, identity, policy, confirmation, payment,
   authorization, or Workflow approval.
9. Define trusted evidence for each important command, decision, fact, recovery,
   side effect, and absence of forbidden side effects.
10. Define the trace contract: sources, correlation, ordering, trust,
    setup/action partitioning, and missing-evidence classification.
11. Define deterministic oracle clauses for PASS, FAIL, SETUP_FAILED,
    OBSERVABILITY_FAILED, and SCENARIO_INVALID.
12. Add a semantic presentation contract and strict JSON judge only when
    assistant meaning is part of the outcome.

## Quality Gate

A Pagoda artifact is implementation-ready only when:

- each outcome, fact, command, decision, side effect, and evidence source has one
  clear owning authority;
- causal paths and branch discriminators are explicit;
- positive, negative, recovery, and forbidden-side-effect paths have evidence
  obligations;
- fixtures are separate from behavior proof and setup evidence cannot satisfy
  outcome evidence;
- assistant wording, model self-report, raw tool-attempt counts, and rejected or
  malformed tool calls are not positive proof;
- required trace sources, missing-evidence classification, and forbidden side
  effects are explicit;
- channel parity claims define child contracts and comparison rules.

If the quality gate is blocked, report the blocking gaps and the exact map,
scenario family, contract, oracle, or harness edits required before
implementation.

## Output

For modeling work, produce the target Evidence Map, authorities, causal path,
scenario families, invariant properties, generated variation dimensions,
counterexamples, evidence obligations, trace/oracle requirements, and validation.

For contract work, produce or update the relevant Outcome, Fixture, Intent,
Evidence, Forbidden Side-Effect, Trace, Scenario Oracle, Assistant Presentation,
and channel parity contracts.

For repair work, produce spec gate status, target path, invariant properties,
scenario families and counterexamples, owner-by-owner implementation steps,
contract/schema updates, tests, harness changes, and validation commands.
