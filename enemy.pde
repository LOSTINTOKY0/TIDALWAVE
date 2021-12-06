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

}
