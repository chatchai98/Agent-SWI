#!/bin/sh
# Agent-SWI structure validator — zero-dependency, POSIX sh.
# Works on macOS, Linux, Git Bash (Windows), and WSL.
# Opt-in tooling; the standard itself stays Markdown-only.
#
# Usage (from anywhere):   sh .agent/tools/validate.sh
# Exit code: 0 = all checks pass, 1 = one or more failures.

set -u

# Repo root = two levels up from this script (.agent/tools/ -> root)
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
cd "$ROOT" || exit 1

FAIL=0
pass() { printf '  OK    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; FAIL=1; }

echo "Agent-SWI structure check (root: $ROOT)"
echo

echo "[1] Required root files"
[ -f BRAIN.md ] && pass "BRAIN.md" || fail "BRAIN.md missing"
[ -d .agent ] && pass ".agent/" || fail ".agent/ missing"

echo "[2] Required .agent files"
for f in \
  .agent/version.md .agent/task.md .agent/stack.md \
  .agent/conventions.md .agent/glossary.md .agent/memory/index.md .agent/archive/index.md .agent/skills/index.md \
  .agent/templates/memory_template.md .agent/templates/archive_template.md .agent/templates/implementation_template.md \
  .agent/templates/skill_template.md .agent/templates/adr_template.md
do
  [ -f "$f" ] && pass "$f" || fail "$f missing"
done

echo "[3] Version consistency"
VFILE=$(grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' .agent/version.md 2>/dev/null | head -n1)
VBRAIN=$(grep -E 'agent_swi_version' BRAIN.md 2>/dev/null | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
if [ -n "$VFILE" ] && [ "$VFILE" = "$VBRAIN" ]; then
  pass "version.md ($VFILE) matches BRAIN.md frontmatter"
else
  fail "version mismatch: version.md='$VFILE' BRAIN.md='$VBRAIN'"
fi

echo "[4] Skill index coverage"
for f in .agent/skills/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  [ "$base" = "index.md" ] && continue
  if grep -q "$base" .agent/skills/index.md; then pass "indexed: $base"; else fail "not in skills/index.md: $base"; fi
done

echo "[5] Memory index coverage"
for f in .agent/memory/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  [ "$base" = "index.md" ] && continue
  if grep -q "$base" .agent/memory/index.md; then pass "indexed: $base"; else fail "not in memory/index.md: $base"; fi
done

echo "[5a] Archive index coverage"
if [ -d .agent/archive ]; then
  for f in $(find .agent/archive -type f -name '*.md' ! -name 'index.md'); do
    rel=${f#".agent/archive/"}
    if grep -q "$rel" .agent/archive/index.md; then pass "indexed: $rel"; else fail "not in archive/index.md: $rel"; fi
  done
fi

echo "[6] Frontmatter present (memory, archive, implementation, skills, decisions)"
for dir in memory archive implementation skills decisions; do
  for f in $(find ".agent/$dir" -type f -name '*.md' 2>/dev/null); do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    [ "$base" = "index.md" ] && continue
    l1=$(sed -n '1p' "$f"); l2=$(sed -n '2p' "$f")
    if [ "$l1" = "---" ] || [ "$l2" = "---" ]; then pass "frontmatter: $f"; else fail "no frontmatter: $f"; fi
  done
done

echo "[7] Naming conventions"
for f in .agent/memory/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f"); [ "$base" = "index.md" ] && continue
  echo "$base" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$' \
    && pass "memory name: $base" || fail "bad memory name (want yyyy-mm-dd.md): $base"
done
if [ -d .agent/archive ]; then
  for f in $(find .agent/archive -type f -name '*.md' ! -name 'index.md'); do
    rel=${f#".agent/archive/"}
    echo "$rel" | grep -Eq '^[0-9]{4}/q[1-4]\.md$' \
      && pass "archive name: $rel" || fail "bad archive name (want .agent/archive/yyyy/qN.md): $rel"
  done
fi
for f in .agent/decisions/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f"); [ "$base" = "index.md" ] && continue
  echo "$base" | grep -Eq '^[0-9]{4}-[a-z0-9-]+\.md$' \
    && pass "ADR name: $base" || fail "bad ADR name (want NNNN-kebab-slug.md): $base"
done
for f in .agent/implementation/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f"); [ "$base" = "index.md" ] && continue
  echo "$base" | grep -Eq '^implementation_plan_[0-9]{2}-[0-9]{2}-[0-9]{4}\.md$' \
    && pass "impl name: $base" || fail "bad impl name (want implementation_plan_dd-mm-yyyy.md): $base"
done

echo "[8] Template safeguard comments (line 1 = HTML reminder)"
for f in .agent/templates/*.md; do
  [ -e "$f" ] || continue
  case $(sed -n '1p' "$f") in
    "<!--"*) pass "reminder comment: $(basename "$f")" ;;
    *) fail "missing line-1 reminder comment: $(basename "$f")" ;;
  esac
done

echo
if [ "$FAIL" -eq 0 ]; then
  echo "RESULT: PASS - structure is consistent."
  exit 0
else
  echo "RESULT: FAIL - fix the items marked FAIL above."
  exit 1
fi
