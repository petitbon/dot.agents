---
name: agent-harness-engineering
description: "Use for repository-local agent operating systems: AGENTS.md as a map, docs as system of record, execution plans, validation loops, mechanical checks, custom lints, structural tests, local worktree bootability, repository-level observability access, quality scorecards, technical-debt ledgers, golden principles, cleanup loops, and agent-legible repository design. Do not use as the primary skill for Pagoda Outcome Contracts, EDD harness execution, scenario oracles, or Workbench-owned evidence traces."
---

# Agent Harness Engineering

Use this skill to make a repository legible, governable, observable, validated, and maintainable for coding agents.

This skill owns the repository operating layer for agents. It does not replace domain architecture, runtime engineering, realtime-agent design, SDK release workflows, or Pagoda evidence harnesses.

## Precedence and Pairing

- Global posture: `ThePetitbonDoctrine`.
- Domain ownership and architecture: `ddd-eda-architecture`.
- Node folder structure: `nodejs-microservice-structure`.
- Node runtime quality and service-level observability implementation: `nodejs-microservice-best-practices`.
- Realtime voice agents: `realtime-agent-design`.
- SDK release workflows: `sdk-release-and-consumer-bump`.
- Pagoda E2E outcome proof: `pagoda-framework`.

Use this skill when the task involves repository guidance, agent instructions, docs topology, execution plans, validation loops, quality scoring, cleanup, custom lints, structural tests, or making application behavior directly inspectable by Codex.

Do not use this skill to change Pagoda Outcome Contracts, Evidence Contracts, Trace Contracts, Scenario Oracles, simulation-ai harness logic, EDD registry semantics, or Workbench/platform isolation unless the task also touches repository-level agent operations.

## Core Rule

Give agents a map, not a giant manual.

Repository-local knowledge is the system of record. Anything a coding agent must know to preserve correctness, architecture, safety, quality, or validation should be discoverable in the repository.

## AGENTS.md as Map

`AGENTS.md` should be short and stable. It should point to deeper source-of-truth files rather than duplicate them.

Recommended responsibilities:

- identify repo purpose;
- identify common commands;
- point to architecture docs;
- point to validation docs;
- point to quality/debt docs;
- point to plans and active work;
- point to relevant skill-specific docs;
- state high-risk constraints and escalation conditions.

Avoid:

- long duplicated manuals;
- stale lists of rules with no owner;
- copied architecture detail;
- copied API docs;
- broad generic advice that belongs in skills;
- instructions that cannot be mechanically verified.

## Repository Knowledge as System of Record

Critical knowledge should live in versioned files such as:

- `AGENTS.md`;
- architecture indexes;
- validation registries;
- quality scorecards;
- technical-debt ledgers;
- golden principles;
- cleanup loop docs;
- execution plans;
- contracts, schemas, tests, harnesses, lints, and CI checks.

When a task reveals missing repository knowledge, update the relevant source of truth rather than relying on chat context.

## Agent Legibility

Optimize for future agents being able to answer:

1. What is this repo for?
2. What commands validate it?
3. What architecture boundaries matter?
4. What source of truth owns the rule I am about to touch?
5. What docs are canonical?
6. What tests, lints, harnesses, or observability signals prove the change?
7. What known debt or quality gap must not be worsened?
8. What cleanup principle applies?

Prefer boring, explicit, navigable structures over clever local abstractions.

## Promotion Path

Recurring guidance should be promoted:

- review comment or human preference;
- documented principle;
- validation checklist;
- test, lint, schema, harness, or CI gate where practical;
- cleanup check or quality-score item.

Do not leave repeated correctness, security, boundary, data-shape, naming, or validation rules as prompt-only guidance.

## Mechanical Enforcement

When a rule matters, prefer mechanical enforcement.

Architecture and structure skills define the domain, boundary, dependency, and folder rules. This skill owns the repository-level validation registry, discoverability, backlog tracking, and cross-repo agent operating layer for those checks.

Candidate mechanisms:

- custom lint rules;
- dependency-boundary checks;
- structural tests;
- schema validation;
- type-level constraints;
- docs freshness checks;
- validation command registry checks;
- file-size or naming checks;
- test harness assertions;
- CI gates for high-risk behavior.

Lint and test failure messages should tell a coding agent how to fix the violation.

A good remediation message includes:

1. violated rule;
2. why it matters;
3. allowed target shape;
4. forbidden shape;
5. exact next step or doc link.

## Repository-Level Observability Access

This skill owns repository-level observability access, documentation, checklists, and validation loops for agents.

It does not own service implementation of logs, metrics, traces, readiness, or runtime evidence. Service implementation belongs to `nodejs-microservice-best-practices`.

For substantial runtime or UI work, make behavior observable to agents through:

- deterministic local startup docs;
- health/readiness command references;
- stable log/trace access instructions;
- correlation-id documentation;
- replay fixture documentation;
- screenshot, DOM, or trace artifact instructions for UI work;
- before/after evidence expectations for bug fixes.

Do not claim runtime validation unless commands were run or evidence was inspected.

## Plans as First-Class Artifacts

Use lightweight plans for small changes and repository-local execution plans for complex work.

A substantial plan should include:

- goal;
- non-goals;
- touched areas;
- acceptance criteria;
- validation commands;
- decision log;
- progress log;
- blockers;
- cleanup/debt entries.

## Quality Scorecard

Maintain quality as a visible repository artifact.

Track, where relevant:

- docs freshness;
- architecture boundary enforcement;
- validation coverage;
- local bootability;
- observability legibility;
- test reliability;
- known debt;
- repeated agent mistakes;
- cleanup backlog;
- high-risk areas without mechanical gates.

The scorecard is a navigation surface for agents and humans.

## Cleanup / Garbage Collection

Agent-generated codebases accumulate drift because agents copy local patterns.

Use recurring cleanup tasks to scan for:

- duplicated rules;
- stale docs;
- missing validation commands;
- boundary violations;
- naming drift;
- untested critical behavior;
- quality-score regressions;
- tech-debt entries that have become actionable;
- prompt-only rules that should become mechanical checks.

Cleanup changes should be small, targeted, and behavior-preserving unless explicitly scoped otherwise.

## Boundary with Pagoda

Pagoda is the independent E2E outcome-proof harness.

`pagoda-framework` owns:

- Outcome Contracts;
- Evidence Contracts;
- Fixture Contracts;
- Trace Contracts;
- Scenario Oracles;
- EDD registry interpretation;
- simulation-ai harness behavior;
- evidence traces;
- channel parity;
- Workbench/platform isolation;
- PASS / FAIL / SETUP_FAILED / OBSERVABILITY_FAILED / SCENARIO_INVALID semantics.

This skill owns the repository operating system for coding agents. Do not move Pagoda responsibilities into this skill, and do not move this skill's general repository governance into Pagoda.

## Review Output

For repository-harness reviews, report:

1. current repository legibility;
2. stale or missing source-of-truth docs;
3. AGENTS.md size/scope issues;
4. validation command gaps;
5. mechanical enforcement opportunities;
6. observability access gaps;
7. quality-score or tech-debt updates;
8. cleanup PR recommendations;
9. exact files to create or update.

## Definition of Done

The repository has a small map, discoverable source-of-truth docs, clear validation entrypoints, mechanical enforcement for important rules where practical, visible quality/debt tracking, and cleanup loops that prevent agent-generated drift from compounding.
