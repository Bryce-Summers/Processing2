/*
 * Iterated Function System Code. Level 1.
 * Written by Bryce Summers on 1/6/2016.
 *
 * Draws Iterated Function Systems using irradiance caching and normalization.
 */

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

// This can be any value, but for numerical stability reosons, we ought to keep it small, because smaller floating point numbers have more prescision.
final double SAMPLE_IRRADIANCE_VALUE = .25;


// The length of a side of the square area of a pixel. 1 makes the sample line up with pixels.
float sample_width = .5;

/*
 * Iterated Function System Parameters.
 */

// When probabalistically sampling from a set of actions, we convert the probability distribution into a cumulative probability distribution.
// The probability distribution is 1/3, 1/3, 1/3, but the cumulative distribution is 1/3, 2/3, 3/3.
// We can then sample from the original probability distribution using a uniform random variable's location in the cumulative distribution.
// This is known as the 'inversion' method.
float cumulative_probability_1 = 1.0/3;
float cumulative_probability_2 = cumulative_probability_1 + 1.0/3;
float cumulative_probability_3 = 3/3; // cumulative_probability_2 + 1.0/3.

// Please note that because of floating point arithmetic,
// we use 1 for the 3rd cumulative probability to prevent numeric errors.
// Otherwise the value would be something like .9999 .

// Define the 3 points in the Sispenski's gasket.
PVector p1;
PVector p2; 
PVector p3;

// Now we will create a variable to store the point that will go around being plotted.
PVector iteration_point;

// Every frame, this animation will draw the given number of points to the screen.
int iterations_per_frame = 100000;
int increase_per_frame = 10000;

// This function is called by the proccessing environment.
// It resizes the screen and initializes the screen specific variables that we will be using.
void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  fullScreen();
   
  // We now want to compute the points on the sispenski triangle subject to the following conditions:
  // 1. We want the triangle to be equilateral triangle.
  // 2. We don't want any of the points to be off of the screen.
  // We will do this by computing an appropiate width for the triangle.
  // Note that be the pythagorean theorem, the height of an equilateral triangle is sqrt(3)/2*the width.
  // The triangle width cannot be larger than the width of the screen,
  // and the height(aka sqrt(3)/2*width) cannot exceed the height of the screen.
  // Therefore the maximal triangle width is the minimum of these two quantities.
  float triangle_width = min(width, height*2/sqrt(3)); 
  
  // To center he triangle on the screen, we will actually want to offset the points from the center of the screen by the half width.
  float triangle_half_width = triangle_width /= 2;
  
  // For aestetic reosons, we make room for the boundary distance functions.
  triangle_half_width -= DISTANCE_BOUNDARY_LENGTH;
  
  // We can now directly compute the horizontal (r_x) and vertical (r_y) offsets used to compute the points.
  float r_x = triangle_half_width;
  float r_y = r_x*sqrt(3)/2;
  
  // Screen coordinates representing the center point on the screen. 
  float center_x = width/2.0;  // width half.
  float center_y = height/2.0; // height half.
  
  // We now use the center coordinates and offsets to initialize the original points on the screen.
  p1 = new PVector(center_x, center_y - r_y);
  p2 = new PVector(center_x - r_x, center_y + r_y);
  p3 = new PVector(center_x + r_x, center_y + r_y);
  iteration_point = p1.copy();
  
  cache = new double[height][width]; 
  
  screen_image = createImage(width, height, ARGB);
  
  distanceProc = new DistanceFunctionProcessor(screen_image);
}

/*
 * Helper Functions.
 */

// Applys an affine transformation to the given point in accordance with the definition of 
// the iterated function system.
PVector IteratePoint(PVector point)
{
  float random_variable = random(1.0);
  PVector randomly_chosen_transform_vector;
  
  if(random_variable < cumulative_probability_1)
  {
    randomly_chosen_transform_vector = p1;  
  }
  else if(random_variable < cumulative_probability_2)
  {
    randomly_chosen_transform_vector = p2;
  }
  else
  {
    randomly_chosen_transform_vector = p3;
  }
  
  point.add(randomly_chosen_transform_vector);
  point.div(2.0);
  
  return point;
}

// Stores the value of the given iteration point in the iradiance cache.
// Uses bilinear interpolation on the 4 values around the point.
/*   Left  Right  Halves
 *  +-----+-----+
 *  |     |     |
 *  |  .......  | Up Half
 *  |  .  |  .  |
 *  +--.--+--.--+  <... The dottend square represents the iteration sample point's irradiance square.
 *  |  .......  |        We need to add partial values to each neighbor pixel based on the area of the sample that is within each image sample region. 
 *  |     |     | Down Half
 *  |     |     |
 *  +-----+-----+
 */
void plotIterationPoint(PVector vec)
{
  // We decompose the vector's values into integral and fractional components using integer rounding.
  int integral_component_x = (int)(vec.x);
  int integral_component_y = (int)(vec.y);
  float fractional_component_x = vec.x - integral_component_x;
  float fractional_component_y = vec.y - integral_component_y;
  
  // We then use
  float percentage_right = max(0.0, fractional_component_x - (1.0 - sample_width));
  float percentage_left  = 1 - percentage_right;
  
  float percentage_down  = max(0.0, fractional_component_y - (1.0 - sample_width));
  float percentage_up    = 1 - percentage_down;
  
  int cache_row = integral_component_y;
  int cache_col = integral_component_x;
  
  // Add each of the area weighted values to the cache.
  cache[cache_row][cache_col]         += SAMPLE_IRRADIANCE_VALUE*percentage_up  *percentage_left;
  cache[cache_row][cache_col + 1]     += SAMPLE_IRRADIANCE_VALUE*percentage_up  *percentage_right;
  cache[cache_row + 1][cache_col]     += SAMPLE_IRRADIANCE_VALUE*percentage_down*percentage_left;
  cache[cache_row + 1][cache_col + 1] += SAMPLE_IRRADIANCE_VALUE*percentage_down*percentage_right;
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
  
  for(int row = 0; row < cache_h;   row++)
  for(int col = 0; col < cache_w; col++)
  {
    // Compute the image signal value.
    int val = (int)(cache[row][col] / max_value*255);
    
    int pixel_index = row*width + col;
    screen_image.pixels[pixel_index] = color(255 - val, 255 - val, 255 - val, 255);
     
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
  
  // Note: frameCount stores how many frame have been drawn to the screen since the beginning.
  // This enables us to increase the number of iterations per frame, because later frames will
  // have less variance and need more samples to make a pereivable change in detail.
  for(int i = 0; i < iterations_per_frame + increase_per_frame*frameCount; i++)
  {
    iteration_point = IteratePoint(iteration_point);
    plotIterationPoint(iteration_point);
  }
  
  // We now update the screen_image with color computed from the values of the irradiance cache.
  drawIradianceCache();
  
  distanceProc.colorUsingDistantFunction(cache);
  
  // Draw the rendered image to the screen.
  image(screen_image, 0, 0);
}


void keyPressed()
{
  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    screen_image.save("output.png");
  }
}