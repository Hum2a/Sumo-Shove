var gw = display_get_gui_width();
var gh = display_get_gui_height();
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var cx = gw * 0.5;
var main_y0 = gh * 0.44;
var hub_y0 = gh * 0.42;
var row_h = 46;
var bw = 280;
var bh = 38;

// --- Mouse (main menu) ---
if (mouse_check_button_pressed(mb_left) && menu_page == "main") {
  for (var i = 0; i < 4; i++) {
    var yy = main_y0 + i * row_h;
    if (point_in_rectangle(mx, my, cx - bw * 0.5, yy - 8, cx + bw * 0.5, yy + bh)) {
      if (i == 0) {
        sumo_settings_save();
        room_goto(room_game);
      } else if (i == 1) {
        menu_page = "settings_hub";
        hub_cursor = 0;
      } else if (i == 2) {
        menu_page = "stats";
        stats_cursor = 0;
        stats_focus_col = 0;
      } else {
        game_end();
      }
    }
  }
}

// --- Mouse (settings hub) ---
if (mouse_check_button_pressed(mb_left) && menu_page == "settings_hub") {
  for (var h = 0; h < 3; h++) {
    var hy = hub_y0 + h * row_h;
    if (point_in_rectangle(mx, my, cx - bw * 0.5, hy - 8, cx + bw * 0.5, hy + bh)) {
      if (h == 0) {
        menu_page = "settings_audio";
        settings_cursor = 0;
      } else if (h == 1) {
        menu_page = "settings_game";
        game_settings_cursor = 0;
      } else {
        menu_page = "main";
        sumo_settings_save();
      }
    }
  }
}

