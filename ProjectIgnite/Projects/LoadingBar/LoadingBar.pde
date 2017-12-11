/*
 * A Simple Loading Bar.
 * Written By, Sara Adkins
 *
 */
int x = 0;

int width  = 500;
int height = 500;

int red  = 255;
int blue = 0;

int size_interval  = 10;
int color_interval = 5;

void setup()
{
  size(500, 200);
  background(0);
  noStroke();
  frameRate(25);
  fill(red, 0, blue);
}

void draw()
{
  rect(x, 50, size_interval, 100);
  
  x    = x + size_interval;
  red  = red - color_interval;
  blue = blue + color_interval;
  
  fill(red, 0, blue);
}