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

// --- Pause: ESC opens pause; paused ESC → main menu; Space/Enter resumes ---
if (game_state == "paused") {
  if (keyboard_check_pressed(vk_escape)) {
    sumo_settings_save();
    room_goto(room_menu);
    exit;
  }
  if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
    game_state = paused_prev_state;
    sfx_try("snd_sumo_ui_confirm");
    exit;
  }
  exit;
}

if (keyboard_check_pressed(vk_escape)) {
  if (game_state == "playing") {
    paused_prev_state = "playing";
    game_state = "paused";
    sfx_try("snd_sumo_pause");
    exit;
  }
}

var cam = view_camera[0];

if (shake_duration > 0) {
  shake_duration--;
  camera_set_view_pos(cam, cam_rest_x + random_range(-shake_amount, shake_amount), cam_rest_y + random_range(-shake_amount, shake_amount));
  if (shake_duration <= 0) {
    camera_set_view_pos(cam, cam_rest_x, cam_rest_y);
  }
}

// Ring-out and player body overlap: see End Step (obj_game_manager Step_2.gml).
