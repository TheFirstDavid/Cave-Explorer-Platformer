class FHammerBro extends FGameObject {

  int frame = 0;
  int speed = 50;
  int direction = L;
  FBox h;

  FHammerBro(float x, float y) {
    super();
    setPosition(x, y);
    setName("hammerbro");
    setRotatable(false);
    h = new FBox(25, 25);
  }

  void act() {
    animate();
    collide();
    move();
    hammer();
  }

  void hammer() {
    if (frameCount % 180 == 0) {
      h.setPosition(getX(), getY());
      h.setFillColor(lavac);
      if (player.getX() < getX()) h.setVelocity(int(random(-200, -100)), -400);
      if (player.getX() > getX()) h.setVelocity(int(random(100, 200)), -400);
      h.setAngularVelocity(10);
      h.setSensor(true);
      h.attachImage(hammer);
      h.setName("ham");
      world.add(h);
    }
  }

  void animate() {
    if (frame >= goomba.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == R) attachImage(hammerbro[frame]);
      if (direction == L) attachImage(reverseImage(hammerbro[frame]));
      frame++;
    }
  }

  void collide() {
    if (isTouching("wall")) {
      direction *= -1;
      setPosition(getX() + direction*5, getY());
    }
    if (isTouching("goomba")) {
      direction *= -1;
      setPosition(getX() + direction*5, getY());
    }
    if (isTouching("hammer")) {
      direction *= -1;
      setPosition(getX() + direction*5, getY());
    }
    if (isTouching("player")) {
      if (player.getY() < getY() - gridSize/2) {
        stomp.play();
        stomp.rewind();
        world.remove(this);
        enemies.remove(this);
        player.setVelocity(player.getVelocityX(), -300);
      } else {
        hit.play();
        hit.rewind();
        player.lives--;
        player.setPosition(800, 1150);
      }
    }
  }

  void move() {
    float vy = getVelocityY();
    setVelocity(speed*direction, vy);
  }
}
