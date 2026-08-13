# Modeling And Coupling Review

Load this reference for DDD/EDA modeling, interaction-mode decisions, required
architecture questions, or coupling review.

## DDD Checklist

Identify core/supporting/generic domains, bounded contexts, entities, value
objects, aggregates, domain/application services, owned data, write ownership,
invariants, anti-corruption layers, and language gaps.

One context owns its rules, data, and contracts. Do not share writes or leak
transport, persistence, or provider DTOs into domain logic. Merge boundaries
that always change together and share invariants; split only when ownership and
change isolation improve.

## EDA Checklist

Distinguish command (intent), event (fact), and query (read). Prefer events when
immediate consistency is unnecessary and consumers tolerate eventual
consistency. Require an explicit event owner, business-language name, schema,
correlation/causation IDs, idempotent consumers, replay safety, and truthful
failure behavior. Add outbox, dedupe, retry/backoff, or DLQ only when materially
needed.

Use synchronous calls when an invariant must be enforced immediately or the
caller cannot proceed safely without a deterministic answer.

## Required Questions

1. Which bounded context owns the capability and data?
2. Which aggregate or invariant owns the rule?
3. Which command starts the change and which fact records it?
4. Which consumers react, with what consistency?
5. Is synchronous interaction currently required?
6. Would modularization be safer than extraction?
7. Does the result reduce cognitive load and move toward verified target state?

## Coupling Smells

Treat shared tables/writes, cycles, cross-context entity leakage, duplicated
rules, god services, controller orchestration, chatty APIs, long synchronous
chains, business rules in shared libraries, provider DTO leakage, and competing
execution models for one path as findings.
