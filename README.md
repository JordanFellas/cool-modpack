# Cool modpack

The CurseForge export of the pack (NeoForge 1.21.1), kept in git so every version is saved and the changelog writes itself.

- `manifest.json`: the CurseForge mods (project and file IDs)
- `overrides/`: our own jars (`overrides/mods`), configs and everything else that ships in the zip
- `externals.txt`: jars too big for git (eeriemusic, 211 MB). They're taken from the CurseForge instance when the zip is built.
- `CHANGELOG.md`: what changed in each version

Tags `v1`, `v8` and so on are the released versions. V2 to V7 are missing because their zips were gone by the time this repo was made.

## Making a change

1. Change files here: configs in `overrides/config`, our jars in `overrides/mods`, mods in `manifest.json`. You can also re-export the pack from CurseForge and unzip it over this folder.
2. Commit, with a message that says what it does for players ("Sapper Zombie spawns less often").
3. Upload the changed files to the BisectHosting server and restart it.

## Releasing a version

```powershell
.\tools\changelog.ps1                         # check what changed since the last version
.\tools\changelog.ps1 -Title "V9" -Write      # add it to CHANGELOG.md
git commit -am "Changelog for V9"
.\tools\build-pack.ps1 -Version 9             # Downloads\Cool modpack-1.21.1-NeoForge(V9).zip, tagged v9
```

The changelog lists mods added, removed and updated (by name, from CurseForge), our jars, every setting that changed with its old and new value, and the commit messages. Claude can also turn it into a short "patch notes" post for Discord.

Windows PowerShell 5.1 runs both scripts; nothing else to install apart from git.
