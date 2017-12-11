void setup()
{
  // 200 base height for beam.
  // 1080 for entire screen.
  size(800, 800);// 20 by 24 inch.
} //<>//

void draw()
{
  //testPath(); // Black path.
  pathWithImpressions(); // Colored path.
  //woodhullImage();
  //bigRedRockEaterImage();
}

void testPath()
{
  Path_Visual_Factory factory = new Path_Visual_Factory();
 
  float max_length = 10.0f;
  Curve curve = factory.newCurve();
  float w = 10; // Width of the curve.

  curve.addPoint(new PVector(100, 50));
  curve.addPoint(new PVector(100, 150));
  curve.addPoint(new PVector(200, 150));
  curve.addPoint(new PVector(300, 300));

  colorMode(HSB, 1);
  ArrayList<Triangle> path_triangles = factory.getVisual(max_length, curve, w, color(0, 1, 1), color(0, 0, 1));
  
  fill(0);
  for(Triangle tri : path_triangles)
  {
    PVector p1 = tri.p1;
    PVector p2 = tri.p2;
    PVector p3 = tri.p3;
    
    triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    /*
    System.out.println("Positions: " + tri.p1 + " " + tri.p2 + " " + tri.p3);
    System.out.println("Tangents:  " + tri.t1 + " " + tri.t2 + " " + tri.t3);
    System.out.println();
    */
  }
  
  System.out.println("Done!");

  noLoop();
}

void pathWithImpressions()
{
  PGraphics g;
  g = createGraphics(width, height);
  g.beginDraw();

  int initial_gap = 5;
  int last_gap = 5;
  int seed = 0;
  int numImpressions = width*height/10;
  //ArrayList<Triangle> triangles = generateTriangles();
  ArrayList<Triangle> triangles = generateTrafficTriangles();
  for(int i = initial_gap; i >= last_gap; i--)
  {
    layer(g, i, numImpressions, triangles, .05);
  }
    
  g.endDraw();
  g.save("output_.png");
    
  // Draw the image to the screen.
  image(g, 0, 0);

  noLoop();
  System.out.println("done");
}

// Test path.

ArrayList<Triangle> generateTriangles()
{
  Path_Visual_Factory factory = new Path_Visual_Factory();
 
  float max_length = 10.0f;
  Curve curve1 = factory.newCurve();
  float w = 50; // Width of the curve.

  curve1.addPoint(new PVector(100, 50));
  curve1.addPoint(new PVector(100, 150));
  curve1.addPoint(new PVector(200, 150));
  curve1.addPoint(new PVector(300, 150));
  curve1.addPoint(new PVector(600, 200));
  
  // red.
  colorMode(HSB, 1);
  color col  = color(0, 1, 1);
  color col2 = color(0, 0, 1);

  ArrayList<Triangle> path_triangles1 = factory.getVisual(max_length, curve1, w, col, col2);
  
  Curve curve2 = factory.newCurve();
  curve2.addPoint(new PVector(200, 0));
  curve2.addPoint(new PVector(300, 200));
  curve2.addPoint(new PVector(200, 400));
  
  col = color(.3, 1, 1); // Not red.
  col2 = color(.3, 0, 1);
  ArrayList<Triangle> path_triangles2 = factory.getVisual(max_length, curve2, w, col, col2);
  
  return merge(path_triangles1, path_triangles2);
}

