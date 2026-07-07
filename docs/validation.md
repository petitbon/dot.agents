# Skill Validation

Run validation from the repository root:

```sh
./scripts/validate-skills.sh
```

The script verifies:

- every `skills/<skill>/` directory has `SKILL.md` and `agents/openai.yaml`;
- frontmatter `name:` matches the skill directory name;
- skill descriptions are long enough to route reliably but stay within the
  repository budget;
- `SKILL.md` files stay compact enough that detailed manuals belong in
  `references/`;
- `references/...` paths mentioned by a skill exist;
- generated `.codesight/`, `.codegraph/`, and `.DS_Store` files are not tracked;
- the SDK release skill does not allow local publishing;
- implicit invocation policy matches the repository allowlist;
- stale skill names such as retired Pagoda aliases are not referenced;
- rule/evidence and checkpoint governance docs exist and reference the skill
  validation command;
- secondary harness docs defer to `AGENTS.md` and do not duplicate stale skill
  inventories.

Manual review still matters for semantic changes. For skill content edits,
confirm that routing remains precise, broad skills do not over-trigger, and
domain-specific invariants still live in the owning skill or reference.

For durable agent-harness guarantees, update `rule-evidence-registry.md` so the
rule has an owner, source, evidence path, and enforcement level. For large or
interruptible tasks, use `task-checkpoint-template.md` or the closest
child-repo equivalent.
