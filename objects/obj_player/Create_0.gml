// 1 = P1, 2 = P2 — use sumo_slot (player_id is readonly in current GameMaker runtimes)
if (!variable_global_exists("sumo_player_id_counter")) {
  global.sumo_player_id_counter = 0;
}
global.sumo_player_id_counter += 1;
sumo_slot = global.sumo_player_id_counter;

// Center sprite on (x, y) — spr_player uses top-left origin in the asset
var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);
sprite_set_offset(sprite_index, sw / 2, sh / 2);

// --- Circular body (solid overlap resolution in obj_game_manager End Step) ---
collision_radius = 22;

// --- Movement (Stage A tuning — tweak for GX feel) ---
spd_x = 0;
spd_y = 0;
move_force = 0.62;
friction_amount = 0.83;
max_speed = 5;

// --- Facing (degrees; used for shove direction and labels) ---
face_angle = 0;

// --- Shove (cooldown, hit range, self-lunge and knockback) ---
shove_cooldown = 0;
shove_cooldown_max = 45;
shove_force = 12;
knockback_force = 15;
shove_range = 64;
// Half-angle (degrees): opponent must be in front of face_angle within this cone
shove_cone_half = 52;
shove_duration = 8;

// --- State (dead players ignore input after falling off) ---
is_dead = false;

// --- Brief spawn flash after each round reset ---
spawn_timer = 0;

// --- Optional motion trail cadence ---
trail_phase = 0;

// --- Juice (Stages B/C): knockback receive pulse / shove snap ---
hit_pulse_timer = 0;
shove_hit_flash = 0;
