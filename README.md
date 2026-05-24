# 🧠 AI Agent Standard Work Instruction

> A drop-in "Second Brain" convention for AI coding agents. One folder, one contract, and every agent that touches your project can recover the same stack, conventions, decisions, memory, and implementation history.

Current standard version: `0.2.0`

---

## 🤔 Why This Exists

AI coding tools often forget the same project context every session:

- Stack and conventions are rediscovered repeatedly.
- Tool-specific memory files do not share one format.
- Plans and decisions stay trapped in chat history.
- Old decisions are reversed because nobody can find why they were made.

Agent-SWI keeps that knowledge in plain Markdown inside the repo. It is not a library or runtime. It is a small, tool-agnostic documentation standard with no executable files.

---

## 🎁 What It Gives You

| Capability | File |
| ---------- | ---- |
| Agent entry point | `BRAIN.md` |
| Standard version | `.agent/version.md` |
| Stack snapshot | `.agent/stack.md` |
| Project-specific rules | `.agent/conventions.md` |
| Domain vocabulary | `.agent/glossary.md` |
| Daily memory log | `.agent/memory/yyyy-mm-dd.md` |
| Keyword-indexed memory | `.agent/memory/index.md` |
| Reusable skill playbooks | `.agent/skills/*.md` |
| Skill discovery index | `.agent/skills/index.md` |
| Per-day implementation plans | `.agent/implementation/implementation_plan_dd-mm-yyyy.md` |
| Architecture Decision Records | `.agent/decisions/NNNN-*.md` |
| Work timeline | `.agent/task.md` |
| Starter templates | `.agent/templates/*.md` |
| Structure checklist | `.agent/checklists/structure_checklist.md` |
| Optional validators | `.agent/tools/validate.sh`, `.agent/tools/validate.ps1` |

---

## 📁 Folder Structure

```text
.
├── BRAIN.md
└── .agent/
    ├── version.md
    ├── task.md
    ├── stack.md
    ├── conventions.md
    ├── glossary.md
    ├── checklists/
    │   └── structure_checklist.md
    ├── memory/
    │   ├── index.md
    │   └── yyyy-mm-dd.md
    ├── skills/
    │   ├── index.md
    │   └── *.md
    ├── implementation/        # optional — created on first implementation plan
    ├── decisions/             # your project's ADRs go here
    ├── templates/
    └── tools/                 # optional — opt-in validators (validate.sh / validate.ps1)
```

> **Optional directories.** `implementation/` and `tools/` are not required to exist. `implementation/` is created the first time you write an implementation plan; `tools/` holds the opt-in validators. The rest of the tree is the expected baseline.

---

## 🚀 Quick Start

### 1. Copy the Standard Into Your Repo

```bash
git clone --depth=1 https://github.com/chatchai98/Agent-SWI tmp-swi
cp -r tmp-swi/BRAIN.md tmp-swi/.agent .
rm -rf tmp-swi
```

This repo ships as a clean skeleton: empty scaffolds for `stack.md`,
`conventions.md`, and `glossary.md`, an empty `decisions/`, and empty indexes.
You start fresh and fill them in.

### 2. Tell Your AI Tool to Read `BRAIN.md`

On the first AI session in the target repo, say:

> Read `BRAIN.md` and follow it.

`BRAIN.md` explains the required read order and the first-time setup flow.

### 3. Set Up Pointer Files — the Key to "Every Session, Every Agent"

Saying "read `BRAIN.md`" only affects the **current** session. To make every AI tool pick up the standard **automatically** in every new session — without you reminding it — set up pointer files once. These are the files each tool loads on its own at startup:

| AI Tool | File it auto-loads |
| ------- | ------------------ |
| Claude Code | `CLAUDE.md` |
| Codex CLI / OpenCode | `AGENTS.md` |
| Gemini CLI | `GEMINI.md` |
| Cursor | `.cursor/rules/agent.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Windsurf | `.windsurfrules` |

Each pointer just says "read `BRAIN.md` first." On the first session, your AI will offer to create them — say yes and pick the tools you use. The skill `.agent/skills/bootstrap-cli-pointers.md` does this safely (it injects into existing files without overwriting your content).

Without this step the standard still works, but you must say "read `BRAIN.md`" at the start of every session.

### 4. Fill the Required Scaffolds

Before relying on the system, replace the placeholders in:

- `.agent/stack.md`
- `.agent/conventions.md`
- `.agent/glossary.md`

Each scaffold contains inline placeholders describing what to fill in.

### 5. Check the Structure

Use `.agent/checklists/structure_checklist.md` after copying or changing the standard. It checks frontmatter, naming conventions, index coverage, and template heading consistency.

---

## 📐 Core Conventions

1. **Read order:** `BRAIN.md` -> `.agent/task.md` -> `.agent/stack.md` -> `.agent/conventions.md` -> `.agent/glossary.md` -> `.agent/memory/index.md` -> `.agent/skills/index.md` -> relevant implementation plans and ADRs.
2. **Same-day artifacts append, never duplicate.** Memory and implementation files use `## Section N - <topic> [HH:MM]`.
3. **Index all memory and skills.** A section or skill that is not indexed is effectively invisible.
4. **Respect work mode.** In read-only or review work, report missing indexes or stale docs instead of editing them.
5. **Every generated artifact has YAML frontmatter.**
6. **Trust code over docs.** If they disagree, trust the code and update the docs when writes are allowed.
7. **Use ADRs for architectural decisions.** ADRs are required for persistence, auth, deployment, public API, data model, cross-module contracts, or tooling standards. Small local refactors and direct bug fixes usually do not need ADRs.

---

## ✅ Structure Check Policy

Agent-SWI is Markdown-only. Use `.agent/checklists/structure_checklist.md` for manual consistency checks.

The checklist covers:

- `.agent/version.md` exists and contains the standard semantic version.
- Required `.agent` files exist.
- `.agent/skills/*.md` files are listed in `.agent/skills/index.md`.
- Artifact files under memory, implementation, skills, and decisions have YAML frontmatter.
- Implementation and ADR filenames match the standard patterns.
- Memory and implementation templates use the canonical section heading format.

The checklist is a guardrail, not a replacement for review. If the checklist and `BRAIN.md` disagree, update `BRAIN.md` first, then update the checklist.

---

## 🏷️ Versioning

Agent-SWI uses semantic versioning for the standard itself:

- Patch: typo fixes or clarifications that do not change workflow.
- Minor: new optional files, examples, checklists, or compatible workflow improvements.
- Major: breaking changes to file layout, required fields, or agent workflow.

`.agent/version.md` records which standard version a project is on. See the GitHub releases for changes between versions.

---

## ❓ FAQ

**Do I need every file?**  
No. The minimum useful subset is `BRAIN.md`, `.agent/task.md`, `.agent/memory/`, and `.agent/memory/index.md`. The full set is recommended for teams and multi-agent workflows.

**Why Markdown instead of a database?**  
Markdown is portable, easy to diff, and already readable by AI agents and humans.

**Can humans use this too?**  
Yes. `task.md`, ADRs, and memory logs are meant to be useful to humans first. AI agents maintain them because they are good at repetitive bookkeeping.

---

## 📄 License

MIT. See `LICENSE`.

Copyright (c) 2026 Chatchai.J <chatchai.j98@gmail.com>

Start with `BRAIN.md`.
