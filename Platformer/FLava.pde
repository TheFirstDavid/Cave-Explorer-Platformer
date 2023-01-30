class FLava extends FGameObject {
  int i = 0;
  int f = int(random(0, 5));

  FLava(float x, float y) {
    super();
    setPosition(x, y);
    setName("lava");
    setFillColor(lavac);
    setFriction(1000);
    setStatic(true);
    setRestitution(1);
  }

  void act() {
    attachImage(lava[f]);
    if (frameCount % 40 == 0) f++;
    if(f == numberOfPics) f = 0;
  }
}
