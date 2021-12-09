//beginning of swarmshot
//maybe needs new name- TIDALWAVE?


//TODO: 
//bullet isn't as spammy, maxes at 9 on screen but is a lil wonky still
//add swarming behavior
//add following behavior
//add obstacles (?)
//collision detection -- maybe improve and offset initial image position ?
//titlescreen w/buttons n options - want to
//make highscore int and such

PImage bkg,player, goldfish, bullet;

int count;
static int screenX = 600;  //x and y of background 
static int screenY = 600;
player p = new player();
ArrayList<bullet> bullets = new ArrayList<bullet>();  //need way to keep track of bullets
ArrayList<enemy> enemies = new ArrayList<enemy>();  //need way to keep track of enemies 
boolean radDebug = false;
float timeCurr;
float timePrev;  //useful for spacing out the claw shooting things
int screen = 0; //tells us if we're on title screen (0), how to play screen (1), credit screen(5), general game screen(2),  boss screen(3), or gameover screen(4). 


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
     enemies.add(new squid(random(600), random(700)));
     
  }else{
    enemies.add(new neonTetra(random(700),random(700)));
  } 
 
} 

public void update(){
  isColliding();
  p.update();
  while(enemies.size() <9){
  spawnEnemy();
  }
  if(enemies.size() >0){
  for(int i = 0; i< enemies.size(); i ++){
    if(!enemies.get(i).alive){
      enemies.remove(i);
      return;
    }
    
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
for(int i = 0; i< enemies.size(); i++){       //loop through all enemies
  float eRad = enemies.get(i).getRad();
  Vec2 ePos = enemies.get(i).getPos();
  Vec2 pPos = p.getPos();
  float pRad = p.getRad();
  ePos = new Vec2(ePos.x + eRad, ePos.y + eRad);
  pPos = new Vec2(pPos.x + pRad, pPos.y + pRad);
  if(ePos.distanceTo(pPos)<pRad+eRad){  //check if player hits any enemies
     enemies.get(i).hit();
     p.hit();
  }
  
 
  for(int j = 0; j < bullets.size(); j++){  //loop through all bullets on screen
  Vec2 bPos = bullets.get(j).getPos();
  float bRad = bullets.get(j).getRad();
  bPos = new Vec2(bPos.x + bRad, bPos.y + bRad);
  if(ePos.distanceTo(bPos)<eRad+bRad){
    bullets.get(j).hit();
    enemies.get(i).hit();
    
  }
  }
}
}//end of isColliding



void draw() {
  cursor(player);
  if(screen == 0){
    
    image(loadImage("images/tidalTitle.png"),0,0);
    //rect(190,230,190,45); // for start
    
  
  }
  if(screen == 1 ){ //checks what screen we are on, 0 is title screen
    if(p.isAlive()){
       update(); //called every time so we have right positions for everything
    image(bkg, 0, 0); //draw background
    for(int i = 0; i <bullets.size(); i++){     //draw bullets
      image(bullet, bullets.get(i).pos.x, bullets.get(i).pos.y);
     }
    for(int i = 0; i <enemies.size(); i++){    //draw enemies
      image(loadImage(enemies.get(i).getImage()), enemies.get(i).pos.x, enemies.get(i).pos.y);
    }
    for(int i = 0; i<p.health; i++){
      image(bullet, 10+i*30, 10);
    }
    if(radDebug){       //this section is to debug hitboxes, draws them for refrence
      circle(p.getPos().x +p.getRad(), p.getPos().y + p.getRad() , p.getRad()*2);
      for(int i = 0;  i< bullets.size(); i ++)
      {
        Vec2 bPos = bullets.get(i).getPos();
        float bRad = bullets.get(i).getRad();
        circle(bPos.x + bRad, bPos.y + bRad, bRad*2);
      }
      for(int i = 0; i< enemies.size(); i ++)
      {        
       Vec2 bPos = enemies.get(i).getPos();
       float bRad = enemies.get(i).getRad();
       circle(bPos.x + bRad, bPos.y + bRad, bRad*2);
      }
     } //end of hitbox debug
    }
    if(!p.isAlive()){  //switch to gameoverScreen
      screen = 4; //gameover screen
    image(loadImage("images/dedScreen.png"),0,0);
    }
  }
 
  
}
void mouseClicked(){
//changes depending on screen
  if(screen == 0){
    //check mouse x and y to see if they're in bounds of play button
    if(mouseX >190 && mouseX <190+190){
      if(mouseY >230 && mouseX <230+45){
        screen = 1;
    }
    }
  }
  if(screen == 4){  //click to return to main screen
    screen = 0;
  }

}
void keyPressed() {
 /* Vec2 pos = p.getPos();      //i decided that i didn't like the wsad controls at ALL so i switched to mouse
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
      timeCurr = millis();
      float elapsed = timeCurr-timePrev;
      timePrev = millis();
      if(bullets.size() < 9 && elapsed>300){
        
      bullets.add(p.fire());
      }
    }
    }
