lifetime--;
trail_alpha -= 0.5 / 15;
if (lifetime <= 0) {
  instance_destroy();
}
