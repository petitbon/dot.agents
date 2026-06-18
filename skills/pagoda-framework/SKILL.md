---
name: pagoda-framework
description: "Use for Agentis Pagoda Workbench outcome proof: Evidence Mapping, Evidence Scenario Thinking, scenario families, invariant properties, Outcome/Evidence/Fixture/Trace Contracts, Scenario Oracles, Evidence Traces, executable EDD runs, simulation-ai harness behavior, LLM presentation variance checks, channel parity contracts, run classification, and Workbench/platform isolation. Use when a task changes or evaluates Pagoda-owned behavior-proof artifacts, scenario JSON, trace/oracle behavior, or coding-agent constraints derived from Pagoda evidence. Do not use for general repo governance, ordinary architecture/refactor work, Node service quality, SDK releases, or realtime prompt/tool design unless Pagoda evidence, contracts, traces, scenarios, or harness execution are directly affected."
---

# Pagoda Framework

Use this skill for Pagoda work. Pagoda is an outcome-first framework for
agent-native software. It combines Evidence Mapping, Evidence Scenario Thinking,
and Evidence Driven Development.

Core rule:

```text
Correctness is not proven by what an agent says.
Correctness is proven by trusted evidence that an authorized outcome occurred
without forbidden side effects.
```

Secondary rule:

```text
Do not test exact LLM wording unless exact wording is the regulated,
contractual, safety, legal, or product outcome under test.
Test normalized meaning, trusted evidence, authorized outcomes, trace ordering,
and forbidden side effects.
```

LLM judge rule:

```text
An LLM judge may evaluate presentation meaning only. It is never authority for
business truth, setup truth, workflow success, identity, availability, booking,
pricing, policy, or forbidden-side-effect absence.
```

## Scope Boundary

Pagoda is an independent, encapsulated, end-to-end outcome-proof harness for
agent-native software.

Pagoda owns:

- Evidence Maps when used to define executable outcome proof;
- Evidence Scenario Thinking artifacts;
- Evidence Scenario Families, invariant properties, generated variations, and
  counterexamples;
- Outcome Contracts, Evidence Contracts, Fixture Contracts, Trace Contracts, and
  Scenario Oracles;
- Evidence Traces and executable EDD outcome runs;
- LLM output variance rules and semantic presentation contracts when they affect
  scenario evaluation;
- LLM-as-judge protocol for assistant presentation meaning when the judge is
  subordinate to deterministic evidence contracts;
- EDD registry interpretation and simulation-ai harness behavior;
- channel parity contracts;
- PASS, FAIL, SETUP_FAILED, OBSERVABILITY_FAILED, and SCENARIO_INVALID
  classification;
- Workbench/platform isolation.

Pagoda does not own general repository harness engineering. AGENTS.md topology,
repository-wide docs as system of record, quality scorecards, technical-debt
ledgers, custom architecture lints, structural tests, local worktree bootability,
general observability access for Codex, and recurring cleanup loops belong to
`agent-harness-engineering` or the relevant architecture/runtime skill.

Use Pagoda to prove outcomes. Use `agent-harness-engineering` to make the
repository legible and governable for coding agents.

For detailed vocabulary, artifact shapes, examples, and checklists, read
`references/pagoda-framework.md` when the task needs more than this compact
workflow. Use its routing section to load only the relevant detail.

## Agentis Workbench Pointers

For Agentis tasks, treat `agentis-pagoda-workbench` as the local owner for
Pagoda/EventStorming model artifacts, the Pagoda testing framework, executable
EDD outcome runs, simulation harness code, trace/oracle code, fixtures,
generated artifacts, and all Pagoda-specific context.

Hard isolation rule:

- `agentis-pagoda-workbench` owns Pagoda testing framework files and artifacts.
- Agentis platform repos must remain 100% agnostic of Pagoda testing,
  EventStorming, EDD registry, simulation harness, oracle, fixture, artifact,
  and Workbench-specific context.
