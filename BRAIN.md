---
agent_swi_version: 0.2.0
type: contract
status: active
---

# BRAIN.md - Standard Work Instructions for AI Agents

> Read this first. This file is the contract for every AI agent working in this project.

---

## 0. Work Modes

Before changing files, identify the current work mode:

| Mode | Meaning | Write behavior |
| ---- | ------- | -------------- |
| `implementation` | The user asked you to build, fix, or update files. | Write required files and maintain indexes. |
| `review` | The user asked for review, audit, or analysis. | Do not change files unless explicitly asked. Report drift instead. |
| `read-only` | The user asked a question or requested inspection only. | Do not change files. |

If the user explicitly asks for edits, use `implementation` mode.

---

## 1. The Golden Rule

Before doing substantive work, read in this order:

1. `BRAIN.md`
2. `.agent/task.md`
3. `.agent/stack.md`
4. `.agent/conventions.md`
5. `.agent/glossary.md`
6. `.agent/memory/index.md`, then only dated memory files relevant to the task
7. `.agent/skills/index.md`, then only skill files relevant to the task
8. Relevant `.agent/implementation/` plans and `.agent/decisions/` ADRs

Token discipline:

- Use `.agent/` as indexed long-term project memory, not as a transcript.
- Read indexes first, then open only entries, skills, ADRs, and plans that match the current task.
- Do not scan the whole repository unless the task scope requires it.
- Prefer targeted search (`rg`) and focused file reads over broad file dumps.
- Stop reading once you have enough context to act safely; resume targeted reading only when blocked or uncertain.

If docs contradict code, trust the code. In implementation mode, update the docs. In review or read-only mode, report the mismatch.

---

## 1.1 First-Time Setup

If this is the first session after adding Agent-SWI to a repo, perform bootstrapping:

1. **Auto-Loading Pointers:** Ask the user if they want to set up CLI pointer files. Highlight that automatic rule files (e.g., `.cursor/rules/agent.mdc`, `.windsurfrules`, `.github/copilot-instructions.md`) are highly recommended as IDEs load them automatically without user prompts, preventing agents from forgetting the standard in new sessions. If approved, run `.agent/skills/bootstrap-cli-pointers.md`.
   *(Skip this step if pointer files already exist and redirect to `BRAIN.md`)*

2. **Identify Adoption Scenario:**
   - **Scenario A: New Project:** If this is a brand new project, initialize `.agent/stack.md`, `.agent/conventions.md`, and `.agent/glossary.md` with the project's planned technologies and guidelines.
   - **Scenario B: Existing Project Adoption:** If adopting Agent-SWI in an existing repository, analyze the codebase first. Do not guess. Read the project code, configurations, and documentation to automatically populate `.agent/stack.md` and `.agent/conventions.md` with the actual stack and conventions.

---

## 2. Artifact Rules

### 2.1 Memory

Memory captures non-obvious context a future agent cannot reconstruct from code or git history.

Rules:

- One file per day: `.agent/memory/yyyy-mm-dd.md`.
- Append sections using exactly: `## Section N - <topic> [HH:MM]`.
- Update `.agent/memory/index.md` in the same change.
- Do not log obvious facts that can be derived from files.
- Keep entries concise and decision-oriented so future agents can avoid rediscovering project context.

### 2.2 Skills

Skills are reusable procedures for repeated work.

Rules:

- One skill per `.agent/skills/<kebab-name>.md`.
- Every skill must be listed in `.agent/skills/index.md`.
- In implementation mode, add missing index rows immediately.
- In review/read-only mode, report missing rows instead of editing.

### 2.3 Implementation Plans

Implementation plans record what changed and how to resume.

Rules:

- File format: `.agent/implementation/implementation_plan_dd-mm-yyyy.md`.
- The `.agent/implementation/` directory is optional and is created on demand when you write the first plan; it does not need to exist in an empty project.
- Same-day work appends a new `## Section N - <name> [HH:MM]` section.
- Every non-trivial implementation should update this file.

