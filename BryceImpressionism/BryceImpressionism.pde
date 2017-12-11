
void setup()
{
  // 200 base height for beam.
  // 1080 for entire screen.
  size(1920, 1080);
  
  GRID = new grid();
}

class grid
{
  // Single dimensional packed array.
  public float[] v_x;  // Velocity x. field value 1.
  public float[] v_y;  // Velocity y. field value 2.
  public float[] temp1;// Temporary buffer.
  public float[] temp2;// Temporary buffer.
  
  int N;
  int rowNum;
  int colNum;
  
  public grid()
  {
    rowNum = height/15;
    colNum = width/15;
    N = (rowNum + 2) * (colNum + 2);
        
    v_x    = new float[N]; 
    v_y    = new float[N];
    temp1  = new float[N];
    temp2  = new float[N];
    
    for(int i = 0; i < N; i++)
    {
      v_x[i] = random_start_velocity();
      v_y[i] = random_start_velocity();
      temp1[i] = 0;
      temp2[i] = 0;
    }
   
    // First establish that the boundaries are inverted.
    setBoundary(1, v_x);
    setBoundary(2, v_y);
    removeDivergence(); //<>//
    
  }
  
  // Provides a bounded random starting velocity.
  public float random_start_velocity()
  {
    //return 1;
    
    float mag = 100;
    return random(mag*2) - mag;
    
  }
  
  public void removeDivergence()
  {
    project_onto_divergence_free_field(v_x, v_y, temp1, temp2);
    setBoundary(1, v_x);
    setBoundary(2, v_y);
  }
  
  // Steps the velocity field by timestep dt.
  public void step(float dt, float visc)
  {
    
    // Diffuse the velocity.
    diffuse(1, temp1, v_x, visc, dt);
    diffuse(2, temp2, v_y, visc, dt);
    copyFromTo(temp1, v_x);
    copyFromTo(temp2, v_y);

    removeDivergence();
        
    // Advect v_x along velocity field v_x,v_y, store in temp1.
    advect(1, temp1, v_x, v_x, v_y, dt);
    // Advect v_y along velocity field v_x,v_y, store in temp2.
    advect(2, temp2, v_y, v_x, v_y, dt);
    copyFromTo(temp1, v_x);// I could optimize this be swaping pointers if I wanted to...
    copyFromTo(temp2, v_y);
    setBoundary(1, v_x);
    setBoundary(2, v_y);
    
    removeDivergence();

  }
  
  public float getVX(float row, float col)
  {
    return lookupValue(v_x, row, col);
  }
  
  public float getVY(float row, float col)
  {
    return lookupValue(v_y, row, col);    
  }
  
  public float lookupValue(float[] array, float row, float col)
  {
    // Scale inputs.
    row *= 1.0*rowNum / height;
    col *= 1.0*colNum / width;
    
    if(row >= rowNum)
    {
      row = rowNum - 1;
    }
    
    if(col >= colNum)
    {
      col = colNum - 1;
    }
    
    // Bilinear interpolation.
    int y0 = (int)row;
    float yp = row - y0;
    int y1 = y0 + 1;
    
    int x0 = (int)col;
    float xp = col - x0;
    int x1 = x0 + 1;
    
    int i00 = IX(y0, x0);
    int i01 = IX(y0, x1);
    int i10 = IX(y1, x0);
    int i11 = IX(y1, x1);
    
    float v00 = array[i00];
    float v01 = array[i01];
    float v10 = array[i10];
    float v11 = array[i11];
    
    // Complement of x percentage.
    float xpc = 1.0 - xp;
    float ypc = 1.0 - yp;
    
    // Linear Interpolation.
    float v0  = v00*xpc + v01*xp;
    float v1  = v10*xpc + v11*xp;
        
    // Bilinear Interpolation.
    float val = v0*ypc + v1*yp;
    
    return val; 
  }
  
  // ASSUMPTION: src and dest have the same length.
  public void copyFromTo(float[] src, float[] dest)
  {
    for(int i = 0; i < src.length; i++)
    {
      dest[i] = src[i];
    }
  }
  
  // Returns the index of the given row and column.
  // ASSUMPTION: row and col are in bounds.
  int IX(int row, int col)
  {
    return (colNum + 2)*row + col; 
  }

