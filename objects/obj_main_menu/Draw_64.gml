var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Background — shifts slightly per screen so each menu reads as its own place
var _bg = make_color_rgb(10, 14, 26);
switch (menu_page) {
  case "main":
    _bg = make_color_rgb(10, 14, 26);
    break;
  case "settings_hub":
    _bg = make_color_rgb(14, 16, 34);
    break;
  case "settings_audio":
    _bg = make_color_rgb(12, 18, 32);
    break;
  case "settings_game":
    _bg = make_color_rgb(22, 14, 20);
    break;
  case "stats":
    _bg = make_color_rgb(10, 20, 28);
    break;
  default:
    _bg = make_color_rgb(10, 14, 26);
    break;
}
draw_set_color(_bg);
draw_rectangle(0, 0, gw, gh, false);

// Hero title + pitch line only on main menu (submenus use their own headers)
if (menu_page == "main") {
  draw_set_color(make_color_rgb(220, 230, 255));
  draw_text_transformed(gw * 0.5, gh * 0.18, "SUMO SHOVE", 2.8, 2.8, 0);

  draw_set_color(make_color_rgb(160, 170, 195));
  draw_text_transformed(gw * 0.5, gh * 0.26, "Local versus · Charge shoves · Ring outs", 1.05, 1.05, 0);
}

var cx = gw * 0.5;
var main_y0 = gh * 0.44;
var row_h = 46;
var bw = 280;
var bh = 38;

