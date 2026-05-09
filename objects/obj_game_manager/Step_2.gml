// End Step — after all instances' Step: solid body overlap + ring-out (see Step_0 header comment)

if (game_state == "paused") {
  exit;
}

if (game_state != "playing") {
  exit;
}

var plist = [];
with (obj_player) {
  if (!is_dead) {
    array_push(plist, id);
  }
}

var npc = array_length(plist);

// Circle-vs-circle: positional separation + light elastic normal impulse (equal mass)
var iter = 4;
for (var it = 0; it < iter; it++) {
  for (var i = 0; i < npc; i++) {
    for (var j = i + 1; j < npc; j++) {
      var a = plist[i];
      var b = plist[j];
      if (!instance_exists(a) || !instance_exists(b)) {
        continue;
      }

      var ra = a.collision_radius;
      var rb = b.collision_radius;
      var dx = b.x - a.x;
      var dy = b.y - a.y;
      var dist = point_distance(a.x, a.y, b.x, b.y);
      var min_d = ra + rb;

      if (dist >= min_d) {
        continue;
      }

      var nx;
      var ny;
      if (dist < 0.001) {
        nx = 1;
        ny = 0;
        dist = 1;
      } else {
        nx = dx / dist;
        ny = dy / dist;
      }

      var overlap = min_d - dist;
      var half = overlap * 0.5;
      a.x -= nx * half;
      a.y -= ny * half;
      b.x += nx * half;
      b.y += ny * half;

      var rvx = b.spd_x - a.spd_x;
      var rvy = b.spd_y - a.spd_y;
      var vn = rvx * nx + rvy * ny;
      if (vn < 0) {
        var e = 0.38;
        var impulse = -(1 + e) * vn * 0.5;
        a.spd_x -= impulse * nx;
        a.spd_y -= impulse * ny;
        b.spd_x += impulse * nx;
        b.spd_y += impulse * ny;
      }
    }
  }
}

// Fall when body would cross the ring edge (center beyond radius minus body)
var fell_inst = [];
with (obj_player) {
  if (!is_dead) {
    var pd = point_distance(x, y, global.platform_cx, global.platform_cy);
    var edge_limit = global.platform_radius - collision_radius;
    if (pd > edge_limit) {
      array_push(fell_inst, id);
    }
  }
}

var fc = array_length(fell_inst);

if (fc == 1) {
  var who = fell_inst[0];
  who.is_dead = true;
  player_fell(who.sumo_slot);
  sfx_try("snd_sumo_fall");
} else if (fc >= 2) {
  for (var fi = 0; fi < fc; fi++) {
    fell_inst[fi].is_dead = true;
  }
  game_state = "double_ko";
  dk_timer = 75;
  with (obj_player) {
    x = (sumo_slot == 1) ? other.p1_start_x : other.p2_start_x;
    y = (sumo_slot == 1) ? other.p1_start_y : other.p2_start_y;
    spd_x = 0;
    spd_y = 0;
    is_dead = false;
    spawn_timer = 60;
    hit_pulse_timer = 0;
    shove_hit_flash = 0;
  }
  sfx_try("snd_sumo_double_ko");
}
