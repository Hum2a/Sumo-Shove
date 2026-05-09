if (p1_score >= wins_needed || p2_score >= wins_needed) {
  game_state = "series_end";
  global.p1_final_score = p1_score;
  global.p2_final_score = p2_score;
  global.series_winner = (p1_score >= wins_needed) ? 1 : 2;
  with (obj_player) {
    is_winning = (sumo_slot == global.series_winner);
  }
  room_goto(room_score);
  exit;
}

round_num++;
round_winner = 0;

with (obj_player) {
  x = (sumo_slot == 1) ? other.p1_start_x : other.p2_start_x;
  y = (sumo_slot == 1) ? other.p1_start_y : other.p2_start_y;
  spd_x = 0;
  spd_y = 0;
  is_dead = false;
  is_winning = false;
  is_shoving = false;
  anim_index = 0;
  prev_anim_sprite = spr_player_idle;
  shove_charge = 0;
  spawn_timer = 60;
  hit_pulse_timer = 0;
  shove_hit_flash = 0;
  shove_cooldown = 0;
}

game_state = "countdown";
countdown_value = 3;
alarm[1] = 60;
