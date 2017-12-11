/*
 * Ex_Sierspinski Triangle Chaos Game Example
 * Written by Grant Schwabacher.
 */

void setup()
{
  size(600, 400);
  smooth();
  background(255);
}

int dx=200;
int dy=300;

void draw()
{
  stroke(#642EFE);
  strokeWeight(2);
  for (int i=0; i<100; i++)
  {
    switch(int(random(3)))
    {
      case 0:              // Points to do with bottom left vertex
        dx=(200+dx)/2;
        dy=(300+dy)/2;
        break;
      case 1:              // Points to do with bottom right vertex
        dx=(400+dx)/2;
        dy=(300+dy)/2;
        break;
      case 2:              // Points to do with top middle vertex
        dx=(600/2+dx)/2;
        dy=(100+dy)/2;
        break;
    }
    point(dx, dy);
  }
}