/* 
 * Matrix IFS class specification, Written by Bryce Summers on 1/6/2016.
 * Purpose: This class provides standard methods for specifying matrix and probabalistic transformations for an IFS.
 */

class Matrix3
{
  double[] data;
  
  Matrix3(double a, double b, double c,
          double d, double e, double f,
          double g, double h, double i)
  {
    data = new double[9];
    
    data[0] = a; data[1] = b; data[2] = c;
    data[3] = d; data[4] = e; data[5] = f;
    data[6] = g; data[7] = h; data[8] = i;
    
  }
  
  PVector mult(PVector in)
  {
    PVector out = new PVector();
    
    out.x = (float)(data[0]*in.x + data[1]*in.y + data[2]*in.z);
    out.y = (float)(data[3]*in.x + data[4]*in.y + data[5]*in.z);
    out.z = (float)(data[6]*in.x + data[7]*in.y + data[8]*in.z);
    
    return out;
  }
  
  // Treat the z component of in as a 1.0
  PVector multHomogenous(PVector in)
  {
    PVector out = new PVector();
    
    out.x = (float)(data[0]*in.x + data[1]*in.y + data[2]);
    out.y = (float)(data[3]*in.x + data[4]*in.y + data[5]);
    out.z = (float)(data[6]*in.x + data[7]*in.y + data[8]);
    
    return out;
  }
  
}

class Transform
{
  Matrix3 matrix;
  double probability;
  
  Transform(Matrix3 M, double prob)
  {
     matrix = M;
     probability = prob;
  }
}

abstract class MatrixIFS extends IFS
{

  ArrayList<Transform> transforms = new ArrayList<Transform>();
  double culmulative_probability;
  
  void addMatrix(Matrix3 M, double prob)
  {
    // Each transform stores an upper bound on its own culmatalive probability.
    culmulative_probability += prob;
    transforms.add(new Transform(M, culmulative_probability));
  }
  
  PVector IteratePoint(PVector point)
  {
    double random_variable = random((float)culmulative_probability);
    
    for(Transform t : transforms)
    {
      if(random_variable < t.probability)
      {
         return t.matrix.multHomogenous(point); 
      }
    }
    
    println("Error: MatrixIFS, this should never happen.");
    return point;
  }
}
  