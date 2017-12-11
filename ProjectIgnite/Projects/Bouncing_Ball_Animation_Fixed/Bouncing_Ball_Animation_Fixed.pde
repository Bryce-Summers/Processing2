/*
 * Bouncing Ball Example.
 * Written by Grant Schwabacher.
 */

float dx=10;  // Initial x position
float dy=10;  // Initial y position
float vx=10;  // Initial x velocity
float vy=0;   // Inital y velocity
float t=.1;   // Time steps
float g=9.8;  // Acceleration due to gravity, where each pixel = 1 meter
float vyf=0;  // Final y velocity
float r=.85;  // Coeficient of Restitution (Bounciness)

void setup()
{
  size(700, 400);
  smooth();
  background(100);
  frameRate(30/t);
}

void draw()
{
  background(100);
  println("dx: " + dx + " dy: " + dy);
  if(dx > (width - 5) && dy > (height - 5))
  {
    ellipse(dx,dy,10,10);
  }
  else 
  {
    println("final y: " + vyf + " y: " + vy);
    ellipse(dx, dy, 10, 10);
    vyf=vy+g*t; 
    dy=dy+vy*t+.5*(vyf-vy)*t;
    println("final dy: " + dy);
    vy=vyf;
    if(dy>(height-5) || dy<5)
    {
      vy=vy*(-r);
    }
    dx=dx+vx*t;
    if(dx>(width-5) || dx<5)
    {
      vx=vx*(-r);
    }
  }
}
  
 