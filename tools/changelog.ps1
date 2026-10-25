<#
Writes a changelog between two versions of the pack: CurseForge mods added, removed and updated (by name),
our own jars in overrides, every setting that changed (old -> new), and the commit notes.

  .\tools\changelog.ps1                      # from the last tag to now, printed
  .\tools\changelog.ps1 -Title "V9" -Write   # same, added to the top of CHANGELOG.md (replacing an Unreleased section)
  .\tools\changelog.ps1 -From v1 -To v8      # any two tags or commits
  -Date 2026-10-23                           # heading date, when it isn't the last commit's

Mod and file names come from CurseForge (api.curse.tools) and are cached in tools\names-cache.json.
Windows PowerShell 5.1. Keep this file ASCII.
#>
param(
    [string]$From,
    [string]$To = "HEAD",
    [string]$Title,
    [string]$Date,
    [switch]$Write
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$repo = Split-Path $PSScriptRoot -Parent
Set-Location $repo

function RunGit([string[]]$GitArgs) {
    # PowerShell 5.1 turns anything git prints on stderr into an error under "Stop"
    $ErrorActionPreference = "Continue"
    $out = & git.exe @GitArgs 2>$null
    if ($LASTEXITCODE -ne 0) { return $null }
    return $out
}

if (-not $From) {
    $From = RunGit @("describe", "--tags", "--abbrev=0", "$To^")
    if (-not $From) { throw "No earlier tag found: pass -From" }
}
if (-not $Title) { $Title = if ($To -eq "HEAD") { "Unreleased" } else { $To } }

# ---- CurseForge mods ----

function Read-Manifest([string]$Ref) {
    $text = (RunGit @("show", "${Ref}:manifest.json")) -join "`n"
    $map = @{}
    foreach ($file in @(($text | ConvertFrom-Json).files | ForEach-Object { $_ })) {
        $map[[string]$file.projectID] = [string]$file.fileID
    }
    return $map
}

$old = Read-Manifest $From
$new = Read-Manifest $To
$added = @($new.Keys | Where-Object { -not $old.ContainsKey($_) })
$removed = @($old.Keys | Where-Object { -not $new.ContainsKey($_) })
$updated = @($new.Keys | Where-Object { $old.ContainsKey($_) -and $old[$_] -ne $new[$_] })

# Names, cached so the API is only asked once per mod or file
$cacheFile = Join-Path $PSScriptRoot "names-cache.json"
$cache = @{ mods = @{}; files = @{} }
if (Test-Path $cacheFile) {
    $saved = [System.IO.File]::ReadAllText($cacheFile) | ConvertFrom-Json
    foreach ($p in $saved.mods.PSObject.Properties) { $cache.mods[$p.Name] = $p.Value }
    foreach ($p in $saved.files.PSObject.Properties) { $cache.files[$p.Name] = $p.Value }
}
$headers = @{ "User-Agent" = "cool-modpack-changelog" }
foreach ($id in @($added + $removed + $updated)) {
    if ($cache.mods.ContainsKey($id)) { continue }
    try {
        $reply = Invoke-RestMethod -Uri "https://api.curse.tools/v1/cf/mods/$id" -Headers $headers
        $cache.mods[$id] = $reply.data.name
    } catch { Write-Warning "Couldn't look up mod ${id}: $_" }
}
foreach ($id in $updated) {
    foreach ($fileId in @($old[$id], $new[$id])) {
        if ($cache.files.ContainsKey($fileId)) { continue }
        try {
            $reply = Invoke-RestMethod -Uri "https://api.curse.tools/v1/cf/mods/$id/files/$fileId" -Headers $headers
            $cache.files[$fileId] = $reply.data.displayName
        } catch { Write-Warning "Couldn't look up file ${fileId}: $_" }
    }
}
$json = [pscustomobject]@{ mods = [pscustomobject]$cache.mods; files = [pscustomobject]$cache.files } | ConvertTo-Json -Depth 4
[System.IO.File]::WriteAllText($cacheFile, $json, (New-Object System.Text.UTF8Encoding($false)))

function ModName([string]$Id) { if ($cache.mods.ContainsKey($Id)) { $cache.mods[$Id] } else { "CurseForge project $Id" } }
function FileName([string]$Id) { if ($cache.files.ContainsKey($Id)) { $cache.files[$Id] } else { "file $Id" } }

# ---- the markdown ----

$lines = New-Object System.Collections.Generic.List[string]
if (-not $Date) { $Date = RunGit @("log", "-1", "--format=%cs", $To) }
$lines.Add("## $Title ($Date)")
$lines.Add("")

$notes = @(RunGit @("log", "--reverse", "--format=%s", "$From..$To"))
if ($notes.Count -gt 0) {
    $lines.Add("### What changed")
    foreach ($n in $notes) { $lines.Add("- $n") }
    $lines.Add("")
}

function Section([string]$Heading, [string[]]$Items) {
    if ($Items.Count -eq 0) { return }
    $lines.Add("### $Heading")
    foreach ($i in ($Items | Sort-Object)) { $lines.Add("- $i") }
    $lines.Add("")
}

Section "Mods added" @($added | ForEach-Object { ModName $_ })
Section "Mods removed" @($removed | ForEach-Object { ModName $_ })
Section "Mods updated" @($updated | ForEach-Object { "$(ModName $_): $(FileName $old[$_]) -> $(FileName $new[$_])" })

# Our own jars and anything else shipped in overrides/mods
$jarChanges = @()
foreach ($row in @(RunGit @("diff", "--name-status", "--find-renames", $From, $To, "--", "overrides/mods"))) {
    $parts = $row -split "`t"
    $what = switch -Wildcard ($parts[0]) { "A" { "Added" } "D" { "Removed" } "M" { "Updated" } "R*" { "Replaced" } default { $parts[0] } }
    $name = Split-Path $parts[-1] -Leaf
    if ($parts[0] -like "R*") { $name = "$(Split-Path $parts[1] -Leaf) -> $name" }
    $jarChanges += "${what}: $name"
}
# The big jars kept out of git are listed in externals.txt (path | sha1 | size)
function Read-Externals([string]$Ref) {
    $map = @{}
    foreach ($line in @(RunGit @("show", "${Ref}:externals.txt"))) {
        $parts = $line -split "\|" | ForEach-Object { $_.Trim() }
        if ($parts.Count -ge 2 -and -not $parts[0].StartsWith("#")) { $map[(Split-Path $parts[0] -Leaf)] = $parts[1] }
    }
    return $map
}
$oldExt = Read-Externals $From
$newExt = Read-Externals $To
foreach ($name in @(@($oldExt.Keys) + @($newExt.Keys) | Sort-Object -Unique)) {
    if (-not $oldExt.ContainsKey($name)) { $jarChanges += "Added: $name" }
    elseif (-not $newExt.ContainsKey($name)) { $jarChanges += "Removed: $name" }
    elseif ($oldExt[$name] -ne $newExt[$name]) { $jarChanges += "Updated: $name" }
}
Section "Jars in the pack (our mods and non-CurseForge mods)" $jarChanges

# Settings: every key whose value changed, per config file
$settingLines = @()
foreach ($row in @(RunGit @("diff", "--name-status", $From, $To, "--", "overrides/config", "overrides/defaultconfigs"))) {
    $parts = $row -split "`t"
    $file = $parts[-1] -replace "^overrides/", ""
    if ($parts[0] -eq "A") { $settingLines += "${file}: new file"; continue }
    if ($parts[0] -eq "D") { $settingLines += "${file}: removed"; continue }
    $before = @{}
    $after = @{}
    foreach ($d in @(RunGit @("diff", "-U0", $From, $To, "--", $parts[-1]))) {
        # TOML: key = value. JSON: "key": value
        if ($d -notmatch '^(\+\+\+|---)' -and $d -match '^([+-])\s*(?:"([A-Za-z0-9_.\-]+)"\s*:|([A-Za-z0-9_.\-]+)\s*=)\s*(.+?),?\s*$') {
            $key = if ($matches[2]) { $matches[2] } else { $matches[3] }
            if ($matches[1] -eq "-") { $before[$key] = $matches[4] } else { $after[$key] = $matches[4] }
        }
    }
    $keys = @(@($before.Keys) + @($after.Keys) | Sort-Object -Unique)
    if ($keys.Count -eq 0) { $settingLines += "${file}: comments or layout only"; continue }
    foreach ($k in $keys) {
        if ($before.ContainsKey($k) -and $after.ContainsKey($k)) { $settingLines += "${file}: $k $($before[$k]) -> $($after[$k])" }
        elseif ($after.ContainsKey($k)) { $settingLines += "${file}: $k = $($after[$k]) (new)" }
        else { $settingLines += "${file}: $k removed (was $($before[$k]))" }
    }
}
Section "Settings changed" $settingLines

$other = @(RunGit @("diff", "--name-status", $From, $To, "--", "overrides", ":!overrides/mods", ":!overrides/config", ":!overrides/defaultconfigs")) |
        ForEach-Object {
            $p = $_ -split "`t"
            $what = switch -Wildcard ($p[0]) { "A" { "Added" } "D" { "Removed" } "M" { "Changed" } "R*" { "Renamed" } default { $p[0] } }
            "${what}: $($p[-1] -replace '^overrides/', '')"
        }
Section "Other files" $other

$text = ($lines -join "`r`n").TrimEnd()
if ($Write) {
    $log = Join-Path $repo "CHANGELOG.md"
    $existing = if (Test-Path $log) { [System.IO.File]::ReadAllText($log) } else { "" }
    $header = "# Cool modpack changelog`r`n`r`n"
    $rest = $existing -replace "^# Cool modpack changelog\s*", ""
    # An Unreleased section at the top is replaced, so the release's section takes its place
    $rest = $rest -replace '(?s)\A## Unreleased.*?(?=\r?\n## |\z)', ''
    [System.IO.File]::WriteAllText($log, $header + $text + "`r`n`r`n" + $rest.TrimStart(), (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Added to CHANGELOG.md"
} else {
    $text
}
