var gw = display_get_gui_width();
var gh = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

if (game_state != "instructions") {
  draw_text(gw * 0.5, 26, "Round " + string(round_num) + " / " + string(max_rounds));

  draw_set_color(make_color_rgb(200, 200, 200));
  draw_text(gw * 0.5, 54, "First to " + string(wins_needed) + " wins the series");

  draw_set_halign(fa_left);
  draw_set_color(c_blue);
  draw_text(60, 84, "P1");

  var py = 114;
  for (var i = 0; i < wins_needed; i++) {
    var cx = 60 + i * 28;
    draw_set_color(c_blue);
    if (i < p1_score) {
      draw_circle(cx, py, 10, false);
    } else {
      draw_circle(cx, py, 10, true);
    }
  }

  draw_set_halign(fa_right);
  draw_set_color(c_red);
  draw_text(gw - 60, 84, "P2");

  draw_set_halign(fa_left);
  py = 114;
  for (var j = 0; j < wins_needed; j++) {
    var cx2 = gw - 60 - (wins_needed - 1 - j) * 28;
    draw_set_color(c_red);
    if (j < p2_score) {
      draw_circle(cx2, py, 10, false);
    } else {
      draw_circle(cx2, py, 10, true);
    }
  }
}

// --- Per-player stats + shove cooldown (live instance vars — tweak later for character options) ---
if (game_state == "playing" || game_state == "countdown") {
  var _bar_w = 154;
  var _bar_h = 12;
  var _row = 16;
  var _y0 = 134;

  var _p1 = noone;
  var _p2 = noone;
  with (obj_player) {
    if (sumo_slot == 1) {
      _p1 = id;
    } else if (sumo_slot == 2) {
      _p2 = id;
    }
  }

  for (var _pi = 0; _pi < 2; _pi++) {
    var _p = (_pi == 0) ? _p1 : _p2;
    if (_p == noone) {
      continue;
    }

    var _left_side = (_pi == 0);
    var _cx = make_color_rgb(130, 190, 255);
    var _cx2 = make_color_rgb(50, 110, 200);
    if (_pi == 1) {
      _cx = make_color_rgb(255, 150, 150);
      _cx2 = make_color_rgb(190, 60, 60);
    }

    var _ax = _left_side ? 20 : (gw - 20 - _bar_w);
    var _ay = _y0;

    draw_set_halign(_left_side ? fa_left : fa_right);
    draw_set_valign(fa_top);
    draw_set_color(_cx);
    draw_text(_left_side ? 20 : gw - 20, _ay, (_pi == 0) ? "P1 — stats" : "P2 — stats");
    _ay += 22;

    var _cdm = _p.shove_cooldown_max;
    var _cd_fill = (_cdm > 0) ? clamp(1 - _p.shove_cooldown / _cdm, 0, 1) : 1;
    draw_set_color(make_color_rgb(34, 40, 52));
    draw_rectangle(_ax, _ay, _ax + _bar_w, _ay + _bar_h, false);
    draw_set_color(merge_colour(_cx2, c_lime, _cd_fill * 0.65));
    draw_rectangle(_ax, _ay, _ax + _bar_w * _cd_fill, _ay + _bar_h, false);
    draw_set_color(make_color_rgb(220, 228, 240));
    draw_rectangle(_ax, _ay, _ax + _bar_w, _ay + _bar_h, true);

    draw_set_color(make_color_rgb(210, 218, 230));
    draw_set_halign(_left_side ? fa_left : fa_right);
    draw_text(_left_side ? _ax : _ax + _bar_w, _ay - 15, "Shove CD");

    _ay += _bar_h + 6;

    var _ch = clamp(_p.shove_charge, 0, 1);
    draw_set_color(make_color_rgb(34, 40, 52));
    draw_rectangle(_ax, _ay, _ax + _bar_w, _ay + _bar_h, false);
    draw_set_color(merge_colour(_cx2, c_yellow, _ch * 0.75));
    draw_rectangle(_ax, _ay, _ax + _bar_w * _ch, _ay + _bar_h, false);
    draw_set_color(make_color_rgb(220, 228, 240));
    draw_rectangle(_ax, _ay, _ax + _bar_w, _ay + _bar_h, true);
    draw_set_color(make_color_rgb(210, 218, 230));
    draw_set_halign(_left_side ? fa_left : fa_right);
    draw_text(_left_side ? _ax : _ax + _bar_w, _ay - 15, "Charge");

    _ay += _bar_h + 10;

    draw_set_color(make_color_rgb(200, 206, 218));
    draw_set_halign(_left_side ? fa_left : fa_right);
    var _tx = _left_side ? 20 : gw - 20;

    draw_text(_tx, _ay, "Speed " + string_format(_p.max_speed, 1, 1));
    _ay += _row;
    draw_text(_tx, _ay, "Accel " + string_format(_p.move_force, 1, 2));
    _ay += _row;
    draw_text(_tx, _ay, "Shove " + string_format(_p.shove_force, 1, 1));
    _ay += _row;
    draw_text(_tx, _ay, "Reach " + string_format(_p.shove_range, 1, 0));
    _ay += _row;
    draw_text(_tx, _ay, "Knock " + string_format(_p.knockback_force, 1, 1));
    _ay += _row;
    draw_text(_tx, _ay, "Grip " + string_format(_p.friction_amount, 1, 2));
  }

  draw_set_halign(fa_left);
  draw_set_color(c_white);
}

