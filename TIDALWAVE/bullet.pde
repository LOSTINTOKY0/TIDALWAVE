public class bullet extends object
{
  public bullet(float x, float y) //specify start location
  {
    super();
    super.vel = new Vec2(0,-2.5);
    super.pos = new Vec2(x,y);
    super.radius = 10;
  }
}
