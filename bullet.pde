public class bullet extends object
{
  public bullet(float x, float y) //specify start location
  {
    super();
    super.vel = new Vec2(0,-500);
    super.pos = new Vec2(x,y);
    super.radius = 10;
  }
  
  public bullet(float x, float y, Vec2 vel) //specify start location
  {
    super();
    super.vel = vel;
    super.pos = new Vec2(x,y);
    super.radius = 10;
  }
  
  public void update(){
     //pos.x = mouseX-16*3;
     //pos.y= mouseY-16*3;
  }
}
