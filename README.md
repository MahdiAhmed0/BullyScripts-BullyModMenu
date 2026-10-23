# Bully Mod Menu (Lua)

An in-game Lua menu for Bully: Scholarship Edition, used to test script functions, prototype a mission and change player state while playing.

## Overview

This repository holds a single script, `Script.lua`, written against the Lua scripting API of Bully: Scholarship Edition. It is laid out like one of the game's mission scripts: `MissionSetup()` prepares the player and `main()` starts a menu thread. The menu exposes a set of small test actions, a three-stage test mission, a ped flag test and a looping sound test.

The script started as a debugging aid that the author used while working on other Bully scripts. The first version published here in August 2023 was a fragment with a Reset Camera entry and markers for missing parts; the complete script was published in February 2026. The test-style function names (`testingBro1` to `testingBro9`) and the informal messages come from that debugging use. It was written as part of early Lua scripting experimentation and game modding research, and it is designed around the constraints of the game's old Lua engine.

## What it does

- Moves the player to a fixed position on load, then shows a nine-entry text menu navigated with two buttons and activated with a third.
- Menu actions: restore health, give the spud gun, toggle the punishment system, kill the targeted ped, step the player's animation speed.
- Runs a scripted test mission: follow a map blip, fight three spawned peds, then reach two more marks.
- Runs a ped flag test that switches `PedSetFlag` IDs on the player one at a time, and a test that loops a 3D sound at a fixed point.

## Requirements

- Bully: Scholarship Edition on PC.
- A way to run a custom script: Derpy's Script Loader (DSL), or a Lua 5.0.2 compiler built for Bully plus an IMG archive tool to replace a script inside `Scripts.img`. Both routes are described below.

## Installation and usage

### Option A: Derpy's Script Loader

According to the DSL documentation, scripts installed with DSL are placed in the `_derpy_script_loader/scripts` folder inside the game directory, do not need to be compiled, and start as soon as the game starts. DSL recognises `MissionSetup` (run when the script starts) and `main` (run after `MissionSetup` finishes), which matches the structure of this script. The loader is downloaded from its Nexus Mods page and its own readme covers installation.

Two notes from the DSL documentation matter for this script. DSL scripts run as soon as the game launches, and the docs say to wait until `SystemIsReady()` returns true before doing most things; `MissionSetup()` here moves the player immediately, so expect to add such a wait (and load a save) before using the script with DSL. The docs also state that `BlipAddXYZ` does not draw a ground blip by default under DSL, so the marks of the test mission may not appear on the ground. The DSL console (the `~` key by default) shows script errors.

### Option B: Replace a script in Scripts.img

The game cannot load Lua source directly, so for this route the script has to be compiled to bytecode with a Lua 5.0.2 `luac` built for Bully's 4-byte float numbers (the Bully Scripting Docs download page provides such a build), for example:

```text
luac -o ArcRace1.lur Script.lua
```

`ArcRace1.lur` is the script modders commonly replace; a mod installed that way is started by interacting with the arcade machine in the boys' dormitory. Use an IMG archive editor such as IMGTool to open `Scripts.img` (found with `Scripts.dir` in the game's `Scripts` folder), replace the original `.lur` with the compiled file under the same name and rebuild the archive. Back up `Scripts.img` and `Scripts.dir` first.

### Controls

Button IDs are passed to `IsButtonBeingPressed(button, 0)`; controller 0 is player 1. The names below are the ones used in derpy54320's control ID table (the "(Left)" and "(Right)" are part of the entry text). These names are in-game actions, so the key or gamepad button for each can be looked up in the game's own controls settings; the sources used here do not list default bindings.

| Button ID | Name in the ID table | In the main menu | In the flag test | During the test mission |
|-----------|----------------------|------------------|------------------|-------------------------|
| 0 | Show Secondary Tasks (Left) | Previous entry | Flag ID minus 1 | No effect |
| 1 | Show Tasks/Objectives (Right) | Next entry | Flag ID plus 1 | Prints the stage message |
| 3 | Zoom out | Activate entry | Set the flag (ID 1 ends the test) | No effect |

