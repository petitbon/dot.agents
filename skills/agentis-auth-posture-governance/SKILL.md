---
name: agentis-auth-posture-governance
description: "Use as the primary skill for Agentis authentication and authorization posture audits, architecture reviews, service-auth drift checks, or changes involving API Gateway user auth, Cloud Run IAM service authenticity, runtime service accounts, service allowlists, inbound service-token verification, x-serverless-authorization, Firebase custom-claims bootstrap, or authz SDK role/resource enforcement. Use repo-agent-governance when the primary artifact is only repository validation plumbing."
---

# Agentis Auth Posture Governance

Use this skill to review or change Agentis auth posture across services,
infrastructure, contracts, docs, and audit checks.

Pair with `agentis-realtime-authority-layer` when a realtime authority change
touches trusted context injection, external user context, internal
service-to-service posture, or domain authorization boundaries. Auth posture
owns provenance and authz posture; realtime authority owns capability
admission, resolver routing, finalization, and evidence policy.

## First Reads

Load these before making findings or edits:

- `docs/architecture/authentication-authorization-posture.md`
- `docs/audit/codex-audit-brief.md` when the task is an audit or cross-repo review
- `references/flat-internal-trust-posture.md` when details beyond the root doc are needed
- the relevant service `README.md`, `AGENTS.md`, deploy workflow, and auth source files
- `agentis-scripts-local/scripts/validate-service-auth-posture.ts`

## Core Thesis

Infrastructure proves caller provenance. Services authorize actions.

External user authentication is owned by API Gateway. Internal service
authenticity is owned by private Cloud Run ingress and runtime IAM. Application
services consume trusted context and enforce domain/resource authorization with
`@agentis-studio/agentis-authz-sdk` and local scope checks.

## Target Posture

- Trust API Gateway `x-apigateway-api-userinfo` as the user claim source for
  gateway-authenticated user traffic.
- Treat `x-serverless-authorization` as Cloud Run transport plumbing, not an
  application authorization signal.
- Do not reintroduce app-level service allowlists, inbound service identity
  token verification, Google cert fetching for service auth, or
  `x-agentis-service-authorization`.
- Keep services agnostic to caller provenance such as "API Gateway" vs
  "Cloud Run service" unless an explicit public webhook boundary requires
  transport-specific validation.
- Preserve local authorization: required business/location/client/session
  scope, role-policy checks, explicit confirmation evidence, target-resource
  verification, and domain invariants still fail closed.

## Review Workflow

1. Classify the surface as external user, internal service-to-service, public
   webhook, event consumer, Firebase custom-claims bootstrap, or Firestore
   rules.
2. Compare implementation, workflows, infra, docs, and surface registry notes
   against the root auth posture doc.
3. Flag stale docs as defects when they require allowlists or inbound service
   token verification.
4. Flag service code as drift when it verifies inbound service identity tokens,
   reads `x-agentis-service-authorization`, treats `x-serverless-authorization`
   as app identity, or fetches Google certs for service auth.
5. Run or update `validate-service-auth-posture` so the posture is mechanically
   protected.

## Audit Output

Report findings as one of:

- **Posture drift**: implementation or infra violates the target posture.
- **Documentation drift**: contracts, registry notes, runbooks, or audit briefs
  still describe the retired allowlist/service-token model.
- **Validation gap**: the target posture is documented but not mechanically
  checked.
- **Domain authorization issue**: provenance is correct, but role/resource
  authorization, scope validation, or fail-close behavior is weak.

Do not recommend allowlists or inbound service-token verification as the fix
unless the root auth posture doc has been intentionally changed first.
