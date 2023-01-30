class FThwomp extends FGameObject {

  int cooldown, threshold;
  float _x, _y;

  FThwomp(float x, float y) {
    super();
    threshold = 120;
    _x = x;
    _y = y;
    cooldown = threshold;
    setPosition(x, y);
    setName("thwomp");
    setRotatable(false);
    setStatic(true);
    attachImage(thwomp[0]);
  }

  void act() {
    if (player.getX() > getX() - gridSize  && player.getX() < getX() + gridSize && player.getY() > getY()) {
      setStatic(false);
      attachImage(thwomp[1]);
      cooldown = threshold;
    }
    
    cooldown--;
    if (cooldown < 0) {
      attachImage(thwomp[0]);
      setStatic(true);
      setPosition(_x, _y);
    }
    
    if (isTouching("player")) {
      player.lives--;
      player.setPosition(800, 1150);
      hit.play();
      hit.rewind();
    }
  }
}
