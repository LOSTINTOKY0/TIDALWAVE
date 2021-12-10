public class player extends object{
  int frame; // if we want to make this an animation, tells us what frame the player should be on. 
 
  boolean isInvincible;
  
  
  player()
  {
    super();
    frame = 1;   //start frame 
    super.health = 3; //default life number
    isInvincible = false; //for powerup later on
    super.vel = new Vec2(15,15);  //base velocity is 3 pix
    super.pos = new Vec2(mouseX-16*3,mouseY-16*3);
    super.radius = 32*3/2;
    
  }
  
  public void update(){
    pos.x = mouseX-16*3;
     pos.y= mouseY-16*3;
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