if (menu_page == "main") {
  if (keyboard_check_pressed(vk_down)) {
    menu_cursor = (menu_cursor + 1) mod 4;
  }
  if (keyboard_check_pressed(vk_up)) {
    menu_cursor = (menu_cursor - 1 + 4) mod 4;
  }
  if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (menu_cursor == 0) {
      sumo_settings_save();
      room_goto(room_game);
    } else if (menu_cursor == 1) {
      menu_page = "settings_hub";
      hub_cursor = 0;
    } else if (menu_cursor == 2) {
      menu_page = "stats";
      stats_cursor = 0;
      stats_focus_col = 0;
    } else {
      game_end();
    }
  }
} else if (menu_page == "settings_hub") {
  for (var hhi = 0; hhi < 3; hhi++) {
    var hyy = hub_y0 + hhi * row_h;
    if (point_in_rectangle(mx, my, cx - bw * 0.5, hyy - 8, cx + bw * 0.5, hyy + bh)) {
      hub_cursor = hhi;
      break;
    }
  }

  if (keyboard_check_pressed(vk_down)) {
    hub_cursor = (hub_cursor + 1) mod 3;
  }
  if (keyboard_check_pressed(vk_up)) {
    hub_cursor = (hub_cursor - 1 + 3) mod 3;
  }
  if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (hub_cursor == 0) {
      menu_page = "settings_audio";
      settings_cursor = 0;
    } else if (hub_cursor == 1) {
      menu_page = "settings_game";
      game_settings_cursor = 0;
    } else {
      menu_page = "main";
      sumo_settings_save();
    }
  }
  if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
    menu_page = "main";
    sumo_settings_save();
  }
} else if (menu_page == "settings_audio") {
  var settings_rows = 5;
  var sy = gh * 0.32;
  var srow = 44;
  var cxm = gw * 0.5;

  for (var rh = 0; rh < settings_rows; rh++) {
    var ryy = sy + rh * srow;
    var ryy_t = ryy - 3;
    var ryy_b = ryy + 26;
    if (point_in_rectangle(mx, my, 32, ryy_t - 2, gw - 32, ryy_b + 4)) {
      settings_cursor = rh;
      break;
    }
  }

  var step_small = 0.05;

  if (mouse_check_button_pressed(mb_left)) {
    for (var rr = 0; rr < 5; rr++) {
      var ry = sy + rr * srow;
      var ry_t = ry - 3;
      var ry_b = ry + 26;

      if (rr <= 2) {
        if (point_in_rectangle(mx, my, cxm - 190, ry_t, cxm - 132, ry_b)) {
          if (rr == 0) {
            global.sumo_master_vol = clamp(global.sumo_master_vol - step_small, 0, 1);
          } else if (rr == 1) {
            global.sumo_sfx_vol = clamp(global.sumo_sfx_vol - step_small, 0, 1);
          } else {
            global.sumo_screen_shake = clamp(global.sumo_screen_shake - step_small, 0, 1.25);
          }
          sumo_settings_apply_audio();
        } else if (point_in_rectangle(mx, my, cxm + 132, ry_t, cxm + 190, ry_b)) {
          if (rr == 0) {
            global.sumo_master_vol = clamp(global.sumo_master_vol + step_small, 0, 1);
          } else if (rr == 1) {
            global.sumo_sfx_vol = clamp(global.sumo_sfx_vol + step_small, 0, 1);
          } else {
            global.sumo_screen_shake = clamp(global.sumo_screen_shake + step_small, 0, 1.25);
          }
          sumo_settings_apply_audio();
        } else if (point_in_rectangle(mx, my, cxm - 120, ry_t + 4, cxm + 120, ry_b - 4)) {
          var _t = (mx - (cxm - 120)) / 240;
          _t = clamp(_t, 0, 1);
          if (rr == 0) {
            global.sumo_master_vol = _t;
          } else if (rr == 1) {
            global.sumo_sfx_vol = _t;
          } else {
            global.sumo_screen_shake = _t * 1.25;
          }
          sumo_settings_apply_audio();
        }
      } else if (rr == 3) {
        if (point_in_rectangle(mx, my, cxm - 96, ry_t, cxm + 96, ry_b)) {
          global.sumo_trails = !global.sumo_trails;
        }
      } else if (rr == 4) {
        if (point_in_rectangle(mx, my, cx - bw * 0.45, ry_t - 2, cx + bw * 0.45, ry_b + 6)) {
          menu_page = "settings_hub";
          sumo_settings_save();
        }
      }
    }
  }

  if (mouse_check(mb_left)) {
    for (var rr = 0; rr < 3; rr++) {
      var ry = sy + rr * srow;
      var ry_t = ry - 3;
      var ry_b = ry + 26;
      if (point_in_rectangle(mx, my, cxm - 120, ry_t + 4, cxm + 120, ry_b - 4)) {
        var _ts = (mx - (cxm - 120)) / 240;
        _ts = clamp(_ts, 0, 1);
        if (rr == 0) {
          global.sumo_master_vol = _ts;
        } else if (rr == 1) {
          global.sumo_sfx_vol = _ts;
        } else {
          global.sumo_screen_shake = _ts * 1.25;
        }
        sumo_settings_apply_audio();
      }
    }
  }

  if (keyboard_check_pressed(vk_down)) {
    settings_cursor = (settings_cursor + 1) mod settings_rows;
  }
  if (keyboard_check_pressed(vk_up)) {
    settings_cursor = (settings_cursor - 1 + settings_rows) mod settings_rows;
  }

  if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
    menu_page = "settings_hub";
    sumo_settings_save();
  }

  if (settings_cursor == 4 && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))) {
    menu_page = "settings_hub";
    sumo_settings_save();
  }

  var adj = 0;
  if (keyboard_check_pressed(vk_left)) {
    adj = -1;
  }
  if (keyboard_check_pressed(vk_right)) {
    adj = 1;
  }

  if (keyboard_check_pressed(vk_space) && settings_cursor == 3) {
    global.sumo_trails = !global.sumo_trails;
  } else if (adj != 0) {
    switch (settings_cursor) {
      case 0:
        global.sumo_master_vol = clamp(global.sumo_master_vol + adj * step_small, 0, 1);
        sumo_settings_apply_audio();
        break;
      case 1:
        global.sumo_sfx_vol = clamp(global.sumo_sfx_vol + adj * step_small, 0, 1);
        sumo_settings_apply_audio();
        break;
      case 2:
        global.sumo_screen_shake = clamp(global.sumo_screen_shake + adj * step_small, 0, 1.25);
        break;
      case 3:
        global.sumo_trails = !global.sumo_trails;
        break;
      case 4:
        break;
    }
  }
} else if (menu_page == "settings_game") {
  var game_rows = 5;
  var sy = gh * 0.28;
  var srow = 44;
  var cxm = gw * 0.5;

  for (var gri = 0; gri < game_rows; gri++) {
    var gyy = sy + gri * srow;
    var gyy_t = gyy - 3;
    var gyy_b = gyy + 26;
    if (point_in_rectangle(mx, my, 32, gyy_t - 2, gw - 32, gyy_b + 4)) {
      game_settings_cursor = gri;
      break;
    }
  }

  if (mouse_check_button_pressed(mb_left)) {
    for (var gr = 0; gr < 5; gr++) {
      var ry = sy + gr * srow;
      var ry_t = ry - 3;
      var ry_b = ry + 26;

      if (gr == 0 || gr == 1) {
        if (point_in_rectangle(mx, my, cxm - 190, ry_t, cxm - 132, ry_b)) {
          if (gr == 0) {
            global.sumo_wins_needed = clamp(global.sumo_wins_needed - 1, 1, 9);
            if (global.sumo_max_rounds < global.sumo_wins_needed) {
              global.sumo_max_rounds = global.sumo_wins_needed;
            }
          } else {
            global.sumo_max_rounds = clamp(global.sumo_max_rounds - 1, global.sumo_wins_needed, 15);
          }
        } else if (point_in_rectangle(mx, my, cxm + 132, ry_t, cxm + 190, ry_b)) {
          if (gr == 0) {
            global.sumo_wins_needed = clamp(global.sumo_wins_needed + 1, 1, 9);
          } else {
            global.sumo_max_rounds = clamp(global.sumo_max_rounds + 1, global.sumo_wins_needed, 15);
          }
        }
      } else if (gr == 2) {
        if (point_in_rectangle(mx, my, cxm - 96, ry_t, cxm + 96, ry_b)) {
          global.sumo_show_instructions = !global.sumo_show_instructions;
        }
      } else if (gr == 3) {
        if (point_in_rectangle(mx, my, cxm - 190, ry_t, cxm - 132, ry_b)) {
          global.sumo_stage_index = (global.sumo_stage_index - 1 + sumo_stage_count() * 10) mod sumo_stage_count();
        } else if (point_in_rectangle(mx, my, cxm + 132, ry_t, cxm + 190, ry_b)) {
          global.sumo_stage_index = (global.sumo_stage_index + 1) mod sumo_stage_count();
        }
      } else if (gr == 4) {
        if (point_in_rectangle(mx, my, cx - bw * 0.45, ry_t - 2, cx + bw * 0.45, ry_b + 6)) {
          menu_page = "settings_hub";
          sumo_settings_save();
        }
      }
    }
  }

  if (keyboard_check_pressed(vk_down)) {
    game_settings_cursor = (game_settings_cursor + 1) mod game_rows;
  }
  if (keyboard_check_pressed(vk_up)) {
    game_settings_cursor = (game_settings_cursor - 1 + game_rows) mod game_rows;
  }

  if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
    menu_page = "settings_hub";
    sumo_settings_save();
  }

  if (game_settings_cursor == 4 && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))) {
    menu_page = "settings_hub";
    sumo_settings_save();
  }

  var gadj = 0;
  if (keyboard_check_pressed(vk_left)) {
    gadj = -1;
  }
  if (keyboard_check_pressed(vk_right)) {
    gadj = 1;
  }

  if (keyboard_check_pressed(vk_space) && game_settings_cursor == 2) {
    global.sumo_show_instructions = !global.sumo_show_instructions;
  } else if (gadj != 0) {
    switch (game_settings_cursor) {
      case 0:
        global.sumo_wins_needed = clamp(global.sumo_wins_needed + gadj, 1, 9);
        if (global.sumo_max_rounds < global.sumo_wins_needed) {
          global.sumo_max_rounds = global.sumo_wins_needed;
        }
        break;
      case 1:
        global.sumo_max_rounds = clamp(global.sumo_max_rounds + gadj, global.sumo_wins_needed, 15);
        break;
      case 2:
        global.sumo_show_instructions = !global.sumo_show_instructions;
        break;
      case 3:
        global.sumo_stage_index = (global.sumo_stage_index + gadj + sumo_stage_count() * 10) mod sumo_stage_count();
        break;
      case 4:
        break;
    }
  }
} else if (menu_page == "stats") {
  var stats_rows = 8;
  var sy = gh * 0.23;
  var srow = 44;
  var lx = 44;
  var cx1 = gw * 0.34;
  var cx2 = gw * 0.66;

  for (var rh = 0; rh < stats_rows; rh++) {
    var ryy = sy + rh * srow;
    var ryy_t = ryy - 3;
    var ryy_b = ryy + 26;
    if (rh < 7) {
      if (point_in_rectangle(mx, my, lx, ryy_t - 2, gw - lx, ryy_b + 4)) {
        stats_cursor = rh;
        if (mx < gw * 0.5) {
          stats_focus_col = 0;
        } else {
          stats_focus_col = 1;
        }
        break;
      }
    } else if (point_in_rectangle(mx, my, 32, ryy_t - 2, gw - 32, ryy_b + 8)) {
      stats_cursor = rh;
      break;
    }
  }

  if (keyboard_check_pressed(vk_tab)) {
    stats_focus_col = 1 - stats_focus_col;
  }

  if (mouse_check_button_pressed(mb_left)) {
    for (var rr = 0; rr < 8; rr++) {
      var ry = sy + rr * srow;
      var ry_t = ry - 3;
      var ry_b = ry + 26;

      if (rr < 7) {
        for (var col = 0; col < 2; col++) {
          var cxu = (col == 0) ? cx1 : cx2;
          if (point_in_rectangle(mx, my, cxu - 190, ry_t, cxu - 132, ry_b)) {
            sumo_fighter_stat_nudge(col, rr, -1);
          } else if (point_in_rectangle(mx, my, cxu + 132, ry_t, cxu + 190, ry_b)) {
            sumo_fighter_stat_nudge(col, rr, 1);
          }
        }
      } else if (rr == 7) {
        if (point_in_rectangle(mx, my, cx - bw * 0.45, ry_t - 2, cx + bw * 0.45, ry_b + 6)) {
          menu_page = "main";
          sumo_settings_save();
        }
      }
    }
  }

  if (mouse_check(mb_left)) {
    for (var rr = 0; rr < 7; rr++) {
      var ry = sy + rr * srow;
      var ry_t = ry - 3;
      var ry_b = ry + 26;
      for (var col = 0; col < 2; col++) {
        var cxu = (col == 0) ? cx1 : cx2;
        if (point_in_rectangle(mx, my, cxu - 120, ry_t + 4, cxu + 120, ry_b - 4)) {
          var _tt = (mx - (cxu - 120)) / 240;
          sumo_fighter_stat_set_from_slider(col, rr, _tt);
        }
      }
    }
  }

  if (keyboard_check_pressed(vk_down)) {
    stats_cursor = (stats_cursor + 1) mod stats_rows;
  }
  if (keyboard_check_pressed(vk_up)) {
    stats_cursor = (stats_cursor - 1 + stats_rows) mod stats_rows;
  }

  if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace)) {
    menu_page = "main";
    sumo_settings_save();
  }

  if (stats_cursor == 7 && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))) {
    menu_page = "main";
    sumo_settings_save();
  }

  var adj = 0;
  if (keyboard_check_pressed(vk_left)) {
    adj = -1;
  }
  if (keyboard_check_pressed(vk_right)) {
    adj = 1;
  }

  if (adj != 0 && stats_cursor < 7) {
    sumo_fighter_stat_nudge(stats_focus_col, stats_cursor, adj);
  }
}
