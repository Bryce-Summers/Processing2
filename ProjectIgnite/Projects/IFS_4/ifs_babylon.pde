/* 
 * Barnsley Fern Affine Transformation specification,
 * Written by Bryce Summers on 1/6/2016.
 */

class ifs_Babylon extends MatrixIFS
{
  
  double bounds = 30;
  /*
  double bound1 = 20;
  double bound2 = 30;
  double bound3 = 1000;
  */
  
  final double fractal_x_min = -2.1820;
  final double fractal_x_max =  2.6558;
  final double fractal_x_range = fractal_x_max - fractal_x_min;
  final double fractal_y_min =  0;
  final double fractal_y_max =  9.9983;
  final double fractal_y_range = fractal_y_max - fractal_y_min;
  
  // Initialize will be called after all of the processing system variables have been already set.
  void initialize()
  {
    
    scale_exponent = .05;
      
    // 2d homegenous aka affine transformation matrice's.
    Matrix3 m1, m2, m3;
    // Cooresponding probabilities.
    double  p1, p2, p3;
    
    p1 = .33;
    m1 = new Matrix3(0,  -.5, -1.732366,
                     .85, 0, 3.366182,
                     0,   0, 1);

    p2 = .33;
    m2 = new Matrix3( .3, .0,   -.027891,
                       0, .3,   5.014877,
                        0,   0,   1);

    p3 = .33;
    m3 = new Matrix3(0, .5, 1.620804,
                    -.85,  0, 3.310401,
                      0,   0, 1.0);
                     
    
                           
    
    addMatrix(m1, p1);
    addMatrix(m2, p2);
    addMatrix(m3, p3);
     
   }
  
  
  PVector getInitialPoint()
  {
   return new PVector(0.0, 0.0); 
  }

  PVector localToScreen(PVector vec)
  {
    double x = width/2  + (vec.x)*(width - DISTANCE_BOUNDARY_LENGTH*2)/2*.16;
    double y = height/2 + (vec.y - 3.333)*((height - DISTANCE_BOUNDARY_LENGTH*2))/2*.2;
    
    return new PVector((float)x, (float)y);
  }
}
  