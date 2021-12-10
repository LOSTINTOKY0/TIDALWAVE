public class squid extends enemy{

public squid(){
  super.one = "images/squid.png";
  super.two = "images/squid2.png";
  super.img = one;
  super.vel = new Vec2(0,1);
  super.radius = 30;
}
public squid(float x, float y){
    super.pos = new Vec2(x,y);
    super.one = "images/squid.png"; 
    super.two = "images/squid2.png";
    super.img = one;
    super.vel = new Vec2(0,-1.5);
    super.radius = 30;
}
public void ink(){} //create cloud of ink that stays on screen ~3-4 secs
 
}
