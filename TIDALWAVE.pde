//beginning of swarmshot
//maybe needs new name- tidal crusher?
PImage bkg,player, goldfish, fish2;

void setup() {
  size(3000,600);
  bkg = loadImage("images/background2.png");
  player = loadImage("images/crab.png");
  goldfish = loadImage("images/goldfish.png");
}

void draw() {
  image(bkg, 0, 0);
   image(player, 325, 325);
   
   image(goldfish, 450, 500);
}
