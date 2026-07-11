# Skill Validation

Run validation from the repository root:

```sh
./scripts/validate-skills.sh
```

When changing the validator or a mechanically enforced semantic guard, run its
temporary-fixture regression suite first:

```sh
./scripts/test-validate-skills.sh
```

The script verifies:

- every `skills/<skill>/` directory has `SKILL.md` and `agents/openai.yaml`;
- frontmatter is delimited, has a non-empty description, and its `name:` matches
  the skill directory name;
- interface metadata has non-empty display, description, and default-prompt
  fields, and the prompt references the correct skill token;
- skill descriptions are long enough to route reliably but stay within the
  repository budget;
- `SKILL.md` files stay compact enough that detailed manuals belong in
  `references/`;
- bundled `references/...` paths mentioned by a skill exist;
- generated `.codesight/`, `.codegraph/`, and `.DS_Store` files are not tracked;
- the SDK release skill and SDK repository guidance do not allow or present
  local publishing; publishing stays owned by declared GitHub Actions workflows;
- every Agentis skill opts into implicit invocation so all skill metadata is
  exposed in the default model context;
- proportional-design, SDK release integrity, booking/Scheduling routing,
  source-precedence, realtime current-state, prompt-channel, and Mermaid-render
  rules do not regress;
- local README inventory is complete;
- when the repository is inside the Agentis aggregator, root `AGENTS.md` and
  `skills-routing.md` contain every skill in their owned routing sections;
- stale skill names such as retired Pagoda aliases are not referenced;
- rule/evidence and checkpoint governance docs exist and reference the skill
  validation command;
- secondary harness docs defer to `AGENTS.md` and do not duplicate stale skill
  inventories.

Manual review still matters for semantic changes outside the targeted hard
guards. For skill content edits, confirm that routing remains precise, broad
skills do not over-trigger, and domain-specific invariants still live in the
owning skill or reference.

For durable agent-harness guarantees, update `rule-evidence-registry.md` so the
rule has an owner, source, evidence path, and enforcement level. For large or
interruptible tasks, use `task-checkpoint-template.md` or the closest
child-repo equivalent.
