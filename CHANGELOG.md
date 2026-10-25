# Cool modpack changelog

## V9 (2026-10-24)

### What changed
- Server-side tweaks: angled holes, forgiving temperature, gentler Sapper Zombie
- Changelog and build scripts
- Keep other people's mod jars out of the repo
- Sapper Zombie keeps its 60 HP
- Bandits hit as hard as the gun they carry
- Bandit bullets hole and break blocks like players' bullets
- Server resource pack that hides block cracks
- Mining chips blocks instead of cracking them
- Bigger chips for softer blocks and better tools
- Less debris when chipping, so you can see the dent
- Mining doesn't chip logs, so trees still fall
- Damaged doors don't hurt you; damaged blocks are called Damaged Block
- Doors, slabs and stairs aren't chipped; damaged ones turn back when mined
- Fix server lag; half blocks chip again
- Damaged slabs, stairs and doors keep their real shape

### Jars in the pack (our mods and non-CurseForge mods)
- Updated: bandits-1.0.0.jar
- Updated: realism-1.0.0.jar

### Settings changed
- config/realism-common.toml: adventureBreaks = false (new)
- config/realism-common.toml: angledHoles = true (new)
- config/realism-common.toml: collapseSpan = 5 (new)
- config/sapper_zombie-common.toml: new file
- config/toughasnails/temperature.toml: climate_clemency_duration 12000 -> 24000
- config/toughasnails/temperature.toml: consumable_effect_duration 2400 -> 6000
- config/toughasnails/temperature.toml: extremity_damage_delay 1200 -> 2400
- config/toughasnails/temperature.toml: extremity_rebound_temperature_change_delay 120 -> 40
- config/toughasnails/temperature.toml: handheld_temperature_change_delay 200 -> 100
- config/toughasnails/temperature.toml: near_heat_cool_proximity 10 -> 7
- config/toughasnails/temperature.toml: on_fire_temperature_change 2 -> 1
- config/toughasnails/temperature.toml: player_temperature_change_delay 200 -> 400
- config/toughasnails/temperature.toml: snow_temperature_change -1 -> 0
- config/toughasnails/temperature.toml: temperature_change_delay 900 -> 2400
- config/toughasnails/temperature.toml: temperature_drop_altitude 230 -> 320
- config/toughasnails/temperature.toml: temperature_rise_altitude -40 -> -64
- config/toughasnails/temperature.toml: wet_ticks 20 -> 10

## V8 (2026-10-23)

### What changed
- V8 (Oct 23)

### Mods added
- [EMF] Entity Model Features [Fabric & Forge]
- [ETF] Entity Texture Features - [Fabric & Forge]
- [TZP] Gogol's Creeper Pack
- Abandoned Cabins (Regular Cabins too)
- Abandoned Watchtowers
- Antique Atlas
- Balm
- Campsite
- Clumps
- Comforts
- Crafting Tweaks
- Create: Gunpowder [aspctt]
- Create: Rock & Stone
- Domino Trees (Dynamic Trees/Timber Tales addon)
- Dynamic Trees
- Dynamic Trees Pam's Harvestcraft 2: Trees
- Entity Culling Fabric/Forge
- Falling Leaves (NeoForge/Forge)
- Farmer's Delight
- Fast Leaf Decay
- FerriteCore ((Neo)Forge)
- GlitchCore
- Guard Villagers
- Heart Core
- ImmediatelyFast
- Inventory Sorter
- ModernFix
- Pam's HarvestCraft 2 - Trees
- Polymorph
- Realistic Torches (Reborn)
- Serene Seasons
- Spooky Campsite
- The Knocker
- The Watcher From The Fog
- Tissou's Zombie Pack
- Tough As Nails
- Tree Physics
- UnionLib

