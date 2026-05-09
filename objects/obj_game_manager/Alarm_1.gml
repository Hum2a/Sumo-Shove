countdown_value--;

if (countdown_value <= 0) {
  game_state = "playing";
  sfx_try("snd_sumo_round_start");
} else {
  alarm[1] = 60;
  sfx_try("snd_sumo_tick");
}
