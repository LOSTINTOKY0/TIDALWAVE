  public class enemy extends object //want a base enemy class so that we can easily build subclasses off of it
  {
  float aggression; //this is how likely the enemy is to attack; 0== no agression, 1 == very agressive  
  
  public enemy()  //constructor with default values
  {   
  super();
  aggression = .5f; //base agression
  vel = new Vec2(2,2);
  radius = 4;
  img ="images/goldfish.png"; //default enemy image;
  }
  public enemy(float x, float y)  //constructor with default values
  {   
  super();
  pos = new Vec2(x,y);
  aggression = .5f; //base agression
  vel = new Vec2(2,0);
  radius = 4;
  img ="images/goldfish.png"; //default enemy image;
  }
  
  public void flipImage(){
    if(img.equals("images/goldfish.png")){
        img = "images/goldfish2.png";
    }
    else
    {
      img = "images/goldfish.png";
    }
  }

}
