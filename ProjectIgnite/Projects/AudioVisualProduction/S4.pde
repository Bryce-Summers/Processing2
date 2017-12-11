// A particular scene used in the audio visual production.
class Scene4 implements Scene
{
  // -- Put variables here.
  String myName;
  
  // -- Setup stuff here.
  public void setup()
  {
    myName = "Scene 4";
  }
  
  // -- Draw stuff here.
  public void draw()
  {
    background(frameCount % 255);
    fill((frameCount + 125) % 255);
    textAlign(CENTER, CENTER);
    text(myName, width/2, height/2);
  }
  
  // -- Define useful functions here.
}