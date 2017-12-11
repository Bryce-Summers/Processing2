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
  void plotIterationPoint(PVector vec, double[][] cache)
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
    
    try{
      
    // Add each of the area weighted values to the cache.
    cache[cache_row][cache_col]         += SAMPLE_IRRADIANCE_VALUE*percentage_up  *percentage_left;
    cache[cache_row][cache_col + 1]     += SAMPLE_IRRADIANCE_VALUE*percentage_up  *percentage_right;
    cache[cache_row + 1][cache_col]     += SAMPLE_IRRADIANCE_VALUE*percentage_down*percentage_left;
    cache[cache_row + 1][cache_col + 1] += SAMPLE_IRRADIANCE_VALUE*percentage_down*percentage_right;
    
    distanceProc.addPoint(cache_row, cache_col);
    distanceProc.addPoint(cache_row, cache_col + 1);
    distanceProc.addPoint(cache_row + 1, cache_col);
    distanceProc.addPoint(cache_row + 1, cache_col + 1);
    
    
    }
    catch(NullPointerException e){}
    catch(ArrayIndexOutOfBoundsException e){}
  }