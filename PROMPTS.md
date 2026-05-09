# Sumo Shove — Cursor Prompt Playbook

> **This repo:** `player_id` is readonly in current GameMaker runtimes. The implementation uses **`sumo_slot`** (1 or 2) and `global.sumo_player_id_counter` from `obj_platform` / `obj_player` Create. When a prompt below says `player_id`, use `sumo_slot` in code.

Use these prompts in order. Each one builds on the last.
Before running any prompt, make sure your `.cursor/rules/` files are in place.

Paste each prompt into Cursor's chat (CMD+L or the chat panel).
After each prompt: save, switch to GameMaker, hit F5 and verify it works before moving on.

---

## PHASE 1 — Player Movement

### Prompt 1.1 — Player Create Event
```
I'm building a 2-player local party game in GameMaker called Sumo Shove.
Players try to push each other off a circular platform. Best of 5 rounds.

Write the full Create event for obj_player in GML.

Requirements:
- player_id variable (1 or 2, set per-instance in room editor)
- Manual velocity variables: spd_x, spd_y, move_force, friction_amount, max_speed
- face_angle variable to track which direction the player is facing
- Shove variables: shove_cooldown, shove_cooldown_max (45 frames), shove_force, knockback_force, shove_range (64px), shove_duration
- is_dead boolean, starts false

Add a comment above each variable group explaining what it does.
```

### Prompt 1.2 — Player Step Event (movement only)
```
Write the Step event for obj_player in GML. This is movement only — no shoving yet.

Requirements:
- Read input based on player_id:
    Player 1: WASD to move, F to shove (just detect it, don't implement shove yet)
    Player 2: Arrow keys to move, L to shove
- Apply input to spd_x/spd_y using move_force
- Clamp to max_speed using point_distance
- Apply friction_amount multiplier each frame
- Move: x += spd_x, y += spd_y
- Update face_angle when there is directional input using point_direction
- Tick shove_cooldown down to 0
- Skip all input if is_dead == true

Use keyboard_check() for held movement, keyboard_check_pressed() for shove.
```

### Prompt 1.3 — Player Draw Event
```
Write the Draw event for obj_player in GML.

Requirements:
- draw_self() to render the sprite
- Above the player, draw "P1" or "P2" depending on player_id
- P1 label is blue (c_blue), P2 label is red (c_red)
- Text is centered horizontally, bottom-aligned vertically
- Reset halign and valign to defaults (fa_left, fa_top) after drawing text

Keep it minimal, no gameplay logic in here.
```

---

## PHASE 2 — Platform & Boundary

### Prompt 2.1 — Platform Create Event
```
Write the Create event for obj_platform in GML.

This object draws the circular arena and exposes its dimensions as global variables
so other objects (like obj_player) can reference them for boundary detection.

Requirements:
- platform_radius = 200 (pixels)
- Store platform center as global.platform_cx = x and global.platform_cy = y
  (this object will be placed at the center of the room)
- Store global.platform_radius = platform_radius
- A floor_color and edge_color variable for drawing
```

### Prompt 2.2 — Platform Draw Event
```
Write the Draw event for obj_platform in GML.

Requirements:
- Draw a filled circle for the platform floor (use draw_circle)
- Draw a thicker outline circle for the edge to show the boundary clearly
- Use a slightly darker color for the edge than the floor
- Platform is centered at x, y (which equals global.platform_cx/cy)
- Do not draw the sprite — this object has no sprite, it's purely code-drawn
```

### Prompt 2.3 — Out-of-bounds detection in Player Step
```
Add out-of-bounds detection to the END of the existing obj_player Step event in GML.

Requirements:
- Calculate distance from player's current x,y to global.platform_cx, global.platform_cy
- If distance > global.platform_radius AND is_dead is false:
    - Set is_dead = true
    - Call player_fell on obj_game_manager, passing this player's player_id:
      with (obj_game_manager) { player_fell(other.player_id); }
- This block must come AFTER the movement code so it checks the updated position

Do not touch any other part of the Step event.
```

---

## PHASE 3 — Shove Mechanic

### Prompt 3.1 — Shove logic in Player Step
```
Add the shove mechanic to obj_player's Step event in GML.
Insert this block after input is read but before movement is applied.

Requirements:
- Trigger when: key_shove is pressed AND shove_cooldown == 0 AND is_dead == false
- On trigger:
    1. Set shove_cooldown = shove_cooldown_max
    2. Apply self-lunge: add lengthdir_x(shove_force, face_angle) to spd_x,
       and lengthdir_y(shove_force, face_angle) to spd_y
    3. Find nearest other player: var opponent = instance_nearest(x, y, obj_player)
       Make sure opponent != self (use id comparison)
    4. If point_distance(x, y, opponent.x, opponent.y) <= shove_range:
         - Apply knockback to opponent:
           opponent.spd_x += lengthdir_x(knockback_force, face_angle)
           opponent.spd_y += lengthdir_y(knockback_force, face_angle)
    5. Create a shove effect at this position:
       instance_create_layer(x, y, "Instances", obj_shove_effect)

Add a comment block above this section: // --- SHOVE ---
```

