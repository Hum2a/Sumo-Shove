var progress = 1 - (lifetime / 20);
var current_radius = lerp(start_radius, end_radius, progress);

draw_set_alpha(lerp(start_alpha, end_alpha, progress));
draw_set_color(c_white);
draw_circle(x, y, current_radius, true);
draw_set_alpha(1);
