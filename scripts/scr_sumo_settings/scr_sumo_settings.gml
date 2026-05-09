/// Sumo Shove — persisted settings (INI in save area)

// Fighter stat rows 0..6 map to per-player arrays (max_speed … shove_cd)

function sumo_settings_ini_path() {
  return working_directory + "sumo_settings.ini";
}

function sumo_fighter_stat_defaults() {
  global.sumo_fp_max_speed = [5, 5];
  global.sumo_fp_move_force = [0.62, 0.62];
  global.sumo_fp_shove_force = [12, 12];
  global.sumo_fp_shove_range = [64, 64];
  global.sumo_fp_knockback = [15, 15];
  global.sumo_fp_friction = [0.83, 0.83];
  global.sumo_fp_shove_cd = [45, 45];
}

function sumo_fighter_stat_clamp_row(row_index, val) {
  switch (row_index) {
    case 0:
      return clamp(val, 2, 12);
    case 1:
      return clamp(val, 0.2, 1.5);
    case 2:
      return clamp(val, 4, 24);
    case 3:
      return clamp(val, 32, 120);
    case 4:
      return clamp(val, 5, 35);
    case 5:
      return clamp(val, 0.5, 0.95);
    case 6:
      return clamp(round(val), 15, 120);
    default:
      return val;
  }
}

/// dir -1 or +1 — used by fighter stats menu (mouse / keyboard)
function sumo_fighter_stat_nudge(player_idx, row_index, dir) {
  var d = dir;
  switch (row_index) {
    case 0:
      global.sumo_fp_max_speed[player_idx] = sumo_fighter_stat_clamp_row(0, global.sumo_fp_max_speed[player_idx] + d * 0.25);
      break;
    case 1:
      global.sumo_fp_move_force[player_idx] = sumo_fighter_stat_clamp_row(1, global.sumo_fp_move_force[player_idx] + d * 0.02);
      break;
    case 2:
      global.sumo_fp_shove_force[player_idx] = sumo_fighter_stat_clamp_row(2, global.sumo_fp_shove_force[player_idx] + d * 0.5);
      break;
    case 3:
      global.sumo_fp_shove_range[player_idx] = sumo_fighter_stat_clamp_row(3, global.sumo_fp_shove_range[player_idx] + d * 4);
      break;
    case 4:
      global.sumo_fp_knockback[player_idx] = sumo_fighter_stat_clamp_row(4, global.sumo_fp_knockback[player_idx] + d * 0.5);
      break;
    case 5:
      global.sumo_fp_friction[player_idx] = sumo_fighter_stat_clamp_row(5, global.sumo_fp_friction[player_idx] + d * 0.02);
      break;
    case 6:
      global.sumo_fp_shove_cd[player_idx] = sumo_fighter_stat_clamp_row(6, global.sumo_fp_shove_cd[player_idx] + d * 3);
      break;
    default:
      break;
  }
}

function sumo_fighter_stat_slider_min(row_index) {
  switch (row_index) {
    case 0:
      return 2;
    case 1:
      return 0.2;
    case 2:
      return 4;
    case 3:
      return 32;
    case 4:
      return 5;
    case 5:
      return 0.5;
    case 6:
      return 15;
    default:
      return 0;
  }
}

function sumo_fighter_stat_slider_max(row_index) {
  switch (row_index) {
    case 0:
      return 12;
    case 1:
      return 1.5;
    case 2:
      return 24;
    case 3:
      return 120;
    case 4:
      return 35;
    case 5:
      return 0.95;
    case 6:
      return 120;
    default:
      return 1;
  }
}

/// Normalized 0..1 for drawing the fighter stat slider fill
function sumo_fighter_stat_slider_norm(player_idx, row_index) {
  var v = 0;
  switch (row_index) {
    case 0:
      v = global.sumo_fp_max_speed[player_idx];
      break;
    case 1:
      v = global.sumo_fp_move_force[player_idx];
      break;
    case 2:
      v = global.sumo_fp_shove_force[player_idx];
      break;
    case 3:
      v = global.sumo_fp_shove_range[player_idx];
      break;
    case 4:
      v = global.sumo_fp_knockback[player_idx];
      break;
    case 5:
      v = global.sumo_fp_friction[player_idx];
      break;
    case 6:
      v = global.sumo_fp_shove_cd[player_idx];
      break;
    default:
      return 0;
  }
  var vmin = sumo_fighter_stat_slider_min(row_index);
  var vmax = sumo_fighter_stat_slider_max(row_index);
  if (vmax <= vmin) {
    return 0;
  }
  return clamp((v - vmin) / (vmax - vmin), 0, 1);
}

