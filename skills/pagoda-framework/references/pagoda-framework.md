# Pagoda Framework Reference

Use this file as the index for Pagoda vocabulary and artifact responsibilities.
Load the narrower references for task-specific detail.

## Routing

- Artifact ownership or Workbench source-of-truth questions:
  `workbench-boundaries.md`.
- Scenario families, generators, invariants, counterexamples, or property-based
  testing: `scenario-thinking.md`.
- Contract schemas, trace clauses, evidence trust, result semantics, or oracle
  implementation: `contracts-and-oracles.md`.
- LLM wording, assistant meaning, semantic output, or judge behavior:
  `presentation-variance.md`.
- Contract failure repair, implementation prompts, harness rules, channel parity,
  or Pagoda debt: `implementation-guidance.md`.

## Definition

Pagoda Evidence Mapping is an outcome-first causal proof model for agent-native
software. Evidence Driven Development turns maps into executable Outcome
Contracts, implementation tasks, runtime harnesses, trace evaluators, and
regression suites so teams can prove intended outcomes without relying on
transcript wording, model self-report, or incidental tool attempts.

## Core Primitives

- **Outcome**: business result or explicit rejection that must become true.
- **Actor**: human, system, runtime agent, coding agent, provider, gateway, or
  infrastructure source that initiates intent or contributes evidence.
- **Intent**: normalized actor goal independent of transcript wording,
  transport, language, or model phrasing.
- **Authority**: bounded context, workflow, aggregate, policy, service, or
  infrastructure layer that may decide, mutate, accept, reject, publish, or
  capture trusted evidence.
- **Command**: request sent to an authority; it expresses intent, not success.
- **Decision**: deterministic policy evaluation from canonical inputs to stable
  output codes and mutually exclusive branches.
- **Constraint / Invariant Property**: rule that must hold before a command,
  fact, or side effect is allowed, including across generated variations.
- **Fact**: accepted business truth owned by one context.
- **Event**: published notification that a fact occurred.
- **Side Effect**: mutation, external call, event, notification, disclosure,
  provider operation, ledger append, or user-visible response.
- **Recovery**: valid rejection, clarification, repair, retry, restart, or
  alternate path with its own evidence.
- **Evidence**: observable, correlated proof that a command, decision, fact,
  side effect, recovery, or absence of forbidden side effect occurred.
- **Trace**: ordered runtime record used to evaluate the map.
- **Oracle**: classification rule that evaluates a trace against an Outcome
  Contract.
- **Evidence Scenario**: concrete or generated path through an Evidence Map that
  attempts to prove or falsify an outcome.
- **Scenario Family**: related Evidence Scenarios generated from the same
  outcome, authority, causal path, invariant, recovery rule, or forbidden side
  effect.
- **Generator**: bounded domain-specific producer of scenario variations.
- **Counterexample**: smallest scenario variation that falsifies an invariant,
  violates a contract, misses evidence, produces a forbidden side effect, or
  exposes trace/oracle ambiguity.
- **Presentation Meaning**: normalized meaning communicated by an assistant, UI,
  transcript, notification, or generated message.

Facts and events are not synonyms:

```text
Fact = accepted business truth owned by a context.
Event = published representation of that fact for consumers.
```

Transcript scripts and Evidence Scenarios are not synonyms:

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

## Method Stack

Use this center of gravity:

```text
Outcome -> Authority -> Causal Path -> Evidence -> Oracle
```

When implementation code is about to change, use:

```text
Outcome -> Authority -> Invariant -> Scenario Family -> Evidence -> Oracle
```
