/*
 * Based on the work of Jos Stam.
 * http://www.intpowertechcorp.com/GDC03.pdf
 * and The Art of Fluid Simulation.
 *
 * Transcribed to procesing, implemented, and commented by Bryce Summers 9/28/2016.
 */

int N = 100;

int scale = 10;

float[] u, v, u_prev, v_prev, density, density_prev;

float[] source;

boolean instructions = true;

void setup()
{
  size(1000, 1000);
  
  int size = SIZE(N);
  
  u       = new float[size];
  v       = new float[size];
  u_prev  = new float[size];
  v_prev  = new float[size];
  density = new float[size];
  density_prev = new float[size];

  source = new float[size];


  for(int i = 0; i < size; i++)
  {
    u[i] = 0;
    v[i] = 0;
  }
  
  for(int r = 0; r < N; r++)
  for(int c = 0; c < N; c++)
  {
    if (dist(r, c, N/2, N/2) < N/4) //<>//
    {
      density[IX(r, c)] = 1.0;
    }    
  }

}

void draw()
{
  // parameters //<>//
  float dt = .01;
  float diffusion = 0.001;
  float visc = 0.0;
  
  get_from_UI();
  vel_step(u, v, u_prev, v_prev, visc, dt);
  dens_step(density, density_prev, u, v, diffusion, dt);
  draw_density(density);

  /*
  float difusion_amount = 1.0;

  float dt = 1.0f/frameRate;
   
  float viscosity = 1.0;

  // Flow the densities according to the current velocity field.
  dens_step(density, density_prev, u, v, difusion_amount, dt);
   
  // Flow the velocities.
  vel_step(u, v, u_prev, v_prev, viscosity, dt);
  */
  
  if(instructions)
  {
    fill(255);
    textAlign(CENTER, BOTTOM);
    textSize(30);
    text("Left Mouse to Add, Right Mouse Remove", width/2, height - 10);
  }
  
}

// Calculate the UI induced density and velocity field modifications.
void get_from_UI()
{
   
   // 0 out all modification_fields.
   for(int i = 0; i < SIZE(N); i++)
   {
     u_prev[i] = 0;
     v_prev[i] = 0;
     density_prev[i] = 0;
   }
   
   // Add fluid density and velocity forces at the site of the user's mouse drag.
   int x = (int) mouseX/10;
   int y = (int) mouseY/10;
   
   int index = IX(x, y);
   
   if(0 <= index && index < SIZE(N) && mousePressed)
   { 
     if(mouseButton == LEFT)
     {
       //density[index] = 7;
     }
     else if(mouseButton == RIGHT)
     {
//density[index] = -7;
     }     
     
     u_prev[index]  = (mouseX - pmouseX)*1000;
     v_prev[index]  = (mouseY - pmouseY)*1000;
   }
}

// Draw the grid to the screen.
void draw_density(float[] density)
{
   for(int y = 0; y < N; y++)
   for(int x = 0; x < N; x++)
   {
     int val = (int)(density[IX(x, y)]*255);
     
     if(val > 255)
     {
       val = 255;
     }
     
     fill(val, val, val);
     stroke(val, val, val);
     rect(x*scale, y*scale, scale, scale);
   }
}


int IX(int col, int row)
{
  int val = col + (N + 2)*row;
  return Math.min(SIZE(N) - 1, val);
}

int SIZE(int N)
{
  return (N + 2)*(N + 2); 
}

void add_source(float[] x, float[] s, float dt)
{
  int i, size = SIZE(N);
  for(i = 0; i < size; i++)
  {
    x[i] += dt*s[i];
  }
}

void set_array_to_constant(float[] array, float constant)
{
  for(int i = 0; i < array.length; i++)
  {
    array[i] = constant;
  }
}

// Set the boundary.
void set_bnd(int b, float[] x)
{
  for(int i = 1; i <= N; i++)
  {
    x[IX(0, i)]     = b==1  ? -x[IX(1,i)]  : x[IX(1,i)];
    x[IX(N+1, i)]   = b==1  ? -x[IX(N, i)] : x[IX(N, i)];
    x[IX(i, 0)]     = b==2  ? -x[IX(i, 1)] : x[IX(i, 1)];
    x[IX(i, N + 1)] = b ==2 ? -x[IX(i, N)] : x[IX(i, N)];
  }
  x[IX(0, 0)]     = 0.5f*(x[IX(1,   0)] + x[IX(0  , 1)]);
  x[IX(0, N+1)]   = 0.5f*(x[IX(1, N+1)] + x[IX(0  , N)]);
  x[IX(N+1, 0)]   = 0.5f*(x[IX(N,   0)] + x[IX(N+1, 1)]); 
  x[IX(N+1, N+1)] = 0.5f*(x[IX(N, N+1)] + x[IX(N+1, N)]);
}

