//beginning of swarmshot
//maybe needs new name- TIDALWAVE?


//TODO: don't let bullet be spammy
//add swarming behavior
//add following behavior
//collision detection
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
  bullet = loadImage("images/claw.png");
  p.setPos(new Vec2(325,325));
}



public void spawnEnemy(){
  
 float a = random(1);
  
  if(a<.3f){ 
    enemies.add(new enemy(random(700), random(700)));
 }
  else if(a <.4f)
  { 
     enemies.add(new squid(random(700), random(700)));
     
  }else{
    enemies.add(new neonTetra(random(700),random(700)));
  } 
 
} 

public void update(){
  p.update();
  while(enemies.size() <9){
  spawnEnemy();
  }
  if(enemies.size() >0){
  for(int i = 0; i< enemies.size(); i ++){
      Vec2 pos = enemies.get(i).getPos(); 
      float rad = enemies.get(i).getRad();
      if(pos.x >screenX - rad*2 ||pos.x<0 || pos.y >screenY || pos.y<0) //check if in bounds, if out of screen bounds then negate direction
      {
        enemies.get(i).setVel(enemies.get(i).getVel().times(-1));
      enemies.get(i).flipImage();
      }
  enemies.get(i).update();
  }
  }
  if(bullets.size() >0){  //each update check if bullet has died or is off screen.
  for(int i = 0; i< bullets.size(); i ++)
  {
    if(bullets.get(i).alive != true){
      bullets.remove(i);
    }
    else
    {
      Vec2 pos = bullets.get(i).getPos(); 
      
      if(pos.x >screenX  ||pos.x<0 || pos.y >screenY || pos.y<0) //check if in bounds
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

public void isColliding(){ //check collisions
for(int i = 0; i< enemies.size(); i++){ //loop through all enemies
  float eRad = enemies.get(i).getRad();
  Vec2 ePos = enemies.get(i).getPos();
  if(p.getPos().x- ePos.x < eRad +p.getRad() && p.getPos().y- ePos.y < eRad +p.getRad() ){ //check if player hits any enemies
    enemies.get(i).hit();
    p.hit();
  }
  for(int j = 0; j < bullets.size(); j++){  //loop through all bullets on screen
  if(bullets.get(i).getPos().x- ePos.x < eRad +bullets.get(i).getRad() &&  bullets.get(i).getPos().y- ePos.y < eRad +bullets.get(i).getRad() ){
    bullets.get(i).hit();
    enemies.get(i).hit();
    
  }
  }
}


}
void draw() {
  update(); //called every time so we have right
  image(bkg, 0, 0); //draw background
  image(player, p.getPos().x, p.getPos().y);  //draw player
  for(int i = 0; i <bullets.size(); i++){
    image(bullet, bullets.get(i).pos.x, bullets.get(i).pos.y);
   }
  for(int i = 0; i <enemies.size(); i++){
    image(loadImage(enemies.get(i).getImage()), enemies.get(i).pos.x, enemies.get(i).pos.y);
  }
}

void keyPressed() {
 /* Vec2 pos = p.getPos(); //i decided that i didn't like the wsad controls at ALL
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
