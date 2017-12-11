// Describes and renders an image of the beautiful factory,
// Woodhull Hospital.
void woodhullImage()
{
  PGraphics g;
  
  int w = 7200;
  int h = 6000;
  g = createGraphics(w, h);
  g.beginDraw();

  // Layers of Image material.
  Region universe = new Region(w, h);
  woodhull_sky(g, universe);
  universe.shrink(new PVector(w/2, h), .1); // Shirink by 10 percent.
  woodhull_all_towers(g, universe);

  g.endDraw();
  g.save("output_.png");
    
  // Draw the image to the screen.
  image(g, 0, 0, width, height);

  noLoop();
  System.out.println("done");
}

void woodhull_sky(PGraphics g, Region universe)
{  
  Path_Visual_Factory factory = new Path_Visual_Factory();
  float max_length = 10.0f; 
  
  Curve curve = universe.getCurveUp();
  float w = universe.getWidth(); // Width of sky curve.

  ArrayList<Triangle> path = factory.getVisual(max_length, curve, w, color(0xF2D780), color(0x6394E2));
  int gap = 5;
  int numImpressions = (int)(universe.getWidth()*universe.getHeight()/3);
  layer(g, gap, numImpressions, path, .05); //<>//
}

void woodhull_window(PGraphics g, Region universe)
{
    Path_Visual_Factory factory = new Path_Visual_Factory();
  float max_length = 10.0f; 
  
  Curve curve = universe.getCurveUp();
  float w = universe.getWidth(); // Width of sky curve.

  color blue  = color(0x9EEAFF);
  color brown = color(0xDFE2D9);
  ArrayList<Triangle> path = factory.getVisual(max_length, curve, w, blue, brown);
  int gap = 5;
  int numImpressions = (int)(universe.getWidth()*universe.getHeight()/3);
  layer(g, gap, numImpressions, path, .5);
}

void woodhull_concrete(PGraphics g, Region universe, boolean rightNotup)
{
  Path_Visual_Factory factory = new Path_Visual_Factory();
  float max_length = 10.0f;

  Curve curve;
  float w;
  if(rightNotup)
  {
    curve = universe.getCurveRight();
    w = universe.getHeight(); // Width of sky curve.
  }
  else
  {
    curve = universe.getCurveUp();
    w = universe.getWidth();
  }

  color brown1  = color(0xA9B0BC);
  color brown2  = color(0x5E5C67);
  ArrayList<Triangle> path = factory.getVisual(max_length, curve, w, brown1, brown2);
  int gap = 5;
  int numImpressions = (int)(universe.getWidth()*universe.getHeight()/3);
  layer(g, gap, numImpressions, path, .3);
}

void woodhull_bricks(PGraphics g, Region universe, color col, boolean rightNotUp)
{
  Path_Visual_Factory factory = new Path_Visual_Factory();
  float max_length = 10.0f;

  Curve curve;
  float w;
  
  if(rightNotUp)
  {
    curve = universe.getCurveRight();
    w = universe.getHeight(); // Width of sky curve.
  }
  else
  {
    curve = universe.getCurveUp();
    w = universe.getWidth();    
  }

  ArrayList<Triangle> path = factory.getVisual(max_length, curve, w, col, col);
  int gap = 3;
  int numImpressions = (int)(universe.getWidth()*universe.getHeight()/3);
  layer(g, gap, numImpressions, path, .3);
}

void woodhull_windowrow(PGraphics g, Region universe)
{
  Region full = universe.copy();
  
  ArrayList<Region> windows = universe.splitX(12);
  
  for(Region r : windows)
  {
    woodhull_window(g, r);
  }
}

// A tower of windows and gray support.
void woodhull_windowTower(PGraphics g, Region universe)
{
  ArrayList<Region> rows = universe.splitY(6);
  
  for(int i = 0; i < rows.size(); i++)
  {
    Region r = rows.get(i);
    
    Region concrete_toprow = r.upSplitFrom(.3);
    Region concrete_leftcol = r.leftSplitFrom(1.0/13);
    Region concrete_row2 = r.upSplitFrom(.5);
    Region concrete_row = concrete_row2.downSplitFrom(1.0/4);
    
    // Windows in the bottom .33
    woodhull_windowrow(g, r);
    
    woodhull_concrete(g, concrete_toprow, true);
    woodhull_concrete(g, concrete_leftcol, false);
    woodhull_concrete(g, concrete_row2, true);
    woodhull_concrete(g, concrete_row, true);
  }
}

void woodhull_brickTower(PGraphics g, Region universe)
{
  ArrayList<Region> rows = universe.splitY(13);
  for(int i = 0; i < rows.size(); i++)
  {
    Region middle = rows.get(i);
    
    Region top    = middle.upSplitFrom(.2);   // equal.
    Region bottom = middle.downSplitFrom(.25);// equal.
    
    // Middle bricks.
    woodhull_bricks(g, middle, color(0xD3A594), true);
    
    // Top bricks.
    woodhull_bricks(g, top, color(0xB57263), true); 
    // Top bricks. They go upwards.
    woodhull_bricks(g, bottom, color(0xB57263), false);
  }
}

void woodhull_tower(PGraphics g, Region universe)
{
 // I want the middle tower to take up the middle .17th of the universe.
 
 // 10 13ths. The window towers only go up 10 13ths of the length of the brick towers.
 Region left  = new Region();
 Region right = new Region();
 
 universe.splitMiddle(left, right, .17);
 
 // Clip off the top 3 13ths.
 left.upSplitFrom(3.0/13);
 right.upSplitFrom(3.0/13);
 
 Region middle = universe;
 
 woodhull_windowTower(g, left);
 woodhull_windowTower(g, right);
 woodhull_brickTower(g, middle);
 
}

void woodhull_all_towers(PGraphics g, Region universe)
{
  ArrayList<Region> towers = universe.splitX(3);
  
  for(Region r : towers)
  {
    woodhull_tower(g, r); 
  }
}