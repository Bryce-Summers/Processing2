/*
 * Iterated Function System Code. Level 1.
 * Written by Bryce Summers on 1/6/2016.
 *
 * Draws Iterated Function Systems using irradiance caching and normalization.
 */

//IFS ifs = new ifs_SispenskiTriangle();
IFS ifs = new ifs_BarnsleyFern();
//IFS ifs = new ifs_Babylon();


/*
 * Distance Function Parameters and variables.
 */
 
DistanceFunctionProcessor distanceProc;
double DISTANCE_BOUNDARY_LENGTH = 20;

/*
 * Value caching parameters.
 */

// This is where the raw values will be stored.
double[][] cache;

// This is the buffer of color values that we will display on screen.
PImage screen_image;
PImage image_3d_plot;
int max_3d_height = 25;

// This can be any value, but for numerical stability reosons, we ought to keep it small, because smaller floating point numbers have more prescision.
final double SAMPLE_IRRADIANCE_VALUE = .25;


// The length of a side of the square area of a pixel. 1 makes the sample line up with pixels.
float sample_width = .5;


// Now we will create a variable to store the point that will go around being plotted.
PVector iteration_point;

// Every frame, this animation will draw the given number of points to the screen.
int iterations_per_frame;
int increase_per_frame;

// This function is called by the proccessing environment.
// It resizes the screen and initializes the screen specific variables that we will be using.
void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  fullScreen();
  
  cache = new double[height][width]; 
  
  screen_image  = createImage(width, height, ARGB);
  image_3d_plot = createImage(width, height + max_3d_height, ARGB);
  
  distanceProc = new DistanceFunctionProcessor(screen_image);
  
  ifs.initialize();
  
  iteration_point = ifs.getInitialPoint();
  iterations_per_frame = ifs.get_iterations_per_frame();
  increase_per_frame   = ifs.get_increase_per_frame();
}

double max(double a, double b)
{
 return a >= b ? a : b; 
}

// Normalizes the cache and draws it to the screen.
void drawIradianceCache()
{
  double max_value = 0.0;
  
  int cache_h = cache.length;
  int cache_w = cache[0].length;
  
  for(int row = 0; row < cache_h;  row++)
  for(int col = 0; col < cache_w; col++)
  {
    double cache_value = cache[row][col];
       
    max_value = max(cache_value, max_value);    
  }
  
  for(int row = 0; row < cache_h; row++)
  for(int col = 0; col < cache_w; col++)
  {
    
    if(cache[row][col] > 0.0)
    {
      double norm_val = cache[row][col] / max_value;
      
      // Increase the intensity of lower intensity parts.
      norm_val = ifs.scaleIrradiance(norm_val);
      
      // Compute the image signal value.
      int val = (int)(norm_val*255);
      val = val - 255;
  
      int pixel_index = row*width + col;
      screen_image.pixels[pixel_index] = color(255 - val, 255 - val, 255 - val, 255);
    }
     
  }
  
  // We need to tell the image that it has been modified.
  screen_image.updatePixels();  
  
}

/*
 * Iterative Drawing Loop. Draws more points to the screen at every frame.
 */
void draw()
{    
  // White.
  background(255);
  
  // For good measure we iterate several times before doing any plotting.
  // This helps elliminate outliers at the beginning that might not actually be in the fractal.
  for(int i = 0; i < 100; i++)
  {
    iteration_point = ifs.IteratePoint(iteration_point);
  }
  
  // Note: frameCount stores how many frame have been drawn to the screen since the beginning.
  // This enables us to increase the number of iterations per frame, because later frames will
  // have less variance and need more samples to make a pereivable change in detail.
  for(int i = 0; i < iterations_per_frame + increase_per_frame*frameCount; i++)
  {
    iteration_point = ifs.IteratePoint(iteration_point);
    
    // Just to be on the safe side while future programmers are still learning, 
    // we will pass a copy of the iteration point to ensure that the real one is not changed.
    plotIterationPoint(ifs.localToScreen(iteration_point.copy()), cache);
  }
  
  // We now update the screen_image with color computed from the values of the irradiance cache.
  drawIradianceCache();
  
  distanceProc.colorUsingDistanceFunction(cache);
  
  // Draw the rendered image to the screen.
  //image(screen_image, 0, 0);
  
  // draw the screen image with a fake 3d approximation.
  draw3DImageOnScreen(screen_image);
  
}

void draw3DImageOnScreen(PImage image)
{
     
  for(int i = 0; i < image_3d_plot.pixels.length; i++)
  {
    image_3d_plot.pixels[i] = color(0,0,0,0);
  }
  
  int len = image.pixels.length;
  for(int i = 0; i < len; i++)
  {
    int val = image.pixels[i] >> 16 & 0xFF;
    
    image_3d_plot.pixels[i + (max_3d_height - val*max_3d_height/255)*width] = image.pixels[i];  
  }
  
  image_3d_plot.updatePixels();
  
  
  image(image_3d_plot, 0, 0);
}


void keyPressed()
{
  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    screen_image.save("output.png");
    image_3d_plot.save("output_3d_plot.png");
  }
}