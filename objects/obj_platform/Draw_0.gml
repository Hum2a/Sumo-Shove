draw_set_color(floor_color);
draw_circle(x, y, platform_radius, false);

draw_set_color(edge_color);
draw_circle(x, y, platform_radius, true);
draw_circle(x, y, platform_radius - 1, true);
draw_circle(x, y, platform_radius + 1, true);

var _warn = variable_global_exists("sumo_ring_warn_dist") ? global.sumo_ring_warn_dist : 40;
var danger = false;
with (obj_player) {
  var d = point_distance(x, y, global.platform_cx, global.platform_cy);
  if (d > global.platform_radius - _warn) {
    danger = true;
  }
}

if (danger) {
  var pulse = 0.35 + 0.35 * sin(current_time / 200);
  draw_set_alpha(pulse);
  draw_set_color(c_red);
  draw_circle(x, y, platform_radius, true);
  draw_set_alpha(1);
}
