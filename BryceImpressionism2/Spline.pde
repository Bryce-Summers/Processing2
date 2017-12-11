class Spline
{
  
  ArrayList<PVector> _point_discretization;
  
  // A Spline of curves.
  ArrayList<Hermite_Curve> _curves;
  
  public Spline()
  {
      _point_discretization = new ArrayList<PVector>();
      _curves = new ArrayList<Hermite_Curve>();
  }
  
  public void addPoint(PVector p)
  {
      _point_discretization.add(p);
      
      if(_point_discretization.size() == 2)
      {
         PVector p0 = _point_discretization.get(0);
         PVector p1 = _point_discretization.get(1);
         PVector tangent = p1.copy().sub(p0);
        
         Hermite_Curve curve = new Hermite_Curve(p0, tangent, p1, tangent, false);
         _curves.add(curve);
      }
      else if(_point_discretization.size() == 3)
      {
         // Add Two new curves.
         _curves.remove(0);
         
         // Add first curve.
         PVector p0 = _point_discretization.get(0);
         PVector p1 = _point_discretization.get(1);
         PVector p2 = _point_discretization.get(2);
         
         PVector t0 = p1.copy().sub(p0);
         PVector t1 = p2.copy().sub(p0).div(2);
         PVector t2 = p2.copy().sub(p1);
         
         Hermite_Curve curve1 = new Hermite_Curve(p0, t0, p1, t1, false);
         _curves.add(curve1);
       
         Hermite_Curve curve2 = new Hermite_Curve(p1, t1, p2, t2, false);
         _curves.add(curve2);
         
      }
      else if(_point_discretization.size() > 3)
      {
        // Remove last curve, add an intermediate, and an ending curve.
        _curves.remove(_curves.size() - 1);
        
        int index0 = _point_discretization.size() - 4;
        PVector p0 = _point_discretization.get(index0 + 0);
        PVector p1 = _point_discretization.get(index0 + 1);// previous
        PVector p2 = _point_discretization.get(index0 + 2);//   ending spline.
        PVector p3 = _point_discretization.get(index0 + 3); // New Point.
        
        PVector t1 = p2.copy().sub(p0).div(2);
        PVector t2 = p3.copy().sub(p1).div(2);
        PVector t3 = p3.copy().sub(p2);
        
        Hermite_Curve curve1 = new Hermite_Curve(p1, t1, p2, t2, false);
         _curves.add(curve1);
       
         Hermite_Curve curve2 = new Hermite_Curve(p2, t2, p3, t3, false);
         _curves.add(curve2);
      }
  }
  
  public int numPoints()
  {
     return _point_discretization.size();
  }
  
  public PVector getPointAtIndex(int i)
  {
    return _point_discretization.get(i);
  }
  
  public PVector removeLastPoint()
  {
     return _point_discretization.remove(_point_discretization.size() - 1);
  }
  
  // Given a time between 0 and 1, returns the position on this spline.
  public PVector getPoint(float time)
  {
    int numCurves = _curves.size();
    
    time *= numCurves;
    
    // Get floating point part.
    int curveIndex = (int)time;
    float curveTime = time - curveIndex;
    
    if(curveIndex >= _curves.size())
    {
      curveIndex = _curves.size() - 1;
      curveTime = 1;
    }
    
    Hermite_Curve curve = _curves.get(curveIndex);
    return curve.position(curveTime);
  }

  // Given a time between 0 and 1, returns the tangent vector on this spline.
  public PVector getTangent(float time)
  {
    int numCurves = _curves.size();
    
    time *= numCurves;
    
    // Get floating point part.
    int curveIndex = (int)time;
    float curveTime = time - curveIndex;
    
    if(curveIndex >= _curves.size())
    {
      curveIndex = _curves.size() - 1;
      curveTime = 1;
    }
    
    Hermite_Curve curve = _curves.get(curveIndex);
    return curve.tangent(curveTime);
  }
}