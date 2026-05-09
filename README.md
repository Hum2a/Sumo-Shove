# Sumo Shove — Cursor Prompt Kit

Everything you need to build Sumo Shove in GameMaker using Cursor as your AI coding assistant.

## What's in here

```
.cursor/
  rules/
    gml.mdc          ← Core GML rules, applied to every file
    game-manager.mdc ← Rules scoped to obj_game_manager
    player.mdc       ← Rules scoped to obj_player
PROMPTS.md           ← All prompts in order, paste into Cursor chat
README.md            ← This file
```

## Setup

1. **Create your GameMaker project** — File → New Project → Blank
2. **Copy this folder's `.cursor/` directory** into your GameMaker project root
   (same level as the `.yyp` file)
3. **Open the GameMaker project folder in Cursor**
4. Work through `PROMPTS.md` top to bottom

## Workflow

```
Cursor (write code) → Save file → GameMaker (F5 to run) → verify → next prompt
```

Don't skip ahead. Each prompt assumes the previous one is working.

## GameMaker setup checklist (before coding)

Create these assets manually in GameMaker IDE first:

**Objects**
- [ ] `obj_player`
- [ ] `obj_platform`
- [ ] `obj_game_manager`
- [ ] `obj_shove_effect`
- [ ] `obj_score_screen`
- [ ] `obj_trail_particle` (optional)

**Sprites**
- [ ] `spr_player` — 32x32 filled circle, origin center
- [ ] `spr_platform` — can leave empty, obj_platform draws itself in code

**Rooms**
- [ ] `room_game` — place obj_platform at center, obj_player x2, obj_game_manager x1
- [ ] `room_score` — place obj_score_screen x1

**Room editor — instance creation code**
- obj_player instance 1: `player_id = 1;`
- obj_player instance 2: `player_id = 2;`

## Phases

| Phase | What you build | Key GML concepts learned |
|---|---|---|
| 1 | Player movement | Input, velocity, friction |
| 2 | Platform + boundary | Globals, distance checks, collision |
| 3 | Shove mechanic | Velocity bursts, knockback, effects |
| 4 | Round system | State machines, alarms, with() |
| 5 | Score screen | Rooms, globals, game_restart() |
| 6 | Polish + GX upload | Camera, countdowns, GX Game Options |

## Tips

- If Cursor generates JS syntax by mistake, paste this reminder: *"This is GML not JavaScript. No const/let/=>/===. Use var for locals, bare assignment for instance vars."*
- Always test in GameMaker after each prompt before moving on
- The `.cursor/rules/*.mdc` files are auto-applied by Cursor based on the `globs` field — you don't need to manually reference them in prompts
