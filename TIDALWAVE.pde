 import processing.sound.*;
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
PImage bkg, player, goldfish, bullet,rules;
float start, curr;//for looping sound
  SoundFile file;
  String audioName = "crabRave.wav";
SoundFile bulletNoise;
  String bulletSoundFile = "bubble.wav";



float level = 1;
boolean updateSpeed;
float dt = 1/frameRate;
int count;
int boss_bool = 0;



//static int numBoss = 5*level;
float numBoss = 5;


float speed = 2;
float targetSpeed = 7;
float maxForce = 10;


int score = 0;

Vec2 velStep = new Vec2(0,0);

float max_enemies = 5;
int startPosX,startPosY;
static int screenX = 750;  //x and y of background
static int screenY = 750;
int trueScreen = 2250; //image is a cube, 2250x 2250 y
int screenPosX, screenPosY; //keeps track of the top left corner of screen
player p;// = new player();
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
  bkg = loadImage("images/scene.png");
  player = loadImage("images/crab.png");
  bullet = loadImage("images/claw.png");
  rules = loadImage("images/rulesScreen.png");
  textFont(createFont("Minecraft.ttf",16,true), 30);
  p = new player(325,500);
  startPosX = 333;
  startPosY = 333;
    file = new SoundFile(this,audioName);
    bulletNoise = new SoundFile(this,bulletSoundFile);
    file.play();
    start = millis();

}



public void spawnEnemy(){

 float a = random(1);

  if(a<.3f){
    enemies.add(new enemy(random(1355-startPosX), random(1355-startPosY)));
 }
  else if(a <.4f){
     enemies.add(new squid(random(1355-startPosX), random(1355-startPosY)));
  }
  else{
     enemies.add(new neonTetra(random(1355-startPosX),random(1355-startPosY)));
  }

}
public void spawnBoss(){
    //come up with better way to spawn boss rather than random
      for(int i = 0; i < (numBoss*level); i++){
       boss.add(new boss(random(-startPosX, 1355-startPosX), random(-startPosY,1355-startPosY)));
       }
  }