- Do not move, copy, import, depend on, or reference Pagoda harness code,
  generated artifacts, storm files, EDD registry files, or Workbench-only
  context from platform repos.
- Platform repos may expose ordinary product contracts, logs, APIs, events, and
  runtime evidence that the Workbench observes from outside. They must not embed
  Pagoda concepts to satisfy tests.

Load the smallest relevant files:

- `agentis-pagoda-workbench/docs/pagoda/scenarios/*.scenario.json`
- `agentis-pagoda-workbench/docs/pagoda/evidence-maps/*.evidence-map.json`
- `agentis-pagoda-workbench/docs/pagoda/contracts/*.outcome-contract.json`
- `agentis-pagoda-workbench/server/pagodaModelService.ts`
- `agentis-pagoda-workbench/server/pagodaCli.ts`
- `agentis-pagoda-workbench/server/simulation-ai/**`
- `agentis-pagoda-workbench/artifacts/**` only for specific run evidence

Do not use the old `agentis-scripts-local` simulation-ai path as the owner for
Workbench EDD execution.

## Method Stack

Use this language consistently:

```text
Evidence Mapping
  Models authorized outcomes, causal paths, ownership, constraints, recovery,
  side effects, evidence obligations, trace requirements, and oracles.

Evidence Scenario Thinking
  Converts Evidence Maps into scenario families, invariant properties,
  generated variations, concrete examples, negative paths, recovery probes,
  forbidden-side-effect probes, counterexamples, and falsification rules.

Evidence Driven Development
  Turns Evidence Maps and Evidence Scenario Families into outcome contracts,
  implementation work, harness behavior, trace evaluation, regression
  protection, and coding-agent tasks.

Outcome Contract
  Machine-evaluable contract for required setup, normalized intent, evidence,
  workflow/domain outcomes, forbidden side effects, trace, and oracle clauses.

Evidence Scenario
  Concrete or generated path through an Evidence Map that attempts to prove or
  falsify an outcome using trusted evidence, forbidden-side-effect checks, trace
  requirements, and oracle clauses.

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

Use this implementation center of gravity when Codex or another coding agent is
about to change code:

```text
Outcome -> Authority -> Invariant -> Scenario Family -> Evidence -> Oracle
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
authority, evidence, trace, oracle, and scenario-family semantics.

## Core Primitives

Use these primitives in maps, plans, contracts, scenario families, and reviews:

- **Outcome**: the business result or explicit rejection that must become true.
- **Intent**: normalized actor goal independent of transcript wording,
  transport, language, or model phrasing.
- **Authority**: the bounded context, workflow, aggregate, policy, service, or
  infrastructure layer that may decide, mutate, accept, reject, publish, or
  capture trusted evidence.
- **Fact**: accepted business truth owned by one context.
- **Event**: published notification that a fact occurred.
- **Evidence**: observable, correlated proof that a command, decision, fact,
  side effect, recovery, or absence of forbidden side effect occurred.
- **Trace**: ordered runtime record used to evaluate the map.
- **Oracle**: classification rule that evaluates a trace against an Outcome
  Contract.
- **Evidence Scenario**: a concrete or generated path through an Evidence Map
  that attempts to prove or falsify an outcome.
- **Scenario Family**: a group of Evidence Scenarios generated from the same
  outcome, authority, causal path, invariant, recovery rule, or forbidden-side
  effect rule.
- **Counterexample**: the smallest scenario variation that falsifies an
  invariant, violates a contract, misses required evidence, produces a forbidden
  side effect, or exposes a trace/oracle ambiguity.
- **Presentation Meaning**: normalized meaning communicated by an assistant, UI,
  transcript, notification, or generated message, independent of exact wording
  unless exact wording is itself the outcome.

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

## Evidence Mapping Workflow

For Pagoda Evidence Map, Evidence Scenario Family, Outcome Contract, Evidence
Contract, Trace Contract, Scenario Oracle, EDD registry, simulation-ai harness,
or Workbench-owned evidence-trace work, follow this order:

