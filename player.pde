public class player{
  int frame; // if we want to make this an animation, tells us what frame the player should be on. 
  int life; //life of player
  boolean isInvincible;
  boolean alive;
  Vec2 vel;
  Vec2 pos;
  
  player()
  {
    frame = 1;   //start frame 
    life = 3; //default life number
    alive = true; //starts alive 
    isInvincible = false; //for powerup later on
    pos = new Vec2(0,0);
    vel = new Vec2(3,3);  //base velocity is 3 pix
    
  }
  public void updateFrame()
  {
    
  }//not super important yet
  public bullet fire()
  {
    //create bullet(s?) from angle of crab claw(s)
    bullet b = new bullet(pos.x+72, pos.y+21); //offset so it fires from right claw
    return b;
  } //shoot claws
  
  public void ouch(){
    if(life >0){
    life--;
    }else{
      alive = false;
    }
  }//lose life or die
  
  public Vec2 getPos()
  {
    return pos;
  }
  public void setPos(Vec2 v)
  {
    pos.x = v.x;
    pos.y = v.y;
  }
  

}