/// Set stat from slider position t in 0..1 (mouse bar / drag)
function sumo_fighter_stat_set_from_slider(player_idx, row_index, t) {
  var vmin = sumo_fighter_stat_slider_min(row_index);
  var vmax = sumo_fighter_stat_slider_max(row_index);
  var tt = clamp(t, 0, 1);
  var v = vmin + tt * (vmax - vmin);
  switch (row_index) {
    case 0:
      global.sumo_fp_max_speed[player_idx] = sumo_fighter_stat_clamp_row(0, v);
      break;
    case 1:
      global.sumo_fp_move_force[player_idx] = sumo_fighter_stat_clamp_row(1, v);
      break;
    case 2:
      global.sumo_fp_shove_force[player_idx] = sumo_fighter_stat_clamp_row(2, v);
      break;
    case 3:
      global.sumo_fp_shove_range[player_idx] = sumo_fighter_stat_clamp_row(3, v);
      break;
    case 4:
      global.sumo_fp_knockback[player_idx] = sumo_fighter_stat_clamp_row(4, v);
      break;
    case 5:
      global.sumo_fp_friction[player_idx] = sumo_fighter_stat_clamp_row(5, v);
      break;
    case 6:
      global.sumo_fp_shove_cd[player_idx] = sumo_fighter_stat_clamp_row(6, v);
      break;
    default:
      break;
  }
}

function sumo_stage_count() {
  return 4;
}

function sumo_stage_radius(stage_index) {
  switch (clamp(stage_index, 0, sumo_stage_count() - 1)) {
    case 0:
      return 200;
    case 1:
      return 175;
    case 2:
      return 228;
    case 3:
      return 185;
    default:
      return 200;
  }
}

function sumo_stage_floor_rgb(stage_index) {
  switch (clamp(stage_index, 0, sumo_stage_count() - 1)) {
    case 0:
      return make_color_rgb(96, 140, 180);
    case 1:
      return make_color_rgb(210, 130, 85);
    case 2:
      return make_color_rgb(150, 205, 235);
    case 3:
      return make_color_rgb(72, 58, 110);
    default:
      return make_color_rgb(96, 140, 180);
  }
}

function sumo_stage_edge_rgb(stage_index) {
  switch (clamp(stage_index, 0, sumo_stage_count() - 1)) {
    case 0:
      return make_color_rgb(48, 72, 96);
    case 1:
      return make_color_rgb(120, 72, 48);
    case 2:
      return make_color_rgb(75, 115, 145);
    case 3:
      return make_color_rgb(190, 95, 210);
    default:
      return make_color_rgb(48, 72, 96);
  }
}

function sumo_stage_name(stage_index) {
  switch (clamp(stage_index, 0, sumo_stage_count() - 1)) {
    case 0:
      return "Classic Ring";
    case 1:
      return "Sunset Arena";
    case 2:
      return "Ice Vault";
    case 3:
      return "Neon Pit";
    default:
      return "Classic Ring";
  }
}

/// Called when entering the match — updates platform visuals and globals (obj_platform must exist)
function sumo_stage_apply() {
  var si = clamp(global.sumo_stage_index, 0, sumo_stage_count() - 1);
  global.sumo_stage_index = si;
  var rad = sumo_stage_radius(si);
  var fc = sumo_stage_floor_rgb(si);
  var ec = sumo_stage_edge_rgb(si);
  global.sumo_ring_warn_dist = clamp(round(rad * 0.2), 32, 56);

  if (instance_exists(obj_platform)) {
    with (obj_platform) {
      platform_radius = rad;
      floor_color = fc;
      edge_color = ec;
      global.platform_cx = x;
      global.platform_cy = y;
      global.platform_radius = platform_radius;
    }
  }
}

/// Match spawn points to platform center and ring size
function sumo_stage_sync_spawns() {
  if (!instance_exists(obj_platform)) {
    return;
  }
  var pcx = 683;
  var pcy = 384;
  var rad = 200;
  with (obj_platform) {
    pcx = x;
    pcy = y;
    rad = platform_radius;
  }
  var ox = clamp(rad - 80, 88, 142);
  if (instance_exists(obj_game_manager)) {
    with (obj_game_manager) {
      p1_start_x = pcx - ox;
      p2_start_x = pcx + ox;
      p1_start_y = pcy;
      p2_start_y = pcy;
    }
  }
}

function sumo_settings_defaults() {
  global.sumo_master_vol = 0.85;
  global.sumo_sfx_vol = 1;
  global.sumo_screen_shake = 1;
  global.sumo_trails = true;
  global.sumo_wins_needed = 3;
  global.sumo_max_rounds = 5;
  global.sumo_show_instructions = true;
  global.sumo_stage_index = 0;
  global.sumo_ring_warn_dist = 40;
  global.sumo_settings_ready = true;
  sumo_fighter_stat_defaults();
}

