public class player extends object{
  int frame; // if we want to make this an animation, tells us what frame the player should be on.

  boolean isInvincible;
  float speed = .05;
  String img2;
  int time = 0;
  boolean doubleShot = false;
  boolean backShot = false;
  boolean spreadShot = false;
  
  player()
  {
    super();
    frame = 1;   //start frame
    super.health = 3; //default life number
    isInvincible = false; //for powerup later on
    super.vel = new Vec2(0,0);  //base velocity is 3 pix
    super.pos = new Vec2(mouseX-16*3,mouseY-16*3);
    super.radius = 32*3/2;
    img = "images/crab.png";
    img2 = "images/crab2.png";
  }

   player(int x, int y)
  {
    super();
    frame = 1;   //start frame
    super.health = 3; //default life number
    isInvincible = false; //for powerup later on
    super.vel = new Vec2(0,0);  //base velocity is 3 pix
    super.pos = new Vec2(x,y);
    super.radius = 32*3/2;
    img = "images/crab.png";
    img2 = "images/crab2.png";

  }



  public void update(){
    time ++;
    //calculate distance from pos of crab to mouseX and mouseY
    Vec2 v = new Vec2(mouseX-16*3,mouseY-16*3);
    if(v.length() > 1){
     vel = vel.plus(pos.minus(new Vec2(mouseX-16*3,mouseY-16*3)).normalized().times(-1*.05));
     if(time%10==0){
      updateFrame();
     }
    }
    vel = pos.minus(new Vec2(mouseX-16*3,mouseY-16*3)).times(-.05);
     pos.x += vel.x; //mouseX-16*3;
     pos.y += vel.y; //mouseY-16*3;
  }
  
  public void hit(){
    if(health >1){
      health --;
      removePowers();
    }
    else
    {
      die();
    }
  }
  
  
  public String getImage() {
    if(frame == 1){
      return img;
    }
    else
    {
      return img2;
    }
  } //for future classes when we want to change the image

  public void updateFrame()  //creates crab animation
  {
    if(frame == 1)
    {
    frame = 2;}
    else
    {
    frame = 1;
  }
  }//not super important yet

  public void reset(){
    p.health = 3;
    p.alive = true;
    doubleShot = false;
    backShot = false;
    spreadShot = false;
  }
  public ArrayList<bullet> fire()
  {
    //create bullet(s?) from angle of crab claw(s)
    ArrayList<bullet> shots = new ArrayList<bullet>();
    bullet b = new bullet(pos.x+72, pos.y+21); //offset so it fires from right claw
    shots.add(b);
    if (spreadShot) {
      shots.add(new bullet(pos.x+72, pos.y+21, new Vec2(500*sin(30*180/PI),500*cos(30*180/PI))));
      shots.add(new bullet(pos.x+72, pos.y+21, new Vec2(500*sin(-30*180/PI),500*cos(30*180/PI))));
    }
    if (doubleShot) {
      shots.add(new bullet(pos.x, pos.y+21));
      if (spreadShot) {
        shots.add(new bullet(pos.x, pos.y+21, new Vec2(500*sin(30*180/PI),500*cos(30*180/PI))));
        shots.add(new bullet(pos.x, pos.y+21, new Vec2(500*sin(-30*180/PI),500*cos(30*180/PI))));
      }
    }
    if (backShot) {
      shots.add(new bullet(pos.x+72, pos.y+21, new Vec2(0, 500)));
      if (doubleShot) {
        shots.add(new bullet(pos.x, pos.y+21, new Vec2(0, 500)));
      }
    }
    
    return shots;
  } //shoot claws
  
  public void removePowers() {
    doubleShot = false;
    backShot = false;
    spreadShot = false;
  }

  public boolean isAlive(){return alive;}


}
