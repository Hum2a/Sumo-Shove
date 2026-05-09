if (spawn_timer > 0) {
  spawn_timer--;
}

var playing = false;
if (instance_exists(obj_game_manager)) {
  with (obj_game_manager) {
    playing = (game_state == "playing");
  }
}

// Allow animation during round_end (fall / idle at halt) while gameplay is stopped
if (!playing) {
  var still_tick = false;
  if (instance_exists(obj_game_manager)) {
    with (obj_game_manager) {
      if (game_state == "round_end") {
        still_tick = true;
      }
    }
  }
  if (!still_tick) {
    exit;
  }
}

if (playing && !is_dead) {
  if (hit_pulse_timer > 0) {
    hit_pulse_timer--;
  }

  if (shove_hit_flash > 0) {
    shove_hit_flash--;
  }

  var key_left;
  var key_right;
  var key_up;
  var key_down;
  var key_shove;

  var key_shove_hold;
  if (sumo_slot == 1) {
    key_left = keyboard_check(ord("A"));
    key_right = keyboard_check(ord("D"));
    key_up = keyboard_check(ord("W"));
    key_down = keyboard_check(ord("S"));
    key_shove_hold = keyboard_check(ord("F"));
  } else {
    key_left = keyboard_check(vk_left);
    key_right = keyboard_check(vk_right);
    key_up = keyboard_check(vk_up);
    key_down = keyboard_check(vk_down);
    key_shove_hold = keyboard_check(ord("L"));
  }

  var input_x = key_right - key_left;
  var input_y = key_down - key_up;

  // Face = movement direction (updated before shove so push matches current input)
  if (input_x != 0 || input_y != 0) {
    face_angle = point_direction(0, 0, input_x, input_y);
  }

  // --- SHOVE CHARGE (release fires; charging slows acceleration) ---
  if (shove_cooldown > 0) {
    shove_charge = 0;
  } else if (key_shove_hold) {
    shove_charge = min(1, shove_charge + shove_charge_rate);
  } else {
    if (shove_charge >= shove_charge_min) {
      var _pow = clamp(shove_charge, 0, 1);
      var _pow_lin = shove_power_min_mult + (shove_power_max_mult - shove_power_min_mult) * _pow;
      var _pow_kb = power(_pow, shove_knockback_charge_curve);
      var _kb_mult = shove_knockback_min_mult + (shove_knockback_max_mult - shove_knockback_min_mult) * _pow_kb;
      var _eff_sf = shove_force * _pow_lin;
      var _eff_kb = knockback_force * _kb_mult;

      shove_cooldown = shove_cooldown_max;
      is_shoving = true;

      spd_x += lengthdir_x(_eff_sf, face_angle);
      spd_y += lengthdir_y(_eff_sf, face_angle);

      var opponent = noone;
      var best_d = 999999;
      with (obj_player) {
        if (id != other.id) {
          var d = point_distance(x, y, other.x, other.y);
          if (d < best_d) {
            best_d = d;
            opponent = id;
          }
        }
      }

      if (opponent != noone) {
        var dist_o = point_distance(x, y, opponent.x, opponent.y);
        var toward_opp = point_direction(x, y, opponent.x, opponent.y);
        var in_arc = abs(angle_difference(face_angle, toward_opp)) <= shove_cone_half;
        if (dist_o <= shove_range && in_arc) {
          opponent.spd_x += lengthdir_x(_eff_kb, face_angle);
          opponent.spd_y += lengthdir_y(_eff_kb, face_angle);
          opponent.hit_pulse_timer = 14;
          shove_hit_flash = 10;

          with (obj_game_manager) {
            trigger_shake(2 + 11 * _pow_kb, 6 + 18 * _pow_kb);
            sfx_try("snd_sumo_shove_hit");
          }
        }
      }

      instance_create_layer(x, y, "Instances", obj_shove_effect);
    }
    shove_charge = 0;
  }

  var _charge_slow = shove_charge * shove_charge_slow_max;
  var _move_mult = clamp(1 - _charge_slow, 0.22, 1);

  spd_x += input_x * move_force * _move_mult;
  spd_y += input_y * move_force * _move_mult;

  var _cap = max_speed * clamp(1 - shove_charge * 0.38, 0.55, 1);
  var vmag = point_distance(0, 0, spd_x, spd_y);
  if (vmag > _cap) {
    var s = _cap / vmag;
    spd_x *= s;
    spd_y *= s;
  }

  spd_x *= friction_amount;
  spd_y *= friction_amount;

  x += spd_x;
  y += spd_y;

  if (shove_cooldown > 0) {
    shove_cooldown--;
  }

  trail_phase++;
  if (trail_phase >= 3) {
    trail_phase = 0;
    if (point_distance(0, 0, spd_x, spd_y) > 2) {
      var t = instance_create_layer(x, y, "Instances", obj_trail_particle);
      t.trail_color = (sumo_slot == 1) ? c_blue : c_red;
    }
  }
}

is_moving = (point_distance(0, 0, spd_x, spd_y) > 0.5);

if (is_dead) {
  sprite_index = spr_player_fall;
  image_speed = anim_spd_fall;
} else if (is_winning) {
  sprite_index = spr_player_win;
  image_speed = anim_spd_win;
} else if (is_shoving) {
  sprite_index = spr_player_shove;
  image_speed = anim_spd_shove;
} else if (is_moving) {
  sprite_index = spr_player_walk;
  image_speed = anim_spd_walk;
} else {
  sprite_index = spr_player_idle;
  image_speed = anim_spd_idle;
}

// Horizontal strip playback (sprites are one subimage = full strip texture)
if (sprite_index != prev_anim_sprite) {
  anim_index = 0;
  prev_anim_sprite = sprite_index;
}

var _nf = max(1, sprite_get_width(sprite_index) div anim_cell_size);

if (is_shoving && sprite_index == spr_player_shove) {
  anim_index += image_speed;
  if (anim_index >= _nf) {
    is_shoving = false;
    anim_index = 0;
    if (is_moving) {
      sprite_index = spr_player_walk;
      image_speed = anim_spd_walk;
    } else {
      sprite_index = spr_player_idle;
      image_speed = anim_spd_idle;
    }
    prev_anim_sprite = sprite_index;
  }
} else {
  anim_index += image_speed;
  while (anim_index >= _nf) {
    anim_index -= _nf;
  }
}
