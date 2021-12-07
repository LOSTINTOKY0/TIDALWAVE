public class neonTetra extends enemy{
  
public neonTetra(float x, float y){
super.pos = new Vec2(x,y);
    super.one = "images/neonTetra.png"; 
    super.two = "images/neonTetra2.png";
    super.img = one;
    super.vel = new Vec2(4.5,-1);
    super.radius = 20;

}
}
