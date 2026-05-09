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

  if (sumo_slot == 1) {
    key_left = keyboard_check(ord("A"));
    key_right = keyboard_check(ord("D"));
    key_up = keyboard_check(ord("W"));
    key_down = keyboard_check(ord("S"));
    key_shove = keyboard_check_pressed(ord("F"));
  } else {
    key_left = keyboard_check(vk_left);
    key_right = keyboard_check(vk_right);
    key_up = keyboard_check(vk_up);
    key_down = keyboard_check(vk_down);
    key_shove = keyboard_check_pressed(ord("L"));
  }

  var input_x = key_right - key_left;
  var input_y = key_down - key_up;

  // Face = movement direction (updated before shove so push matches current input)
  if (input_x != 0 || input_y != 0) {
    face_angle = point_direction(0, 0, input_x, input_y);
  }

  // --- SHOVE ---
  if (key_shove && shove_cooldown == 0) {
    shove_cooldown = shove_cooldown_max;
    is_shoving = true;

    spd_x += lengthdir_x(shove_force, face_angle);
    spd_y += lengthdir_y(shove_force, face_angle);

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
        opponent.spd_x += lengthdir_x(knockback_force, face_angle);
        opponent.spd_y += lengthdir_y(knockback_force, face_angle);
        opponent.hit_pulse_timer = 14;
        shove_hit_flash = 10;

        with (obj_game_manager) {
          trigger_shake(5, 10);
          sfx_try("snd_sumo_shove_hit");
        }
      }
    }

    instance_create_layer(x, y, "Instances", obj_shove_effect);
  }

  spd_x += input_x * move_force;
  spd_y += input_y * move_force;

  var vmag = point_distance(0, 0, spd_x, spd_y);
  if (vmag > max_speed) {
    var s = max_speed / vmag;
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
  if (image_index >= sprite_get_number(spr_player_shove) - 1) {
    is_shoving = false;
  }
} else if (is_moving) {
  sprite_index = spr_player_walk;
  image_speed = anim_spd_walk;
} else {
  sprite_index = spr_player_idle;
  image_speed = anim_spd_idle;
}
