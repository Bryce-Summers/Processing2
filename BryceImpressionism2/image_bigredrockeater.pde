// Describes and renders an image of the beautiful factory,
// Woodhull Hospital.
void bigRedRockEaterImage()
{
  PGraphics g;
  
  int w = 720;
  int h = 600;
  g = createGraphics(w, h);
  g.beginDraw();

  // Layers of Image material.
  int branching_factor = 3;
  ArrayList<Triangle> tris  = bigRedRockEater_branch(g, 0, PI, PI/2, new PVector(width/2, height), branching_factor, color(0xFF6B68), 3);
  ArrayList<Triangle> tris2 = bigRedRockEater_branch(g, 0, PI, PI/2, new PVector(width/2, height), branching_factor, color(0x8E3B3A), 3);
  ArrayList<Triangle> tris3 = bigRedRockEater_branch(g, 0, PI, PI/2, new PVector(width/2, height), branching_factor, color(0xEF1D1A), 3);
  
  ArrayList<ArrayList<Triangle>> all_paths = new ArrayList<ArrayList<Triangle>>();
  all_paths.add(tris);
  all_paths.add(tris2);
  all_paths.add(tris3);
  ArrayList<Triangle> paths = merge(all_paths);
  
  int gap = 5;
  int numImpressions = width*height/3;
  float alpha = .05;
  layer(g, gap, numImpressions, paths, alpha);

  g.endDraw();
  g.save("output_.png");
    
  // Draw the image to the screen.
  image(g, 0, 0, width, height);

  noLoop();
  System.out.println("done");
}

ArrayList<Triangle> bigRedRockEater_branch(PGraphics g, float angle_min, float angle_max, float angle_start, PVector location, int times, color col, int recursion)
{
  ArrayList<Triangle> output = new ArrayList<Triangle>();
  if(recursion == 0)
  {
    return output;
  }
  
  float angle_range = angle_max - angle_min;
  float inc = angle_range /= times;
  for(float angle = angle_min; angle < angle_max; angle += inc)
  {
    float angle_middle = (angle + angle + inc)/2;
    ArrayList<Triangle> tris = bigRedRockEater_continue(g, angle, angle + inc, angle_middle, location, times, col, recursion);
    output = merge(output, tris);
  }
  
  return output;
}

ArrayList<Triangle> bigRedRockEater_continue(PGraphics g, float angle_min, float angle_max, float angle_start, PVector location, int times, color col, int recursion)
{
  ArrayList<Triangle> output = new ArrayList<Triangle>();
  
  Path_Visual_Factory factory = new Path_Visual_Factory();
  float max_length = 10.0f; 
  float w = 10; // Width of sky curve.
  
  Curve curve = factory.newCurve();
  PVector pt = location.copy();
  curve.addPoint(pt);
  
  for(int i = 0; i < times; i++)
  {
    float angle_range = angle_max - angle_min;
    float angle = angle_min + random(angle_range);
    float dx = cos(angle);
    float dy = -sin(angle);
    
    int len = width/times/times;
    pt = pt.copy().add(new PVector(dx*len, dy*len));  
    
    curve.addPoint(pt);    
    
    ArrayList<Triangle> path = factory.getVisual(max_length, curve, w, col, col);
    output = merge(output, path);
   
    // Recursively branch.
    ArrayList<Triangle> other = bigRedRockEater_branch(g, angle_min, angle_max, angle_start, pt, times, col, recursion - 1);
    output = merge(output, other);
  }
  
  return output;
}