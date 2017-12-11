/* 
 * Barnsley Fern Affine Transformation specification,
 * Written by Bryce Summers on 1/6/2016.
 */

class ifs_BarnsleyFern extends MatrixIFS
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
    // 2d homegenous aka affine transformation matrice's.
    Matrix3 m1, m2, m3, m4;
    // Cooresponding probabilities.
    double  p1, p2, p3, p4;
    
    p1 = .01;
    m1 = new Matrix3(0,   0, 0,
                     0, .16, 0,
                     0,   0, 1);
                     
    p2 = .85;
    m2 = new Matrix3( .85, .04,   0,
                     -.04, .85, 1.6,
                        0,   0,   1);
                     
    p3 = .07;
    m3 = new Matrix3(.2, -.26, 0,
                     .23, .22, 1.60,
                       0,   0, 1.0);
                     
    p4 = .07;
    m4 = new Matrix3(-.15, .28,   0,
                     .26,  .24, .44,
                       0,    0,   1);
                           
    
    addMatrix(m1, p1);
    addMatrix(m2, p2);
    addMatrix(m3, p3);
    addMatrix(m4, p4);
     
   }
  
  
  PVector getInitialPoint()
  {
   return new PVector(0.0, 0.0); 
  }

  PVector localToScreen(PVector vec)
  {
    // Conversion between fractal coordinates and screen space coordinates.
    double x = width - bounds - (vec.y - fractal_y_min)/fractal_y_range*(width-bounds*2);
    double y = bounds + (vec.x - fractal_x_min)/fractal_x_range*(height - bounds*2);
    
    return new PVector((float)x, (float)y);
  }
}
  