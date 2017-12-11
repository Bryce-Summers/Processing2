class Region
{
  // Box.
  float x1;
  float y1;
  float x2;
  float y2;
  
  // Regions start out encompassing the full image plane.
  public Region()
  {
    x1 = 0;
    y1 = 0;
    x2 = 1;
    y2 = 1;
  }
  
  public Region(float width, float height)
  {
    x1 = 0;
    y1 = 0;
    x2 = width;
    y2 = height;
  }
  
  Region copy()
  {
    Region output = new Region();
    output.copyFrom(this);
    return output;
  }
  
  // Put this region within another region.
  void copyFrom(Region r)
  {
    x1 = r.x1;
    y1 = r.y1;
    x2 = r.x2;
    y2 = r.y2;
  }
  
  // Sets this region to the middle percentage of itself and
  // fits the clipped wings to the left and the right.
  void splitMiddle(Region left, Region right, float per)
  {
    float per_left = (1.0 - per)/2;
    left.copyFrom(leftSplitFrom(per_left));
    float per_right = 1.0 - per_left*(per_left + per); // I think this may be a bug.
    right.copyFrom(rightSplitFrom(per_right));
  }
  
  // This becomes the left percent of the region r.
  // R becomes the right 1.0 - percentage.
  Region leftSplitFrom(float per)
  {
    Region output = copy();
    
    float per_c = 1.0 - per;
    output.x2 = this.x1*per_c + this.x2*per;
    this.x1 = output.x2;    
    
    return output;
  }
  
  Region upSplitFrom(float per)
  {
    Region output = copy();
    
    float per_c = 1.0 - per;
    output.y2 = this.y1*per_c + this.y2*per;
    this.y1 = output.y2;
    
    return output;
  }
  
    // This becomes the left percent of the region r.
  // R becomes the right 1.0 - percentage.
  Region rightSplitFrom(float per)
  {    
    Region output = copy();
    float per_c = 1.0 - per;
    output.x1 = this.x1*per + this.x2*per_c;
    this.x2 = output.x1;
    
    return output;
  }
  
  Region downSplitFrom(float per)
  {
    Region output = copy();
    float per_c = 1.0 - per;
    output.y1 = this.y1*per + this.y2*per_c;
    this.y2 = output.y1;
    return output;
  }
  
  // Splits into a set of equal horizontal pieces.
  ArrayList<Region> splitX(int pieces)
  {
    ArrayList<Region> output = new ArrayList<Region>();
    
    for(int i = 0; i < pieces; i++)
    {
      Region r = new Region();
      float x1 = this.x1 + this.getWidth()*i/pieces;
      float x2 = this.x1 + this.getWidth()*(i + 1)/pieces;
      r.x1 = x1;
      r.x2 = x2;
      
      r.y1 = this.y1;
      r.y2 = this.y2;
      
      output.add(r);
    }

    return output;
  }
  
  ArrayList<Region> splitY(int pieces)
  {
    ArrayList<Region> output = new ArrayList<Region>();
    
    for(int i = 0; i < pieces; i++)
    {
      Region r = new Region();
      float y1 = this.y1 + this.getHeight()*i/pieces;
      float y2 = this.y1 + this.getHeight()*(i + 1)/pieces;
      r.y1 = y1;
      r.y2 = y2;
      
      r.x1 = this.x1;
      r.x2 = this.x2;
      
      output.add(r);
    }

    return output;
  }
  
  // Curve going through to the right.
  Curve getCurveRight()
  {
    Path_Visual_Factory factory = new Path_Visual_Factory();
    Curve curve = factory.newCurve();
    
    curve.addPoint(new PVector(x1, y1*.5 + y2*.5));
    curve.addPoint(new PVector(x2, y1*.5 + y2*.5));
    return curve;
  }
  
  Curve getCurveLeft()
  {
    Path_Visual_Factory factory = new Path_Visual_Factory();
    Curve curve = factory.newCurve();
    
    // Other way around from curve right.
    curve.addPoint(new PVector(x2, y1*.5 + y2*.5));
    curve.addPoint(new PVector(x1, y1*.5 + y2*.5));    
    return curve;
  }
  
  Curve getCurveUp()
  {
    Path_Visual_Factory factory = new Path_Visual_Factory();
    Curve curve = factory.newCurve();
    
    curve.addPoint(new PVector(x1*.5 + x2*.5, y2));
    curve.addPoint(new PVector(x1*.5 + x2*.5, y1));
    return curve;
  }
  
  Curve getCurveDown()
  {
    Path_Visual_Factory factory = new Path_Visual_Factory();
    Curve curve = factory.newCurve();

    curve.addPoint(new PVector(x1*.5 + x2*.5, y1));
    curve.addPoint(new PVector(x1*.5 + x2*.5, y2));
    return curve;
  }
  
  float getHeight()
  {
    return y2 - y1;
  }
  
  float getWidth()
  {
    return x2 - x1;
  }
  
  float getHalfWidth()
  {
    return getWidth()/2;
  }
  
  float getHalfHeight()
  {
    return getHeight()/2;
  }

  void shrink(PVector location, float per)
  {
    float per_c = 1.0 - per;
    x1 = location.x*per + x1*per_c;
    x2 = location.x*per + x2*per_c;
    
    y1 = location.y*per + y1*per_c;
    y2 = location.y*per + y2*per_c;
  }
}