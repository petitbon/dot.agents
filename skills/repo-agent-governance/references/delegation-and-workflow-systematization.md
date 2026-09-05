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

## Context And Handoffs

Keep one outcome per task. For long work, replace the existing checkpoint with
current goal, constraints, owners, decisions, repository/branch state, validation,
blockers, and next action. Link evidence; omit transcripts, copied source, and
superseded steps. Do not create checkpoints for routine edits or stop authorized
work just to start a new thread.

When resuming, read that checkpoint and verify changed facts before reopening
evidence. Recommend a fresh thread at a completed task boundary when the next
task is unrelated; do not carry the previous transcript into its handoff.

For tools, select relevant fields and source ranges before returning results.
Budget the combined batch, including each nested result. Keep complete logs in
temporary files and return status, failure locations, and the log path; inspect
more when needed. Reuse source and validation already obtained for unchanged
inputs. Preserve images as image content instead of serializing data URLs.

## Parallel Work

Parallelize only independent, reviewable workstreams. Define shared-file and
contract boundaries, integration owner, per-stream validation, final validation,
and conflict resolution before delegation.

When delegation is authorized, send only the objective, applicable constraints,
owner paths, and expected evidence. Fork full history only when those facts
cannot supply the necessary context; otherwise use no history or a bounded fork.

Do not parallelize work sharing one invariant, transaction, state machine, or
fragile contract unless the user explicitly assigns an integration plan.
