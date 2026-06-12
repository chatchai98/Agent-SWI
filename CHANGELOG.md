# Changelog

All notable changes to the Agent-SWI standard are documented here.
This project follows [Semantic Versioning](https://semver.org/): patch = clarifications, minor = compatible additions, major = breaking layout/workflow changes.

## [0.4.0] - 2026-06-12

### Added

- `CHANGELOG.md` — version history now lives in the repo, not only in GitHub releases.
- CI workflow (`.github/workflows/validate.yml`) that runs `sh .agent/tools/validate.sh` on every push and pull request, so the standard validates itself.

### Changed

- Validators (`validate.sh`, `validate.ps1`) now require `.agent/checklists/structure_checklist.md`, matching its "core guardrail" role in `README.md` and `BRAIN.md`.
- README pointer-file table now lists all tools covered by the `bootstrap-cli-pointers` skill (added Aider, Antigravity CLI, DeepSeek TUI).
- `structure-validate` skill gained a worked example.

## [0.3.0] - 2026-05-31

### Added

- Searchable cold-archive standard: `.agent/archive/index.md`, `.agent/archive/yyyy/qN.md`, archive template, and archive rules in `BRAIN.md` §2.1.1.

## [0.2.0] - 2026-05-24

### Added

- Initial public release: `BRAIN.md` contract, `.agent/` skeleton (version, task, stack, conventions, glossary, memory + index, skills + index, templates, decisions), structure checklist, and opt-in validators.
