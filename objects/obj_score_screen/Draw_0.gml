draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

var cx = room_width * 0.5;
var title_y = room_height * 0.28;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (winner == 1) {
  draw_set_color(c_blue);
} else {
  draw_set_color(c_red);
}

draw_text_transformed(cx, title_y, "Player " + string(winner) + " Wins!", 2.4, 2.4, 0);

draw_set_color(c_white);
draw_text_transformed(cx, title_y + 90, string(p1_score) + "   –   " + string(p2_score), 2, 2, 0);

var wins_needed = 3;
var pip_y = title_y + 170;

for (var i = 0; i < wins_needed; i++) {
  var cx1 = cx - 140 + i * 28;
  draw_set_color(c_blue);
  if (i < p1_score) {
    draw_circle(cx1, pip_y, 12, false);
  } else {
    draw_circle(cx1, pip_y, 12, true);
  }
}

for (var j = 0; j < wins_needed; j++) {
  var cx2 = cx + 60 + j * 28;
  draw_set_color(c_red);
  if (j < p2_score) {
    draw_circle(cx2, pip_y, 12, false);
  } else {
    draw_circle(cx2, pip_y, 12, true);
  }
}

draw_set_color(make_color_rgb(200, 200, 200));
draw_text_transformed(cx, room_height - 96, "Press ENTER or SPACE to rematch", 1.2, 1.2, 0);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
