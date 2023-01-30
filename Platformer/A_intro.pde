int s = 60;
int g = 1;
void intro() {
  intros.play();
  image(intro, 0, 0, width, height);
  pushMatrix();
  textFont(introText);
  textSize(s);
  s = s + g;
  if (s >= 100 || s <= 25) g = g*-1;
  
  fill(255);
  rotate(radians(-width/200));
  text("Cave Explorer", width/2.1, height/4);
  popMatrix();
 
 play.show();
 if (play.clicked) {
   mode = GAME;
 }
}