### Prompt 3.2 — Shove Effect object
```
Write all events for obj_shove_effect in GML.
This is a short-lived visual burst that appears when a shove fires.

Create event:
- lifetime = 20 (frames)
- start_radius = 8
- end_radius = 40
- start_alpha = 1
- end_alpha = 0

Step event:
- Count down lifetime
- Destroy self when lifetime reaches 0

Draw event:
- Calculate progress = 1 - (lifetime / 20)  — goes from 0 to 1 as it dies
- Interpolate radius: current_radius = lerp(start_radius, end_radius, progress)
- Interpolate alpha: draw_set_alpha(lerp(start_alpha, end_alpha, progress))
- draw_set_color(c_white)
- Draw an outlined circle at x, y with current_radius
- Reset alpha to 1 after drawing

No sprite needed. Pure code drawing.
```

---

## PHASE 4 — Game Manager & Round System

### Prompt 4.1 — Game Manager Create Event
```
Write the Create event for obj_game_manager in GML.

This is the singleton that controls all game state.
There is exactly one instance of this in room_game.

Requirements:
- game_state = "playing"  (states: "playing", "round_end", "series_end")
- p1_score = 0
- p2_score = 0
- round_num = 1
- max_rounds = 5
- wins_needed = 3
- round_end_delay = 180  (3 seconds at 60fps, used for alarm)
- Start positions for both players (match your room layout):
    p1_start_x, p1_start_y
    p2_start_x, p2_start_y
- round_winner = 0  (0 = nobody yet, set when round ends)
```

### Prompt 4.2 — player_fell function
```
Write a function called player_fell for obj_game_manager in GML.
This should go in a Script event or User Event 0 on the object.

Arguments: player_id_who_fell (the player who went out of bounds)

Logic:
- If game_state != "playing", exit the function early (return)
- Set game_state = "round_end"
- Award a point to the OTHER player:
    if player_id_who_fell == 1: p2_score++, round_winner = 2
    if player_id_who_fell == 2: p1_score++, round_winner = 1
- Start alarm[0] = round_end_delay

Note: in GML, define this as a method in Create event:
player_fell = function(pid) { ... }
```

### Prompt 4.3 — Game Manager Alarm[0] (round reset)
```
Write the Alarm[0] event for obj_game_manager in GML.
This fires after the round-end pause.

Logic:
- Check if either player has reached wins_needed (3):
    if p1_score >= wins_needed or p2_score >= wins_needed:
        - Set game_state = "series_end"
        - Store results in globals for the score screen:
            global.p1_final_score = p1_score
            global.p2_final_score = p2_score
            global.series_winner = (p1_score >= wins_needed) ? 1 : 2
        - room_goto(room_score)
        - Return
- Otherwise, start the next round:
    - round_num++
    - round_winner = 0
    - Reset both players using with(obj_player):
        with (obj_player) {
            x = (player_id == 1) ? other.p1_start_x : other.p2_start_x;
            y = (player_id == 1) ? other.p1_start_y : other.p2_start_y;
            spd_x = 0;
            spd_y = 0;
            is_dead = false;
        }
    - Set game_state = "playing"
```

### Prompt 4.4 — Game Manager Draw GUI (HUD)
```
Write the Draw GUI event for obj_game_manager in GML.
Draw GUI renders in screen space, not world space — use GUI coordinates.

Requirements:
- At the top center of the screen, draw: "Round round_num / max_rounds"
  Assume display_get_gui_width() for center x, y = 30
- On the left side (x=60, y=80), draw "P1" in blue and then p1_score below it
- On the right side (x = display_get_gui_width()-60, y=80), draw "P2" in red and p2_score
- Score as filled circle pips: draw a filled circle for each win earned, outlined circle for each win remaining
  (3 pips per player, filled = won, outlined = remaining)
- If game_state == "round_end":
    Draw centered text in the middle of the screen: "Player X wins the round!"
    where X = round_winner
    Use a large font if you have one set, otherwise default

Reset all draw settings (color, alpha, halign, valign) at the end of this event.
```

---

## PHASE 5 — Score Screen

### Prompt 5.1 — Score Screen Controller Create Event
```
Write the Create event for obj_score_screen in GML.
This object lives in room_score and handles the end-of-series screen.

Requirements:
- Read from globals set by game_manager:
    winner = global.series_winner
    p1_score = global.p1_final_score
    p2_score = global.p2_final_score
- rematch_available = true
- A simple "press Enter to rematch" prompt
```

### Prompt 5.2 — Score Screen Step Event
```
Write the Step event for obj_score_screen in GML.

Requirements:
- If keyboard_check_pressed(vk_return) or keyboard_check_pressed(vk_space):
    - Reset globals:
        global.p1_final_score = 0
        global.p2_final_score = 0
        global.series_winner = 0
    - game_restart() — this resets everything and goes back to the first room
```