### Mods removed
- [Let's Do] Beachparty
- [SBW] Superb Warfare
- Create Aeronautics
- Create Aeronautics: Transmission & Linkage
- Do a Barrel Roll
- Fancy Flares - Signal Flare Gun Mod
- Immersive Vehicles - Official Automobile Pack - [OAmP] - Best Cars Race and new cars Ultimate Drive
- Immersive Vehicles (MTS)
- Immersive Vehicles (MTS/IV) - Official Content Pack - [OCP] - Planes, Cars, Helicopters & More!
- Loot Beams: Refork
- Mobile Networks
- SBW Aeronautics compat
- Simple Voice Radio

### Mods updated
- [Let's Do] Meadow: Meadow - 1.4.9 - NEOFORGE - 1.21.1 -> Meadow - 1.4.10 - NEOFORGE - 1.21.1
- Cool Rain: coolrain-1.4.0-1.21.1.jar -> coolrain-1.1.0-1.21.1-neoforge.jar
- CoroUtil: coroutil-neoforge-1.21.0-1.3.8.jar -> coroutil-neoforge-1.21.0-1.3.9.jar
- Fresh Animations: FA 1.10.4 -> FA 1.11.1 - 1.20+
- Puzzles Lib: v21.1.64-mc1.21.1+neoforge -> v21.1.65-mc1.21.1+neoforge
- SnAssets Library - Particles: SnAssets - Particles - V1.1 -> SnAssets - Particles - V1.3
- Structory: Towers: v1.0.16 ~ Mod -> v1.0.14 ~ Mod 1.21.x

### Jars in the pack (our mods and non-CurseForge mods)
- Added: bandits-1.0.0.jar
- Added: eeriemusic-neoforge-1.21.1-1.6.jar
- Added: realism-1.0.0.jar
- Added: sapper_zombie-2.0.0.jar

### Settings changed
- config/aeronautics_utility_objects-server.toml: removed
- config/aeronautics-server.toml: removed
- config/badmobs-common.toml: allowNormalSpawning true -> false
- config/badmobs-common.toml: allowSpawners true -> false
- config/beachparty-common.toml: removed
- config/do_a_barrel_roll-client.json: removed
- config/do_a_barrel_roll-server.json: removed
- config/entity_model_features.json: new file
- config/entity_texture_features.json: new file
- config/ferritecore-mixin.toml: new file
- config/fml.toml: earlyWindowHeight 480 -> 768
- config/fml.toml: earlyWindowWidth 854 -> 1024
- config/hordes/data/hordes/horde_data/scripts/default.json: comments or layout only
- config/hordes/data/hordes/horde_data/tables/apocalypse.json: new file
- config/hordes/hordes-info.json: data_version 12 -> -1
- config/hordes-common.toml: infectPlayers true -> false
- config/immediatelyfast.json: new file
- config/inventory-particles/cache/aeronautics/atlas.png: removed
- config/inventory-particles/cache/aeronautics/regions.txt: removed
- config/inventory-particles/cache/aeronautics/spawn_areas.cached: removed
- config/inventory-particles/cache/aeronautics_utility_objects/atlas.png: removed
- config/inventory-particles/cache/aeronautics_utility_objects/regions.txt: removed
- config/inventory-particles/cache/aeronautics_utility_objects/spawn_areas.cached: removed
- config/inventory-particles/cache/mts/atlas.png: removed
- config/inventory-particles/cache/mts/regions.txt: removed
- config/inventory-particles/cache/mts/spawn_areas.cached: removed
- config/iris.properties: comments or layout only
- config/lootbeams/custom_config.toml: removed
- config/lootbeams/dynamic_config.toml: removed
- config/lootbeams/light_config.toml: removed
- config/lootbeams/loot_information_config.toml: removed
- config/lootbeams/sound_config.toml: removed
- config/mebahel-zombie-horde/mebahel-zombie-horde_config.json: showHordeSpawningMessage true -> false
- config/mobilenetworks-client.toml: removed
- config/mobilenetworks-gameplay.toml: removed
- config/mobilenetworks-maps.properties: removed
- config/mobilenetworks-server.toml: removed
- config/modernfix-mixins.properties: new file
- config/mtsconfig.json: removed
- config/mtsconfigclient.json: removed
- config/offroad-server.toml: removed
- config/pointblank-common.toml: headshotDamageModifier 3.0 -> 2.0
- config/pointblank-common.toml: hitscanDamageModifier 1.0 -> 0.6
- config/realism-common.toml: new file
- config/simulated-client.toml: removed
- config/simulated-server.toml: removed
- config/sodium-fingerprint.json: comments or layout only
- config/superbwarfare-client.toml: removed
- config/superbwarfare-common.toml: removed
- config/superbwarfare-server.toml: removed
- config/toughasnails/temperature.toml: new file
- config/toughasnails/thirst.toml: new file

### Other files
- Removed: servers.dat