// Generates triangles aalong paths on an intersection.
ArrayList<Triangle> generateTrafficTriangles()
{
  // Bottom lanes.
  PVector p1 = new PVector(250, 700);
  PVector p2 = new PVector(350, 700);
  PVector p3 = new PVector(450, 700);
  PVector p4 = new PVector(550, 700);
  
  // Right lanes
  PVector p5  = new PVector(700, 550);
  PVector p6  = new PVector(700, 450);
  PVector p7  = new PVector(700, 350);
  PVector p8  = new PVector(700, 250);
  
  // Top lanes
  PVector p9  = new PVector(550, 100);
  PVector p10 = new PVector(450, 100);
  PVector p11 = new PVector(350, 100);
  PVector p12 = new PVector(250, 100);

  // Left lanes
  PVector p13 = new PVector(100, 250);
  PVector p14 = new PVector(100, 350);
  PVector p15 = new PVector(100, 450);
  PVector p16 = new PVector(100, 550);
  
  // Corners.
  PVector c1 = new PVector(150, 650);
  PVector c2 = new PVector(650, 650);
  PVector c3 = new PVector(650, 150);
  PVector c4 = new PVector(150, 150);
  
  colorMode(HSB, 1);
  color red = color(0, 1, 1);
  color green = color(.3, 1, 1);
  color yellow = color(.14, 1, 1);
  
  // form all paths.
  float path_w = 75;
  ArrayList<Triangle> tris = new ArrayList<Triangle>();
  
  // -- Straight Up Down Configuration.
  /*
  
  // Up, down.
  tris = addPath(p3, p10, green, path_w, tris);
  tris = addPath(p4, p9, green, path_w, tris);
  tris = addPath(p11, p2, green, path_w, tris);
  tris = addPath(p12, p1, green, path_w, tris);
  
  // Right, Left.
  tris = addPath(p16, p5, red, path_w, tris);
  tris = addPath(p15, p6, red, path_w, tris);
  tris = addPath(p7, p14, red, path_w, tris);
  tris = addPath(p8, p13, red, path_w, tris);
  
  // Crosswalks
  tris = addPath(c1, c2, red, path_w, tris);
  tris = addPath(c3, c4, red, path_w, tris);
  tris = addPath(c4, c1, green, path_w, tris);
  tris = addPath(c2, c3, green, path_w, tris);
  
  // Right curves.
  tris = addPath(p4, p5,  green, path_w, tris, true);
  tris = addPath(p3, p6,  red,   path_w, tris, true);
  tris = addPath(p8, p9,  yellow, path_w, tris, true);
  tris = addPath(p7, p10, red, path_w, tris, true);
  tris = addPath(p12, p13, green, path_w, tris, true);
  tris = addPath(p11, p14, red, path_w, tris, true);
  tris = addPath(p16, p1, yellow, path_w, tris, true);
  tris = addPath(p15, p2, red, path_w, tris, true);
  
  // Left curves.
  tris = addPath(p3, p14, yellow, path_w, tris, true);
  tris = addPath(p7,  p2, red, path_w, tris, true);
  tris = addPath(p11, p6, yellow, path_w, tris, true);
  tris = addPath(p15, p10, red, path_w, tris, true);
  */
  
  // Left Turn Configuration
  /*
  // Up, down.
  tris = addPath(p3,  p10, red, path_w, tris);
  tris = addPath(p4,  p9,  red, path_w, tris);
  tris = addPath(p11, p2,  red, path_w, tris);
  tris = addPath(p12, p1,  red, path_w, tris);
  
  // Right, left
  tris = addPath(p16, p5, red, path_w, tris);
  tris = addPath(p15, p6, red, path_w, tris);
  tris = addPath(p7, p14, red, path_w, tris);
  tris = addPath(p8, p13, red, path_w, tris);
  
  // Crosswalks
  tris = addPath(c1, c2, red, path_w, tris);
  tris = addPath(c3, c4, red, path_w, tris);
  tris = addPath(c4, c1, red, path_w, tris);
  tris = addPath(c2, c3, red, path_w, tris);
  
  // Right curves.
  tris = addPath(p4, p5,  green, path_w, tris, true);
  tris = addPath(p3, p6,  red,   path_w, tris, true);
  tris = addPath(p8, p9,  green, path_w, tris, true);
  tris = addPath(p7, p10, green, path_w, tris, true);
  tris = addPath(p12, p13, green, path_w, tris, true);
  tris = addPath(p11, p14, red, path_w, tris, true);
  tris = addPath(p16, p1, green, path_w, tris, true);
  tris = addPath(p15, p2, green, path_w, tris, true);
  
  // Left curves.
  tris = addPath(p3, p14, green, path_w, tris, true);
  tris = addPath(p7,  p2, red, path_w, tris, true);
  tris = addPath(p11, p6, green, path_w, tris, true);
  tris = addPath(p15, p10, red, path_w, tris, true);
  */
  
  // -- Pedestrian Scramble.
  // Up, down.
  tris = addPath(p3,  p10, red, path_w, tris);
  tris = addPath(p4,  p9,  red, path_w, tris);
  tris = addPath(p11, p2,  red, path_w, tris);
  tris = addPath(p12, p1,  red, path_w, tris);
  
  // Right, left
  tris = addPath(p16, p5, red, path_w, tris);
  tris = addPath(p15, p6, red, path_w, tris);
  tris = addPath(p7, p14, red, path_w, tris);
  tris = addPath(p8, p13, red, path_w, tris);
  
  // Crosswalks
  tris = addPath(c1, c2, green, path_w, tris);
  tris = addPath(c3, c4, green, path_w, tris);
  tris = addPath(c4, c1, green, path_w, tris);
  tris = addPath(c2, c3, green, path_w, tris);
  
  // Right curves.
  tris = addPath(p4, p5,  yellow, path_w, tris, true);
  tris = addPath(p3, p6,  red,   path_w, tris, true);
  tris = addPath(p8, p9,  yellow, path_w, tris, true);
  tris = addPath(p7, p10, red, path_w, tris, true);
  tris = addPath(p12, p13, green, path_w, tris, true);
  tris = addPath(p11, p14, red, path_w, tris, true);
  tris = addPath(p16, p1, yellow, path_w, tris, true);
  tris = addPath(p15, p2, red, path_w, tris, true);
  
  // Left curves.
  tris = addPath(p3, p14,  red, path_w, tris, true);
  tris = addPath(p7,  p2,  red, path_w, tris, true);
  tris = addPath(p11, p6,  red, path_w, tris, true);
  tris = addPath(p15, p10, red, path_w, tris, true);
  
  // diagonal Pedestrian paths.
  tris = addPath(c1, c3,  green, path_w, tris);
  tris = addPath(c2, c4,  green, path_w, tris);

  return tris;
}

