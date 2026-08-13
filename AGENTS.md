# Agent Guide - Agentis Skills

This repository owns reusable Agentis Codex skills. It is a standalone git
repository under the `/Users/jlp/agentis` aggregator workspace.

## Repository Purpose

- `skills/<skill>/SKILL.md` is the skill entrypoint and routing surface.
- `skills/<skill>/references/` holds deeper task-specific guidance.
- `skills/<skill>/agents/openai.yaml` holds display metadata and invocation
  policy.
- `scripts/validate-skills.sh` is the local validation entrypoint.

Do not treat this repository as an application, package workspace, or generated
source map.

## Skill Authoring Rules

- Keep `SKILL.md` as a compact routing file with core invariants.
- Move detailed manuals, examples, and long checklists into `references/`.
- Use exactly one primary skill for a task. Pair skills only when the task
  directly changes artifacts owned by the paired skill.
- Every Agentis skill is exposed for implicit invocation so its routing metadata
  is available in the default model context.
- Keep every routing description precise. Broad governance, architecture,
  runtime, structure, and doctrine skills must state when they are primary and
  identify narrower skills that take precedence.
- Keep each description within 350 characters, the implicit description catalog
  within 4,000 characters, router entrypoints within their byte budgets, and
  declared phase context within the validator budget.
- Every referenced `references/...` file must exist.

## Safety Rules

- Never allow local SDK publishing. Agentis SDK publishing is owned by GitHub
  Actions.
- Do not commit generated analysis output or local CodeGraph data.
- Do not commit `.DS_Store`, dependency folders, caches, or local secrets.
- Model-specific prompt guidance must point to current official docs or owning
  runtime contracts when model behavior could have changed.

## Validation

Run:

```sh
./scripts/validate-skills.sh
```

When changing `scripts/validate-skills.sh` or one of its semantic guards, also
run:

```sh
./scripts/test-validate-skills.sh
```

Before claiming a skill cleanup is complete, report the validation command and
result. For meaningful changes, include an evidence report that maps each rule
or finding to a file or command result.