  // Using the Helmholtz decomposition,
  // Projects this vector field onto a divergence free field.
  // This is done be subtracting the gradient of pressure,
  // pressure is the diffusion of the -divergence.
  // the divergence is the gradient of the velocity field.
  public void project_onto_divergence_free_field(float[] u, float[] v, float[] p, float[] div)
  {
    
      // Computes the divergence field as the negative gradient of the velocity field.
      for(int j = 1; j <= rowNum; j++)
      for(int i = 1; i <= colNum; i++)
      {
          div[IX(j, i)]= -0.5f*
                               (
                                u[IX(j, i + 1)]  //<>//
                               -u[IX(j, i - 1)]
                               )/colNum + 
                               (
                                v[IX(j + 1, i)]
                               -v[IX(j - 1, i)]
                               )/rowNum;
          p[IX(j, i)] = 0; // Pressure field is initialized to 0.
      }
      
      
      setBoundary(0, div);
      setBoundary(0, p);
      
      // Computes pressure as the diffusion of the divergence.
      lin_solve(0, p, div, 1, 4); // 1 part original divergence, 1.0 / 4 parts each neighbor's divergence. //<>//
      
      // Subtracts from the velocity field the gradient of the pressure field. 
      // for every cell.
      for(int j = 1; j <= rowNum; j++)
      for(int i = 1; i <= colNum; i++)
      {
          u[IX(j, i)] -= 0.5f*colNum*(p[IX(j, i + 1)] - p[IX(j,     i - 1)]);
          v[IX(j, i)] -= 0.5f*rowNum*(p[IX(j + 1, i)] - p[IX(j - 1, i    )]);
      }
      
      setBoundary(1, u);
      setBoundary(2, v);
    }

  // Set the boundary.
  // b == 0 --> Boundaries do exactly what their neighbors do.
  //      1 --> Do exactly the opposite of what horizontal neighbors do.
  //      2 --> Do exactly the opposite of what vvertical neighbors do.
  void setBoundary(int b, float[] x)
  {
    for(int j = 1; j <= rowNum + 1; j++)
    {
      x[IX(j,     0         )] = b == 1 ? -x[IX(j, 1)]      : x[IX(j, 1)];
      x[IX(j,     colNum + 1)] = b == 1 ? -x[IX(j, colNum)] : x[IX(j, colNum)];
    }
    
    for(int i = 1; i <= colNum + 1; i++)
    {
      x[IX(0,          i    )] = b == 2 ? -x[IX(1,      i)] : x[IX(1,      i)];
      x[IX(rowNum + 1, i    )] = b == 2 ? -x[IX(rowNum, i)] : x[IX(rowNum, i)];
    }
    
    x[IX(0,                   0)] = 0.5f*(x[IX(0,               1)] + x[IX(1,               0 )]);
    x[IX(rowNum + 1,          0)] = 0.5f*(x[IX(rowNum + 1,      1)] + x[IX(rowNum,          0 )]);
    x[IX(0,          colNum + 1)] = 0.5f*(x[IX(0,          colNum)] + x[IX(1,      colNum + 1 )]); 
    x[IX(rowNum + 1, colNum + 1)] = 0.5f*(x[IX(rowNum + 1, colNum)] + x[IX(rowNum, colNum + 1 )]);
  }
  
  void lin_solve(int b, float[] x, float[] x0, float a, float c)
  {
     int ITERATIONS = 20;
     for(int n = 0; n < ITERATIONS; n++)
     {
       for(int j = 1; j <= rowNum; j++)// For each cell.
       for(int i = 1; i <= colNum; i++)
       {
         x[IX(j, i)] = (  x0[IX(j,     i    )] +
                        a*(
                           x[IX(j,     i - 1)] +
                           x[IX(j,     i + 1)] +
                           x[IX(j - 1, i    )] +
                           x[IX(j + 1, i    )]
                          ))/c;
       }
       setBoundary(b, x);
     }
  }
  
  // advects d0 along velocity field uv with the timestep dt.
  // Stores result in d.
  void advect(int b, float[] d, float[]d0, float[] u, float[] v, float dt)
  {
      int i0, j0, i1, j1;
      float x, y, s0, t0, s1, t1;
      
      // for every cell.
      for(int j = 1; j <= rowNum; j++)
      for(int i = 1; i <= colNum; i++)
      {
        x = i - dt*colNum*u[IX(j, i)];
        y = j - dt*rowNum*v[IX(j, i)];
        
        if(x < 0.5f)
        {
          x = .5f;
        }
          
        if(x > colNum + .5f)
        {
          x = colNum + .5f;
        }
           
        i0 = (int)x;
        i1 = i0 + 1;
        
        if(y < 0.5f)
        {
          y = 0.5f;
        }
        if(y > rowNum + 0.5f)
        {
          y = rowNum + .5f;
        }
         
        j0 = (int)y;
        j1 = j0 + 1;
         
        s1 = x - i0; s0 = 1 - s1; t1 = y - j0; t0 = 1 - t1;
        d[IX(j, i)] = s0*(t0*d0[IX(j0, i0)] + t1*d0[IX(j1, i0)]) +
                      s1*(t0*d0[IX(j0, i1)] + t1*d0[IX(j1, i1)]);
      }
      
      setBoundary(b, d);
  }
  
