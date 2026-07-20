# Maintenance-Window Cutovers

Use this reference when planning deployment of a code or architecture change.

## Cutover Plan

Structure deployment as a maintenance-window cutover to the current target
state. Identify:

- preconditions, required authority, and the exact deployment scope;
- deployment and execution order;
- any required write pause or traffic quiescence;
- cutover actions and explicit failure boundaries;
- validation and reopening criteria.

Do not use rolling compatibility, dual-read/write, migration-on-read, service
startup repair, or fallback behavior as a substitute for the cutover.

## Persisted Data

When persisted data must be removed, transformed, backfilled, reseeded, or
otherwise manipulated:

1. Add a bounded operational script under `agentis-scripts-local/scripts/`.
2. Follow that repository's nearest `AGENTS.md` and CLI conventions.
3. Preserve the owning domain's write boundary; orchestration may call
   owner-provided operations but must not take ownership of another service's
   data.
4. Fail closed on ambiguous environment, scope, authority, ownership, or target
   data.
5. Make the operation safely repeatable and default destructive actions to a
   dry run when practical.
6. Write only the current authoritative shape. Do not add a runtime
   compatibility reader, startup repair, or permanent alternate path.

Use a current-state action name such as `cutover-*`, `backfill-*`, or `reset-*`.
Remove the script when the cutover is complete and it is no longer an active
operational procedure.

## User Handoff

Give the user:

- the maintenance-window preconditions;
- the exact `yarn cli run --env <profile> <script-name> [args...]` command;
- the expected dry-run or preflight output when available;
- the execution order relative to service deployment;
- the exact post-run validation commands and reopening criteria;
- every skipped check, blocker, or manual step.
