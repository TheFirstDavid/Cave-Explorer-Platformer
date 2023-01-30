class FPlayer extends FGameObject {
  int lives = 3;
  int frame;
  int direction;
  final int L = -1;
  final int R = 1;

  FPlayer() {
    super();
    frame = 0;
    direction = R;
    setPosition(775, 1150);
    setName("player");
    setFillColor(icec);
    setRotatable(false);
  }

  void act() {
    input();
    collisions();
    animate();
  }

  void animate() {
    if (frame >= action.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == R) attachImage(action[frame]);
      if (direction == L) attachImage(reverseImage(action[frame]));
      frame++;
    }
  }

  void collisions() {
    if (isTouching("hammer")) {
      setPosition(775, 1150);
      lives--;
    }
    if (isTouching("ham")) {
      setPosition(775, 1150);
      lives--;
    }
  }

  void input() {

    float vy = getVelocityY();
    if (vy == 0) {
      action = idle;
    }
    if (akey) {
      direction = L;
      setVelocity(-200, vy);
      action = run;
    }
    if (dkey) {
      direction = R;
      setVelocity(200, vy);
      action = run;
    }
    if (abs(vy) > 0.1) {
      action = jump;
    }
    jumping();
  }



  void jumping() {
    float vx = getVelocityX();
    ArrayList<FContact> jump = getContacts();
    for (int i = 0; i < jump.size(); i++) {
      FContact j = jump.get(i);
      if (j.contains("ground")) {
        if (spacekey) setVelocity(vx, -600);
      } else if (j.contains("wall")){
        if(spacekey) setVelocity(vx, -600);
      }else if (j.contains("spike")) {
        if (cooldown < 0) {
          hit.play();
          hit.rewind();
          lives--;
          setPosition(800, 1150);
          cooldown = 60;
        }
      } else if (j.contains("lava")) {
        hit.play();
        hit.rewind();
        setVelocity(vx, -1000);
        if (cooldown < 0) {
          lives--;
          cooldown = 60;
        }
      } else if (j.contains("spring")) {
        if (spacekey) setVelocity(vx, -1000);
      } else if (j.contains("trophy")) {
        check++;
        mode = WIN;
      }
    }
  }
}
