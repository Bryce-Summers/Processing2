int seed = 15;
double cos_pi_over_6 = 0.86602540378;
double cos_pi_over_3 = 0.5;
double angle = cos_pi_over_3;


void setup()
{
  // 200 base height for beam.
  // 1080 for entire screen.
  size(300, 300);
}

void draw()
{
  int light_density = 1920*200/1000;
  
  light_density *= .33 * .25;
  
  for(int i = 0; i < 5; i++)
  {    
    export_background(seed + i, light_density, "level0_" + i + ".png");
    export_foreground(seed + i, light_density, "level1_" + i + ".png");
  }
}

void export_foreground(int seed, int light_density, String name)
{  
  PGraphics g = createGraphics(width, height);
  
  g.beginDraw();
  
  // White.
  //g.background(0xffffffff);
  
  // White.
  color from = 0xffffffff;
  color to   = 0xFF3D87FF;
  color black = 0xff000000;  
  
  g.fill(0xFF3D87FF);
  g.stroke(0,0,0);
  
  randomSeed(seed);
  
  for(int i = 0; i < light_density; i++)
    drawPhoton(g, 0);
 
     
  g.endDraw();
  g.save(name);
  
  g.line(0, 0, width, height);
  
  // Draw the image to the screen.
  image(g, 0, 0);
  
  noLoop();  
}

void export_background(int seed, int light_density, String name)
{
  PGraphics g = createGraphics(width, height);
  
  g.beginDraw();
  
  // White.
  //g.background(0xffffffff);
  
  // White.
  color from = 0xffffffff;
  color to   = 0xFF3D87FF;
  color black = 0xff000000;  
  
  g.fill(0xFF3D87FF);
  g.stroke(0,0,0);
  
  randomSeed(seed);
  
  // Standard beam of light density: width*height/1000
  
  for(int i = 0; i < light_density; i++)
    drawPhoton(g, 1);
 
     
  g.endDraw();
  g.save(name);
  
  g.line(0, 0, width, height);
  
  // Draw the image to the screen.
  image(g, 0, 0);
  
  noLoop();
}

void drawPhoton(PGraphics g, int level)
{
  
  /*
  float cx = -100;
  float cy = height/2;
  */
  
  float cx = 0;
  float cy = height/2;

  float px = random(width);
  float py = random(height);
  
  float hue = random(1);
    
  float diameter = 4;
  g.noStroke();
    
  g.ellipseMode(CENTER);  // Set ellipseMode to CENTER
  g.colorMode(HSB, 1);
  g.fill(hue, 100, 100);  // Set fill to gray
  
  // Particles in the foreground.
  if(level == 0)
    g.ellipse(px, py, diameter, diameter);  // Draw gray ellipse using CENTER mode.
  
  // normalized velocity direction.
  
  float dx = px - cx;
  float dy = py - cy;
  
  float distance = dist(cx, cy, px, py);
  
  dx /= distance;
  dy /= distance;
  
  dx *= 100;
  dy *= 100;
  

  /*
  float dx = 100;
  float dy = 0;
  */

  // Motion lines in the background.
  if(level == 1)
    g.stroke(hue, 50, 100);
    g.strokeWeight(1);
    g.line(px, py, px - dx, py - dy);
} //<>//