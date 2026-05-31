# Agent-SWI structure validator - zero-dependency, Windows PowerShell 5.1+.
# Mirror of validate.sh for native Windows (no Git Bash / WSL needed).
# Opt-in tooling; the standard itself stays Markdown-only.
#
# Usage:  powershell -ExecutionPolicy Bypass -File .agent\tools\validate.ps1
# Exit code: 0 = all checks pass, 1 = one or more failures.

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Set-Location $root

$script:Fail = 0
function Pass($m) { Write-Host "  OK    $m" }
function Fail($m) { Write-Host "  FAIL  $m"; $script:Fail = 1 }
$verRe = '[0-9]+\.[0-9]+\.[0-9]+'

Write-Host "Agent-SWI structure check (root: $root)"
Write-Host ""

Write-Host "[1] Required root files"
if (Test-Path BRAIN.md) { Pass "BRAIN.md" } else { Fail "BRAIN.md missing" }
if (Test-Path .agent)   { Pass ".agent/" } else { Fail ".agent/ missing" }

Write-Host "[2] Required .agent files"
$required = @(
  '.agent\version.md', '.agent\task.md', '.agent\stack.md',
  '.agent\conventions.md', '.agent\glossary.md', '.agent\memory\index.md', '.agent\archive\index.md', '.agent\skills\index.md',
  '.agent\templates\memory_template.md', '.agent\templates\archive_template.md', '.agent\templates\implementation_template.md',
  '.agent\templates\skill_template.md', '.agent\templates\adr_template.md'
)
foreach ($f in $required) {
  if (Test-Path $f) { Pass $f } else { Fail "$f missing" }
}

Write-Host "[3] Version consistency"
$vfile = ''
$vbrain = ''
if (Test-Path .agent\version.md) {
  $m = ([regex]$verRe).Match((Get-Content .agent\version.md -Raw)); if ($m.Success) { $vfile = $m.Value }
}
if (Test-Path BRAIN.md) {
  $brainRaw = Get-Content BRAIN.md -Raw
  if ($brainRaw -match "agent_swi_version:\s*($verRe)") { $vbrain = $matches[1] }
}
if ($vfile -and $vfile -eq $vbrain) { Pass "version.md ($vfile) matches BRAIN.md frontmatter" }
else { Fail "version mismatch: version.md='$vfile' BRAIN.md='$vbrain'" }

function Test-IndexCoverage($dir, $indexPath, $label) {
  Write-Host $label
  if (-not (Test-Path $indexPath)) { Fail "$indexPath missing"; return }
  $idx = Get-Content $indexPath -Raw
  Get-ChildItem $dir -Filter *.md -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne 'index.md' } | ForEach-Object {
      if ($idx -match [regex]::Escape($_.Name)) { Pass "indexed: $($_.Name)" }
      else { Fail "not in $indexPath`: $($_.Name)" }
    }
}
Test-IndexCoverage '.agent\skills' '.agent\skills\index.md' "[4] Skill index coverage"
Test-IndexCoverage '.agent\memory' '.agent\memory\index.md' "[5] Memory index coverage"

Write-Host "[5a] Archive index coverage"
if (-not (Test-Path '.agent\archive\index.md')) { Fail ".agent\archive\index.md missing" }
else {
  $archiveIdx = Get-Content '.agent\archive\index.md' -Raw
  $archiveRoot = (Resolve-Path '.agent\archive').Path
  Get-ChildItem '.agent\archive' -Filter *.md -File -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne 'index.md' } | ForEach-Object {
      $rel = $_.FullName.Substring($archiveRoot.Length + 1) -replace '\\', '/'
      if ($archiveIdx -match [regex]::Escape($rel)) { Pass "indexed: $rel" }
      else { Fail "not in .agent\archive\index.md: $rel" }
    }
}

Write-Host "[6] Frontmatter present (memory, archive, implementation, skills, decisions)"
foreach ($d in 'memory', 'archive', 'implementation', 'skills', 'decisions') {
  Get-ChildItem ".agent\$d" -Filter *.md -File -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne 'index.md' } | ForEach-Object {
      $lines = Get-Content $_.FullName -TotalCount 2
      if (($lines.Count -ge 1 -and $lines[0] -eq '---') -or ($lines.Count -ge 2 -and $lines[1] -eq '---')) {
        Pass "frontmatter: .agent\$d\$($_.Name)"
      } else { Fail "no frontmatter: .agent\$d\$($_.Name)" }
    }
}

Write-Host "[7] Naming conventions"
Get-ChildItem '.agent\memory' -Filter *.md -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -ne 'index.md' } | ForEach-Object {
    if ($_.Name -match '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$') { Pass "memory name: $($_.Name)" }
    else { Fail "bad memory name (want yyyy-mm-dd.md): $($_.Name)" }
  }
Get-ChildItem '.agent\archive' -Filter *.md -File -Recurse -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -ne 'index.md' } | ForEach-Object {
    $rel = $_.FullName.Substring((Resolve-Path '.agent\archive').Path.Length + 1) -replace '\\', '/'
    if ($rel -match '^[0-9]{4}/q[1-4]\.md$') { Pass "archive name: $rel" }
    else { Fail "bad archive name (want .agent/archive/yyyy/qN.md): $rel" }
  }
Get-ChildItem '.agent\decisions' -Filter *.md -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -ne 'index.md' } | ForEach-Object {
    if ($_.Name -match '^[0-9]{4}-[a-z0-9-]+\.md$') { Pass "ADR name: $($_.Name)" }
    else { Fail "bad ADR name (want NNNN-kebab-slug.md): $($_.Name)" }
  }
Get-ChildItem '.agent\implementation' -Filter *.md -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -ne 'index.md' } | ForEach-Object {
    if ($_.Name -match '^implementation_plan_[0-9]{2}-[0-9]{2}-[0-9]{4}\.md$') { Pass "impl name: $($_.Name)" }
    else { Fail "bad impl name (want implementation_plan_dd-mm-yyyy.md): $($_.Name)" }
  }

Write-Host "[8] Template safeguard comments (line 1 = HTML reminder)"
Get-ChildItem '.agent\templates' -Filter *.md -File -ErrorAction SilentlyContinue | ForEach-Object {
  $l1 = Get-Content $_.FullName -TotalCount 1
  if ($l1 -like '<!--*') { Pass "reminder comment: $($_.Name)" }
  else { Fail "missing line-1 reminder comment: $($_.Name)" }
}

Write-Host ""
if ($script:Fail -eq 0) { Write-Host "RESULT: PASS - structure is consistent."; exit 0 }
else { Write-Host "RESULT: FAIL - fix the items marked FAIL above."; exit 1 }
