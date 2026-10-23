# Bully Mod Menu (Lua)

An in-game Lua menu for Bully: Scholarship Edition, used to test script functions, prototype a mission and change player state while playing.

## Overview

`Script.lua` is laid out like one of the game's mission scripts: `MissionSetup()` places the player and `main()` starts a menu thread. The menu started as a debugging aid for my other Bully scripts, which is where the test-style function names and informal messages come from.

## Menu entries

| # | Entry | Effect |
|---|---|---|
| 1 | Say Hi ! | Prints a greeting. |
| 2 | Health | Restores the player's health to its maximum. |
| 3 | Get Spud Gun | Puts the spud gun in weapon slot 1. |
| 4 | Punishment Toggle | Disables or re-enables the punishment system and resets punishment points. |
| 5 | Kill Ped | Kills the ped the player is targeting. |
| 6 | Jimmy's Speed | Raises the animation speed stat in steps of 25 percent, from 100 up to 400, then back to 100. |
| 7 | Start test mission | Three-stage mission: follow a blip, fight three peds, reach two more marks. |
| 8 | Start Test Stimulus FUNCTION ! | Spawns a wandering ped and opens a menu that cycles `PedSetFlag` IDs 1 to 132 on the player, one at a time. |
| 9 | Start Test Vehiacle moving from ped! | Loops a 3D sound at a fixed point. |

## Controls

| Button ID | Game action | Menu | Flag test |
|---|---|---|---|
| 0 | Show Secondary Tasks | Previous entry | Flag ID minus 1 |
| 1 | Show Tasks/Objectives | Next entry | Flag ID plus 1 |
| 3 | Zoom out | Activate entry | Set the flag (ID 1 ends the test) |

The IDs are the game's control actions; the physical key or gamepad button is whatever the game binds to that action.

## How it works

- `menu()` keeps the entries in a `{text, Func}` table, reads the three buttons with `IsButtonBeingPressed` each frame and prints the selected label with `TextPrintString`.
- `StartMission()` drives the test mission with a `Stage` counter; an `Informations` thread prints a stage-specific message on request.
- `testStim()` and `FlagsMenu()` apply one ped flag at a time, clearing the previous one before setting the next.
- Globals such as `switch`, `JimmySpeed`, `onMission` and `tempFlag` carry state between the menu functions.

## Running the script

- Bully: Scholarship Edition on PC.
- Load it with Derpy's Script Loader (DSL) from its `_derpy_script_loader/scripts` folder, or compile it with the Bully build of the Lua 5.0.2 `luac` (available from the Bully Scripting Docs) and place the `.lur` in `Scripts/Scripts.img` in place of a built-in script such as `ArcRace1.lur`.

## Notes

- Some printed strings are informal.
- Written as part of early Lua scripting experimentation and game modding research, and shared for learning.

## Credits

- Written by Mahdi (Fibonacci).
- Button, stat and model IDs were checked against derpy54320's Bully LUA Reference.
