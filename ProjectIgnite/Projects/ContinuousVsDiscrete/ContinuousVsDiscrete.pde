PGraphics g;

void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  fullScreen();
  g = createGraphics(width, height);
}

void draw()
{
  
  
  g.beginDraw();
  
  // Draw the continuous function.
  int resolution = 50;
  
  // Draw the approximation boxes.
  g.rectMode(CORNERS);
  g.strokeWeight(5);
  int box_val = 60;
  g.stroke(box_val, box_val, box_val);
  for(int x = 0; x < width; x += resolution)
  {
    float y = max(f_0(x), f_0(x + resolution));
    float val = 255 - 255*f_shift(x);
    g.fill(val, val, val);
    
    g.rect(x, y, x + resolution, height);
  }
  
  g.strokeWeight(10);
  g.stroke(0, 0, 0);
  g.noFill();
  g.beginShape();
  for(int x = 0; x < width; x += 10)
  {
    g.vertex(x, f_0(x));
  }
  g.endShape();
  
  
  g.endDraw();
  
  g.save("output.png");
  
  image(g, 0, 0); 
  
  noLoop();

}

// returns y coordinate on screen.
float f_0(int x)
{
  float val = f_shift(x);
  
  return val*height/2 + height/2;
}

// Returns normalized y coordinate.
float f_shift(int x)
{
  return f(x*1.0/width - .5);
}

// A Continous Function.
float f(float x)
{
  float x_2 = x*x;
  float x_3 = x_2*x;
  return -2*x_3 + 3*x_2; // Bryce's Favorite Polynomial.
}


void keyPressed()
{
  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    save("output.png");
  }
}