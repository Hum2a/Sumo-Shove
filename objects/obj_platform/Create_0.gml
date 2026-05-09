platform_radius = 200;

// Reset before obj_player Create events so each run gets a stable 1, 2, …
global.sumo_player_id_counter = 0;

global.platform_cx = x;
global.platform_cy = y;
global.platform_radius = platform_radius;

floor_color = make_color_rgb(96, 140, 180);
edge_color = make_color_rgb(48, 72, 96);
