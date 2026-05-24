# Skills index

> **Purpose.** One-stop lookup for every reusable skill playbook in this project. Read this file before opening individual skill files; it tells you what exists and when to reach for it.
>
> **How to use.** Scan the §2 Skills Table for a matching skill -> open only the file it points to -> follow the steps inside.

---

## 1. How to Maintain This Index

### Index drift rule

Only check the skill directory for index drift when the task adds, deletes, renames, or modifies files under `.agent/skills/`, or when a missing skill is suspected.

1. List every `.md` file present in `.agent/skills/` (excluding this `index.md`).
2. Compare against the **§2 Skills Table** below.
3. For each `.md` file that is **not yet in the table**, read only its frontmatter and first heading, then add a row automatically in implementation mode.
4. In review/read-only mode, report missing rows instead of editing.

Do not scan every skill file at session start. The table is the routing layer; individual skill files are opened only when relevant.

### When adding a row

Fill all columns. Use kebab-case tags. Pull the description from the skill file's opening sentence (the "when to use" line).

Row format:

```
| [Skill Name](filename.md) | `tag1`, `tag2` | One sentence: when an agent should reach for this skill. | YYYY-MM-DD |
```

### When updating a row

- If a skill file is renamed, update its link in this table in the same change.
- If a skill is deleted, remove its row and append a struck-through note: `~~skill-name~~ — removed YYYY-MM-DD`.
- If the procedure inside a skill changes significantly, bump `Last Verified` to today.

### What NOT to index here

- Files that are templates (those live in `.agent/templates/`).
- Partial drafts — only index a skill that has at least a `## Steps` section filled in.

---

## 2. Skills Table

| Skill | Tags | When to use | Last Verified |
| ----- | ---- | ----------- | ------------- |
| [Bootstrap CLI Pointer Files](bootstrap-cli-pointers.md) | `setup`, `onboarding`, `cli`, `pointer-files` | User wants every AI CLI (Claude Code, Codex, Gemini, Cursor, Windsurf, Copilot, Aider, …) to auto-read `BRAIN.md` at session start — create or safely inject pointer files. | 2026-05-22 |
| [Structure Validate](structure-validate.md) | `structure-check`, `validation`, `index-drift`, `maintenance` | Check Agent-SWI structural consistency or suspected index drift; run the validator and act on each violation by work mode. | 2026-05-24 |

---

_Last updated: 2026-05-24_
