---
name: repo-agent-governance
description: "Use for repository-local agent governance: AGENTS.md as a map, docs as system of record, execution plans, validation registries, mechanical checks, custom lints, structural tests, local worktree bootability, repository-level observability access, quality scorecards, technical-debt ledgers, cleanup loops, skill inventory hygiene, and agent-legible repository design. Do not use as the primary skill for domain rules, Pagoda outcome proof, Node runtime implementation, or booking workflow design."
---

# Repo Agent Governance

Use this skill to make a repository legible, governable, observable, validated, and maintainable for coding agents.

This skill owns the repository operating layer for agents. It does not replace domain architecture, runtime engineering, realtime-agent design, SDK release workflows, booking workflow architecture, or Pagoda outcome proof.

## Scope

Use this skill when the task involves:

- `AGENTS.md` design;
- docs topology;
- source-of-truth discovery;
- execution plans;
- validation registries;
- quality scorecards;
- cleanup loops;
- technical-debt ledgers;
- custom lints;
- structural tests;
- repository-local observability access;
- making application behavior inspectable by Codex;
- converting repeated agent guidance into reusable workflow infrastructure.

Do not use this skill as the primary owner of the domain rule. Use it to make the rule discoverable, enforceable, and visible to future agents.

## Core Rule

Give agents a map, not a giant manual.

Repository-local knowledge is the system of record. Anything a coding agent must know to preserve correctness, architecture, safety, quality, or validation should be discoverable in the repository.

## AGENTS.md As Map

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

## Repository Knowledge As System Of Record

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

## Agentic Workflow Systematization

When a task pattern repeats, convert it from ad hoc prompting into reusable workflow infrastructure.

Promotion path:

1. one-off prompt or review comment;
2. documented workflow note;
3. skill, reference, checklist, repo-local command, or runbook;
4. mechanical validation, lint, schema, harness, or CI gate where practical.

Use skills for repeatable procedural context that agents need across tasks:

- team standards;
- repo conventions;
- validation paths;
- review routines;
- release flows;
- evidence requirements;
- recurring investigation patterns;
- safety and authority rules.

Do not use skills as dumping grounds for broad manuals. A good skill makes a repeated delegation safer, faster, and more consistent.

## Delegation Sizing

Before large tasks, classify the delegation size:

- **small**: local edit or focused review;
- **medium**: multi-file change with clear validation;
- **large**: architecture, cross-service, release, migration, harness, or workflow change;
- **frontier**: ambiguous, high-risk, long-running, or multi-agent work.

Large and frontier tasks require:

- plan;
- non-goals;
- touched areas;
- validation commands;
- progress checkpoints;
- reviewable evidence before completion is claimed.

The first prompt in a long-running agent thread should define the broad outcome, constraints, ownership boundaries, and evidence expectations. Later turns should narrow, review, correct, or integrate.

## Parallel Agent Work

Parallel agent work is useful only when workstreams are independent and reviewable.

Before splitting work across agents, define:

- independent workstream boundaries;
- shared files or contracts that must not be edited concurrently;
- merge/integration owner;
- validation required per workstream;
- final integration validation;
- conflict resolution rule.

Do not parallelize work that shares one invariant, one transaction boundary, one state machine, or one fragile contract unless a human explicitly assigns an integration plan.

## Mechanical Enforcement

When a rule matters, prefer mechanical enforcement.

Architecture and structure skills define domain, boundary, dependency, and folder rules. This skill owns repository-level validation registry placement, discoverability, backlog tracking, and cross-repo agent operating layer for those checks.

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

A good remediation message includes:

1. violated rule;
2. why it matters;
3. allowed target shape;
4. forbidden shape;
5. exact next step or doc link.

## Repository-Level Observability Access

This skill owns repository-level observability access, documentation, checklists, and validation loops for agents.

It does not own service implementation of logs, metrics, traces, readiness, or runtime evidence. Service implementation belongs to `nodejs-service-runtime`.

For substantial runtime or UI work, make behavior observable to agents through:

- deterministic local startup docs;
- health/readiness command references;
- stable log/trace access instructions;
- correlation-id documentation;
- replay fixture documentation;
- screenshot, DOM, or trace artifact instructions for UI work;
- before/after evidence expectations for bug fixes.

Do not claim runtime validation unless commands were run or evidence was inspected.

## Plans As First-Class Artifacts

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

## Skill Inventory Hygiene

Periodically review skills for:

- overlapping routing descriptions;
- stale procedural guidance;
- repeated instructions that should be references;
- missing validation commands;
- skills that are too broad to invoke reliably;
- high-value recurring workflows that are still prompt-only;
- instructions that should become repo-local checks.

Prefer fewer, sharper skills over many overlapping manuals.

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

## Boundary With Pagoda

`pagoda-framework` owns outcome proof: contracts, traces, scenario oracles, evidence-scenario registry interpretation, simulation harness behavior, channel parity, Workbench/platform isolation, and run classification.

This skill owns the repository operating layer for coding agents.

## Review Output

For repository-governance reviews, report:

1. current repository legibility;
2. stale or missing source-of-truth docs;
3. `AGENTS.md` size/scope issues;
4. validation command gaps;
5. mechanical enforcement opportunities;
6. observability access gaps;
7. quality-score or tech-debt updates;
8. cleanup PR recommendations;
9. exact files to create or update.

## Definition of Done

The repository has a small map, discoverable source-of-truth docs, clear validation entrypoints, mechanical enforcement for important rules where practical, visible quality/debt tracking, and cleanup loops that prevent agent-generated drift from compounding.
