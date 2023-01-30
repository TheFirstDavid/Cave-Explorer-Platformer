void win() {
  caves.pause();
  caves.rewind();
  win.play();
  background(0);
  textSize(85);
  fill(#FFC000);
  if (check >= 0 && check <= 3) text("GOOD JOB", width/2, height/2);
  again.show();
  if (again.clicked) {
    
    if (check >= 3) check = 0;
    mode = INTRO;
    win.pause();
    win.rewind();
    setup();
    draw();
  }
}