`IsButtonBeingPressed` returns true only on the frame the button is first pressed, so holding a button does not repeat the action. The menu label is only redrawn when the selection changes, so no entry is shown until a navigation button is pressed.

## How it works

Terms: a ped is any character, including the player; `gPlayer` is the game's global handle for the player ped; a blip is a minimap marker; stats are per-ped numeric attributes set with `GameSetPedStat` and `PedOverrideStat`.

### Entry points

`MissionSetup()` disables player control with `PlayerSetControl(0)`, calls `PlayerSetPosXYZArea(270, -110, 6, 0)` to place the player at (270, -110, 6) in area 0, waits in a `Wait(0)` loop until `AreaIsLoading()` is false, then enables widescreen with `CameraSetWidescreen(true)`.

`main()` prints a welcome line with `TextPrintString` (the text contains an asterisked word), waits two seconds, gives control back with `PlayerSetControl(1)`, turns widescreen off, prints "You can move now!" and calls `CreateThread("menu")`.

### Menu loop

`menu()` builds `SimpleMenu`, a table of nine `{text, Func}` entries, and keeps the current index in the global `Selection` (initially 1). Each frame it checks the three buttons listed under Controls and wraps the selection at both ends (`table.getn(SimpleMenu)` gives the entry count; Lua 5.0 has no `#` length operator). The selected function runs on the menu thread itself, so a function that loops (the test mission, the flag test, the sound test) stops the menu from reading input until it returns.

### Menu entries

Labels are quoted exactly as they appear in `Script.lua`.

| # | Label in game | Function | Effect |
|---|---------------|----------|--------|
| 1 | Say Hi ! | `testingBro1` | Prints "HI !" for three seconds. |
| 2 | Health | `testingBro2` | Restores the player's health to its maximum (`PedGetMaxHealth`, `PlayerSetHealth`). |
| 3 | Get Spud Gun | `testingBro3` | Puts the spud gun in weapon slot 1 (`PedOverrideStat(gPlayer, 45, 305)`; stat 45 is weapon slot 1 and 305 is the spud gun model). |
| 4 | Punishment Toggle | `testingBro4` | First press disables the punishment system and resets punishment points to 0; second press enables it again. State is kept in `switch`. |
| 5 | Kill Ped | `testingBro5` | Kills whatever ped the player is currently targeting (`PedGetTargetPed`, then `PedApplyDamage` with 100000). |
| 6 | Jimmy's Speed | `testingBro6` | Adds 25 to `JimmySpeed` and writes it to stat 20 (animation speed factor) with `GameSetPedStat`; above 400 it resets to 100. Prints the value as a percentage. |
| 7 | Start test mission | `testingBro7` | Sets `onMission` and runs `StartMission()` (see below). |
| 8 | Start Test Stimulus FUNCTION ! | `testingBro8` | Sets `onMission` and runs `testStim()` (see below). |
| 9 | Start Test Vehiacle moving from ped! | `testingBro9` | Loops `SoundPlay3D(270, -110, 6, 'NavDwn')` every 500 ms. The label does not match what the function does. |

Entries 7 and 8 share the `onMission` guard, which is never reset, so only one of the two tests can be started during a run.

### Test mission

`StartMission()` is a linear mission with a `Stage` counter that the `Informations` thread reads:

1. `Stage = 1`. Prints "Follow the marks on MiniMap!", adds a blip with `BlipAddXYZ(302, -72, 5, 0)`, creates three peds of model 31 (Tad, a Prep) at x = 302.5, 303 and 303.5, and starts the `Informations` thread. Waits until `PedInRectangle(gPlayer, x + 2, y + 2, x - 2, y - 2)` reports the player inside a 4 by 4 square around the blip.
2. `Stage = 2`. Removes the blip, prints "Beat those!", and for each enemy calls `PedSetPedToTypeAttitude(enemy, 13, 0)` (presumably faction 13 = Player and attitude 0 = Hate per derpy54320's ID tables; the function's parameters are not documented), `PedAttackPlayer(enemy, 3)` and `AddBlipForChar(enemy, 0, 26, 4)` (the values 0 and 26 match the Yellow Cross and Red Cross entries in the blip icon table). Waits until `PedsIsDead()` is true, then adds a second blip at (323, -98, 6) and waits for the player to reach it.
3. `Stage = 3`. Removes the second blip, prints "Last mark!!!", adds a third blip at (472, -89, 5), waits for the player to reach it and calls `MissionSucceed()`.

