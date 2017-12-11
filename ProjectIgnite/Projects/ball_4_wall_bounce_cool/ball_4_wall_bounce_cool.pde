/*
 * Cool wall bounce patterns.
 * Written by Bryce Summers.
 * Adapted from the windows bouncing ball screen saver, which was written by Grant Schwabacher.
 * 
 */

float xPos = 10;
float xDir = 1;
float yPos = 10;
float yDir = 1;
int angle  = -45;

int ball_radius = 10;

void setup()
{
  size(600, 400);
  smooth();
  frameRate(100);
  
  xPos = width/2;
  yPos = height/2;
}

void draw()
{
   
  //background(124, 124, 124, .00); // Try commenting out this line!
  fill(124, 124, 124, 25);
  rect(0, 0, width, height);
  
  if(frameCount % 60 == 0)
  {
   xPos = width/2;
   yPos = height/2;
   
   xDir = cos(radians(angle));
   yDir = sin(radians(angle));
   angle++;
  }
  
  fill(0);
  for(int i = 0; i < 1000; i++)
  {
   drawBall(); 
  }
  
  
}

void drawBall()
{
  ellipse(xPos, yPos, 20, 20);
  
  // Move the ball in the x direction by its x_velocity.
  xPos = xPos + xDir;
  
  // Bouncing off left and right walls.
  if(xPos > width - ball_radius || xPos < ball_radius)
  {
    xDir = xDir*-1;
  }
  
  // Move the ball in the y direction by its y_velocity.
  yPos = yPos + yDir;
  
  // Bouncing off top and bottom walls.
  if(yPos > height - ball_radius || yPos < ball_radius)
  {
    yDir = yDir*-1;
  }  
}