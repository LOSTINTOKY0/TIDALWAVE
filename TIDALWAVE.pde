//beginning of swarmshot
//maybe needs new name- tidal crusher?
PImage bkg,player, goldfish, bullet;

int count;
static int screenX = 750;  //x and y of background 
static int screenY = 750;
player p = new player();
ArrayList<bullet> bullets = new ArrayList<bullet>();  //need way to keep track of bullets
ArrayList<enemy> enemies = new ArrayList<enemy>();  //need way to keep track of enemies 



void settings()
{
  size(screenX,screenY);
}
void setup() {
  bkg = loadImage("images/background.png");
  player = loadImage("images/crab.png");
  goldfish = loadImage("images/goldfish.png");
  bullet = loadImage("images/claw.png");
  p.setPos(new Vec2(325,325));
}





public void update(){
  p.update();
  if(bullets.size() >0){  //each update check if bullet has died or is off screen.
  for(int i = 0; i< bullets.size(); i ++)
  {
    if(bullets.get(i).alive != true){
      bullets.remove(i);
    }
    else
    {
      Vec2 pos = bullets.get(i).getPos(); 
      if(pos.x >screenX ||pos.x<0 || pos.y >screenY || pos.y<0) //check if in bounds
      {
        bullets.remove(i);
      }
      else
      {
        bullets.get(i).update();
      }
    }
  }
}





}
void draw() {
  update(); //called every time so we have right
  image(bkg, 0, 0); //draw background
  image(player, p.getPos().x, p.getPos().y);  //draw player
  image(goldfish, 450, 500);
  for(int i = 0; i <bullets.size(); i++){
    image(bullet, bullets.get(i).pos.x, bullets.get(i).pos.y);
   }
  for(int i = 0; i <enemies.size(); i++){
    image(goldfish, enemies.get(i).pos.x, enemies.get(i).pos.y);
  }
}

void keyPressed() {
 /* Vec2 pos = p.getPos();
  Vec2 vel = p.getVel();
    if(key == 'w')
    {
    p.setPos(pos.x, pos.y - vel.y);
    }
    if(key == 's')
    {
      p.setPos(pos.x, pos.y + vel.y);
    }
    if(key == 'a')
    {
      p.setPos(pos.x - vel.x, pos.y );
    }
     if(key == 'd')
    {
      p.setPos(pos.x +vel.x, pos.y );
    }*/
    if(keyCode == ' '){
      bullets.add(p.fire());
    }
    }
