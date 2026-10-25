<#
Builds the CurseForge zip of the pack from the repo (what's committed), adds the big jars listed in
externals.txt from the CurseForge instance, and tags the version.

  .\tools\build-pack.ps1 -Version 9
  .\tools\build-pack.ps1 -Version 9 -Instance "D:\somewhere\Cool modpack"

Writes Downloads\Cool modpack-1.21.1-NeoForge(V<Version>).zip. Windows PowerShell 5.1. Keep this file ASCII.
#>
param(
    [Parameter(Mandatory = $true)][string]$Version,
    [string]$Instance = (Join-Path $env:USERPROFILE "curseforge\minecraft\Instances\Cool modpack"),
    [string]$Out = (Join-Path $env:USERPROFILE "Downloads"),
    [switch]$NoTag
)

$ErrorActionPreference = "Stop"
$repo = Split-Path $PSScriptRoot -Parent
Set-Location $repo

if (git status --porcelain) {
    Write-Warning "There are uncommitted changes: the zip only has what's committed. Commit first if they belong in this version."
}

$zip = Join-Path $Out "Cool modpack-1.21.1-NeoForge(V$Version).zip"
if (Test-Path $zip) { throw "$zip already exists: pick another version number or delete it first" }

# Everything committed, minus the repo's own files (see .gitattributes)
git archive --format=zip -o $zip HEAD
if ($LASTEXITCODE -ne 0) { throw "git archive failed" }

# The big jars kept out of git
$stage = Join-Path ([System.IO.Path]::GetTempPath()) ("cool-modpack-" + [guid]::NewGuid())
foreach ($line in Get-Content (Join-Path $repo "externals.txt")) {
    if ($line.Trim() -eq "" -or $line.TrimStart().StartsWith("#")) { continue }
    $parts = $line -split "\|" | ForEach-Object { $_.Trim() }
    $path = $parts[0]
    $sha1 = $parts[1]
    $name = Split-Path $path -Leaf
    $source = @((Join-Path $repo $path), (Join-Path $Instance ("mods\" + $name))) | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $source) { throw "Can't find $name (looked in the repo and $Instance\mods)" }
    $actual = (Get-FileHash $source -Algorithm SHA1).Hash.ToLower()
    if ($actual -ne $sha1) { Write-Warning "$name doesn't match externals.txt (it's a different version): using it anyway" }
    $target = Join-Path $stage $path
    New-Item -ItemType Directory -Force (Split-Path $target -Parent) | Out-Null
    Copy-Item $source $target
}
if (Test-Path $stage) {
    $sevenZip = "C:\Program Files\7-Zip\7z.exe"
    Push-Location $stage
    if (Test-Path $sevenZip) {
        & $sevenZip a -tzip $zip "overrides" | Out-Null
    } else {
        Compress-Archive -Path "overrides" -DestinationPath $zip -Update
    }
    Pop-Location
    Remove-Item $stage -Recurse -Force
}

if (-not $NoTag) {
    git tag "v$Version" 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Warning "Tag v$Version already exists: left as it was" }
}
$size = [math]::Round((Get-Item $zip).Length / 1MB, 1)
Write-Host "Built $zip ($size MB)"
