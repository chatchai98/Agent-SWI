---
name: structure-validate
type: skill
tags: [structure-check, validation, index-drift, maintenance]
last_verified: 2026-06-12
related_files:
  - .agent/checklists/structure_checklist.md
  - .agent/tools/validate.sh
  - .agent/tools/validate.ps1
---

# Skill — Structure Validate

> Use this skill when you need to check Agent-SWI structural consistency, or when you suspect index drift (an un-indexed skill/memory file, missing frontmatter, a misnamed artifact). It tells you how to run the check and exactly what to do with each violation, split by work mode.

---

## When to use

- After adding, renaming, or deleting any file under `.agent/`.
- Before finishing implementation work, as part of the `BRAIN.md` closeout checklist.
- When a skill or memory entry seems "missing" — it may exist on disk but not in its index.
- In `review` / `read-only` work, to detect and report drift without changing files.

## Prerequisites

- Repo root contains `BRAIN.md` and `.agent/`.
- For the automated path: a shell (`sh`) or PowerShell. No runtime/install required.
- Know the current work mode (`implementation`, `review`, `read-only`) — it decides whether you fix or only report.

## Steps

1. **Run the validator** (preferred — covers most checks and exits non-zero on failure).
   ```sh
   # macOS / Linux / Git Bash / WSL
   sh .agent/tools/validate.sh
   ```
   ```powershell
   # Windows (native PowerShell)
   powershell -ExecutionPolicy Bypass -File .agent\tools\validate.ps1
   ```
   If neither shell is available, fall back to `.agent/checklists/structure_checklist.md` and check by hand.

2. **Read each `FAIL` line.** Each maps to one of the violation types in the table below.

3. **Act on each violation according to work mode** (see "Violation playbook"). The rule is constant: `implementation` fixes, `review`/`read-only` only reports.

4. **Re-run the validator** until it prints `RESULT: PASS` (exit 0). In review/read-only mode, skip the fix-and-rerun loop and instead report the full list of `FAIL` lines and their impact.

## Violation playbook

| Validator FAIL | Meaning | implementation mode | review / read-only mode |
| -------------- | ------- | ------------------- | ----------------------- |
| `not in skills/index.md` | Skill file exists but is unindexed | Add the row to `.agent/skills/index.md` in the same change | Report the orphaned skill; do not edit |
| `not in memory/index.md` | Memory file exists but is unindexed | Add the entry to `.agent/memory/index.md` | Report the orphaned memory file |
| `no frontmatter` | Artifact missing YAML frontmatter | Add frontmatter per `BRAIN.md` §3 | Report which file lacks frontmatter |
| `bad memory/ADR/impl name` | Filename breaks the naming convention | Rename to the correct pattern, then fix any references | Report the misnamed file |
| `version mismatch` | `.agent/version.md` ≠ `BRAIN.md` frontmatter | Decide the correct version, update both to match | Report the divergence |
| `<file> missing` | A required file is absent | Create it from the matching template if appropriate, or flag if intentional | Report the missing required file |
| `missing line-1 reminder comment` | A template lost its safeguard comment | Restore the `<!-- CRITICAL: ... -->` line at line 1 | Report the template |

## Verification

- Automated path: validator exits `0` and prints `RESULT: PASS`.
- In review/read-only mode: every `FAIL` line is reported with its file and impact; no files were modified.
- After fixing an index drift, the previously-orphaned file now appears in its `index.md`.

## Common pitfalls

- **Fixing in review mode.** Review/read-only work must report drift, not edit it — see `BRAIN.md` §0.
- **Forgetting the same-change index update.** When you add a skill/memory file, update its `index.md` in the *same* change, or the next validator run will flag it.
- **Only running one script.** `validate.sh` and `validate.ps1` should agree; if you change structural rules, update both.
- **Treating a missing optional dir as a failure.** `.agent/implementation/` and `.agent/tools/` are optional; the validator does not require them.

## Examples

**2026-06-12 — review-mode run on this repo (v0.4.0).** Both validators were run from the repo root:

```sh
sh .agent/tools/validate.sh
powershell -ExecutionPolicy Bypass -File .agent\tools\validate.ps1
```

Both printed `RESULT: PASS` and exited 0, and their OK/FAIL lines agreed. Because the session was in review mode, no files were touched; the result was reported instead. If one of them had printed, e.g., `FAIL  not in skills/index.md: new-skill.md`, the violation playbook row for `not in skills/index.md` would apply: report the orphaned skill (review mode) or add the index row in the same change (implementation mode).

---

_Last verified: 2026-06-12. If the validator's checks or the checklist change, update this skill to match before using it._
