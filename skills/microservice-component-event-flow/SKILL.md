---
name: microservice-component-event-flow
description: "Use for one microservice internal Mermaid flow: APIs/events, handlers, rules, storage, clients, and effects. Excludes sequences and system topology."
---

# Microservice Component & Event Flow Diagram

Create a service-centered Mermaid flowchart that explains how one microservice
works internally and communicates through APIs, events, persistence, and
outbound dependencies.

## Routing

Use this skill only when the requested artifact centers on one service's
internal component and event flow. Do not use it for broad system topology,
deployment or infrastructure diagrams, database schemas, pure sequence
diagrams, runtime traces, or generic code documentation without a diagram.

If runtime ordering is the primary artifact, use a Mermaid `sequenceDiagram`
without treating this skill as primary.

## Reference Loading

Load `references/mermaid-authoring-and-validation.md` when authoring the diagram.
It owns subgraph layout, Mermaid syntax, forbidden-path styling, the compact
template, and render validation.

## Core Rule

Show what enters the service, which components enforce business behavior, what
the service owns, and how it reaches persistence, external services, and
published events. Keep the service boundary explicit.

Do not invent APIs, events, dependencies, or ownership. Mark anything inferred
but unproven as inferred or uncertain.

## Inspection Method

1. Identify the service boundary and primary responsibility.
2. Find inbound routes, handlers, webhooks, RPCs, and event consumers.
3. Find application use cases, orchestration, policies, validators, and auth.
4. Find domain services, aggregates, entities, workflows, and state machines.
5. Find repositories, stores, transactions, outbound clients, and publishers.
6. Identify emitted events and their topics or queues.
7. Identify forbidden paths, especially direct writes into another owner's
   domain.
8. Use CodeGraph first when available, then verify exact details from source,
   contracts, and tests.

Avoid implementation noise such as every DTO, mapper, helper, logger, or config
constant unless it is architecturally important.

## Required Content

Use only the relevant sections from this logical flow:

```text
external caller/event
  -> inbound adapter and handler
  -> application use case
  -> business policy or workflow
  -> domain model or state machine
  -> repository, client, or publisher
  -> database, external authority, or published topic
```

Make ownership and forbidden paths visible when they affect behavior. Realtime
adapters, SDKs, and workflow layers may invoke owners but must not become the
source of another service's domain truth.

## Output

Unless the user requests another format, provide:

1. a short diagram title;
2. the Mermaid flowchart;
3. brief notes listing assumptions, inferred items, uncertain items, and
   missing evidence.

## Quality Bar

The diagram must answer quickly:

- What enters the service and which handlers receive it?
- Which use cases and domain rules matter?
- What state, data, and side effects does the service own?
- Which stores and external authorities does it use?
- Which events does it publish?
- Which paths are explicitly forbidden?

Render or parse the final Mermaid source before claiming completion. Report the
exact validation command and result; if no renderer is available, report the
missing prerequisite and next command without installing tooling automatically.

## Definition Of Done

The rendered flowchart is service-centered, source-backed, readable, and
ownership-explicit. It includes the architecturally meaningful inbound,
application, domain, persistence, outbound, and event paths without inventing
or overloading detail.
