// --- Instructions (Stage A): dismiss with Space / Enter ---
if (game_state == "instructions") {
  if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
    controls_intro_done = true;
    game_state = "countdown";
    countdown_value = 3;
    alarm[1] = 60;
    sfx_try("snd_sumo_ui_confirm");
  }
  exit;
}

// --- Double KO brief beat before countdown ---
if (game_state == "double_ko") {
  dk_timer--;
  if (dk_timer <= 0) {
    game_state = "countdown";
    countdown_value = 3;
    alarm[1] = 60;
    sfx_try("snd_sumo_countdown");
  }
  exit;
}

// --- Pause (Stage C): ESC ---
if (keyboard_check_pressed(vk_escape)) {
  if (game_state == "playing") {
    paused_prev_state = "playing";
    game_state = "paused";
    sfx_try("snd_sumo_pause");
    exit;
  }
  if (game_state == "paused") {
    game_state = paused_prev_state;
    sfx_try("snd_sumo_ui_confirm");
    exit;
  }
}

if (game_state == "paused") {
  exit;
}

var cam = view_camera[0];

if (shake_duration > 0) {
  shake_duration--;
  camera_set_view_pos(cam, cam_rest_x + random_range(-shake_amount, shake_amount), cam_rest_y + random_range(-shake_amount, shake_amount));
  if (shake_duration <= 0) {
    camera_set_view_pos(cam, cam_rest_x, cam_rest_y);
  }
}

// --- Out-of-bounds (Stage A): resolve after players moved; handles simultaneous ring-outs ---
if (game_state != "playing") {
  exit;
}

var fell_inst = [];
with (obj_player) {
  if (!is_dead) {
    var pd = point_distance(x, y, global.platform_cx, global.platform_cy);
    if (pd > global.platform_radius) {
      array_push(fell_inst, id);
    }
  }
}

var fc = array_length(fell_inst);

if (fc == 1) {
  var who = fell_inst[0];
  who.is_dead = true;
  player_fell(who.sumo_slot);
  sfx_try("snd_sumo_fall");
} else if (fc >= 2) {
  for (var i = 0; i < fc; i++) {
    fell_inst[i].is_dead = true;
  }
  game_state = "double_ko";
  dk_timer = 75;
  with (obj_player) {
    x = (sumo_slot == 1) ? other.p1_start_x : other.p2_start_x;
    y = (sumo_slot == 1) ? other.p1_start_y : other.p2_start_y;
    spd_x = 0;
    spd_y = 0;
    is_dead = false;
    spawn_timer = 60;
    hit_pulse_timer = 0;
    shove_hit_flash = 0;
  }
  sfx_try("snd_sumo_double_ko");
}