public void update(){
  //max_enemies *= level;
  //numBoss *= level;
  curr = millis();
  if(curr-start >= 163326.4 && screen == 1){//if we've reached the end of our audiofile, play again!
       file.stop();
        file.cue(28.9);
        file.play();
        file.amp(.3);
        start = millis()+ 28900;
  }
 
  isColliding();
    p.update();
    startPosX += (int) (p.getVel().x*1.3);  //helps with screen scrolling
    startPosY += (int) (p.getVel().y*1.3);
    updateSpeed = true;
    if(startPosX <0)
    {
      updateSpeed = false;
    startPosX = 0;
    }else if(startPosX >1000-333)
    {
      updateSpeed = false;
    startPosX = 1000-333;
    } if(startPosY <0)
    {
      updateSpeed = false;
    startPosY = 0;
    }else if(startPosY >1000-333)
    {
      updateSpeed = false;
    startPosY = 1000-333;
    }
  if (boss.size() < 1){
    boss_bool = 0;
    }
  if(boss.size() >=1){
    boss_bool = 1;
    }
  if(enemies.size() < (max_enemies*level) && boss.size() ==0 && boss_bool == 0){
    boss_bool = 1;
    spawnEnemy();
  }
  if((score > (level*5)-1) && (boss.size() < numBoss) && boss_bool ==0){
    spawnBoss();
    println("level: ", level);
    level++;
     p.health += level;
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
      Vec2 currPos = new Vec2(pos.x+startPosX, pos.y + startPosY);
      if(currPos.x > 1355  || currPos.x<0 || currPos.y >1355   || currPos.y < 0) //check if in bounds, if out of screen bounds then negate direction
      {
        enemies.get(i).setVel(enemies.get(i).getVel().times(-1));
      enemies.get(i).flipImage();
      if(currPos.x >1355){
      enemies.get(i).setPos(new Vec2(1335-startPosX -rad*2, enemies.get(i).getPos().y));
      }else if(currPos.x <0){
      enemies.get(i).setPos(new Vec2(-startPosX + rad*2, enemies.get(i).getPos().y));
      }else if(currPos.y >1355){
      enemies.get(i).setPos(new Vec2(enemies.get(i).getPos().x, 1335-startPosY + rad*2));
      }else if(currPos.y <0){
      enemies.get(i).setPos(new Vec2(enemies.get(i).getPos().x, -startPosY + rad*2));
      }
      }

  enemies.get(i).update();
     if(updateSpeed){ enemies.get(i).setPos(enemies.get(i).getPos().minus((p.getVel().times(2.24))));}

  }
  }
  if(bullets.size() >0){  //each update check if bullet has died or is off screen.
  for(int i = 0; i< bullets.size(); i ++){
    if(bullets.get(i).alive != true){
      bullets.remove(i);
    }
    else{
      Vec2 pos = bullets.get(i).getPos();
      if(pos.x >1416  ||pos.x<0 || pos.y >1416 || pos.y<0){ //check if in bounds
        bullets.remove(i);
      }
      else{
        bullets.get(i).update();
        if(updateSpeed){bullets.get(i).setPos( bullets.get(i).getPos().minus((p.getVel().times(2.24))));
     }
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
  
    //Max speed
    if (boss.get(i).vel.length() > speed*level){
      boss.get(i).vel = boss.get(i).vel.normalized().times(speed*level);
    }
  

    if(!boss.get(i).alive){
      boss.remove(i);
      return;
    }
    //check if it reaches an edge
   /* if(boss.get(i).pos.x >trueScreen - boss.get(i).radius*2 ||boss.get(i).pos.x<0 || boss.get(i).pos.y >trueScreen || boss.get(i).pos.y<0) //check if in bounds, if out of screen bounds then negate direction
    {
      boss.get(i).setVel(boss.get(i).getVel().times(-1));
    } */
    
      Vec2 pos = boss.get(i).getPos();
      float rad = boss.get(i).getRad();
     Vec2 currPos = new Vec2(pos.x+startPosX, pos.y + startPosY);
      if(currPos.x > 1355  || currPos.x<0 || currPos.y >1355   || currPos.y < 0) //check if in bounds, if out of screen bounds then negate direction
      {
       // boss.get(i).setVel(boss.get(i).getVel().times(-1));
     // boss.get(i).flipImage();
      
      if(currPos.x >1355){
      boss.get(i).setPos(new Vec2(1355-startPosX -rad*12, boss.get(i).getPos().y));
      }else if(currPos.x <0){
      boss.get(i).setPos(new Vec2(0-startPosX + rad*12, boss.get(i).getPos().y));
      }else if(currPos.y >1355){
      boss.get(i).setPos(new Vec2(boss.get(i).getPos().x, 1355-startPosY - rad*12));
      }else if(currPos.y <0){
      boss.get(i).setPos(new Vec2(boss.get(i).getPos().x, 0-startPosY +rad*12));
      }
      }
  boss.get(i).update();
  if(updateSpeed){ boss.get(i).setPos(boss.get(i).getPos().minus((p.getVel().times(2.242424))));

  }
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
   cursor(bullet);
    image(loadImage("images/tidalTitle.png"),0,0);
    curr = millis();
     if(curr-start >= 28900 &&( screen == 0 ||screen == 4 || screen == 2)){//if we've reached the end of our audiofile, play again!
        file.cue(0);
        file.play();
        file.amp(1);
        start = millis();
  }
   //rect(165*1.25, 420*1.25, 255*1.25, 45*1.25); // for start
  }else if(screen == 2){
    curr = millis();
     if(curr-start >= 28900 &&( screen == 0 ||screen == 4 || screen == 2)){//if we've reached the end of our audiofile, play again!
        file.cue(0);
        file.play();
        file.amp(1);
        start = millis();
  }
   cursor(bullet);
    image(rules,0,0);
    fill(255,255,255);
    text("HOW TO PLAY ", 250, 50);
    
    text("use your mouse to move the crab",100, 175);
    
    text("press space to shoot claws", 100, 300);
    
    text("shoot as many fish as possible! ", 100, 425);
    
    text("press spacebar to return to main menu ", 100, 550);
    //rect(190*1.25, 230*1.25, 190*1.25, 45*1.25); // for start
  }else if(screen == 3){
    curr = millis();
     if(curr-start >= 28900 || curr-start>=0 &&( screen == 0 ||screen == 4 || screen == 2)){//if we've reached the end of our audiofile, play again!
        file.cue(0);
        file.play();
        file.amp(1);
        start = millis();
  }
   cursor(bullet);
    image(rules,0,0);
    fill(255,255,255);
    text("CREDITS ", 320, 50);
    
    text("JACOB NELSON",50, 175);
    
    text("WYATT GUSTAFSON", 50, 300);
    
    text("AUDREY HEBERT ", 50, 425);
    
    text("MADE FOR FALL 2021 5611 FINAL PROJECT ", 50, 550);
    
    text("press spacebar to return to main menu ", 50, 675);
    //rect(190*1.25, 230*1.25, 190*1.25, 45*1.25); // for start
  }
  if(screen == 1 ){ //checks what screen we are on, 0 is title screen
    if(p.isAlive()){
      noCursor();
       update(); //called every time so we have right positions for everything
    image(bkg, 0, 0, 750, 750, startPosX, startPosY, startPosX+333, startPosY+333);
    //print("pos of screen X is " + startPosX + "Pos of screen Y is " + startPosY + "\n");
    //image(bkg, 0, 0); //draw background
    for(int i = 0; i <bullets.size(); i++){     //draw bullets
      image(bullet, bullets.get(i).pos.x, bullets.get(i).pos.y);
     }
    for(int i = 0; i <enemies.size(); i++){    //draw enemies
      image(loadImage(enemies.get(i).getImage()), enemies.get(i).pos.x, enemies.get(i).pos.y);// enemies.get(i).radius*3,enemies.get(i).radius*3);
    }
    for(int i = 0; i <boss.size(); i++){    //draw boss figures
      image(loadImage(boss.get(i).getImage()), boss.get(i).pos.x, boss.get(i).pos.y, boss.get(i).radius*12,boss.get(i).radius*12);
    }
    for(int i = 0; i<p.health; i++){
      print("health is ! " + p.health);
      image(bullet, 10+i*30, 10);
    }

    // Writing score to screen

    fill(0);
    stroke(5);
    fill(255);
   
    text("Score: " + str(score), 3*width/4, 30);
     text("LEVEL " + str(level), 2*width/4, 30);

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

    image(loadImage(p.getImage()), p.getPos().x, p.getPos().y);
    }
    if(!p.isAlive()){  //switch to gameoverScreen
      screen = 4; //gameover screen
       curr = millis();
       if(curr-start >= 28900 || curr-start <0 &&( screen == 0 ||screen == 4 || screen == 2)){//if we've reached the end of our audiofile, play again!
        print("REACHED!!!");
        file.cue(0);
        file.play();
        file.amp(1);
        start = millis();
  }
    image(loadImage("images/dedScreen.png"),0,0);
    cursor(bullet);
    }
  }





}

void mouseClicked(){
//changes depending on screen
  if(screen == 0){
    //check mouse x and y to see if they're in bounds of play button
    if(mouseX >190*1.25 && mouseX <190*1.25*2){
      if(mouseY >230*1.25 && mouseY <230*1.25+45*1.25){
        screen = 1;
        file.cue(28.9);
        file.play();
        file.amp(.3);
        start = millis()+28900;
      }
    }
     if(mouseX >186*1.25 && mouseX <195*1.25*2){
      if(mouseY >327*1.25 && mouseY <330*1.25+45*1.25){
        screen = 2;
      }
    }
    if(mouseX >165*1.25 && mouseX <165*1.25+255*1.25){
      if(mouseY >420*1.25 && mouseY <420*1.25+45*1.25){
        screen = 3;
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
  if(screen == 2){
    if(keyCode == ' '){
    screen = 0;
  }
  }
  if(screen == 3){
    if(keyCode == ' '){
    screen = 0;
  }
}
  
  if(keyCode == ' '){
   if(bullets.size() < 9){
      bullets.add(p.fire());
      bulletNoise.play();
    }
  }
}
