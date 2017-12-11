void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  //size(512, 512);
  size(600, 600);  
  
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
  
  float x_range = x_max - x_min;
  float y_range = y_max - y_min;
  for(int i = 0; i < len; i++)
  {
    float x = (x_coords[i] - x_min)/x_range*size/2;
    float y = (y_coords[i] - y_min)/y_range*size/2;
    x_coords[i] = x;
    y_coords[i] = y;
  }
  
  // Draw the axis.
  int weight = 5;
  int arrow_head_size = width/20;
  g.stroke(0, 0, 0, 255);
  g.strokeWeight(weight);
  
  // y axis.
  float y_axis_x = X(0, size - arrow_head_size/2, 0);
  float y_axis_y = Y(0, size - arrow_head_size/2,0);
  drawArrow(X(0,0,0), Y(0,0,0),
            y_axis_x, y_axis_y, arrow_head_size, g);

  // x axis.
  float x_axis_x = X(size - arrow_head_size/2, 0, 0);
  float x_axis_y = Y(size - arrow_head_size/2, 0, 0);
  drawArrow(X(0,0,0), Y(0,0,0),
            x_axis_x, x_axis_y, arrow_head_size, g);
            
  // w axis.
  float z_axis_x = X(0, 0, size - arrow_head_size/2);
  float z_axis_y = Y(0, 0, size - arrow_head_size/2);
  drawArrow(X(0,0,0), Y(0,0,0),
            z_axis_x, z_axis_y, arrow_head_size, g);
  
  Matrix transform;
  // Identity.
  
  /*
  transform = new Matrix(new float[]
  {1.0, 0.0, 0.0,
   0.0, 1.0, 0.0,
   0.0, 0,   1.0  
  });
  
  
  /*
  
  // Scaling.
  transform = new Matrix(new float[]
  {.75, 0.0, 0.0,
   0.0, .75, 0.0,
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
  
  */
  
  // Shear.
  transform = new Matrix(new float[]
  {1.0, 1.5, 0.0,
   0.0, 1.0, 0.0,
   0.0, 0, 1.0  
  });
  
  
  
  // Translation.
  transform = new Matrix(new float[]
  {1.0, 0.0, .5,
   0.0, 1.0, 0,
   0.0, 0, 1.0  
  });
  
  /*
  
  transform = new Matrix(new float[]
  {-1.0, 0.0, 0.0,
   0.0, -1.0, 0.0,
   0.0, 0, 1.0  
  });
  */
  
  // Draw the identity to the screen.
  g.fill(100, 100, 100, 60); // gray original.
  
  g.strokeWeight(2);
  for(int w = 0; w < size; w += 30)
  {
    if(w == size/2/30*30)
    {
      g.stroke(0, 0, 0, 255);
    }
    else
    {
     g.stroke(0, 0, 0, 20); 
    }
    g.beginShape();
  for(int i = 0; i < len + 6; i ++)
  {
    PVector point = new PVector(x_coords[i % len], y_coords[i % len], w); 
    
    point = transform.mult(point);
      
    // Draw the coordinates to the screen.
      
    float x = X(point.x, point.y, 0);
    float y = Y(point.x, point.y, 0);
    g.curveVertex(x, y);
  }
  g.endShape();
  }
  
  // Draw the homogeneous copies to the screen.
  g.fill(181, 245, 255, 200); // Light blue.
  g.strokeWeight(2);
  g.stroke(0, 0, 0, 255);
  
  for(int w = 0; w < size; w += 30)
  {
    if(w == size/2/30*30)
    {
     g.fill(100, 100, 100, 200); // gray original.
    }
    else
    {
       g.fill(181, 245, 255, 200); // Light blue.
    }
    g.beginShape();
    for(int i = 0; i < len + 6; i ++)
    {
      PVector point = new PVector(x_coords[i % len], y_coords[i % len], w); 
      
      point = transform.mult(point);
      
      // Draw the coordinates to the screen.
      
      float x = X(point.x, point.y, point.z);
      float y = Y(point.x, point.y, point.z);
      g.curveVertex(x, y);
    }
  g.endShape();
  }
  
  float ahs = arrow_head_size;
  g.textSize(arrow_head_size);
  g.stroke(0, 0, 0, 200);
  g.fill(0,0,0);
  g.textAlign(CENTER, CENTER);
  g.text("+Y", y_axis_x - ahs, y_axis_y + ahs*2);
  g.text("+X", x_axis_x + ahs, x_axis_y + ahs*2);
  g.text("+W", z_axis_x + ahs*2, z_axis_y + ahs);

  
    
  
  g.endDraw();
  image(g, 0, 0); 
  
  g.save("output.png");
  noLoop();
  
  
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

// Converts from 3D space to 2D isometric space.
float X(float x, float y, float z)
{
  return width/2 - x + y;
}

float Y(float x, float y, float z)
{
 return height/2 + (x + y)/2 - z;
}


void drawLines(int resolution)
{
  // Draw horizontal lines.
  for(int y = 0; y < height;  y += resolution)
  {    
    float x1 = X(0, y, 0);
    float y1 = Y(0, y, 0);
    float x2 = X(width, y, 0);
    float y2 = Y(width, y, 0);
    line(x1, y1, x2, y2);
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