class FBridge extends FGameObject {
  
  FBridge(float x, float y) {
    super();
    setPosition(x, y);
    setName("bridge");
    setFillColor(bridgec);
    attachImage(bridge);
    setStatic(true);
    setRotatable(false);
  }
  
  void act() {
    if(isTouching("player")){
      setSensor(true);
      setStatic(false);
    }
  }
}
