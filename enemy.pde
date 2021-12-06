  public class enemy //want a base enemy class so that we can easily build subclasses off of it
  {
  float aggression; //this is how likely the enemy is to attack; 0== no agression, 1 == very agressive
  Vec2 speed; //idk if this needs to be a vec2 but whatever
  Vec2 pos;  
  float radius; //for collisions, need hitbox
  int health;
  boolean alive;
  
  public enemy()  //constructor with default values
  {   
  pos = new Vec2 (0,0);
  aggression = .5f;
  speed = new Vec2(2,2);
  radius = 4;
  health = 0;
  alive = true;
  }
  
  public float getRadius() //radius will be useful for collision detection
  {  
    return radius;
  }
  
  
  public void ouch() //what happens if is hit by bullet
  {
    if(health>=1)
    {
      health--;
    }
    else
    {
      die();
    }
  }
  
  public void die(){
    alive = false;
  }

}
