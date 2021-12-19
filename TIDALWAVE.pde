//beginning of swarmshot
//maybe needs new name- TIDALWAVE?


//TODO: 
//bullet isn't as spammy, maxes at 9 on screen but is a lil wonky still, add timing that wworks?
//add swarming behavior
//add following behavior
//add obstacles (?)
//need music
//collision detection -- maybe improve and offset initial image position ? otherwise fine
//titlescreen only works for game -- no instructions or credits yet
//make highscore int and such
//wait to spawn enemies so player isn't instantly flooded
//add scrolling mechanics to screen -- need larger image
PImage bkg, player, goldfish, bullet;



float dt = 1/frameRate;
float level = 1;

int count;
int boss_bool = 0;

float score = 1;

//static int numBoss = 5*level;
float numBoss = 5;


float speed = 2;
float targetSpeed = 7;
float maxForce = 10;


int score = 0;

Vec2 velStep = new Vec2(0,0);

float max_enemies = 5;

static int screenX = 750;  //x and y of background 
static int screenY = 750;
player p = new player();
ArrayList<bullet> bullets = new ArrayList<bullet>();  //need way to keep track of bullets
ArrayList<enemy> enemies = new ArrayList<enemy>();  //need way to keep track of enemies
ArrayList<boss> boss = new ArrayList<boss>();  //need way to keep track of bosses
boolean radDebug = false;
float timeCurr;
float timePrev;  //useful for spacing out the claw shooting things
int screen = 0; //tells us if we're on title screen (0), how to play screen (1), credit screen(5), general game screen(2),  boss screen(3), or gameover screen(4). 


void settings()
{
  size(screenX,screenY);
}
void setup() {
  bkg = loadImage("images/background.PNG");
  player = loadImage("images/crab.png");
  bullet = loadImage("images/claw.png");
  p.setPos(new Vec2(325,325));
}



public void spawnEnemy(){
  
 float a = random(1);
  
  if(a<.3f){ 
    enemies.add(new enemy(random(700), random(700)));
 }
  else if(a <.4f){ 
     enemies.add(new squid(random(600), random(700)));    
  } 
  else{
     enemies.add(new neonTetra(random(700),random(700)));
  }
 
} 
public void spawnBoss(){
    //come up with better way to spawn boss rather than random
      for(int i = 0; i < (numBoss*level); i++){
       boss.add(new boss(random(30,200), random(30,200)));
   }
  }

