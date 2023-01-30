void game() {
println(check);
  pushMatrix();
  translate(-player.getX()*zoom*0.25+width/2, -player.getY()*zoom*0.25+height/2);

  if (player.getY() < 1200) {
    caves.pause();
    caves.rewind();
    intros.play();
    image(grassland, 0, -50, 1400, 800);
  }

  if (player.getY() > 1200) {
    intros.pause();
    intros.rewind();
    caves.play();
    image(cave, 0, -200, 2000, 2000);
  }

  popMatrix();
  drawWorld();
  actWorld();
  textSize(30);
  fill(lavac);
  text("LIVES:", 50, 50);
  if (player.lives == 3) {
    heart.resize(32, 32);
    image(heart, 100, 35);
    image(heart, 140, 35);
    image(heart, 180, 35);
  } else if (player.lives == 2) {
    image(heart, 100, 35);
    image(heart, 140, 35);
  } else if (player.lives == 1) {
    image(heart, 100, 35);
  } else if (player.lives <= 0) {
    mode = GAMEOVER;
  }
  cooldown--;
  pause.show();
  if (pause.clicked) {
    mode = PAUSE;
  }
}
