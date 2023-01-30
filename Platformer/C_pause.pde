void pause () {
  background(0);
  pushMatrix();
  textFont(introText);
  textSize(s);
  s = s + g;
  if (s >= 100 || s <= 25) g = g*-1;
  fill(255);
  rotate(radians(width/300));
  text("PAUSED", width/2.1, height/2);
  popMatrix();
  
  pause.show();
  if (pause.clicked) mode = GAME;
}