`PedsIsDead()` returns false while any of the three enemies is both valid (`PedIsValid`) and not dead (`PedIsDead`), and true otherwise.

`Informations()` runs forever and, whenever button 1 is pressed, prints a message that depends on `Stage`. The messages are informal and the Stage 3 one contains a stylised profanity.

### Ped flag test

`testStim()` creates a ped of model 31 at the start position, waits one second, makes it wander with `PedWander(testPed, true)` and starts the `FlagsMenu` thread. It then waits until `endOfTest` is set, prints "The test is over now!", waits two seconds and calls `MissionSucceed()`.

`FlagsMenu()` keeps a flag ID in `Selection` (starting at 2) and prints "Current Flag ID:" followed by the number every frame:

- Button 0 decrements the ID and wraps from 1 to 132; button 1 increments it and wraps from 132 to 1.
- Button 3 with ID 1 selected sets `endOfTest = true` and leaves the loop, ending the test.
- Button 3 with any other ID calls `PedSetFlag(gPlayer, id, true)`. If a flag was already set in this test (`FlagHasBeenSet`), the previous one stored in `tempFlag` is first cleared with `PedSetFlag(gPlayer, tempFlag, false)`.

The flags are applied to the player (`gPlayer`), not to the wandering ped that was spawned. The range 1 to 132 is the script's own choice; the sources consulted do not document the valid flag IDs.

### Globals

| Name | Initial value | Role |
|------|---------------|------|
| `switch` | 0 | Punishment toggle state (0 = system enabled, 1 = disabled). |
| `JimmySpeed` | 100 | Current value written to stat 20 (animation speed factor). |
| `onMission` | false | Guard so the test mission or flag test starts only once. |
| `endOfTest` | false | Set by `FlagsMenu` to end the flag test. |
| `FlagHasBeenSet` | false | Whether a flag from the flag test is currently active. |
| `tempFlag` | 0 | ID of the currently active test flag. |

`Selection`, `SimpleMenu`, `Stage`, `enemies`, `tempBlips` and `testPed` are also globals because they are assigned without `local`. `Selection` in particular is shared between `menu()` and `FlagsMenu()`.

## Known limitations and notes

- `Alive` is read by the loops in `menu()`, `FlagsMenu()` and `testingBro9()` (`until not Alive`) but is never assigned in the script and is not documented in the sources consulted. If the environment does not define it, `not Alive` is true on the first check and each of these loops runs exactly once.
- The speed entry steps 125, 150, ... 400, then on the next press briefly writes 425 before resetting to 100.
- The enemy blips and the third mark blip are never removed by the script.
- `MissionSucceed()` is called at the end of both tests, which suggests the script was written to run as a mission script rather than stay resident.
- Some printed strings are informal; the welcome line contains an asterisked word and one stage message contains a stylised profanity.
- The repository does not include a license file.

## Credits

- Written by Fibonacci (MahdiAhmed0 on GitHub).
- Button, stat, faction, attitude, blip and model IDs were checked against derpy54320's Bully LUA Reference (https://github.com/derpy54320/Bully-LUA-Reference, archived October 2023).
- `IsButtonBeingPressed` behaviour, DSL script entry points and the compile command were checked against the community Bully Scripting Docs (https://bully-scripting.vercel.app). The IMGTool steps follow a Steam community guide (https://steamcommunity.com/app/12200/discussions/0/4638240774906007922).

## Status

Experimental script, shared as-is for learning and experimentation. It has not been run again for this README; whether the menu stays open depends on the `Alive` variable described under Known limitations.