public void update(){
  //max_enemies *= level;
  //numBoss *= level;
  isColliding();
  p.update();

  if (boss.size() < 1){
    boss_bool = 0;
    }
  if(boss.size() >=1){
    boss_bool = 1;
    }
  if(enemies.size() < (max_enemies*level) && boss.size() ==0 && boss_bool == 0){
    boss_bool = 1;
    p.health = level*2;
    spawnEnemy();
  }
  if((score > (level*5)-1) && (boss.size() < numBoss) && boss_bool ==0){
    spawnBoss();
    println("level: ", level);
    level++;
  }
  
  if(enemies.size() >0){
  for(int i = 0; i< enemies.size(); i ++){
    if(!enemies.get(i).alive){
      enemies.remove(i);
      print(score);
      score++;
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
  for(int i = 0; i< bullets.size(); i ++){
    if(bullets.get(i).alive != true){
      bullets.remove(i);
    }
    else{
      Vec2 pos = bullets.get(i).getPos();      
      if(pos.x >screenX  ||pos.x<0 || pos.y >screenY || pos.y<0){ //check if in bounds
        bullets.remove(i);
      }
      else{
        bullets.get(i).update();
      }
    }
  }
}
///////////////// THIS IS WHERE ENTIRE BOIDS ALGORITHM GETS IMPLEMENTED ////////////////////
  if(boss.size() >0){
  for(int i = 0; i< boss.size(); i ++){
    Vec2 zeroVec = new Vec2 (0,0);
    boss.get(i).setAcc(zeroVec);
 
    
    /////////////////////////////
    //Seperation force (push away from each neighbor if we are too close
    for  (int j = 0; j < boss.size(); j++){ //Go through neighbors
      float dist = boss.get(i).pos.distanceTo(boss.get(j).pos);
      if (dist < .01 || dist > 50) continue; //TODO: Why do we not need to skip i == j?
      Vec2 seperationForce =  boss.get(i).pos.minus(boss.get(j).pos).normalized();
      seperationForce.setToLength(200.0/pow(dist,2));
      boss.get(i).acc = boss.get(i).acc.plus(seperationForce);
      //if (i ==0) println(acc[i].x,acc[i].y,pos[i].minus(pos[1]).length());
    }
    //Atttraction force (move towards the average position of our neighbors
    Vec2 avgPos = new Vec2(0,0);
    int count = 0;
    for  (int j = 0; j <  boss.size(); j++){ //Go through each neighbor
      float dist = boss.get(i).pos.distanceTo(boss.get(j).pos);
      if (dist < 60 && dist > 0){
        avgPos.add(boss.get(j).pos);
        count += 1;
      }
    }
    avgPos.mul(1.0/count);
    if (count >= 1){
      Vec2 attractionForce = avgPos.minus(boss.get(i).pos);
      attractionForce.normalize();
      attractionForce.mul(1.0);
      attractionForce.clampToLength(maxForce);
      boss.get(i).acc = boss.get(i).acc.plus(attractionForce);
    }
    //Alignment force
    Vec2 avgVel = new Vec2(0,0);
    count = 0;
    for  (int j = 0; j <  boss.size(); j++){ //Go through each neighbor
      float dist = boss.get(i).pos.minus(boss.get(j).pos).length();
      if (dist < 40 && dist > 0){
        avgVel.add(boss.get(j).vel);
        count += 1;
      }
    }
    avgVel.mul(1.0/count);
    if (count >= 1){
      Vec2 towards = avgVel.minus(boss.get(i).vel);
      towards.normalize();
      boss.get(i).acc = boss.get(i).acc.plus(towards.times(2));
    }
    //Goal Speed
    Vec2 mousePos = new Vec2(mouseX, mouseY);
    Vec2 targetVel = mousePos.minus(boss.get(i).pos);
    targetVel.setToLength(targetSpeed);
    Vec2 goalSpeedForce = targetVel.minus(boss.get(i).vel);
    goalSpeedForce.mul(1.0);
    goalSpeedForce.clampToLength(maxForce);
    boss.get(i).acc = boss.get(i).acc.plus(goalSpeedForce);    
    
    //Wander force
    Vec2 randVec = new Vec2(1-random(2),1-random(2));
    boss.get(i).acc = boss.get(i).acc.plus(randVec.times(10.0)); 
    
    ///////////////////////////////////
    
    
    
    //Update Position & Velocity
    boss.get(i).pos = boss.get(i).pos.plus(boss.get(i).vel.times(dt));
    boss.get(i).vel = boss.get(i).vel.plus(boss.get(i).acc.times(dt));
    //println(vel[i].x,vel[i].y);
    
    //Max speed
    if (boss.get(i).vel.length() > speed*level){
      boss.get(i).vel = boss.get(i).vel.normalized().times(speed*level);
    }
  /*
      Vec2 pos = boss.get(i).getPos(); 
      float rad = boss.get(i).getRad();
      Vec2 newVel = new Vec2 (2,1);
      boss.get(i).setVel(newVel); */
     
    if(!boss.get(i).alive){
      boss.remove(i);
      return;
    }
    //check if it reaches an edge 
    if(boss.get(i).pos.x >screenX - boss.get(i).radius*2 ||boss.get(i).pos.x<0 || boss.get(i).pos.y >screenY || boss.get(i).pos.y<0) //check if in bounds, if out of screen bounds then negate direction
    {
      boss.get(i).setVel(boss.get(i).getVel().times(-1)); 
    } 
  boss.get(i).update();
  }
 }
/////////////////// SWARMING ALGORITHM FOR BOSS FINISHED HERE ////////////////////////////



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
        score += 10;
      }
    }
  }

  for(int i = 0; i< boss.size(); i++){       //loop through all boss
    float eRad = boss.get(i).getRad();
    Vec2 ePos = boss.get(i).getPos();
    Vec2 pPos = p.getPos();
    float pRad = p.getRad();
    ePos = new Vec2(ePos.x + eRad, ePos.y + eRad);
    pPos = new Vec2(pPos.x + pRad, pPos.y + pRad);
    if(ePos.distanceTo(pPos)<pRad+eRad){  //check if player hits any bosses
      boss.get(i).hit();
      p.hit();
    }
  
 
    for(int j = 0; j < bullets.size(); j++){  //loop through all bullets on screen
      Vec2 bPos = bullets.get(j).getPos();
      float bRad = bullets.get(j).getRad();
      bPos = new Vec2(bPos.x + bRad, bPos.y + bRad);
      if(ePos.distanceTo(bPos)<eRad+bRad){
        bullets.get(j).hit();
        boss.get(i).hit();  
        score += 50;
      }
    }
  }
}//end of isColliding

