public class player extends object{
  int frame; // if we want to make this an animation, tells us what frame the player should be on.

  boolean isInvincible;
  float speed = .05;

  player()
  {
    super();
    frame = 1;   //start frame
    super.health = 3; //default life number
    isInvincible = false; //for powerup later on
    super.vel = new Vec2(0,0);  //base velocity is 3 pix
    super.pos = new Vec2(mouseX-16*3,mouseY-16*3);
    super.radius = 32*3/2;
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

  }



  public void update(){
    //calculate distance from pos of crab to mouseX and mouseY
    Vec2 v = new Vec2(mouseX-16*3,mouseY-16*3);
    if(v.length() > 1){
     vel = vel.plus(pos.minus(new Vec2(mouseX-16*3,mouseY-16*3)).normalized().times(-1*.05));

    }
    vel = pos.minus(new Vec2(mouseX-16*3,mouseY-16*3)).times(-.05);
     pos.x += vel.x; //mouseX-16*3;
     pos.y += vel.y; //mouseY-16*3;
  }


  public void updateFrame()
  {
  }//not super important yet

  public void reset(){
    p.health = 3;
    p.alive = true;
  }
  public bullet fire()
  {
    //create bullet(s?) from angle of crab claw(s)
    bullet b = new bullet(pos.x+72, pos.y+21); //offset so it fires from right claw
    return b;
  } //shoot claws

  public boolean isAlive(){return alive;}


}
