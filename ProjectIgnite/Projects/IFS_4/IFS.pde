/* 
 * IFS class specification, Written by Bryce Summers on 1/6/2016.
 * Purpose: This class provides an abstracted interface for defining the functionality of particular Iterated function systems.
 * Different interesting fractals can subclass this class to work with my IFS rendering system.
 */

abstract class IFS
{
      
  int get_iterations_per_frame()
  {
   return 1000; 
  }
  
  int get_increase_per_frame()
  {
    return 0;
  }
  
  double scale_exponent = .2;
  
  double scaleIrradiance(double norm_val)
  {
   return Math.pow(norm_val, scale_exponent); 
  }
    
  
  // Initialize will be called after all of the processing system variables have been already set.
  abstract void initialize();
  abstract PVector getInitialPoint();
  abstract PVector IteratePoint(PVector point);
  
  // This gives iterated function systems the chance to transform points one last time before they are drawn to the screen.
  // This function should not modify vec.
  abstract PVector localToScreen(PVector vec);
}