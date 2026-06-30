# Flat Internal Trust Posture

Use this reference for Agentis auth posture audits or implementation reviews.

## Target-State Matrix

| Surface | Authenticity Owner | Application Responsibility |
| --- | --- | --- |
| Browser/operator API calls | API Gateway Firebase JWT policy | Consume trusted gateway claims; enforce role/resource authorization |
| Internal service-to-service calls | Private Cloud Run ingress and runtime IAM | Validate required domain scope, correlation, and command preconditions |
| Public webhooks | Webhook-specific transport validation and ingress policy | Bind to internal runtime state; reject ambiguous or unauthorized actions |
| Event consumers | Pub/Sub/Eventarc delivery and runtime IAM | Validate event contract, idempotency, ownership, and replay policy |
| Firebase custom-claims bootstrap | API Gateway user auth plus Salon Config runtime IAM | Recompute and write authorized custom claims; runtime SA needs Firebase Auth admin |
| Firestore direct reads | Firebase Auth custom claims and Firestore rules | Keep claims fresh and scoped; do not bypass owning backend contracts |

## Allowed Header Use

- `x-apigateway-api-userinfo`: trusted user claims when API Gateway supplied it.
- `x-serverless-authorization`: Cloud Run transport credential for private
  service invocation. Outbound clients may send it. Inbound app code must not
  treat it as role, tenant, user, service, or authorization evidence.
- `Authorization`: user bearer token at API Gateway or local/dev test harnesses.
  It is not the internal service-auth contract.

## Forbidden App-Level Patterns

- Service-principal allowlists such as `*_ALLOWED_SERVICE_PRINCIPALS`.
- Inbound service-token verification for application authorization.
- Google cert fetching for service-to-service app auth.
- `x-agentis-service-authorization`.
- `x-forwarded-authorization` as a service auth or principal-building surface.
- Audit findings that require services to prove whether the caller was API
  Gateway or another Cloud Run service.

## Required Authorization That Remains

Flat internal trust does not permit arbitrary business actions. Services must
still fail closed on:

- missing or malformed user claims for user-scoped routes;
- missing business, location, client, session, appointment, or correlation
  scope required by a command;
- role-policy denial from `@agentis-studio/agentis-authz-sdk`;
- target resource outside the requested business/location/client scope;
- missing explicit confirmation evidence for governed writes;
- stale workflow state, conflicted proposals, duplicate side effects, or
  unsupported domain transitions.

## Audit Checklist

1. Read `docs/architecture/authentication-authorization-posture.md`.
2. Check service README/AGENTS auth sections match the target posture.
3. Check deploy workflows use runtime service accounts and do not wire retired
   service-auth env vars.
4. Check source does not verify inbound service tokens or read retired headers.
5. Check outbound private calls use `x-serverless-authorization` only as
   transport plumbing.
6. Check contracts and surface registry notes do not say internal calls require
   allowlisted or verified service principals.
7. Check `agentis-scripts-local` validation catches any drift found.
8. Separate provenance drift from domain authorization bugs in findings.

## Common False Positives

- **"Missing allowlist"**: not a finding under the current posture. Verify
  private Cloud Run ingress, runtime IAM, and domain authorization instead.
- **"Missing inbound service token verification"**: not a finding under the
  current posture. Verify services do not use token claims as app identity.
- **"`x-serverless-authorization` is present"**: acceptable on outbound private
  Cloud Run calls; it is forbidden only as inbound application authorization.
- **"Services accept internal callers without identifying caller service"**:
  expected. Caller provenance belongs to infrastructure.
- **"Gateway user claims are trusted"**: expected for API Gateway-authenticated
  routes. The app still must enforce role/resource authorization.
