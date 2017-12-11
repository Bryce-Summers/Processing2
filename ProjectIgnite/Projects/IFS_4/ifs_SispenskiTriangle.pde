/*
 * Sispenski's Triangle specification.
 * Written By Bryce Summers on 1/6/2016.
 */

class ifs_SispenskiTriangle extends IFS
{
  
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
 
  
  void initialize()
  {
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
    
  }
  
  PVector getInitialPoint()
  {
    return p1.copy();
  }
  
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
  
  // Not necessary for sispenski's triangle, because it already does all of its calculations in world space.
  PVector localToScreen(PVector vec)
  {
    return new PVector(vec.x, vec.y);
     //return vec; 
  }
  

}