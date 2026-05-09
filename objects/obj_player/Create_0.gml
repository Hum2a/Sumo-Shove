// 1 = P1, 2 = P2 — use sumo_slot (player_id is readonly in current GameMaker runtimes)
if (!variable_global_exists("sumo_player_id_counter")) {
  global.sumo_player_id_counter = 0;
}
global.sumo_player_id_counter += 1;
sumo_slot = global.sumo_player_id_counter;

sprite_index = spr_player_idle;

// Strip sprites are one texture (e.g. 256×64 = 4×64 cells); origin is per-cell center.
anim_cell_size = 64;
sprite_set_offset(spr_player_idle, anim_cell_size / 2, anim_cell_size / 2);
sprite_set_offset(spr_player_walk, anim_cell_size / 2, anim_cell_size / 2);
sprite_set_offset(spr_player_shove, anim_cell_size / 2, anim_cell_size / 2);
sprite_set_offset(spr_player_fall, anim_cell_size / 2, anim_cell_size / 2);
sprite_set_offset(spr_player_win, anim_cell_size / 2, anim_cell_size / 2);

// --- Animation state ---
anim_index = 0;
prev_anim_sprite = spr_player_idle;
is_moving = false;
is_shoving = false;
is_winning = false;
anim_spd_idle = 0.1;
anim_spd_walk = 0.2;
anim_spd_shove = 0.3;
anim_spd_fall = 0.2;
anim_spd_win = 0.15;

// --- Circular body (solid overlap resolution in obj_game_manager End Step) ---
// Tuned for 64x64 spr_player (texture was resized to match asset bounds).
collision_radius = 15;

// --- Movement (Stage A tuning — tweak for GX feel) ---
spd_x = 0;
spd_y = 0;
move_force = 0.62;
friction_amount = 0.83;
max_speed = 5;

// --- Facing (degrees; used for shove direction + draw rotation) ---
face_angle = 0;
// fat_sumo art faces toward +y ("down" on screen) at image_angle 0; align rotation to movement direction
sprite_face_angle_offset = -90;

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

image_speed = anim_spd_idle;