### Prompt 5.3 — Score Screen Draw Event
```
Write the Draw event for obj_score_screen in GML.
This is the full winner/score display.

Requirements:
- Black background: draw_rectangle covering the full room
- Large centered title: "Player X Wins!" where X = winner variable
  Player 1 winner → blue text, Player 2 winner → red text
- Below title: show the final score, e.g. "3 – 2"
- Below score: show each player's pip score (same filled/outlined circle style as HUD)
- At the bottom: "Press ENTER or SPACE to rematch"
- Use room_width / 2 for horizontal center, space elements vertically

Make it feel like a proper results screen, not just a debug printout.
```

---

## PHASE 6 — Polish & GX.games Prep

### Prompt 6.1 — Screen shake on shove hit
```
Add screen shake to obj_game_manager in GML.

When a shove lands on an opponent (not a whiff), trigger a small screen shake.

Requirements:
- Add shake_amount = 0 and shake_duration = 0 to Create event
- Add a trigger_shake(amount, duration) method in Create event
- In the Step event: if shake_duration > 0, apply camera offset using
  camera_set_view_pos with a random offset of +/- shake_amount, then decrement shake_duration
  When shake_duration hits 0, reset camera to normal position
- shake_amount should be around 4–6 pixels, shake_duration around 10–12 frames
- obj_player should call this when a shove connects:
  with (obj_game_manager) { trigger_shake(5, 10); }

Note: use the default view camera. Get it with camera_get_active() or view_camera[0].
```

### Prompt 6.2 — Countdown before each round
```
Add a 3-2-1 countdown before each round starts in obj_game_manager GML.

Requirements:
- Add a new game_state: "countdown"
- When a round starts (both at game start and after reset), set game_state = "countdown"
  and countdown_value = 3, then start alarm[1] = 60 (fires every second)
- Alarm[1] event: decrement countdown_value. If it hits 0, set game_state = "playing".
  Otherwise restart alarm[1] = 60.
- In Draw GUI: if game_state == "countdown", draw the countdown number centered on screen
  in large text (use a big font if available)
- In obj_player Step: add game_state check — only process input if:
  with (obj_game_manager) { if (game_state != "playing") return; }
  (Check this at the very top of the Step event before any input is read)
```

### Prompt 6.3 — Player respawn animation
```
Add a brief spawn-in animation to obj_player in GML.

When is_dead is set back to false (round reset), the player should flash for ~60 frames
to show they've just respawned and are temporarily visible but the round hasn't started.

Requirements:
- Add spawn_timer = 0 to Create event
- When reset by game manager, also set spawn_timer = 60 on each player
- In Step: if spawn_timer > 0, decrement it
- In Draw: if spawn_timer > 0, flash the sprite by toggling draw_set_alpha
  between 1 and 0.3 every 6 frames using (spawn_timer mod 12 < 6)
- Reset alpha to 1 when spawn_timer == 0

This gives visual feedback that a new round is about to start.
```

### Prompt 6.4 — GX.games Game Options checklist
```
I need to prepare this GameMaker project for upload to GX.games (Opera GX).

Write me a plain text checklist of everything I need to configure in GameMaker's
Game Options > Opera GX before uploading, including:
- Game name and display name
- Version number format
- Resolution and aspect ratio settings
- Interpolation / pixel settings
- Any GX-specific settings I should know about
- The upload process from inside GameMaker (the "Create Executable" / upload flow)
- File size limit to be aware of

Format it as a numbered checklist I can tick off.
```

---

## OPTIONAL — Nice to haves

### Prompt OPT.1 — Win streak taunt text
```
In obj_game_manager's Draw GUI event, add a taunt line that appears after a round ends.

If one player is ahead 2-0 or 3-1 in wins, show a trash talk line above the score.
Examples: "Dominant.", "Is that all?", "Don't go easy on me."
Pick randomly from an array of 5 taunts defined in Create event.

Show it in the winning player's color during the round_end state.
```

### Prompt OPT.2 — Simple particle trail on players
```
Add a simple motion trail to obj_player in GML.

Every 3 frames, if the player is moving fast (point_distance(0,0,spd_x,spd_y) > 2),
spawn a trail particle at the current x,y.

Create a new object obj_trail_particle with:
- Create event: lifetime = 15, starting alpha = 0.5, color matches player_id
  (c_blue for P1, c_red for P2) — set color as a variable passed in after creation
- Step event: lifetime--, destroy when 0, fade alpha each frame
- Draw event: draw a small filled circle (radius 6) at x,y with current alpha and color

In obj_player Step, spawn trail particles and immediately set their color variable.
```

### Prompt OPT.3 — Platform edge danger flash
```
In obj_platform's Draw event, add a danger indicator.

If any player is within 40px of the platform edge (distance from platform center > platform_radius - 40),
draw a pulsing red ring around the edge of the platform.

The ring pulses opacity using sin(current_time / 200) to create a breathing effect.
Check all instances of obj_player with a with() loop.

This gives visual feedback when a player is close to falling.
```
