game_state = "countdown";
p1_score = 0;
p2_score = 0;
round_num = 1;
max_rounds = 5;
wins_needed = 3;
round_end_delay = 150;
round_winner = 0;

p1_start_x = 563;
p1_start_y = 384;
p2_start_x = 803;
p2_start_y = 384;

shake_amount = 0;
shake_duration = 0;
cam_rest_x = 0;
cam_rest_y = 0;

countdown_value = 3;
boot_done = false;
controls_intro_done = false;
paused_prev_state = "playing";
dk_timer = 0;

taunt_lines[0] = "Dominant.";
taunt_lines[1] = "Is that all?";
taunt_lines[2] = "Don't go easy on me.";
taunt_lines[3] = "Too easy.";
taunt_lines[4] = "Try harder.";

// --- Stage B: optional SFX — create Sound resources with these exact names in the IDE, or leave unassigned ---
sfx_try = function(asset_name) {
  var idx = asset_get_index(asset_name);
  if (idx != -1) {
    audio_play_sound(idx, 10, false);
  }
};

player_fell = function(pid) {
  if (game_state != "playing") {
    return;
  }

  game_state = "round_end";

  if (pid == 1) {
    p2_score++;
    round_winner = 2;
  } else if (pid == 2) {
    p1_score++;
    round_winner = 1;
  }

  alarm[0] = round_end_delay;
  sfx_try("snd_sumo_round_win");
};

trigger_shake = function(amount, dur) {
  var cam = view_camera[0];
  cam_rest_x = camera_get_view_x(cam);
  cam_rest_y = camera_get_view_y(cam);
  shake_amount = amount;
  shake_duration = dur;
};
