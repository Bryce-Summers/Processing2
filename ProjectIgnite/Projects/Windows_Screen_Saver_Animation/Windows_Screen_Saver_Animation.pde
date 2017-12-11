/*
 * Windows bouncing ball screen saver.
 * Written by Grant Schwabacher.
 */

int xPos = 10;
int xDir = 1;
int yPos = 10;
int yDir = 1;

int ball_radius = 10;

void setup()
{
  size(600, 400);
  smooth();
  frameRate(100);
}

void draw()
{
   
  background(124); // Try commenting out this line!
  
  
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