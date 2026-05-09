if (keyboard_check_pressed(vk_return) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
  global.p1_final_score = 0;
  global.p2_final_score = 0;
  global.series_winner = 0;
  room_goto(room_menu);
}
