public class object //base class for everything
{
  Vec2 vel;
  Vec2 pos;
 float radius; //for collisions, need hitbox
 boolean alive;
 float health;
 String img;
 
  public object(){
   pos = new Vec2(0,0);
   vel = new Vec2(0,0);
   radius = 3;
   health = 0; //base health, 0 means can only take one hit
   img = "images/goldfish.png"; //default image
  }
  
  public void update(){
    if(alive)
    {
      pos = pos.plus(vel);
    }
  }
  
 
  
  public void die(){ //easy cleanup for bullet
  alive = false;
  }
  
   public void hit(){
    if(health >0){
      health --;
    }
    else
    {
      die();
    }
  }
  
  //getter and setter functions
  public void setRadius(float r) {radius = r;} //for collision detection later on 
  public float getRadius() { return radius;} //for collision detection later on 
  public void setImage(String str) {img =str;} //for future classes when we want to change the image
  public String getImage() {return img;} //for future classes when we want to change the image
  public Vec2 getPos(){return pos;}
  public void setPos(Vec2 v){pos = v;}
  
 
    
}