// Solves Ax = c for x using Gauss-Seidel relaxations.
// Solves the Laplace equation cell = average of neighbor cells.
void lin_solve(int b, float[] x, float[] x0, float a, float c)
{
   int ITERATIONS = 20;
   for(int n = 0; n < ITERATIONS; n++)
   {
     for(int j = 1; j <= N; j++)// For each cell.
     for(int i = 1; i <= N; i++)
     {
         x[IX(i, j)] = (x0[IX(i, j)] + a*(x[IX(i - 1, j)] +
         x[IX(i + 1, j)] + x[IX(i, j - 1)] + x[IX(i, j+1)]))/c;
     }
     set_bnd(b, x);
   }
}


void diffuse(int b, float[] x, float[] x0, float diff, float dt)
{
  float a = dt*diff*N*N;
  lin_solve(b, x, x0, a, 1 + 4*a );
}

// Implicit Semi-legrangian, based on a backwards Newton like method.
void advect(int b, float[] d, float[]d0, float[] u, float[] v, float dt)
{
  int i0, j0, i1, j1;
  float x, y, s0, t0, s1, t1, dt0;
  dt0 = dt*N;
  
  // for every cell.
  for(int j = 1; j <= N; j++)
  for(int i = 1; i <= N; i++)
  {
    x = i - dt0*u[IX(i, j)];
    y = j - dt0*v[IX(i, j)];
    
    if(x < 0.5f)
    {
      x = .5f;
    }
      
     if(x > N + .5f)
     {
       x = N + .5f;
     }
       
     i0 = (int)x;
     i1 = i0 + 1;
     
     if(y < 0.5f) y=0.5f;
     if(y > N + 0.5f) y = N + 05f;
     
     j0 = (int)y;
     j1 = j0 + 1;
     
     s1 = x - i0; s0 = 1 - s1; t1 = y - j0; t0 = 1 - t1;
     d[IX(i, j)] = s0*(t0*d0[IX(i0, j0)] + t1*d0[IX(i0, j1)]) +
                   s1*(t0*d0[IX(i1, j0)] + t1*d0[IX(i1, j1)]);
  }
  
  set_bnd(b, d);
}

// Hemholtz decomposition.
void project(float[] u, float[] v, float[] p, float[] div)
{
  // for every cell.
  for(int j = 1; j <= N; j++)
  for(int i = 1; i <= N; i++)
  {
    div[IX(i, j)]=-0.5f*(u[IX(i+1,j)]-u[IX(i-1,j)] + v[IX(i,j+1)]-v[IX(i,j-1)])/N;
    p[IX(i,j)]=0;
  }
  
  set_bnd(0, div);
  set_bnd(0, p);
  
  lin_solve(0, p, div, 1, 4);
  
  // for every cell.
  for(int j = 1; j <= N; j++)
  for(int i = 1; i <= N; i++)
  {
    u[IX(i,j)] -= 0.5f*N*(p[IX(i + 1, j)] - p[IX(i - 1, j)]);
    v[IX(i,j)] -= 0.5f*N*(p[IX(i, j + 1)] - p[IX(i, j - 1)]);
  }
  
  set_bnd(1, u);
  set_bnd(2, v);
  
}

void dens_step(float[] x, float [] x0, float[] u, float[]v, float diff, float dt)
{
 add_source(x, x0, dt);
 
 // SWAP(x, x0)
 float[] temp = x0;
 x0 = x;
 x = temp;
 
 diffuse(0, x, x0, diff, dt);
 
 // SWAP(x, x0)
 temp = x0;
 x0 = x;
 x = temp;
 
 advect(0, x, x0, u, v, dt);
 
}

void vel_step(float[] u, float[] v, float[] u0, float[] v0, float visc, float dt)
{
  add_source(u, u0, dt);
  add_source(v, v0, dt);
  
  // SWAP(u0, v);
  float[] temp = u0;
  u0 = u;
  u = temp;
  
  diffuse(1, u, u0, visc, dt);
  
  // SWAP(v0, v);
  temp = v0;
  v0 = v;
  v = temp;
  
  diffuse(2, v, v0, visc, dt);
  
  project(u, v, u0, v0);
  
  // SWAP(u0, v);
  temp = u0;
  u0 = u;
  u = temp;
  
  // SWAP(v0, v);
  temp = v0;
  v0 = v;
  v = temp;
  
  advect(1, u, u0, u0, v0, dt);
  advect(2, v, v0, u0, v0, dt);
  
  project(u, v, u0, v0);
}