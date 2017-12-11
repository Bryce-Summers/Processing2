int resolution = 32;

void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  //size(512, 512);
  size(1282, 1282);
}


void draw()
{
    background(255);

    noStroke();

    //drawWuLine(32, 32, 1280 - 36, 204);
    
   // drawWuLine(32, 32, 64, 500);
    
    //drawWuLine(64, 500, 300, 32);
    
    Point A, B, C;
    A = new Point(width/2, 32);
    B = new Point(32, height - 32);
    C = new Point(width - 32, height/2);
    
    fill(200);    
    drawTriangle(A, B, C);
    
    //drawWuLine(64, 541, 500, 478);
    
    stroke(45, 45, 45);
    strokeWeight(1);
    //drawLines(16);
    
    stroke(30, 30, 30);
    strokeWeight(1.5);
    drawLines(32);
    
    stroke(15, 15, 15);
    strokeWeight(2);
    drawLines(64);
    
    stroke(0, 0, 0);
    strokeWeight(4);
    drawLines(128);
    
    stroke(0, 0, 0);
    strokeWeight(8);
    drawLines(256);
  
    strokeWeight(4);
  
    
  
  save("output.png");
  noLoop();
  
}

class Point
{
  double x;
  double y;
  
  Point(double x_in, double y_in)
  {
    x = x_in;
    y = y_in;
  }
  
  void scaleBy(double scale)
  {
     x *= scale;
     y *= scale;
  }
}

void drawTriangle(Point A, Point B, Point C)
{
  
  // Reorient the points, if they are not in counter clowise orientation.
  if(lineSideTest(A, B, C) >= 0)
  {
     Point temp = B;
     B = C;
     C = temp;
  }
  
  double min_x = Math.min(A.x, Math.min(B.x, C.x));
  double max_x = Math.max(A.x, Math.max(B.x, C.x));
  
  double min_y = Math.min(A.y, Math.min(B.y, C.y));
  double max_y = Math.max(A.y, Math.max(B.y, C.y));
  
  min_x /= resolution;
  max_x /= resolution;
  
  min_y /= resolution;
  max_y /= resolution;
   
  
  A.scaleBy(1.0 / resolution);
  B.scaleBy(1.0 / resolution);
  C.scaleBy(1.0 / resolution);
  
  for(int x = (int)min_x; x <= max_x; x++)
  for(int y = (int)min_y; y <= max_y; y++)
  {
    Point P = new Point(x, y);
        
    if(lineSideTest(P, A, B) < 0 &&
       lineSideTest(P, B, C) < 0 &&
       lineSideTest(P, C, A) < 0)
    {
      drawPixel(x, y);
    }     
    
  }
  
  // Scale back up and draw lines.
  A.scaleBy(resolution);
  B.scaleBy(resolution);
  C.scaleBy(resolution);
    
  drawWuLine(A, B);
  drawWuLine(B, C);
  drawWuLine(C, A);
  
  
}

double lineSideTest(Point P, Point A, Point B)
{
  return (B.x - A.x)*(P.y - A.y) - (B.y - A.y)*(P.x-A.x);
}

void drawWuLine(Point A, Point B)
{
  drawWuLine(A.x, A.y, B.x, B.y); 
}

void drawWuLine(double x0, double y0, double x1, double y1)
{
  if(x0 > x1)
  {
     double temp_x = x0;
     double temp_y = y0;
     
     x0 = x1;
     y0 = y1;
     
     x1 = temp_x;
     y1 = temp_y;    
  }
  
  // If the line is steep, then we should transpose it.
  if(Math.abs(y1 - y0) > Math.abs(x1 - x0))
  {
    drawWuLine_helper(y0, x0, y1, x1, true);
  }
  else
  {
    drawWuLine_helper(x0, y0, x1, y1, false); 
  }
  
}

// rot is true if this function is transposed.
void drawWuLine_helper(double x0, double y0, double x1, double y1, boolean rot)
{
  if(x0 > x1)
  {
     double temp_x = x0;
     double temp_y = y0;
     
     x0 = x1;
     y0 = y1;
     
     x1 = temp_x;
     y1 = temp_y;    
  }
  
  double m = (y1 - y0)*1.0/(x1 - x0);
  
  x0 /= resolution;
  x1 /= resolution;
  y0 /= resolution;
  y1 /= resolution;
  
  
  x0 -= .5;
  x1 -= .5;
  
  
  y0 -= .5;
  y1 -= .5;
  
  
  int x_start = (int)(x0);
  int x_end = (int)(x1);
  int y_start = (int)(y0);
  int y_end = (int)(y1);
  
  // -- Draw the Left endpoint.
  double per_x = (x_start) + 1 - x0;
  double per_y = (y_start) + 1 - y0;
   
  if(!rot)
  {
    drawInterpolatedPixel(x_start, y_start, 0, per_x, per_y,
                          true, false,
                          true, false);
  }
  else
  {
    drawInterpolatedPixel(y_start, x_start, 0, per_y, per_x,
                          true,  true,
                          false, false);
  }
                        

  // Draw Middle Segments.
  for(int x = x_start + 1; x <= x_end; x++)
  {
    double y = y0 + (x - x0)*m;
    per_y = ((int)y) + 1 - y;
    
    if(!rot)
    {
      drawInterpolatedPixel(x, (int)y, 0, 1.0, per_y,
                          true, false,
                          true, false);
    }
    else
    {
      drawInterpolatedPixel((int)y, x, 0, per_y, 1.0,
                            true, true,
                            false, false); 
    }
  }

  // Draw the Right EndPoint Segments.
  per_x = (x_end) + 1 - x1;
  per_y = (y_end) + 1 - y1;
  
  if(!rot)
  {
    drawInterpolatedPixel(x_end, y_end, 0, per_x, per_y,
                          false, true,
                          false, true);
  }
  else
  {
    drawInterpolatedPixel(y_end, x_end, 0, per_y, per_x,
                          false, false,
                          true, true);
    
  }
}

void drawPixel(int x, int y)
{
  rect(x*resolution, y*resolution, resolution, resolution);
}

// per_x = percentage to the left column, per_y = percentage to the right column.
void drawInterpolatedPixel(int x, int y, int val, double per_x, double per_y, boolean b00, boolean b10, boolean b01, boolean b11)
{
  int res = resolution;

  int loc_x = x*res;
  int loc_y = y*res;

  // Draw all 4 rectangles.
  if(b00)
  {
    double p = per_x*per_y;
    int v = (int)(p*val);
    fill(v, v, v, (int)(255*p));
    rect(loc_x, loc_y, res, res);
  }
  
  if(b10)
  {
    double p = (1.0 - per_x)*per_y;
    int v = (int)(p*val);
    fill(v, v, v, (int)(255*p));
    rect(loc_x + res, loc_y, res, res);
  }
 
   if(b01)
   {
    double p = per_x*(1.0 - per_y);
    int v = (int)(p*val);
    fill(v, v, v, (int)(255*p));
    rect(loc_x, loc_y + res, res, res);
   }
  
  if(b11)
  {
    double p = (1.0 - per_x)*(1.0  - per_y);
    int v = (int)(p*val);
    fill(v, v, v, (int)(255*p));
    rect(loc_x + res, loc_y + res, res, res);
  }
}

void drawLines(int resolution)
{
  // Draw horizontal lines.
  for(int y = 0; y < height;  y += resolution)
  {    
    line(0, y, width, y); 
  }
  
  // Draw Vertical Lines.
  for(int x = 0; x < width; x += resolution)
  {
    line(x, 0, x, height); 
  } 
}

void keyPressed()
{
  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    save("output.png");
    
  }
  
  
}