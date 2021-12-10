public class boss extends enemy{

public boss(){
  super.one = "images/piranha.jpg";
  super.two = "images/piranha.jpg";
  super.img = one;
  super.vel = new Vec2(-1+random(2),-1+random(2));;
  super.radius = 7;
}
public boss(float x, float y){
    super.pos = new Vec2(x,y);
    super.one = "images/piranha.jpg"; 
    super.two = "images/piranha.jpg";
    super.img = one;
    super.vel = new Vec2(-1+random(2),-1+random(2));;
    super.acc = new Vec2(0,0);
    super.vel.normalize();
    super.vel.mul(maxSpeed);
    super.radius = 7;
}
}
