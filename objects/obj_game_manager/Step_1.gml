if (boot_done) {
  exit;
}

boot_done = true;

with (obj_player) {
  x = (sumo_slot == 1) ? other.p1_start_x : other.p2_start_x;
  y = (sumo_slot == 1) ? other.p1_start_y : other.p2_start_y;
  spd_x = 0;
  spd_y = 0;
  is_dead = false;
  is_shoving = false;
  is_winning = false;
  anim_index = 0;
  prev_anim_sprite = spr_player_idle;
  shove_charge = 0;
  spawn_timer = 60;
  hit_pulse_timer = 0;
  shove_hit_flash = 0;
  shove_cooldown = 0;
}

if (!controls_intro_done && global.sumo_show_instructions) {
  game_state = "instructions";
} else {
  countdown_value = 3;
  game_state = "countdown";
  alarm[1] = 60;
}