### 2.4 Architecture Decision Records

ADRs capture decisions that should not be reversed accidentally.

Rules:

- File format: `.agent/decisions/NNNN-<short-slug>.md`.
- Status values: `proposed`, `accepted`, `superseded`, `deprecated`.
- Superseded ADRs stay in place and point to the replacement.

ADR required when the decision changes:

- persistence or data model
- authentication or authorization
- deployment or infrastructure
- public APIs or external contracts
- cross-module architecture
- standard workflow, required tooling, or structure-check policy

ADR usually not required for:

- typo fixes
- local refactors with no contract change
- direct bug fixes that follow an existing decision
- formatting-only changes

### 2.5 Living Singletons

Keep these files current:

- `.agent/stack.md`
- `.agent/conventions.md`
- `.agent/glossary.md`
- `.agent/task.md`

If they are placeholders in a newly adopted repo, fill them before relying on them for context.

---

## 3. Frontmatter Convention

Generated files under `.agent/memory/`, `.agent/implementation/`, `.agent/skills/`, and `.agent/decisions/` start with YAML frontmatter.

Example:

```yaml
---
date: 2026-05-23
type: implementation
status: done
tags: [structure-check, docs]
related_files:
  - .agent/checklists/structure_checklist.md
related_docs:
  - .agent/decisions/0001-example-decision.md
---
```

---

## 4. Structure Check

Use `.agent/checklists/structure_checklist.md` after structural edits.

The checklist is a guardrail for this contract. If the checklist and this file disagree, update this file first, then update the checklist.

### Optional automated validator

An opt-in, zero-dependency validator lives at `.agent/tools/`. It checks required files, version consistency, index coverage, frontmatter, naming, and template safeguards, then exits non-zero on any failure. The standard core stays Markdown-only; the validator is optional.

Run the one that matches the platform:

- macOS / Linux / Git Bash / WSL: `sh .agent/tools/validate.sh`
- Windows (native PowerShell): `powershell -ExecutionPolicy Bypass -File .agent\tools\validate.ps1`

Both scripts perform identical checks. In `review` or `read-only` mode, run the validator to detect drift but report results instead of editing files.

---

## 5. Session Workflow

### Start

1. Identify work mode.
2. Follow the read order using token discipline.
3. **Resumption & Handoff Check:** Check the last completed items in `.agent/task.md` and the most recent entry in `.agent/memory/index.md`. If resuming a task, read the relevant dated memory log to understand previous decisions and prevent session amnesia.
4. Check relevant memory, implementation plans, ADRs, and skills only after their indexes indicate they are useful.
5. Use targeted code search to find the smallest relevant code surface before opening files.

### During Work

- Use existing conventions before inventing new ones.
- Add ADRs before implementing qualifying architectural decisions.
- Capture only non-obvious findings in memory.
- Keep indexes updated when writes are allowed.

### Completion

Before sending the final response, review this closeout checklist. The task is not complete until the applicable items are done or explicitly marked not applicable.

For implementation work:

1. Confirm the requested change is implemented.
2. Run verification, or state why verification was skipped.
3. Update the implementation plan when the work has one.
4. Append `.agent/task.md` with the completed work.
5. Update memory only when the session produced durable, non-obvious context that a future agent cannot reconstruct from code, docs, or git history.
6. If memory is updated, update `.agent/memory/index.md` in the same change.
7. Update relevant indexes when adding, deleting, or renaming indexed files.
8. Review `.agent/checklists/structure_checklist.md` after structural changes.
9. Final response must mention what changed and what verification was done.

Do not create memory entries for routine edits, obvious implementation details, or facts already visible in the touched files.

---

## 6. When in Doubt

- Code beats docs.
- Newer memory supersedes older memory.
- Read-only work reports drift instead of fixing it.
- If the workflow changes, update `BRAIN.md` first.