if (menu_page == "main") {
  var labels = ["Play", "Options", "Fighter stats", "Quit"];
  for (var i = 0; i < 4; i++) {
    var yy = main_y0 + i * row_h;
    var sel = menu_cursor == i;
    draw_set_color(sel ? make_color_rgb(55, 65, 95) : make_color_rgb(35, 42, 62));
    draw_rectangle(cx - bw * 0.5, yy - 8, cx + bw * 0.5, yy + bh, false);
    draw_set_color(sel ? c_white : make_color_rgb(210, 218, 235));
    draw_text(cx, yy + bh * 0.35, labels[i]);
    draw_set_color(make_color_rgb(120, 135, 165));
    draw_rectangle(cx - bw * 0.5, yy - 8, cx + bw * 0.5, yy + bh, true);
  }

  draw_set_halign(fa_center);
  draw_set_valign(fa_top);
  draw_set_color(make_color_rgb(130, 140, 165));
  draw_text(gw * 0.5, gh * 0.82, "Up / Down · Enter or Space · Mouse click");
} else if (menu_page == "stats") {
  // Slider layout must match Step_0 hitboxes (same geometry as Settings sliders)
  var sy = gh * 0.23;
  var srow = 44;
  var lx = 44;
  var cx1 = gw * 0.34;
  var cx2 = gw * 0.66;
  var _maxw = 240;

  draw_set_halign(fa_left);
  draw_set_valign(fa_top);

  draw_set_color(make_color_rgb(220, 230, 255));
  draw_text_transformed(lx, gh * 0.11, "SUMO SHOVE", 1.35, 1.35, 0);

  draw_set_color(c_white);
  draw_text(lx, gh * 0.165, "FIGHTER STATS");

  draw_set_color(make_color_rgb(170, 180, 200));
  draw_text(lx, gh * 0.205, "Sliders per fighter · Tab column · Bar drag or − / + · Left/Right keys · Esc saves");

  draw_set_halign(fa_center);
  draw_set_valign(fa_middle);
  draw_set_color(make_color_rgb(140, 190, 255));
  draw_text(cx1, sy - 50, "P1");
  draw_set_color(make_color_rgb(255, 160, 160));
  draw_text(cx2, sy - 50, "P2");

  var stat_labels = ["Speed cap", "Accel", "Shove force", "Reach", "Knockback", "Grip (friction)", "Shove CD (frames)"];

  for (var r = 0; r < 8; r++) {
    var ry = sy + r * srow;
    var ry_t = ry - 3;
    var ry_b = ry + 26;
    var sel_row = stats_cursor == r;

    if (sel_row) {
      draw_set_alpha(0.12);
      draw_set_color(c_white);
      draw_rectangle(28, ry_t - 2, gw - 28, ry_b + 4, false);
      draw_set_alpha(1);
    }

    if (r < 7) {
      draw_set_halign(fa_left);
      draw_set_valign(fa_middle);
      draw_set_color(sel_row ? c_white : make_color_rgb(200, 208, 220));
      draw_text(lx + 6, ry + 11, stat_labels[r]);

      for (var col = 0; col < 2; col++) {
        var cxu = (col == 0) ? cx1 : cx2;
        var cell_sel = sel_row && stats_focus_col == col;
        var _pn = sumo_fighter_stat_slider_norm(col, r);
        var _fill_c = (col == 0) ? make_color_rgb(90, 140, 210) : make_color_rgb(210, 100, 120);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (cell_sel) {
          draw_set_alpha(0.16);
          draw_set_color((col == 0) ? make_color_rgb(70, 110, 170) : make_color_rgb(170, 80, 90));
          draw_rectangle(cxu - 192, ry_t - 2, cxu + 192, ry_b + 4, false);
          draw_set_alpha(1);
        }

        draw_set_color(make_color_rgb(55, 62, 82));
        draw_rectangle(cxu - 190, ry_t, cxu - 132, ry_b, false);
        draw_rectangle(cxu + 132, ry_t, cxu + 190, ry_b, false);
        draw_set_color(make_color_rgb(160, 210, 255));
        draw_text(cxu - 161, ry + 11, "−");
        draw_text(cxu + 161, ry + 11, "+");

        draw_set_color(make_color_rgb(45, 50, 68));
        draw_rectangle(cxu - 120, ry_t + 4, cxu + 120, ry_b - 4, false);
        draw_set_color(_fill_c);
        draw_rectangle(cxu - 120, ry_t + 4, cxu - 120 + _maxw * _pn, ry_b - 4, false);

        var pv = 0;
        switch (r) {
          case 0:
            pv = global.sumo_fp_max_speed[col];
            break;
          case 1:
            pv = global.sumo_fp_move_force[col];
            break;
          case 2:
            pv = global.sumo_fp_shove_force[col];
            break;
          case 3:
            pv = global.sumo_fp_shove_range[col];
            break;
          case 4:
            pv = global.sumo_fp_knockback[col];
            break;
          case 5:
            pv = global.sumo_fp_friction[col];
            break;
          case 6:
            pv = global.sumo_fp_shove_cd[col];
            break;
        }

        var ptxt = "";
        if (r == 1 || r == 5) {
          ptxt = string_format(pv, 1, 2);
        } else if (r == 6) {
          ptxt = string(round(pv));
        } else {
          ptxt = string_format(pv, 1, 1);
        }

        draw_set_color(make_color_rgb(220, 232, 250));
        draw_text(cxu, ry + 11, ptxt);
      }
    } else {
      draw_set_halign(fa_center);
      draw_set_valign(fa_middle);
      draw_set_color(make_color_rgb(75, 85, 115));
      draw_rectangle(cx - bw * 0.45, ry_t - 2, cx + bw * 0.45, ry_b + 6, false);
      draw_set_color(make_color_rgb(220, 228, 240));
      draw_text(cx, ry + 11, "Back");
    }
  }

  draw_set_halign(fa_center);
  draw_set_valign(fa_top);
  draw_set_color(make_color_rgb(130, 140, 165));
  draw_text(gw * 0.5, gh * 0.91, "Keys: Left / Right on focused row · Esc saves");
} else if (menu_page == "settings_hub") {
  var hub_y0 = gh * 0.42;
  var hub_labels = ["Audio & Video", "Game & Stage", "< Back to menu"];

  draw_set_halign(fa_center);
  draw_set_valign(fa_middle);
  draw_set_color(make_color_rgb(220, 230, 255));
  draw_text_transformed(gw * 0.5, gh * 0.16, "SUMO SHOVE", 1.55, 1.55, 0);
  draw_set_color(c_white);
  draw_text_transformed(gw * 0.5, gh * 0.24, "OPTIONS", 1.4, 1.4, 0);
  draw_set_color(make_color_rgb(160, 170, 195));
  draw_text_transformed(gw * 0.5, gh * 0.31, "Choose a category · Esc returns to main menu", 1.02, 1.02, 0);

  for (var hi = 0; hi < 3; hi++) {
    var hyy = hub_y0 + hi * row_h;
    var hsel = hub_cursor == hi;
    draw_set_color(hsel ? make_color_rgb(55, 65, 95) : make_color_rgb(35, 42, 62));
    draw_rectangle(cx - bw * 0.5, hyy - 8, cx + bw * 0.5, hyy + bh, false);
    draw_set_color(hsel ? c_white : make_color_rgb(210, 218, 235));
    draw_text(cx, hyy + bh * 0.35, hub_labels[hi]);
    draw_set_color(make_color_rgb(120, 135, 165));
    draw_rectangle(cx - bw * 0.5, hyy - 8, cx + bw * 0.5, hyy + bh, true);
  }

  draw_set_halign(fa_center);
  draw_set_valign(fa_top);
  draw_set_color(make_color_rgb(130, 140, 165));
  draw_text(gw * 0.5, gh * 0.88, "Esc saves · Back leaves options");
} else if (menu_page == "settings_audio") {
  var sy = gh * 0.32;
  var srow = 44;
  var lx = 56;
  var cxm = gw * 0.5;

  draw_set_halign(fa_left);
  draw_set_valign(fa_top);

  draw_set_color(make_color_rgb(220, 230, 255));
  draw_text_transformed(lx, gh * 0.11, "SUMO SHOVE", 1.35, 1.35, 0);

  draw_set_color(c_white);
  draw_text(lx, gh * 0.175, "AUDIO & VIDEO");

  draw_set_color(make_color_rgb(170, 180, 200));
  draw_text(lx, gh * 0.225, "Sliders · Toggle trails · Esc returns to Options");

  var audio_labels = ["Master volume", "SFX volume", "Screen shake", "Motion trails", "< Back to Options"];

  for (var r = 0; r < 5; r++) {
    var ry = sy + r * srow;
    var ry_t = ry - 3;
    var ry_b = ry + 26;
    var sel = settings_cursor == r;

    if (sel) {
      draw_set_alpha(0.15);
      draw_set_color(c_white);
      draw_rectangle(32, ry_t - 2, gw - 32, ry_b + 4, false);
      draw_set_alpha(1);
    }

    draw_set_color(sel ? c_white : make_color_rgb(200, 208, 220));
    draw_text(lx + 8, ry, audio_labels[r]);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (r <= 2) {
      draw_set_color(make_color_rgb(55, 62, 82));
      draw_rectangle(cxm - 190, ry_t, cxm - 132, ry_b, false);
      draw_rectangle(cxm + 132, ry_t, cxm + 190, ry_b, false);
      draw_set_color(make_color_rgb(160, 210, 255));
      draw_text(cxm - 161, ry + 11, "−");
      draw_text(cxm + 161, ry + 11, "+");

      draw_set_color(make_color_rgb(45, 50, 68));
      draw_rectangle(cxm - 120, ry_t + 4, cxm + 120, ry_b - 4, false);
      var _pct = (r == 0) ? global.sumo_master_vol : ((r == 1) ? global.sumo_sfx_vol : global.sumo_screen_shake / 1.25);
      var _maxw = 240;
      draw_set_color(make_color_rgb(90, 140, 210));
      draw_rectangle(cxm - 120, ry_t + 4, cxm - 120 + _maxw * clamp(_pct, 0, 1), ry_b - 4, false);

      var _pct_txt = (r == 2) ? round(global.sumo_screen_shake * 100) : round(((r == 0) ? global.sumo_master_vol : global.sumo_sfx_vol) * 100);
      draw_set_color(make_color_rgb(160, 210, 255));
      draw_text(cxm, ry + 11, string(_pct_txt) + "%");
    } else if (r == 3) {
      draw_set_color(make_color_rgb(55, 68, 92));
      draw_rectangle(cxm - 96, ry_t, cxm + 96, ry_b, false);
      draw_set_color(make_color_rgb(160, 210, 255));
      draw_text(cxm, ry + 11, global.sumo_trails ? "ON" : "OFF");
    } else if (r == 4) {
      draw_set_color(make_color_rgb(75, 85, 115));
      draw_rectangle(cxm - bw * 0.45, ry_t - 2, cxm + bw * 0.45, ry_b + 6, false);
      draw_set_color(make_color_rgb(220, 228, 240));
      draw_text(cxm, ry + 11, "Back");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
  }

  draw_set_halign(fa_center);
  draw_set_valign(fa_top);
  draw_set_color(make_color_rgb(130, 140, 165));
  draw_text(gw * 0.5, gh * 0.91, "Esc → Options menu");
} else if (menu_page == "settings_game") {
  var sy = gh * 0.28;
  var srow = 44;
  var lx = 56;
  var cxm = gw * 0.5;

  draw_set_halign(fa_left);
  draw_set_valign(fa_top);

  draw_set_color(make_color_rgb(220, 230, 255));
  draw_text_transformed(lx, gh * 0.11, "SUMO SHOVE", 1.35, 1.35, 0);

  draw_set_color(c_white);
  draw_text(lx, gh * 0.175, "GAME & STAGE");

  draw_set_color(make_color_rgb(170, 180, 200));
  draw_text(lx, gh * 0.225, "Match rules · Pick arena · Esc returns to Options");

  var game_labels = ["Wins to win series", "Max rounds (match cap)", "Show controls overlay", "Arena stage", "< Back to Options"];

  for (var gr = 0; gr < 5; gr++) {
    var ry = sy + gr * srow;
    var ry_t = ry - 3;
    var ry_b = ry + 26;
    var gsel = game_settings_cursor == gr;

    if (gsel) {
      draw_set_alpha(0.15);
      draw_set_color(c_white);
      draw_rectangle(32, ry_t - 2, gw - 32, ry_b + 4, false);
      draw_set_alpha(1);
    }

    draw_set_color(gsel ? c_white : make_color_rgb(200, 208, 220));
    draw_text(lx + 8, ry, game_labels[gr]);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (gr == 0 || gr == 1) {
      draw_set_color(make_color_rgb(55, 62, 82));
      draw_rectangle(cxm - 190, ry_t, cxm - 132, ry_b, false);
      draw_rectangle(cxm + 132, ry_t, cxm + 190, ry_b, false);
      draw_set_color(make_color_rgb(160, 210, 255));
      draw_text(cxm - 161, ry + 11, "−");
      draw_text(cxm + 161, ry + 11, "+");
      draw_text(cxm, ry + 11, (gr == 0) ? string(global.sumo_wins_needed) : string(global.sumo_max_rounds));
    } else if (gr == 2) {
      draw_set_color(make_color_rgb(55, 68, 92));
      draw_rectangle(cxm - 96, ry_t, cxm + 96, ry_b, false);
      draw_set_color(make_color_rgb(160, 210, 255));
      draw_text(cxm, ry + 11, global.sumo_show_instructions ? "ON" : "OFF");
    } else if (gr == 3) {
      draw_set_color(make_color_rgb(55, 62, 82));
      draw_rectangle(cxm - 190, ry_t, cxm - 132, ry_b, false);
      draw_rectangle(cxm + 132, ry_t, cxm + 190, ry_b, false);
      draw_set_color(make_color_rgb(160, 210, 255));
      draw_text(cxm - 161, ry + 11, "◀");
      draw_text(cxm + 161, ry + 11, "▶");
      draw_set_color(make_color_rgb(210, 220, 245));
      draw_text(cxm, ry + 11, sumo_stage_name(global.sumo_stage_index));
    } else if (gr == 4) {
      draw_set_color(make_color_rgb(75, 85, 115));
      draw_rectangle(cxm - bw * 0.45, ry_t - 2, cxm + bw * 0.45, ry_b + 6, false);
      draw_set_color(make_color_rgb(220, 228, 240));
      draw_text(cxm, ry + 11, "Back");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
  }

  draw_set_halign(fa_center);
  draw_set_valign(fa_top);
  draw_set_color(make_color_rgb(130, 140, 165));
  draw_text(gw * 0.5, gh * 0.91, "Esc → Options menu");
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
