# Agent-SWI Structure Checklist

Use this checklist after copying Agent-SWI into a project or after changing `.agent/`.

> **Faster path (optional):** run the zero-dependency validator instead of checking by hand. It covers most items below and exits non-zero on failure.
> - macOS / Linux / Git Bash / WSL: `sh .agent/tools/validate.sh`
> - Windows: `powershell -ExecutionPolicy Bypass -File .agent\tools\validate.ps1`

## Required Root Files

- [ ] `BRAIN.md` exists at the project root.
- [ ] `.agent/` exists at the project root.

## Required `.agent` Files

- [ ] `.agent/version.md`
- [ ] `.agent/task.md`
- [ ] `.agent/stack.md`
- [ ] `.agent/conventions.md`
- [ ] `.agent/glossary.md`
- [ ] `.agent/memory/index.md`
- [ ] `.agent/archive/index.md`
- [ ] `.agent/skills/index.md`
- [ ] `.agent/templates/memory_template.md`
- [ ] `.agent/templates/archive_template.md`
- [ ] `.agent/templates/implementation_template.md`
- [ ] `.agent/templates/skill_template.md`
- [ ] `.agent/templates/adr_template.md`

## Version

- [ ] `.agent/version.md` contains semantic versioning, for example `0.2.0`.
- [ ] `BRAIN.md` frontmatter has the same `agent_swi_version`.

## Index Coverage

- [ ] Every `.agent/skills/*.md` file except `index.md` is listed in `.agent/skills/index.md`.
- [ ] Every `.agent/memory/yyyy-mm-dd.md` file is listed in `.agent/memory/index.md`.
- [ ] Every `.agent/archive/yyyy/qN.md` archive file is listed in `.agent/archive/index.md`.

## Frontmatter

- [ ] Memory files start with YAML frontmatter.
- [ ] Archive files start with YAML frontmatter.
- [ ] Implementation files start with YAML frontmatter.
- [ ] Skill files start with YAML frontmatter.
- [ ] ADR files start with YAML frontmatter.

## Naming

- [ ] Memory files use `yyyy-mm-dd.md`.
- [ ] Archive files use `.agent/archive/yyyy/qN.md`.
- [ ] Implementation files use `implementation_plan_dd-mm-yyyy.md`.
- [ ] ADR files use `NNNN-kebab-case-slug.md`.
- [ ] Skill files use `kebab-case.md`.

## Section Headings & Safeguards

- [ ] Memory sections use `## Section N - <topic> [HH:MM]`.
- [ ] Archive sections use `## Section N - <topic> [YYYY-MM-DD]`.
- [ ] Implementation sections use `## Section N - <topic> [HH:MM]`.
- [ ] Templates use the same heading format with placeholders.
- [ ] Templates contain the critical index reminder comment at the very top (line 1).

## Work Mode

- [ ] In review/read-only work, report drift instead of editing files.
- [ ] In implementation work, update relevant indexes and logs in the same change.
- [ ] Before final response, review the `BRAIN.md` completion checklist.
- [ ] For implementation work, append `.agent/task.md`.
- [ ] Update memory only for durable, non-obvious context; do not create routine memory noise.
- [ ] After adding, deleting, or renaming files, scan references for stale paths.
- [ ] Startup guidance reads indexes first and opens only relevant long-form files.
- [ ] Startup guidance treats `.agent/archive/` as cold storage and does not load archive files unless the archive index is relevant.