ArrayList<Triangle> addPath(PVector p1, PVector p2, color col, float path_w, ArrayList<Triangle> previous)
{
  return addPath(p1, p2, col, path_w, previous, false);
}

ArrayList<Triangle> addPath(PVector p1, PVector p2, color col, float path_w, ArrayList<Triangle> previous, boolean isCurved)
{
  Path_Visual_Factory factory = new Path_Visual_Factory();
 
  float max_length = 10.0f;
  Curve curve = factory.newCurve();
  curve.addPoint(p1);
  
  // If the path is curved, we bend it towards the center.
  if(isCurved)
  {
    float distance = p2.copy().sub(p1).mag();
    PVector midpoint = p1.copy().add(p2).div(2.0);
    PVector center = new PVector(width/2, height/2);
    
    PVector toCenter = center.copy().sub(midpoint).normalize();
    
    // Move the midpoint closer to the center.
    midpoint.add(toCenter.mult(distance/4));
    curve.addPoint(midpoint);
  }
  
  curve.addPoint(p2);
  ArrayList<Triangle> path_triangles1 = factory.getVisual(max_length, curve, path_w, col, col); 
  
  return merge(previous, path_triangles1);
}

ArrayList<Triangle> merge(ArrayList<ArrayList<Triangle>> arrays)
{
  ArrayList<Triangle> output = new ArrayList<Triangle>();
  
  for(ArrayList<Triangle> array : arrays)
  {
    output = merge(output, array);
  }
  
  return output;
}

ArrayList<Triangle> merge(ArrayList<Triangle> arr1, ArrayList<Triangle> arr2)
{
  for(Triangle tri : arr2)
  {
    arr1.add(tri);
  }
  
  return arr1;
}

// Fill in a set of triangles using strokes.
// Alpha: .05 is rather transparent, .5 is rather defined.
void layer(PGraphics g, int gap, int numImpressions, ArrayList<Triangle> triangles, float alpha)
{
  
  for(int i = 0; i < numImpressions; i++)
  {
    int triIndex = (int)random(triangles.size());
    Triangle tri = triangles.get(triIndex);
    PVector pos = tri.getRandomPoint();
    PVector tangent = tri.interpolateTangentAtPt(pos);
    
    // 0 - 1.
    color col  = tri.interpolateColorAtPt(pos);
    
    colorMode(HSB, 1);
    
    // FIXME: Extract time to compute blending of colors.
    drawImpression(g, gap, pos, tangent, hue(col), saturation(col), alpha);
  }
  
  /*
  for(int x = 0; x < width; x  += gap*20)
  for(int y = 0; y < height; y += gap*20)
  { //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    //drawImpression(g, gap, x, y);
  }*/
}

void drawImpression(PGraphics g, int gap, PVector pos, PVector tangent, float hue, float sat, float alpha)//, int px, int py)
{
  
  sat = 1;
  
  float px = pos.x; //<>//
  float py = pos.y;  

  // normalized velocity direction.

  float dx = tangent.x;
  float dy = tangent.y;
  
  // Compute magnitude of velocity vector.
  float distance = dist(0, 0, dx, dy);
  
  // Normalize velocity vector.
  dx /= distance;
  dy /= distance;
   
  // Compute perpendicular direction vector.
  float perp_x = -dy*gap;
  float perp_y =  dx*gap;
   
  // Draw velocity vector.
  float mag = gap*2;
  dx *= mag;
  dy *= mag;
  
  float val = 1;
  //float sat = 1;

  // Motion Lines.
  
  //blendMode(ADD);
  
  g.colorMode(HSB, 1);
  val = 1;//getVal();
  g.stroke(hue, sat, val, alpha);  // Set fill to gray.
  g.strokeWeight(gap);
  g.line(px + dx/2, py + dy/2, px - dx/2, py - dy/2);
    
  val = .3;
  
  //val = .9;//getVal();
  g.stroke(hue, sat, val, alpha);  // Set fill to gray.
  g.line(px + perp_x + dx/2, py + perp_y + dy/2, px - dx/2, py - dy/2);
  
  //val = .9;//getVal();
  g.stroke(hue, sat, val, alpha);  // Set fill to gray.
  g.line(px - perp_x + dx/2, py - perp_y + dy/2, px - dx - dx/2, py - dy - dy/2);
  
}

float getVal()
{
  return random(1);
}