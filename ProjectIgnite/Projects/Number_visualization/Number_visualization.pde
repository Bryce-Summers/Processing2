void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  //size(512, 512);
  //size(1920, 1350);
  size(1920, 1350);
}

void draw()
{

  PGraphics g = createGraphics(width, height);
  g.beginDraw();

  float h = 1080;

  float size = h/4;
  float inc = width/30;
  g.strokeWeight(2);
  g.fill(181, 245, 255, 255); // Light blue.
  int i = 0;
  float y = size;
  float y2 = size*3;
  
  float weight = h/400.0;
  
  for(int x = (int)inc/2 - width; x < width*2; x += inc)
  {
    g.stroke(0, 0, 0, 255); // Black.
    g.strokeWeight(weight*2);
    drawNumber(x,  y,  X(x, size - inc/2), inc/3, g);
    float x2 = f(x - width/2) + width/2;
    drawNumber(x2, y2, X(x, size - inc/2), inc/3, g);
    
    g.strokeWeight(weight);
    g.line(x, y, x2, y2);
    
    
    // Draw the derivative arrows.
    g.stroke(255, 88, 58); // Orange.
    
    // Derivative arrows.
    drawArrow(x, y, x + inc, y, inc/3, g);
    drawArrow(x2, y2, f(x + inc - width/2) + width/2, y2, inc/3, g);

    // Curvature arrows.
   // drawArrow(x, y2, x + f(x + inc) - f(x) - (f(x) - f(x - inc)), y2, inc/3, g);

    g.stroke(0, 0, 0, 255); // Black.
    g.ellipse(x, y, inc/3, inc/3);
    g.ellipse(x2, y2, inc/3, inc/3);
    
    i++;
  }
    
  
  g.endDraw();
  image(g, 0, 0); 
  
  g.save("output.png");
  noLoop();
  
  
}

// The transformation function.
float f(float x)
{
  return x + width/2;
}

float X(float x, float size)
{
 return (x - width/2)*1.0/(width/2)*size; 
}

void drawNumber(float x, float y, float mag, float head_len, PGraphics g)
{
  drawArrow(x, y, x, y - mag, head_len, g);
}

void drawArrow(float x1, float y1, float x2, float y2, float head_length, PGraphics g)
{
  g.line(x1, y1, x2, y2);
  
  float dx = x2 - x1;
  float dy = y2 - y1;
  float mag = dist(x1, y1, x2, y2);
  
  float par_x = dx/mag;
  float par_y = dy/mag;
  
  float perp_x = -par_y;
  float perp_y =  par_x;

  // Draw one of the arrow heads.
  g.line(x2, y2, x2 - par_x*head_length + perp_x*head_length,
    y2 - par_y*head_length + perp_y*head_length);
    
  // Draw the other.
  g.line(x2, y2, x2 - par_x*head_length - perp_x*head_length,
                 y2 - par_y*head_length - perp_y*head_length);
}

void keyPressed()
{
  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    save("output.png");
    
  }
  
  
}