function sumo_settings_apply_audio() {
  audio_master_gain(global.sumo_master_vol);
  audio_group_set_gain(audiogroup_default, global.sumo_sfx_vol, 0);
}

function sumo_settings_load() {
  sumo_settings_defaults();
  var fn = sumo_settings_ini_path();
  if (!file_exists(fn)) {
    sumo_settings_apply_audio();
    return;
  }

  ini_open(fn);
  global.sumo_master_vol = clamp(ini_read_real("Audio", "master", global.sumo_master_vol), 0, 1);
  global.sumo_sfx_vol = clamp(ini_read_real("Audio", "sfx", global.sumo_sfx_vol), 0, 1);
  global.sumo_screen_shake = clamp(ini_read_real("Gameplay", "shake", global.sumo_screen_shake), 0, 1.25);
  global.sumo_trails = ini_read_real("Gameplay", "trails", global.sumo_trails ? 1 : 0) >= 0.5;
  global.sumo_wins_needed = clamp(round(ini_read_real("Match", "wins_needed", global.sumo_wins_needed)), 1, 9);
  global.sumo_max_rounds = clamp(round(ini_read_real("Match", "max_rounds", global.sumo_max_rounds)), 1, 15);
  if (global.sumo_max_rounds < global.sumo_wins_needed) {
    global.sumo_max_rounds = global.sumo_wins_needed;
  }
  global.sumo_show_instructions = ini_read_real("Match", "show_intro", global.sumo_show_instructions ? 1 : 0) >= 0.5;
  global.sumo_stage_index = clamp(round(ini_read_real("Match", "stage", global.sumo_stage_index)), 0, sumo_stage_count() - 1);

  for (var fp = 0; fp < 2; fp++) {
    var sec = (fp == 0) ? "FighterP1" : "FighterP2";
    global.sumo_fp_max_speed[fp] = sumo_fighter_stat_clamp_row(0, ini_read_real(sec, "max_speed", global.sumo_fp_max_speed[fp]));
    global.sumo_fp_move_force[fp] = sumo_fighter_stat_clamp_row(1, ini_read_real(sec, "move_force", global.sumo_fp_move_force[fp]));
    global.sumo_fp_shove_force[fp] = sumo_fighter_stat_clamp_row(2, ini_read_real(sec, "shove_force", global.sumo_fp_shove_force[fp]));
    global.sumo_fp_shove_range[fp] = sumo_fighter_stat_clamp_row(3, ini_read_real(sec, "shove_range", global.sumo_fp_shove_range[fp]));
    global.sumo_fp_knockback[fp] = sumo_fighter_stat_clamp_row(4, ini_read_real(sec, "knockback", global.sumo_fp_knockback[fp]));
    global.sumo_fp_friction[fp] = sumo_fighter_stat_clamp_row(5, ini_read_real(sec, "friction", global.sumo_fp_friction[fp]));
    global.sumo_fp_shove_cd[fp] = sumo_fighter_stat_clamp_row(6, ini_read_real(sec, "shove_cd", global.sumo_fp_shove_cd[fp]));
  }

  ini_close();

  sumo_settings_apply_audio();
}

function sumo_settings_save() {
  var fn = sumo_settings_ini_path();
  ini_open(fn);
  ini_write_real("Audio", "master", global.sumo_master_vol);
  ini_write_real("Audio", "sfx", global.sumo_sfx_vol);
  ini_write_real("Gameplay", "shake", global.sumo_screen_shake);
  ini_write_real("Gameplay", "trails", global.sumo_trails ? 1 : 0);
  ini_write_real("Match", "wins_needed", global.sumo_wins_needed);
  ini_write_real("Match", "max_rounds", global.sumo_max_rounds);
  ini_write_real("Match", "show_intro", global.sumo_show_instructions ? 1 : 0);
  ini_write_real("Match", "stage", global.sumo_stage_index);

  for (var fp = 0; fp < 2; fp++) {
    var sec = (fp == 0) ? "FighterP1" : "FighterP2";
    ini_write_real(sec, "max_speed", global.sumo_fp_max_speed[fp]);
    ini_write_real(sec, "move_force", global.sumo_fp_move_force[fp]);
    ini_write_real(sec, "shove_force", global.sumo_fp_shove_force[fp]);
    ini_write_real(sec, "shove_range", global.sumo_fp_shove_range[fp]);
    ini_write_real(sec, "knockback", global.sumo_fp_knockback[fp]);
    ini_write_real(sec, "friction", global.sumo_fp_friction[fp]);
    ini_write_real(sec, "shove_cd", global.sumo_fp_shove_cd[fp]);
  }

  ini_close();
}
