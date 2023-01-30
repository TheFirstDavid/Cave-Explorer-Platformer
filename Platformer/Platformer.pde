import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import fisica.*;
//World
FWorld world;

//mode framework
final int INTRO    = 0;
final int GAME     = 1;
final int PAUSE    = 2;
final int GAMEOVER = 3;
final int WIN = 4;;
int mode;

//normal colours
color brown = #9c5a3c;
color white = #FFFFFF;
color black = #000000;

//Trophy
color trophyc = #565cf7;

//walls
color stonewall = #141414;
color grasswall = #1a8f00;
color icewall = #0051ff;
color fakeice = #484848;

//enemy colours
color thwo = #ff00ff;
color hbro = #ffff00;
color goombac = #00FFFF;

//terrain
color bridgec = #0000FF;
color lavac =   #FF0000;
color spikec = #6f3198;
color stonec =  #464646;
color trunk = #7a3416;
color leaves = #00FF00;
color springc = #fff200;
color icec =  #00b7ef;
color blocker = #212121;
color snowice = #0022ff;
color magmac = #b00000;
color grassc = #808080;
color dirtc = #ff2200;

//Images
PImage map, map2, stone, grass, glwall, grwall, gtrwall, gtlwall, ice, rcorner, lcorner, brcorner, blcorner, dirt;
PImage tree, treeL, treeR, treeM, treeF, spike, lbridge, rbridge, bridge, spring, hammer, magma, snowicep, trophy, heart;
PImage intro, cave, grassland;
PImage[] lava;
PImage[] goomba;
PImage[] thwomp;
PImage[] hammerbro;
PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;

//Buttons
Button play;
Button pause;
Button retry;
Button again;

//ArrayLists
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;

//ints
int numberOfPics;
int cooldown = 60;
int gridSize = 32;

//fonts
PFont introText;

//checker
int check = 0;

//music
Minim minim;
AudioPlayer intros, win, caves, dead, stomp, hit;

float zoom = 1.5;
boolean upkey, downkey, leftkey, rightkey, wkey, skey, akey, dkey, spacekey;
boolean mouseReleased, wasPressed;
FPlayer player;

void setup() {
  size(600, 600);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  Fisica.init(this);
  minim = new Minim(this);
  intros = minim.loadFile("sound/intro.mp3");
  win = minim.loadFile("sound/win.mp3");
  caves = minim.loadFile("sound/cave.mp3");
  dead = minim.loadFile("sound/dead.mp3");
  stomp = minim.loadFile("sound/stomp.mp3");
  hit = minim.loadFile("sound/hit.mp3");
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  numberOfPics = 5;
  introText = createFont("fonts/introfont.ttf", 1);
  intro = loadImage("backgrounds/intro.png");
  cave = loadImage("backgrounds/background.png");
  grassland = loadImage("backgrounds/greenery.png");
  stone = loadImage("textures/stone.png");
  ice = loadImage("textures/ice.png");
  dirt = loadImage("textures/dirt.png");
  map = loadImage("map1.png");
  map2 = loadImage("map2.png");
  tree = loadImage("textures/tree.png");
  treeL = loadImage("textures/treeleft.png");
  treeR = loadImage("textures/treeright.png");
  treeM = loadImage("textures/treemiddle.png");
  treeF = loadImage("textures/treefill.png");
  spike = loadImage("textures/spike.png");
  lbridge = loadImage("textures/lbridge.png");
  rbridge = loadImage("textures/rbridge.png");
  bridge = loadImage("textures/bridge.png");
  spring = loadImage("textures/trampoline.png");
  magma = loadImage("textures/magma.jpeg");
  snowicep = loadImage("textures/snowice.png");
  grass = loadImage("textures/grass1.png");
  trophy = loadImage("textures/trophy.png");
  heart = loadImage("textures/heart.png");
  

  //Button Setups
  play = new Button("PLAY", width/2, 500, 100, 50, black, white);
  pause = new Button("PAUSE", 500, 100, 75, 75, black, white);
  retry = new Button("RETRY", width/2, 450, 150, 100, lavac, black);
  again = new Button("AGAIN!", width/2, 450, 150, 100, #FFC000, white);

  //Player
  idle = new PImage[30];
  for (int i = 0; i < 30; i++) {
    idle[i] = loadImage("textures/idle0.png");
  }
  idle[29] = loadImage("textures/idle1.png");
  jump = new PImage[1];
  jump[0] = loadImage("textures/jump0.png");
  run = new PImage[3];
  run[0] = loadImage("textures/runright0.png");
  run[1] = loadImage("textures/runright1.png");
  run[2] = loadImage("textures/runright2.png");

  //lava
  lava = new PImage[numberOfPics];
  for (int i = 0; i < numberOfPics; i++) {
    lava[i] = loadImage("textures/lava"+i+".png");
  }

  //goomba
  goomba = new PImage[2];
  goomba[0] = loadImage("textures/goomba0.png");
  goomba[0].resize(gridSize, gridSize);
  goomba[1] = loadImage("textures/goomba1.png");
  goomba[1].resize(gridSize, gridSize);

  //Thwomp
  thwomp = new PImage[2];
  thwomp[0] = loadImage("textures/thwomp0.png");
  thwomp[1] = loadImage("textures/thwomp1.png");

  //hammerbro
  hammerbro = new PImage[2];
  hammerbro[0] = loadImage("textures/hammerbro0.png");
  hammerbro[1] = loadImage("textures/hammerbro1.png");
  hammer = loadImage("textures/hammer.png");


//different maps stuff
  action = idle;
  if (check == 0) loadWorld(map);
  if (check >= 1) loadWorld(map2);
  loadPlayer();
}

void draw() {
  click();
  if (mode == INTRO) {
    intro();
  } else if (mode == GAME) {
    game();
  } else if (mode == WIN) {
    win();
  } else if (mode == PAUSE) {
    pause();
  } else if (mode == GAMEOVER) {
    gameOver();
  }
}

void actWorld() {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }
  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
  }
}