1. **Name the outcome**: identify the business result or explicit rejection.
2. **Assign authority**: identify who owns each outcome, fact, decision,
   command, side effect, and evidence source.
3. **Normalize intent**: separate actor wording from canonical business fields.
4. **Map the causal path**: encode explicit causal edges from actor intent to
   command, decision, fact, side effect, recovery, and outcome.
5. **Derive evidence scenarios**: create scenario families from the outcome
   path, including concrete examples, generated variations, invariant
   properties, negative paths, recovery paths, forbidden-side-effect probes, and
   counterexamples.
6. **Map constraints**: attach invariants to the authorities that enforce them.
7. **Map recovery**: name stable rejection, repair, clarification, retry,
   restart, or approval paths.
8. **Map side effects**: list allowed side effects, forbidden side effects, and
   side effects forbidden before evidence, identity, policy, confirmation,
   payment, authorization, or Workflow approval.
9. **Map evidence**: define what proves each important command, decision, fact,
   recovery, side effect, and absence of forbidden side effects.
10. **Define the trace contract**: specify required sources, correlation,
    ordering, trust, setup/action partitioning, and missing-evidence
    classification.
11. **Define the oracle**: classify PASS, FAIL, SETUP_FAILED,
    OBSERVABILITY_FAILED, and SCENARIO_INVALID deterministically.
12. **Define presentation judging**: when assistant meaning is part of the
    outcome, require a semantic presentation contract and a strict JSON judge
    result that can only fail or support the presentation clause.

## Quality Gate

Before treating a map, scenario family, or legacy storm artifact as
implementation-ready, verify:

- each outcome, fact, command, decision, side effect, and evidence source has
  one clear owning authority;
- every path has explicit causal relationships and mutually exclusive branch
  discriminators where needed;
- recovery paths are connected to the constraints that produce them;
- each target outcome has at least one concrete Evidence Scenario and one
  invariant property when behavior varies;
- generated variations are bounded by domain-valid data;
- positive, negative, recovery, and forbidden-side-effect paths have explicit
  evidence obligations;
- fixtures are separate from behavior proof and setup evidence is not counted as
  outcome evidence;
- tool attempts, rejected or malformed calls, transcript wording, and model
  self-report are not counted as positive proof;
- LLM output variance is handled through semantic meaning, trusted evidence,
  and explicit presentation contracts;
- exact wording is required only when the contract explicitly says exact wording
  is the outcome;
- required trace sources are captured out of band when possible;
- missing trace evidence has explicit classification;
- forbidden side effects are explicit and evaluated independently;
- property-based tests do not replace trusted evidence traces;
- cross-channel parity claims define each channel path and comparison contract.
- LLM judge output is strict, typed, auditable, and subordinate to deterministic
  evidence; missing, malformed, ambiguous, or contradictory judge output never
  produces success.

If the quality gate is blocked, report only the blocking gaps and the exact map,
scenario family, contract, or legacy storm edits required before implementation.

## Output Shapes

For Pagoda Evidence Map or outcome-proof modeling work, cover current state if
supplied, target Evidence Map, bounded-context authorities, causal path,
Evidence Scenario Families, invariant properties, generated variation
dimensions, counterexamples, evidence obligations, trace and oracle
requirements, LLM output variance when relevant, and verification.

For contract work, produce the Outcome Contract, Fixture Contract, Intent
Contract, Evidence Contract, Forbidden Side-Effect Contract, Trace Contract,
Scenario Oracle, Evidence Scenario Family when needed, Assistant Presentation
Contract when user-facing meaning is part of the outcome, and channel parity
contract when needed.

For Pagoda contract repair or extension work, produce spec gate status, target
path, invariant properties, scenario families and counterexamples,
owner-by-owner implementation steps, contract/schema updates, tests and harness
changes, and validation commands.

Include migration, rollback, compatibility shims, or feature flags only when
explicitly requested or when the supplied architecture requires them.
