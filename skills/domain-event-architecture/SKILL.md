---
name: domain-event-architecture
description: "Use for domain/event boundaries, ownership, commands, contracts, and cross-service flows. Live-tool authority and booking state use narrower skills."
---

# Domain + Event Architecture

Use Domain-Driven Design and Event-Driven Architecture to clarify ownership,
invariants, contracts, coupling, and operability.

## Scope

This skill owns bounded contexts, data/write ownership, APIs, commands, events,
workflows, contracts, context maps, and target-state architecture. Pair another
skill only when its owned artifact also changes.

## Routing

- Use `booking-workflow-architecture` for Agentis booking proposal identity,
  confirmation, commit, recovery, and appointment side effects.
- Use agentis-realtime-authority-layer when the primary concern is the
  realtime tool/authority ontology across registries, adapters, resolvers, and
  domain authorities.
- Use this skill for broader service ownership, commands/events, contracts, or
  cross-service coupling around those narrower workflows.
- Use `repo-agent-governance` for repository placement and mechanical
  enforcement of an architecture rule.

## Reference Loading

- Load `references/architecture-source-and-workflow.md` when establishing source
  precedence, redesigning an agentic workflow, or producing durable
  architecture artifacts.
- Load `references/modeling-and-coupling-review.md` for DDD/EDA analysis,
  synchronous-versus-event decisions, required questions, and coupling smells.

## North Star

Improve ownership clarity, invariant enforcement, change isolation,
operability, contract quality, and cognitive load. Modularize immature
boundaries first; extract only for current ownership, deployment, scaling,
compliance, isolation, or materially different rates of change.

## Hard Rules

Never recommend or implement:

- fallback behavior that fabricates business success;
- permissive behavior when ownership, authority, data, or invariants are
  uncertain;
- guessed provider fields, inferred IDs, or undocumented contract semantics;
- undeclared public contracts or shared write ownership;
- direct writes bypassing the owning workflow or transaction;
- events used as RPC in disguise;
- orchestration hidden in controllers, routes, handlers, hooks, or adapters;
- provider-owned business truth when an internal context should own it;
- runtime migrations, startup repair, rollback architecture, compatibility
  shims, dual paths, or feature flags unless explicitly requested.

Transport resilience is valid only when it does not mask domain failure or
invent facts. Deployed architecture changes use the doctrine-owned
maintenance-window cutover; persisted-data work uses the owning
`agentis-scripts-local` command and post-run validation.

## Required Outcome

State the owning context, data, aggregate/invariant, command, fact/event,
consumers, consistency need, coupling change, and evidence. Prefer synchronous
interaction when the caller cannot proceed safely without an immediate
deterministic invariant decision; otherwise consider an owned event with
idempotent, replay-safe consumers.

## Definition Of Done

Boundaries are justified in domain terms; ownership is clearer; coupling is
reduced or explicit; commands, APIs, and events have contracts; critical paths
have evidence; and durable decisions are discoverable and mechanically
enforceable where practical.
