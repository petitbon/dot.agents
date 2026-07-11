---
name: repo-agent-governance
description: "Use as the primary skill for repository-local agent governance when those artifacts are directly affected: AGENTS.md as a map, docs as system of record, execution plans, validation registries, mechanical checks, custom lints, structural tests, local worktree bootability, repository-level observability access, quality scorecards, technical-debt ledgers, cleanup loops, skill inventory hygiene, and agent-legible repository design. Do not use as the primary skill for domain rules, Pagoda outcome proof, Node runtime implementation, or booking workflow design."
---

# Repo Agent Governance

Make a repository legible, governable, observable, validated, and maintainable
for coding agents.

## Routing

Use this skill when the repository operating layer is the primary artifact:
`AGENTS.md`, docs topology, source discovery, plans, validation registries,
mechanical check placement, observability access, quality/debt tracking,
cleanup loops, or skill hygiene.

Do not use it as the primary owner of domain rules, runtime implementation,
realtime behavior, SDK releases, booking workflows, or Pagoda outcome proof.
Use it to make an owning skill's rule discoverable, enforceable, and visible.

For realtime authority governance, take the rule from
`agentis-realtime-authority-layer`; this skill owns check placement and
discoverability only.

## Reference Loading

- Load `references/delegation-and-workflow-systematization.md` for delegation
  sizing, checkpoints, repeatable workflows, and parallel-work boundaries.
- Load `references/observability-quality-and-cleanup.md` for repository-level
  observability access, plans, quality/debt visibility, and cleanup loops.

## Core Rule

Give agents a map, not a giant manual. Keep critical knowledge in versioned,
discoverable repository files and encode important recurring rules in tests,
schemas, lints, harnesses, or CI where practical.

## AGENTS.md As Map

Keep `AGENTS.md` short and stable. It should identify repository purpose,
commands, canonical docs, validation, quality/debt sources, relevant skills,
high-risk constraints, and escalation points.

Do not duplicate architecture, APIs, manuals, or broad generic advice. Point to
the owning source instead.

## Agent Legibility

A future agent should answer:

1. What is this repository for?
2. Which commands validate it?
3. Which architecture and ownership rules matter?
4. Which source owns the rule being changed?
5. Which docs are canonical?
6. Which tests, lints, harnesses, or observations prove behavior?
7. Which known debt or cleanup rule applies?

Prefer explicit, navigable structures over clever local conventions.

## Mechanical Enforcement

When a rule matters, prefer the smallest practical hard check: schema
validation, type constraint, structural test, custom lint, dependency rule,
docs freshness check, harness assertion, or CI gate.

Architecture, runtime, and structure skills define their owned rules. This
skill owns repository placement, registry visibility, and backlog tracking for
the check.

Every remediation message should state the violated rule, why it matters,
allowed shape, forbidden shape, and exact next step or source link.

## Skill Inventory Hygiene

Review skills for overlapping routing, stale procedures, duplicated manuals,
missing validation, excessive breadth, prompt-only recurring workflows, and
rules that should become repository checks. Prefer fewer, sharper skills.

## Rule Evidence Registry

When adding or changing a durable governance rule, update
`docs/rule-evidence-registry.md` or the repository equivalent with owner,
source, evidence command/artifact, and enforcement level.

## Boundary With Pagoda

`pagoda` owns outcome contracts, traces, scenario oracles, evidence translation,
channel parity, Workbench isolation, and run classification. This skill owns
the coding-agent operating layer around those artifacts.

## Review Output

Report repository legibility, stale/missing sources, `AGENTS.md` scope,
validation gaps, enforcement opportunities, observability access, quality/debt
updates, cleanup recommendations, and exact files to change.

## Definition Of Done

The repository has a compact map, discoverable sources, clear validation,
mechanical enforcement for important rules, visible quality/debt tracking, and
cleanup loops that prevent agent-generated drift from compounding.
