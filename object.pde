public class object //base class for everything
{
 protected Vec2 vel;
 protected Vec2 pos;
 protected Vec2 acc;
 float radius; //for collisions, need hitbox
 boolean alive;
 float health;
 String img;
 
  public object(){
   pos = new Vec2(0,0);
   vel = new Vec2(0,0);
   acc = new Vec2(0,0);
   radius = 20;
   health = 1; //base health, 0 means can only take one hit
   img = "images/goldfish.png"; //default image
   alive = true;
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
    if(health >1){
      health --;
    }
    else
    {
      die();
    }
  }
  
  //getter and setter functions
  public void setRad(float r) {radius = r;} //for collision detection later on 
  public float getRad() { return radius;} //for collision detection later on 
  public void setImage(String str) {img =str;} //for future classes when we want to change the image
  public String getImage() {return img;} //for future classes when we want to change the image
  public Vec2 getPos(){return pos;}
  public void setPos(Vec2 v){pos = v;}
  public void setPos(float x, float y){pos.x = x; pos.y = y;}
  public Vec2 getVel(){return vel;}
  public void setVel(Vec2 v){vel = v;}
  public Vec2 getAcc(){return acc;}
  public void setAcc(Vec2 a){acc = a;}
  
 
    
}