void drawWorld() {
  pushMatrix();
  translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}

void loadWorld(PImage img) {
  world = new FWorld(-2000, -2000, 2000, 2000);
  world.setGravity(0, 981);
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y); //colour of current pixel
      color s = img.get(x, y+1); //colour below current pixel
      color w = img.get(x-1, y); //colour west of current pixel
      color e = img.get(x+1, y); //colour east of current pixel
      color n = img.get(x, y-1); //colour north of current pixel
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(x*gridSize, y*gridSize);
      b.setStatic(true);
      //Boring Terrain
      if (c == stonec) {
        b.setFriction(0);
        b.attachImage(stone);
        b.setFriction(7);
        b.setName("ground");
        world.add(b);
      } else if (c == grassc) {
        b.setFriction(5);
        b.attachImage(grass);
        b.setName("ground");
        world.add(b);
      } else if (c == dirtc) {
        b.attachImage(dirt);
        b.setFriction(5);
        b.setName("ground");
        world.add(b);
      } else if (c == icec) {
        b.setFriction(0);
        ice.resize(32, 32);
        b.attachImage(ice);
        b.setFriction(0);
        b.setName("ground");
        world.add(b);
      } else if (c == trunk) {
        b.attachImage(tree);
        b.setSensor(true);
        b.setName("ground");
        world.add(b);
      } else if (c == springc) {
        b.attachImage(spring);
        b.setName("spring");
        b.setFriction(1000);
        world.add(b);
      } else if (c == stonewall) {
        b.attachImage(stone);
        b.setFriction(7);
        b.setName("wall");
        world.add(b);
      } else if (c == grasswall) {
        b.attachImage(grass);
        b.setFriction(5);
        b.setName("wall");
        world.add(b);
      } else if (c == icewall) {
        b.attachImage(ice);
        b.setFriction(0);
        b.setName("wall");
        world.add(b);
      } else if (c == blocker) {
        b.attachImage(dirt);
        b.setFriction(0);
        b.setName("blocker");
        world.add(b);
      } else if (c == fakeice) {
        b.attachImage(ice);
        b.setFriction(0);
        b.setName("fakey");
        world.add(b);
      }else if (c == magmac) {
        magma.resize(32, 32);
        b.attachImage(magma);
        b.setFriction(5);
        b.setName("ground");
        world.add(b);
      } else if (c == snowice) {
        b.attachImage(snowicep);
        snowicep.resize(32, 32);
        world.add(b);
      }

      //Tree Leaves
      else if (c == leaves && w != leaves) { //endpiece
        b.attachImage(treeL);
        b.setFriction(7);
        b.setName("ground");
        world.add(b);
      } else if (c == leaves && e != leaves) { //endpiece
        b.attachImage(treeR);
        b.setFriction(7);
        b.setName("ground");
        world.add(b);
      } else if (c == leaves && w == leaves && e == leaves && s != trunk) { //fillerpiece
        b.attachImage(treeF);
        b.setFriction(7);
        b.setName("ground");
        world.add(b);
      } else if (c == leaves && s == trunk) { //middlepiece
        b.attachImage(treeM);
        b.setFriction(7);
        b.setName("ground");
        world.add(b);
      }

      //Complex Terrain
      else if (c == spikec) {
        b.attachImage(spike);
        b.setName("spike");
        world.add(b);
      } else if (c == bridgec) {
        FBridge br = new FBridge(x*gridSize, y*gridSize);
        br.setName("ground");
        terrain.add(br);
        world.add(br);
      } else if (c == lavac) {
        FLava la = new FLava(x*gridSize, y*gridSize);
        la.setName("lava");
        terrain.add(la);
        world.add(la);
      }
      
      //Enemies
      else if (c == goombac) {
        FGoomba gmb = new FGoomba (x*gridSize, y*gridSize);
        enemies.add(gmb);
        world.add(gmb);
      } else if (c == thwo) {
        FThwomp thw = new FThwomp (x*gridSize, y*gridSize);
        enemies.add(thw);
        world.add(thw);
      } else if (c == hbro) {
        FHammerBro bro = new FHammerBro (x*gridSize, y*gridSize);
        enemies.add(bro);
        world.add(bro);
      }
      
      //Winning trophy
      else if (c == trophyc) {
        b.attachImage(trophy);
        trophy.resize(32, 32);
        b.setName("trophy");
        world.add(b);
      }
    }
  }
}


boolean hitGround(FBox b) {
  ArrayList<FContact> contactList = player.getContacts();
  int i = 0;
  while (i < contactList.size()) {

    FContact myContact = contactList.get(i);
    if (myContact.contains(b))
      return true;
    i++;
  }
  return false;
}

void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}
