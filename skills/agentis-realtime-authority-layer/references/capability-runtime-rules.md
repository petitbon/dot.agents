# Capability Runtime Rules

Use this reference when changing operation classification, capability metadata,
Authority Runtime admission, resolver dispatch, or structured results.

## Operation Classes

- `RUNTIME_CONTROL`: ephemeral channel command without domain finalization.
- `QUERY`: backend-authority read with structured results and optional evidence.
- `DIRECT_COMMAND`: non-mutation command requiring authority execution and
  finalization.
- `GOVERNED_MUTATION`: side effect requiring operation identity, idempotency,
  preconditions, confirmation where applicable, finalization, and evidence.

Do not impose mutation overhead on runtime control or treat mutations as reads.

## Capability Manifest

Define or derive:

- operation/tool name, kind, workflow phase, and channels;
- resolver key, primary authority, and required authority components;
- trusted identity, proposal, confirmation, and business-scope requirements;
- closed model argument schema and server-injected fields;
- finalization and user-visible success policy;
- grounding, fact policy, and evidence scenario;
- idempotency and stale-state rules for writes.

## Authority Runtime

The runtime must:

1. reject undeclared or channel-disallowed tools;
2. validate arguments strictly and reject unknown fields;
3. strip or reject model-supplied trusted fields;
4. inject server-owned context;
5. enforce requirements, authorization, and workflow preconditions;
6. bind operation and idempotency identity for governed mutations;
7. dispatch only to the declared resolver;
8. enforce finalization before user-visible success;
9. append required local evidence/outbox records;
10. return structured success, pending, rejected, conflict, expired, or failed
    results.

Prefer an in-process shared runtime/SDK on the hot path unless a network
boundary is explicitly justified by runtime isolation or centralized
enforcement requirements.
