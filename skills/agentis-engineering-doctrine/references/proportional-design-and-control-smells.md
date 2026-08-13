# Proportional Design And Control Smells

Load this reference for optimization, service-split, control-stack, or
fallback-success decisions.

## Design Bias

- Prefer composition over inheritance and abstractions at domain/application
  boundaries.
- Keep business rules near the owning domain concept.
- Avoid repeated hot-path work when an indexed design is clearer.
- Treat bugs as possible boundary, invariant, or state-model debt.
- Make unsafe states unrepresentable where practical.
- Prefer one path with explicit preconditions over arrival-history branches.
- Prefer deletion over abstraction when deletion preserves the invariant.

## Proportional Design And Optimization

A clean target state is the simplest end state satisfying current requirements,
ownership, invariants, and evidence needs. Unless explicitly requested, do not
add services, queues, caches, replicas, indexes, pipelines, frameworks,
abstraction layers, CQRS, event sourcing, sharding, read models, or distributed
coordination for speculative scale, reuse, extensibility, or growth.

Do not split reads and writes into separate microservices solely as a presumed
optimization. Keep them in the same owning service unless current evidence or
an explicit requirement proves independent ownership, scaling, deployment,
compliance, availability, or runtime isolation.

Optimization requires at least one concrete driver:

- an explicit user requirement;
- a measured bottleneck or profile;
- a defined SLO, capacity, latency, cost, or reliability constraint;
- a proven ownership, compliance, deployment, or runtime-isolation boundary.

When a driver exists, state it, compare the simpler and optimized designs, and
implement only the complexity needed. Optimization never permits violating
ownership, correctness, or fail-close invariants.

## Control-Stack Smell

Repeated suppression, sentinel state, timing windows, phrase matching,
duplicate filtering, cleanup branches, or special-case state can indicate that
the feature is wrong. Before adding containment, propose deletion, simpler
product behavior, a first-class shared contract, or redesign around the owning
authority/state machine.

Authentication, schema validation, authorization, confirmation, policy,
idempotency, and durable state machines are legitimate boundary controls. The
smell is code whose main purpose is keeping a feature from getting out of hand.

## No Fallback Success

Never fabricate successful business outcomes. Do not return fake availability,
treat failed writes as complete, swallow validation, guess identifiers or
business facts, convert dependency failure into empty success without a domain
rule, or write through a non-owner. Transport resilience is allowed only when
it does not mask a failed domain operation or invent facts.
