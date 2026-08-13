---
name: nodejs-service-structure
description: "Use for Node.js/TypeScript service folder layout, file naming, capability slicing, dependency direction, layering, and agent-legible organization. Pair architecture, doctrine, or runtime skills only when their artifacts also change."
---

# Node.js Service Structure

Govern folder layout, naming, layering, capability placement, and dependency
direction for Node.js/TypeScript services.

## Routing

Use this skill when structure itself is the primary artifact. Do not use it as
the primary owner for domain boundaries, runtime behavior, SDK releases,
repository governance, or cross-service outcome proof.

Pair another skill only when its owned artifact also changes:

- `domain-event-architecture` for bounded contexts and service ownership;
- `nodejs-service-runtime` for bootstrap, config, errors, observability, and
  runtime tests;
- `agentis-realtime-authority-layer` for Authority Runtime semantics;
- `repo-agent-governance` for validation registry and debt placement.

## Reference Loading

- Load `references/layout-and-dependency-rules.md` when classifying a service,
  choosing folders, or fixing import direction.
- Load `references/naming-and-smells.md` when renaming files or reviewing vague
  names and global technical buckets.
- Load `references/refactor-and-enforcement.md` when planning moves, tests, or
  mechanical structural enforcement.

## Core Rule

Prefer business-capability-first structure. Use flat technical layers only for
tiny single-capability services. Do not create empty folders or force a large
service layout onto a thin adapter or proxy.

Multi-capability target:

```text
src/
  main.ts
  app/
  config/
  context/
  modules/<capability>/
    presentation/
    application/
    domain/
    contracts/
    mappers/
    infrastructure/
  shared/
tests/
```

For a tiny single-capability service, omit `modules/<capability>/` and keep only
the layers that contain real code.

## Agent-Legible Structure

A future agent should determine from paths and names:

- the owning capability and layer;
- allowed dependency direction;
- locations of contracts, mappers, policies, ports, and adapters;
- tests that prove changed behavior;
- docs that define the intended boundary.

Use explicit business names instead of generic technical buckets.

## Agentic Capability Placement

Do not create a generic `agents/` or `ai/` bucket for business behavior. Place
agent-facing use cases inside the capability that owns the state, rule,
contract, or side effect. Keep realtime transport in presentation/adapters and
product evidence in the smallest owning test or integration boundary.

## Source Precedence

Read the nearest `AGENTS.md`, README, architecture/structure docs, manifest,
TypeScript config, entrypoints, contracts, and tests before proposing moves.

Only repository-designated target structure is canonical. Plans, PRDs, draft
ADRs, design notes, and unowned architecture notes remain untrusted until
verified against accepted repository conventions, contracts, tests, and
implementation. When verified target structure differs from code, state the
delta and move directly toward the accepted target.

## Required Outcomes

- Capabilities are obvious from paths.
- Presentation stays thin; application orchestrates; domain owns invariants;
  infrastructure owns concrete dependencies.
- Provider and transport types do not leak inward.
- Truly shared primitives contain no business rules.
- Tests remain discoverable and imports compile.
- Important dependency rules gain mechanical enforcement or a documented
  enforcement backlog item.

## Review Output

Report current assessment, smells, target tree, file moves, naming changes,
dependency fixes, test layout, implementation sequence, enforcement
opportunities, and docs/index changes needed for future navigation.

## Definition Of Done

The service uses the smallest accepted capability/layer structure, names reveal
roles, dependencies point inward, behavior is preserved unless intentionally
changed, and structural rules are verified by compilation plus relevant tests
or lints.