// Runs physics operations for player and projectile movement
void movePhysics(float dt) {
  //Vec2 newPlayerPos = p.getPos().plus(p.getVel().times(dt));
  //p.setPos(newPlayerPos);
  for (int i = 0; i < bullets.size(); i++) {
    Vec2 newBulletPos = bullets.get(i).getPos().plus(bullets.get(i).getVel().times(dt));
    bullets.get(i).setPos(newBulletPos);
  }
} // end of movePhysics


void draw() {
  movePhysics(1/frameRate);
  
  if(screen == 0){
    image(loadImage("images/tidalTitle.png"),0,0);
   // rect(190*1.25,230*1.25,190*1.25,45*1.25); // for start
  }
  if(screen == 1 ){ //checks what screen we are on, 0 is title screen
    if(p.isAlive()){
       update(); //called every time so we have right positions for everything
    image(bkg, 0, 0); //draw background
    for(int i = 0; i <bullets.size(); i++){     //draw bullets
      image(bullet, bullets.get(i).pos.x, bullets.get(i).pos.y);
     }
    for(int i = 0; i <enemies.size(); i++){    //draw enemies
      image(loadImage(enemies.get(i).getImage()), enemies.get(i).pos.x, enemies.get(i).pos.y, enemies.get(i).radius*3,enemies.get(i).radius*3);
    }
    for(int i = 0; i <boss.size(); i++){    //draw boss figures
      image(loadImage(boss.get(i).getImage()), boss.get(i).pos.x, boss.get(i).pos.y, boss.get(i).radius*3,boss.get(i).radius*3);
    }
    for(int i = 0; i<p.health; i++){
      image(bullet, 10+i*30, 10);
    }
    
    // Writing score to screen
    
    fill(0);
    stroke(5);
    fill(255);
    textFont(createFont("Arial",16,true), 30);
    text("Score: " + str(score), 3*width/4, 30);
    
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
      for(int i = 0; i< boss.size(); i ++)
      {        
       Vec2 bPos = boss.get(i).getPos();
       float bRad = boss.get(i).getRad();
       circle(bPos.x + bRad, bPos.y + bRad, bRad*2);
      }
     } //end of hitbox debug
    }
    if(!p.isAlive()){  //switch to gameoverScreen
      screen = 4; //gameover screen
    image(loadImage("images/dedScreen.png"),0,0);
    }
  }
 
  image(player, p.getPos().x, p.getPos().y);
  
  
  
  
}
void mouseClicked(){
//changes depending on screen
  if(screen == 0){
    //check mouse x and y to see if they're in bounds of play button
    if(mouseX >190*1.25 && mouseX <190*1.25+190*1.25){
      if(mouseY >230*1.25 && mouseX <230*1.25+45*1.25){
        screen = 1;
      }
    }
  }
  if(screen == 4){  //click to return to main screen
    screen = 0;
    p.reset();
    level = 1;
    score = 1;
    enemies.clear();
    bullets.clear();
    boss.clear();
  }

}
void keyPressed() {
  /*
  if(key == 'w' || key == 'W')
  {
    p.setVel(new Vec2(p.getVel().x, -450));
  }
  if(key == 's' || key == 'S')
  {
    p.setVel(new Vec2(p.getVel().x, 450));
  }
  if(key == 'a' || key == 'A')
  {
    p.setVel(new Vec2(-450, p.getVel().y));
  }
  if(key == 'd' || key == 'D')
  {
    p.setVel(new Vec2(450, p.getVel().y));
  }
    */
  if(keyCode == ' '){
   /* timeCurr = millis();        //time delay was a pain,maybe fix later?
    float elapsed = timeCurr-timePrev;
    timePrev = millis(); */
    if(bullets.size() < 9){// && elapsed>300){
      bullets.add(p.fire());
    }
  }
}

void keyReleased() {
  /*
  if(key == 'w' || key == 'W')
  {
    p.setVel(new Vec2(p.getVel().x, 0));
  }
  if(key == 's' || key == 'S')
  {
    p.setVel(new Vec2(p.getVel().x, 0));
  }
  if(key == 'a' || key == 'A')
  {
    p.setVel(new Vec2(0, p.getVel().y));
  }
  if(key == 'd' || key == 'D')
  {
    p.setVel(new Vec2(0, p.getVel().y));
  }
  */
}
