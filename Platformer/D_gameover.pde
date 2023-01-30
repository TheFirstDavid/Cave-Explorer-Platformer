void gameOver() {
  intros.pause();
  intros.rewind();
  caves.pause();
  caves.rewind();
  dead.play();
  background(0);
  textSize(85);
  fill(lavac);
  text("GAMEOVER", width/2, height/2);
  retry.show();
  if (retry.clicked) {
    check = 0;
  dead.pause();
  dead.rewind();
    mode = INTRO;
    setup();
    draw();
  }
}
