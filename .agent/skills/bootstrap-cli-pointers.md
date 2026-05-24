---
name: bootstrap-cli-pointers
type: skill
tags: [setup, onboarding, cli, pointer-files]
last_verified: 2026-05-22
related_files:
  - BRAIN.md
  - README.md
---

# Skill — Bootstrap CLI Pointer Files

> Run this skill when the user wants every AI CLI they use (Claude Code, Codex, Gemini, Cursor, Windsurf, Copilot, Aider, OpenCode, Antigravity, DeepSeek, …) to read `BRAIN.md` automatically at session start.

---

## When to use

- First time `BRAIN.md` is dropped into a repo and the user asks "how do I make my AI tools read this?"
- User says: *"set up pointer files"*, *"init pointers"*, *"add CLAUDE.md / AGENTS.md / etc."*
- User copies this `BRAIN.md` system into an **existing** project that already has tool-specific instructions (e.g. existing `CLAUDE.md`, `.cursorrules`) and wants to keep those while still pointing at `BRAIN.md`.

## Prerequisites

- `BRAIN.md` exists at the project root. If it doesn't, stop and ask the user to add it first.
- Write access to the repo.
- Confirm with the user **which CLI tools they actually use** before writing files — do not create pointer files for tools they don't use.

## CLI → pointer-file mapping

| CLI | Pointer file (relative to repo root) |
| --- | ------------------------------------ |
| Claude Code | `CLAUDE.md` |
| Codex CLI | `AGENTS.md` |
| Gemini CLI | `GEMINI.md` |
| Cursor | `.cursor/rules/agent.mdc` |
| Windsurf | `.windsurfrules` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Aider | `CONVENTIONS.md` (plus `--read CONVENTIONS.md` in `.aider.conf.yml`) |
| OpenCode | `AGENTS.md` *(shared with Codex)* |
| Antigravity CLI | `AGENTS.md` *(shared with Codex)* |
| DeepSeek TUI | `AGENTS.md` *(shared with Codex)* |

When two selected tools share a path (`AGENTS.md`), only handle that file **once**.

## Pointer-file templates

### Full template (for new files)

Replace `{CLI_NAME}` with the human-readable CLI name (e.g. `Claude Code`).

```markdown
# {CLI_NAME} — Project Instructions

> This file is a **pointer**. All project workflow lives in `BRAIN.md` at the
> repo root. Do not duplicate guidance here.

## Read first

1. Open `BRAIN.md` in the project root and follow §0 "The Golden Rule".
2. Then read, in order:
   - `.agent/task.md`
   - `.agent/stack.md`
   - `.agent/conventions.md`
   - `.agent/glossary.md`
   - `.agent/memory/index.md`  (then only the dated files relevant to your task)
   - `.agent/skills/index.md`  (then only the skill files relevant to your task)
3. If code disagrees with these docs, **trust the code** and update the doc.

## Why this file exists

Different AI coding tools look for instructions in different filenames. This
file is the entry point that `{CLI_NAME}` looks for; it redirects you to the
single source of truth so the workflow stays consistent across every tool.
```

### Inject block (for existing files — preserve user content)

```markdown
<!-- agent-swi:begin -->
> **Project agent workflow:** Read `BRAIN.md` at the project root **before**
> following any other instructions in this file. `BRAIN.md` is the single
> source of truth for AI agent workflow across every CLI; this file is just
> the entry point your tool looks for.
<!-- agent-swi:end -->
```

The markers make injection **idempotent** — never insert this block twice.

## Steps

1. **Confirm scope.** Ask the user which CLIs they use. Default suggestion: the four most common (`Claude Code`, `Codex CLI`, `Gemini CLI`, `GitHub Copilot`). Do not assume — confirm.

2. **Resolve pointer paths.** From the mapping table above, build the list of files you will touch. Deduplicate when several CLIs share a path (`AGENTS.md`).

3. **For each pointer file, decide the action:**
   - **File does not exist** → write the **full template** with `{CLI_NAME}` substituted (use the first CLI that maps to that path).
   - **File exists and already contains `<!-- agent-swi:begin -->`** → skip (already done; report it).
   - **File exists without the marker** → ask the user per file: *Inject (default) / Overwrite / Skip*.
     - **Inject:** prepend the inject block. If the file starts with YAML frontmatter (`---` … `---`), insert the block **after** the closing `---`. Preserve all original content and leave a blank line between the block and the original body.
     - **Overwrite:** replace the file with the full template.
     - **Skip:** leave it alone.

4. **Create parent directories** as needed (e.g. `.cursor/rules/`, `.github/`).

5. **Report.** Tell the user exactly what changed:
   - Files written from template
   - Files where the pointer block was injected
   - Files skipped (and why)

## Verification

- For every selected CLI, the pointer file exists at the path in the mapping table.
- Every pointer file either (a) is the full template, or (b) contains `<!-- agent-swi:begin -->` followed by `<!-- agent-swi:end -->`.
- Existing user content in injected files is intact — only prepended to, never overwritten.
- Re-running the skill is a no-op: the marker check prevents duplicate injection.

## Common pitfalls

- **Don't overwrite without asking.** An existing `CLAUDE.md` in the user's project may contain instructions they care about. Inject is the safe default; overwrite only on explicit user choice.
- **Don't duplicate shared pointers.** If the user selects Codex + OpenCode + Antigravity, only handle `AGENTS.md` once.
- **Frontmatter detection.** YAML frontmatter is the **first** `---` … `---` block at the very top of the file. If `---` appears later (e.g. as a horizontal rule), it is **not** frontmatter — do not treat it as one.
- **Don't link to `BRAIN.md` with absolute paths.** Use relative paths so the project stays portable.
- **Don't add guidance to the pointer file itself.** All real instructions live in `BRAIN.md`; the pointer is a one-paragraph redirect.

## Examples

_(none yet — first invocation will be recorded in `.agent/implementation/` and linked here)_

---

_Last verified: 2026-05-22. If the CLI ↔ pointer-file mapping shifts (a new CLI adopts a different convention), update this skill before using it._
