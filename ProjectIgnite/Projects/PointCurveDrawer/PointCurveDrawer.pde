void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  //size(512, 512);
  
  //size(600, 600);// <-- good.
  
  size(1000, 1000);
  
}


void draw()
{

  String coords[] = loadStrings("file_handCurve.txt");


  PGraphics g = createGraphics(width, height);
  g.beginDraw();

  int len = coords.length/2;
  float[] x_coords = new float[len];
  float[] y_coords = new float[len];
  
  // Parse all of the coordinates.
  for(int i = 0; i < len; i ++)
  {
    x_coords[i] = new Float(coords[i*2]);
    y_coords[i] = new Float(coords[i*2 + 1]);
  }
  
  // Compute original bounds.
  float x_min = Float.MAX_VALUE, x_max = Float.MIN_VALUE;
  float y_min = Float.MAX_VALUE, y_max = Float.MIN_VALUE;
  for(int i = 0; i < len; i++)
  {
    float x = x_coords[i];
    float y = y_coords[i];
    x_min = min(x_min, x);
    x_max = max(x_max, x);
    y_min = min(y_min, y);
    y_max = max(y_max, y); 
  }
  
  int size = width/2;
  
  size = width*2 - 12;
    
  float x_range = x_max - x_min;
  float y_range = y_max - y_min;
  for(int i = 0; i < len; i++)
  {
    float x = (x_coords[i] - x_min)/x_range*size/2;
    float y = (y_coords[i] - y_min)/y_range*size/2;
    x_coords[i] = x;
    y_coords[i] = y;
  }
  
  
  // Draw the identity to the screen.
  g.fill(100, 100, 100); // gray original.
  g.noFill();
  g.strokeWeight(2);
  g.beginShape();
  for(int i = 0; i < len + 6; i ++)
  {
    PVector point = new PVector(x_coords[i % len], y_coords[i % len], 1.0); 
    
    //point = transform.mult(point);
    
    System.out.println(point.x + " " + point.y);
    
    // Draw the coordinates to the screen.
    g.curveVertex(point.x + 3, point.y + 3);
  }
  g.endShape();
  
  g.endDraw();
  image(g, 0, 0); 
  g.save("output.png");
  noLoop();
  if(true){return;}


  Matrix transform;
  // Identity.
  transform = new Matrix(new float[]
  {1.0, 0.0, 0.0,
   0.0, 1.0, 0.0,
   0.0, 0,   1.0  
  });
  
  /*
  // Scaling.
  transform = new Matrix(new float[]
  {-2.0, 0.0, 0.0,
   0.0, 2.0, 0.0,
   0.0, 0, 1.0  
  });
  
  float theta = PI/4;
  float ct = cos(theta);
  float st = sin(theta);
  
  // Rotation.
  transform = new Matrix(new float[]
  {ct, -st, 0.0,
   st, ct, 0.0,
   0.0, 0, 1.0  
  });
  
  // Shear.
  transform = new Matrix(new float[]
  {1.0, -2.0, 0.0,
   0.0, 1.0, 0.0,
   0.0, 0, 1.0  
  });
  
  
  // Translation.
  transform = new Matrix(new float[]
  {1.0, 0.0, -size*.75,
   0.0, 1.0, -size*.5,
   0.0, 0, 1.0  
  });
  
  transform = new Matrix(new float[]
  {-1.0, 0.0, 0.0,
   0.0, -1.0, 0.0,
   0.0, 0, 1.0  
  });
  
  */
  
  // Draw the axis.
  int weight = 5;
  int arrow_head_size = width/20;
  g.stroke(0, 0, 0, 255);
  g.strokeWeight(weight);
  
  // y axis.
  drawArrow(size, 0, size, size*2 - weight, arrow_head_size, g);
  // x axis.
  drawArrow(0, size, size*2 - weight, size, arrow_head_size, g);
  
  // Draw the identity to the screen.
  g.fill(100, 100, 100); // gray original.
  g.strokeWeight(2);
  g.beginShape();
  for(int i = 0; i < len + 6; i ++)
  {
    PVector point = new PVector(x_coords[i % len], y_coords[i % len], 1.0); 
    
    //point = transform.mult(point);
    
    // Draw the coordinates to the screen.
    g.curveVertex(point.x + size, point.y + size);

  }
  g.endShape();

  PVector basis_x = new PVector(size/2, 0, 0.0);
  PVector basis_y = new PVector(0, size/2, 0.0);
  
  PVector origin = new PVector(0, 0, 1.0);
  
  g.strokeWeight(weight*2);
  
  // Draw basis vectors pre transformation.
  g.stroke(100, 100, 100, 255);
  drawArrow(size, size, size + basis_x.x, size + basis_x.y, arrow_head_size/2, g);
  drawArrow(size, size, size + basis_y.x, size + basis_y.y, arrow_head_size/2, g);
  
  // Draw the transformed figure.
  g.fill(181, 245, 255, 200); // Light blue.
  g.strokeWeight(2);
  g.beginShape();
  for(int i = 0; i < len + 6; i ++)
  {
    PVector point = new PVector(x_coords[i % len], y_coords[i % len], 1.0); 
    
    point = transform.mult(point);
    
    non_linear_transform(point, size);
    
    point.x /= point.z;
    point.y /= point.z;
    
    // Draw the coordinates to the screen.
    g.curveVertex(point.x + size, point.y + size);

  }
  g.endShape();

  // Draw basis vectors post transformation.
  g.strokeWeight(weight*2);
  /* We have commented out the linear transform code.
   * and are replaceing it with some non linear code that requires use to draw several lines to rerpesent the output curve.
  basis_x = transform.mult(basis_x);
  basis_y = transform.mult(basis_y);
  origin  = transform.mult(origin);
    
  //basis_x = basis_x.mult(1.0 / basis_x.z);
  //basis_y = basis_y.mult(1.0 / basis_y.z);
  origin  = origin .mult(1.0 / origin.z);
    
  g.stroke(48, 193, 193, 200);
    
  origin.x += size;
  origin.y += size;
  
  drawArrow(origin.x, origin.y, origin.x + basis_x.x, origin.y + basis_x.y, arrow_head_size/2, g);
  drawArrow(origin.x, origin.y, origin.x + basis_y.x, origin.y + basis_y.y, arrow_head_size/2, g);
  */
  
  g.stroke(48, 193, 193, 200);
  
  PVector x1 = origin.copy();
  PVector y1 = origin.copy();
  
  non_linear_transform(x1, size);
  non_linear_transform(y1, size);
  
  x1.x += size;
  x1.y += size;
  y1.x += size;
  y1.y += size;
  
  for(int i = 1; i < 1000; i++)
  {
    PVector x2 = PVector.mult(basis_x, i/1000.0);
    PVector y2 = PVector.mult(basis_y, i/1000.0);
    
    non_linear_transform(x2, size);
    non_linear_transform(y2, size);
    
    x2.x += size;
    x2.y += size;
    y2.x += size;
    y2.y += size;

    //if(i > 1)
    {
      g.line(x1.x, x1.y, x2.x, x2.y);
      g.line(y1.x, y1.y, y2.x, y2.y);
    }
   
    x1 = x2;
    y1 = y2;
  }
  non_linear_transform(basis_x, size);
  non_linear_transform(basis_y, size);
  basis_x.x += size;
  basis_x.y += size;
  basis_y.x += size;
  basis_y.y += size;
  drawArrow(x1.x, x1.y, basis_x.x, basis_x.y, arrow_head_size/2, g);
  drawArrow(y1.x, y1.y, basis_y.x, basis_y.y, arrow_head_size/2, g);
    
  g.textSize(arrow_head_size);
  g.stroke(0, 0, 0, 200);
  g.fill(0,0,0);
  g.textAlign(CENTER, CENTER);
  g.text("+Y", size + arrow_head_size*2, size*2 - arrow_head_size);
  g.text("+X", size*2 - arrow_head_size, size + arrow_head_size*2);
    
  
  g.endDraw();
  image(g, 0, 0); 
  
  g.save("output.png");
  noLoop();
  
  
}

void non_linear_transform(PVector vec, float size)
{
  vec.x = -pow(vec.x, 1.1f)/(dist(vec.x, vec.y, 0, 0) + .1)*size/2 + vec.y - 30;
  vec.y = -pow(vec.y, 1.06f) + vec.x + size/2 - 150;
  
}

class Matrix
{
  float[] vals;
  
  // Takes in a 3 by 3 array of matrix values.
  Matrix(float[] vals)
  {
    this.vals = vals;
  }
  
  PVector mult(PVector in)
  {
    float x_out = vals[0]*in.x + vals[1]*in.y + vals[2]*in.z;
    float y_out = vals[3]*in.x + vals[4]*in.y + vals[5]*in.z;
    float z_out = vals[6]*in.x + vals[7]*in.y + vals[8]*in.z;
    
    return new PVector(x_out, y_out, z_out);
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