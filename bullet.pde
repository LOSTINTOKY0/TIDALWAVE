public class bullet
{
  int durability; // how many fish the bullet can pass through before it dies
  Vec2 vel;
  Vec2 pos;
  float radius; //hitbox of bullet
  boolean dead;
  
  public bullet(float x, float y) //specify start location
  {
    dead = false;
    vel = new Vec2(0,-1.5);
    pos = new Vec2(x,y);
    radius = 3.0f;
  }
  public void update(){
    pos.x = vel.x+pos.x;
    pos.y = vel.y+pos.y;
  
  }
  
  public Vec2 getPos()
  {
  return pos;
  }
  
  public void die(){ //easy cleanup for bullet
  dead = true;
  }
  
  public void collide(){
    if(durability >0){
      durability --;
    }
    else
    {
      die();
    }
  }
    
  
  
}
