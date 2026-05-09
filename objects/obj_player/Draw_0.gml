if (spawn_timer > 0) {
  if (spawn_timer mod 12 < 6) {
    draw_set_alpha(1);
  } else {
    draw_set_alpha(0.3);
  }
} else {
  draw_set_alpha(1);
}

// Tint body so both fighters read clearly on the arena (sprite art is shared)
if (sumo_slot == 1) {
  image_blend = make_color_rgb(140, 190, 255);
} else {
  image_blend = make_color_rgb(255, 140, 140);
}

var sc = 1;
if (hit_pulse_timer > 0) {
  sc *= 1 + 0.14 * (hit_pulse_timer / 14);
}
if (shove_hit_flash > 0) {
  sc *= 1 + 0.08 * (shove_hit_flash / 10);
}

image_xscale = sc;
image_yscale = sc;
image_angle = face_angle + sprite_face_angle_offset;

// One frame from horizontal strip (sprite width = cells × anim_cell_size; single subimage)
var cell = anim_cell_size;
var spr = sprite_index;
var nf = max(1, sprite_get_width(spr) div cell);
var fi = floor(anim_index) mod nf;
if (is_shoving && sprite_index == spr_player_shove) {
  fi = clamp(floor(anim_index), 0, nf - 1);
}
var sx = fi * cell;

var _mat = matrix_build(x, y, 0, 0, 0, image_angle, image_xscale, image_yscale, 1);
matrix_set(matrix_world, _mat);
draw_sprite_part_ext(spr, 0, sx, 0, cell, cell, -cell * 0.5, -cell * 0.5, 1, 1, image_blend, draw_get_alpha());
matrix_set(matrix_world, matrix_build_identity());

image_angle = 0;
image_xscale = 1;
image_yscale = 1;

image_blend = c_white;
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

if (sumo_slot == 1) {
  draw_set_color(c_blue);
} else {
  draw_set_color(c_red);
}

draw_text(x, y - 24, "P" + string(sumo_slot));

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