  void diffuse(int b, float[] x, float[] x0, float diff, float dt)
  {
    float a = dt*diff*rowNum*colNum;
    lin_solve(b, x, x0, a, 1 + 4*a );
  }  
}
 
  
  

grid GRID;

void draw()
{
  
  PGraphics g;

  int seed = 0;
  
  // Step the grid, especially to diffuse the velocity.
  float viscocity = 1;// Viscocity slows down the transfer of values, but also creates enables diffusion.
  float dt = .5;
  float numDiffusionSteps = 3;
  for(int i = 0; i < numDiffusionSteps; i++)
  {
    GRID.step(dt, viscocity);
  }
  
  int numImpressions = width*height/10*5;
  int numFrames = 1;
  for(int frame = 0; frame < numFrames; frame++)
  {
    
    g = createGraphics(width, height);
    g.beginDraw();

    int initial_gap = 5;
    int last_gap = 5;
    for(int i = initial_gap; i >= last_gap; i--)
    {
      layer(g, i, seed, "output_" + i + ".png", numImpressions);
    }
    
    g.endDraw();
    g.save("output_" + frame + ".png");
    
    // Draw the image to the screen.
    image(g, 0, 0);

    GRID.step(.01, .000);
    //seed += 1;
  }
  
  noLoop();
  System.out.println("done");
}

void layer(PGraphics g, int gap, int seed, String name, int numImpressions)
{  
  
  
  
  //randomSeed(seed);
  int N = numImpressions / gap;
  for(int i = 0; i < N; i++)
  {
    drawImpression(g, gap);
  }
  
  /*
  for(int x = 0; x < width; x  += gap*20)
  for(int y = 0; y < height; y += gap*20)
  { //<>//
    //drawImpression(g, gap, x, y);
  }*/
  
      

}

void drawImpression(PGraphics g, int gap)//, int px, int py)
{
  
  /*
  float cx = -100;
  float cy = height/2;
  */
  
  float cx = 0;
  float cy = height/2;

  float px = random(width - 1);
  float py = random(height - 1);
 
  /*
  int grid_size = 30;
  px = floor(px/grid_size) * grid_size;
  py = floor(py/grid_size) * grid_size;
  */
  
  
  // normalized velocity direction.

  /*

  */

  float dx = GRID.getVX(py, px);
  float dy = GRID.getVY(py, px);
  
  // Manually set vector field.
  /* Arrays.
  float box = floor(px/10) * 10;
  
  float angle = PI/2 + PI*2*box/width;
  
  dx = cos(-angle);
  dy = -sin(-angle);
  */
  
  // Radial.
  //dx = px - cx;
  //dy = py - cy;
  
  // Compute magnitude of velocity vector.
  float distance = dist(0, 0, dx, dy);
  
  // Normalize velocity vector.
  dx /= distance;
  dy /= distance;
   
  // Compute perpendicular direction vector.
  float perp_x = -dy*gap;
  float perp_y =  dx*gap;
   
  // Draw velocity vector at length 10.
  float mag = gap*2;
  dx *= mag;
  dy *= mag;
  
  if(random(1) < .001)
  {
   System.out.println(distance); 
  }

  /*
  float dx = 100;
  float dy = 0;
  */
  
  
  float alpha = .5;//.05;
  float val = 1;
  float sat = 1;

  // Motion Lines.
  
  //float hue = 0/360;
  //float hue = 53/360.0;// Yellow.
  float hue = 128/360.0;// Green
  
  //blendMode(ADD);
  
  g.colorMode(HSB, 1);
  val = 1;//getVal();
  g.stroke(hue, sat, val, alpha);  // Set fill to gray.
  g.strokeWeight(gap);
  g.line(px + dx/2, py + dy/2, px - dx/2, py - dy/2);
    
  val = .3;
  
  //val = .9;//getVal();
  g.stroke(hue, sat, val, alpha);  // Set fill to gray.
  g.line(px + perp_x + dx/2, py + perp_y + dy/2, px - dx/2, py - dy/2);
  
  //val = .9;//getVal();
  g.stroke(hue, sat, val, alpha);  // Set fill to gray.
  g.line(px - perp_x + dx/2, py - perp_y + dy/2, px - dx - dx/2, py - dy - dy/2);
  
}

float getVal()
{
  return random(1);
}