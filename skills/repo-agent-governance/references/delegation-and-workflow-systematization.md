# Delegation And Workflow Systematization

Use this reference for repeated agent workflows, delegation sizing, checkpoints,
or parallel-work design.

## Promotion Path

Convert repeated task guidance from:

1. prompt or review comment;
2. documented workflow note;
3. skill, reference, checklist, command, or runbook;
4. mechanical validation or CI gate where practical.

Use skills for repeatable procedural context across tasks, not as dumping
grounds for broad manuals.

## Delegation Size

- `small`: local edit or focused review;
- `medium`: multi-file change with clear validation;
- `large`: architecture, cross-service, release, migration, harness, or
  workflow change;
- `frontier`: ambiguous, high-risk, long-running, or multi-agent work.

Large/frontier tasks require an explicit outcome, non-goals, touched areas,
owners, validation, checkpoints, and reviewable evidence. Use
`docs/task-checkpoint-template.md` or the nearest equivalent for interruptible
work.

## Parallel Work

Parallelize only independent, reviewable workstreams. Define shared-file and
contract boundaries, integration owner, per-stream validation, final validation,
and conflict resolution before delegation.

Do not parallelize work sharing one invariant, transaction, state machine, or
fragile contract unless the user explicitly assigns an integration plan.
