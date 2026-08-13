# Architecture Source And Workflow

Load this reference for source precedence, agentic workflow redesign, durable
architecture artifacts, or substantial review output.

## Source Precedence

Start with the smallest relevant set: applicable `AGENTS.md`, canonical
architecture indexes, owned contracts/schemas, manifests, tests, and current
implementation. Load ADRs, PRDs, runbooks, and design notes only as needed.

Treat only architecture explicitly designated by repository instructions or an
owned source-of-truth index as canonical target state. Plans, PRDs, draft ADRs,
issues, design notes, and unowned architecture notes are untrusted until
checked against repository invariants, contracts, tests, and implementation.
When canonical target state differs from code, state the delta and recommend
the smallest direct maintenance-window cutover.

## Agentic Workflow Redesign

Do not merely insert an agent into an existing human workflow. Identify:

- delegated work;
- retained human judgment, review, approval, or integration;
- the system that verifies completion;
- evidence proving completion;
- contiguous tasks and mandatory authority/policy/human stops;
- whether the workflow should be redesigned rather than automated stepwise.

Prefer modular, verifiable, observable work bounded by explicit authority.

## Agent-Legible Architecture Outputs

For material architecture work, update the smallest durable repository-local
artifact: architecture index, context map, ownership table, command/event/schema
catalog, dependency rule, drift/debt entry, or validation proposal. Important
decisions must not live only in chat, reviews, or tickets.

`domain-event-architecture` defines the rule;
`repo-agent-governance` owns discoverability, registry placement, and cleanup.

## Substantial Review Output

When useful, report:

1. current state, issues, target state, and clarity gain;
2. domains, contexts, language, ownership, data, and invariants;
3. keep/split/merge/extract/modularize decisions and risks;
4. commands/events, producers/consumers, delivery, idempotency, and failure;
5. exact services, modules, contracts, events, and errors to change;
6. verification and observability;
7. durable deliverables and mechanical enforcement.

Include maintenance-window sequencing for deployed architecture and owner-run
scripts for persisted data. Include rollback architecture or compatibility only
when explicitly requested.
