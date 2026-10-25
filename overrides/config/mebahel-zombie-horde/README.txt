Mebahel's Zombie Horde - Configuration Guide
===========================================

This README explains what each field in the configuration JSON files does.
All config files are located in this folder.

Files:
  1) mebahel-zombie-horde_config.json
  2) mebahel-zombie-hordemob_type_config.json

1) mebahel-zombie-horde_config.json
--------------------------------------------
General Horde behaviour settings.

  - spawnInDayLight (boolean, default: true)
    If true, hordes can spawn during the day.
    If false, hordes spawn only at night (Overworld).

  - enableDifficultySystem (boolean, default: true)
    If true, the mod can increase difficulty after the Nether has been reached.
    (Your manager currently bumps difficulty once the advancement 'minecraft:nether/root' is completed.)

  - hordeSpawning (boolean, default: true)
    Master switch. If false, no hordes are spawned by the mod.

  - hordeSpawnDelay (array [amount, unit], default: [15, "minute"])
    Controls how often the mod attempts to spawn a horde.
    Accepted units:
      * "minute" => amount * 60 seconds
      * "day"    => amount * 24000 ticks
    Examples:
      [15, "minute"] => every ~15 minutes
      [1,  "day"]    => once per Minecraft day (random time in the day block)
    Backward compatibility:
      If the value was a number (legacy config), it is auto-converted to [number, "minute"].

  - hordeSpawnChance (float 0..1, default: 1.0)
    Probability for each horde attempt to actually spawn.
    1.0 => always spawns when scheduled.
    0.5 => ~50% of the attempts spawn.

  - hordeNumber (int 1..20, default: 1)
    Number of horde spawn attempts each time the schedule triggers.
    Example: 3 means the manager will attempt spawning 3 hordes in a row (each gated by hordeSpawnChance).

  - randomNumberHordeReinforcements (int 0..10, default: 0)
    Adds a random extra amount of members to the horde.
    If > 0, reinforcement = random(0..value-1) is added to the follower count.

  - hordeMemberBonusHealth (int 0..800, default: 0)
    Extra max health added to every spawned horde member.
    Example: 10 => +10 HP on top of base mob health.

  - hordeMemberBreakGlass (boolean, default: true)
    If true, eligible mobs (from mob_type_config) get the goal to break glass.

  - hordeMemberBreakFence (boolean, default: true)
    If true, eligible mobs (from mob_type_config) get the goal to break fences.

  - showHordeSpawningMessage (boolean, default: true)
    If true, sends a chat message when a horde spawns.
    The message includes clickable coordinates that run a /tp command.

  - hordeSpawnDistanceFromPlayer (int >= 0, default: 60)
    Base distance (in blocks) from the chosen player for spawning the horde.
    Your code then adds a random extra offset (0..19) to X and Z.

Overworld spawn placement:
  The manager tries up to 16 nearby surface positions.
  The leader and each follower need solid ground, free space, and a visible sky.
  If no suitable position is found, that spawn attempt is skipped.

Validation rules applied at load:
  - hordeSpawnChance must be within [0..1]
  - hordeNumber must be within [1..20]
  - randomNumberHordeReinforcements must be within [0..10]
  - hordeMemberBonusHealth must be within [0..800]
  - hordeSpawnDistanceFromPlayer must be >= 0

2) mebahel-zombie-hordemob_type_config.json
--------------------------------------------
Defines which mobs can appear in a horde, where they can spawn, and what weapons they may get.

Root:
  {
    "hordeCompositions": [ ... ]
  }

hordeCompositions[] fields:
  - weight (int > 0)
    Weight used to randomly pick a composition.
    Higher weight => more likely selection.

  - dimensions (string[] of dimension ids)
    List of dimension identifiers in which this composition is eligible.
    Example: ["minecraft:overworld", "minecraft:the_nether"]
    If missing/empty, the loader auto-fills ["minecraft:overworld"].

  - biomes (string[] of biome ids, optional)
    Restricts this composition to the biome at the horde leader's spawn position.
    Example: ["minecraft:desert"].
    If missing/empty, all biomes in the allowed dimensions are eligible.
    Matching biome-specific compositions take priority over unrestricted ones.
    Defaults: zombies elsewhere in the Overworld; husks in deserts and badlands.
    Normal hordes have weight 8; armed and armored elite hordes have weight 1.

  - mobTypes (array)
    List of mobs that can spawn for this composition.

mobTypes[] fields:
  - id (string)
    Entity type identifier. Example: "minecraft:zombie".

  - weight (int > 0)
    Weight used to pick which mob type is spawned inside the composition.

  - spawnWithWeaponProbability (float, default: 0.15)
    Probability (0..1) that the mob spawns with a weapon from 'weapons'.
    If <= 0 in config, the loader forces it to 0.15.

  - weapons (array, optional)
    Weapon pool used when the mob spawns with a weapon.
    Each entry is weighted.

  - spawnWithArmorProbability (float 0..1, optional)
    Independent chance for each armor slot when 'armor' is configured.
    If absent, each slot uses 0.06 * difficulty level.

  - armor (object, optional)
    Weighted armor lists by slot: head, chest, legs, feet.
    Each entry has itemId and weight (int > 0).
    Example: "head": [{"itemId": "minecraft:iron_helmet", "weight": 2}].
    Missing or empty slot lists leave that slot empty.
    If armor is absent, legacy random iron armor applies to all four slots.

weapons[] fields:
  - itemId (string)
    Item identifier. Example: "minecraft:iron_sword".

  - weight (int, preferred)
    Relative weight for random pick.
    Higher weight => more likely.
    Invalid weights (<= 0) are fixed to 1 by the loader.

  - chance (float, legacy compatibility)
    Old field kept for backward compatibility.
    If 'weight' is not valid, 'chance' (0..1) is converted into a weight ~ (chance*100).

