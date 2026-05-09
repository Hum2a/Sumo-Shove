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
  draw_text_transformed(gw * 0.5, gh * 0.52, "P1 — Move: WASD   Shove: F", 1.25, 1.25, 0);

  draw_set_color(c_red);
  draw_text_transformed(gw * 0.5, gh * 0.60, "P2 — Move: Arrows   Shove: L", 1.25, 1.25, 0);

  draw_set_color(make_color_rgb(200, 200, 210));
  draw_text_transformed(gw * 0.5, gh * 0.72, "ESC pauses during a round.", 1.05, 1.05, 0);

  draw_set_color(c_yellow);
  draw_text_transformed(gw * 0.5, gh * 0.84, "Press SPACE or ENTER to start", 1.35, 1.35, 0);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