if (game_state == "round_end") {
  draw_set_halign(fa_center);
  draw_set_valign(fa_middle);
  draw_set_color(c_white);

  var taunt_show = false;
  var taunt_col = c_white;

  if ((p1_score >= 2 && p2_score == 0) || (p1_score == 3 && p2_score == 1)) {
    taunt_show = true;
    taunt_col = c_blue;
  } else if ((p2_score >= 2 && p1_score == 0) || (p2_score == 3 && p1_score == 1)) {
    taunt_show = true;
    taunt_col = c_red;
  }

  if (taunt_show) {
    draw_set_color(taunt_col);
    draw_text_transformed(gw * 0.5, gh * 0.36, taunt_lines[irandom(4)], 1.4, 1.4, 0);
  }

  draw_set_color(c_white);
  draw_text_transformed(gw * 0.5, gh * 0.5, "Player " + string(round_winner) + " wins the round!", 2, 2, 0);
}

if (game_state == "countdown" && countdown_value > 0) {
  draw_set_halign(fa_center);
  draw_set_valign(fa_middle);
  draw_set_color(c_yellow);
  draw_text_transformed(gw * 0.5, gh * 0.5, string(countdown_value), 4, 4, 0);
}

if (game_state == "double_ko") {
  draw_set_halign(fa_center);
  draw_set_valign(fa_middle);
  draw_set_color(make_color_rgb(255, 150, 40));
  draw_text_transformed(gw * 0.5, gh * 0.52, "DOUBLE KO!", 2.5, 2.5, 0);
  draw_set_color(c_white);
  draw_text_transformed(gw * 0.5, gh * 0.62, "Replay round — no score", 1.2, 1.2, 0);
}

if (game_state == "paused") {
  draw_set_alpha(0.62);
  draw_set_color(c_black);
  draw_rectangle(0, 0, gw, gh, false);
  draw_set_alpha(1);
  draw_set_halign(fa_center);
  draw_set_valign(fa_middle);
  draw_set_color(c_white);
  draw_text_transformed(gw * 0.5, gh * 0.46, "PAUSED", 3, 3, 0);
  draw_text_transformed(gw * 0.5, gh * 0.58, "Press ESC to resume", 1.4, 1.4, 0);
}

if (game_state == "instructions") {
  draw_set_alpha(0.88);
  draw_set_color(make_color_rgb(8, 12, 24));
  draw_rectangle(0, 0, gw, gh, false);
  draw_set_alpha(1);

  draw_set_halign(fa_center);
  draw_set_valign(fa_middle);
  draw_set_color(c_white);
  draw_text_transformed(gw * 0.5, gh * 0.28, "SUMO SHOVE", 3.2, 3.2, 0);

  draw_set_color(make_color_rgb(220, 230, 255));
  draw_text_transformed(gw * 0.5, gh * 0.42, "Push your rival off the disk. Best of 5 rounds.", 1.15, 1.15, 0);

  draw_set_color(c_blue);
  draw_text_transformed(gw * 0.5, gh * 0.48, "P1 — Move: WASD   Hold F to charge shove — release to strike", 1.05, 1.05, 0);

  draw_set_color(c_red);
  draw_text_transformed(gw * 0.5, gh * 0.56, "P2 — Move: Arrows   Hold L to charge shove — release to strike", 1.05, 1.05, 0);

  draw_set_color(make_color_rgb(200, 200, 210));
  draw_text_transformed(gw * 0.5, gh * 0.66, "Charging slows you — full charge hits harder.", 1.05, 1.05, 0);

  draw_set_color(make_color_rgb(200, 200, 210));
  draw_text_transformed(gw * 0.5, gh * 0.74, "Bodies collide — shoves only land in front of you.", 1.05, 1.05, 0);

  draw_set_color(make_color_rgb(200, 200, 210));
  draw_text_transformed(gw * 0.5, gh * 0.82, "ESC pauses during a round.", 1.05, 1.05, 0);

  draw_set_color(c_yellow);
  draw_text_transformed(gw * 0.5, gh * 0.92, "Press SPACE or ENTER to start", 1.35, 1.35, 0);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
