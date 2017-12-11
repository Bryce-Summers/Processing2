void setup()
{
  size(1920, 1080);
}

void draw()
{

  PGraphics g = createGraphics(width, height);
  
  g.beginDraw();
  
  g.background(0x00000000);

  for(int i = 0; i < 100000; i++)
    drawGrass(g);
   
  g.endDraw();
  g.save("output.png");
  
  g.line(0, 0, width, height);
  
  // Draw the image to the screen.
  image(g, 0, 0);
  
  noLoop();  
}

void drawGrass(PGraphics g)
{ 
  float x = random(1920);
  float y = random(1080);
  
  float angle   = -PI/2 + random(PI/6);
  float d_angle = random(PI/6) - PI/12;
  float len = random(10) + 5;

  g.noFill();
  
  g.strokeWeight(7);
  g.stroke(0xff000000);
  drawLine(g, x, y, angle, d_angle, len);
  
  
  g.strokeWeight(5);
  g.stroke(color((int)random(100), 186, (int)random(100)));
  
  drawLine(g, x, y, angle, d_angle, len);
}

void drawLine(PGraphics g, float x, float y, float angle_start, float d_angle, float len)
{
   float angle = angle_start;
   g.beginShape();
  
  for(int i = 0; i < 10; i++)
  {
    g.vertex(x, y);
    
    x += len*cos(angle);
    y += len*sin(angle);
    
    len *= .9;
    
    angle += d_angle;
  }
  
  g.endShape();
}