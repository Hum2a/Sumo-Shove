lifetime--;
trail_alpha -= 0.72 / 18;
if (lifetime <= 0) {
  instance_destroy();
}
