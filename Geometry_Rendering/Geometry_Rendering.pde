void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  size(1200, 800, P3D);
  println("Hello");
}

ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<Integer> faces  = new ArrayList<Integer>();
PGraphics g;

void draw()
{
  
  g = createGraphics(width, height, P3D);
  g.smooth(8);
  g.beginDraw();
  
  
  init_tetrahedron();
  int subdivisions = 6;
  for(int i = 0; i < subdivisions; i++)
  {
    subdivide();
  }

  float fov = PI/3.0; 
  float cameraZ = (height/2.0) / tan(fov/2.0);
  g.perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0); 

  drawShape();

  
  g.endDraw();
  image(g, 0, 0); 

  g.save("output.png");
  
  noLoop();
  
  println("Done");

}

PVector direction_light1 = new PVector(-1, 1, -.5);

// Enable consistent lights for the scene.
void lightsOn(boolean ambient, boolean diffuse, boolean specular)
{
  //g.lights();
  
  float red = 128.0;
  float green = 128.0;
  float blue = 128.0;
  float dx = -1.0;
  float dy = 1.0;
  float dz = -.5;
  
  if(diffuse)
  {
    g.directionalLight(red, green, blue, dx, dy, dz);
  }
  
  if(specular)
  {
    g.directionalLight(red, green, blue, dx, dy, -1);
    g.lightSpecular(255, 255, 255);
  }
  
  if(ambient)
  {
    g.ambientLight(50, 50, 50);
  }
}

// Initializes the list of points with a tetrahedron.
void init_tetrahedron()
{
   points = new ArrayList<PVector>();
   
   points.add(new PVector(1, 0, -1/sqrt(2)));
   points.add(new PVector(-1, 0, -1/sqrt(2)));
   points.add(new PVector(0, 1, 1/sqrt(2)));
   points.add(new PVector(0, -1, 1/sqrt(2)));

   for(PVector pt : points)
   {
     pt.normalize();
   }

   createFace(faces, 0, 1, 2);
   createFace(faces, 1, 0, 3);
   createFace(faces, 2, 1, 3);
   createFace(faces, 0, 2, 3);
   
   
}

// Adds a face made up of three vectors to the given face list.
// Retrieves vectors from the global points list.
void createFace(ArrayList<Integer> faces, int index0, int index1, int index2)
{
    faces.add(index0);
    faces.add(index1);
    faces.add(index2);
}


void subdivide()
{
  ArrayList<Integer> new_faces = new ArrayList<Integer>();
  
  int len = faces.size();
  for(int i = 0; i < len; i += 3)
  {

    int i0 = faces.get(i + 0);
    int i1 = faces.get(i + 1);
    int i2 = faces.get(i + 2);

    PVector pt0 = points.get(i0);
    PVector pt1 = points.get(i1);
    PVector pt2 = points.get(i2);

    /* Failure. I can't leave any original edges.
    PVector pt_new = pt0.copy().div(3).add(pt1.copy().div(3)).add(pt2.copy().div(3));
    
    // Scale to a length of 2.
    pt_new.normalize();
    int i_new = points.size();
    points.add(pt_new);

    // Add the subdivided faces.
    createFace(new_faces, i_new, i1, i0);
    createFace(new_faces, i_new, i2, i1);
    createFace(new_faces, i_new, i0, i2);
    */

    // New subdivision points along each edge.
    PVector n0 = pt0.copy().div(2).add(pt1.copy().div(2));
    PVector n1 = pt1.copy().div(2).add(pt2.copy().div(2));
    PVector n2 = pt2.copy().div(2).add(pt0.copy().div(2));
    
    n0.normalize();
    n1.normalize();
    n2.normalize();

    int i_n0 = points.size();
    int i_n1 = points.size() + 1;
    int i_n2 = points.size() + 2;
    points.add(n0);
    points.add(n1);
    points.add(n2);

    // Add the subdivided faces.
    createFace(new_faces, i0,   i_n0, i_n2);
    createFace(new_faces, i_n0, i_n1, i_n2);
    createFace(new_faces, i_n0, i1,   i_n1);
    createFace(new_faces, i_n2, i_n1, i2);
  }

  // Replace the old list with the new list.
  faces = new_faces;
}

void drawShape()
{
  setupTransforms();
  //drawGeoemtricSurface();
  //drawParameterLines();
  //drawPlane();
  
  // Shadow on plane.
  //drawShadow(direction_light1);
  
  // Project sphere onto computer screen.
  drawProjection();
}

float scale = 200;

// For the most part, our world is centered around a unit sphere near the origin.
void setupTransforms()
{
  float stroke_weight = 1.0;

  g.translate(width *.6, height*.4, 20);
  float scale = 200;
  g.scale(scale, scale, scale);
  
  g.rotateX(-PI/12);

  g.rotateY(PI/12);
  
  g.strokeWeight(stroke_weight/scale);
}

void setStrokeWeight(float weight)
{
   g.strokeWeight(weight/scale);
}

void drawGeoemtricSurface()
{
  // Ambient, diffuse, specular.
  //lightsOn(false, false, true);
  g.noStroke();
  //g.stroke(0);
  setStrokeWeight(5);
  //g.noFill();
  g.fill(250);

  // Translate Vector Faces into drawn triangles.  
  
  int count = 0;
  for(int i : faces)
  {
    //println(i);
    // Shapes are of length 3.
    if(count % 3 == 0)
    {
      g.beginShape();
    }
    
    PVector pt = points.get(i);
    g.normal(pt.x, pt.y, pt.z);
    g.vertex(pt.x, pt.y, pt.z);
    
    count++;
    if(count % 3 == 0)
    {
      g.endShape(CLOSE);
    }
  }
  g.endShape(CLOSE); 
}
  
void drawParameterLines()
{
  g.noLights();
  // Parameter Lines.
  g.stroke(0);
  setStrokeWeight(2);
  g.noFill();
  g.beginShape(); // Polyline.
  float radius = 1.0001;

  for(float angle = 0; angle < 2*PI; angle += .001)
  {    
    g.vertex(radius*cos(angle), 0, radius*sin(angle));
  }
  g.endShape();
  
  g.stroke(0);
  g.noFill();
  g.beginShape(); // Polyline.

  for(float angle = 0; angle < 2*PI; angle += .001)
  {    
    g.vertex(0, radius*cos(angle), radius*sin(angle));
  }
  g.endShape(); 
}

float plane_offset = 1.01;

void drawPlane()
{
  g.noLights();
  g.stroke(0);
  g.fill(255);
  setStrokeWeight(5);
  
  g.beginShape();
  g.vertex(-2.5,  plane_offset, -2);
  g.vertex( 2,  plane_offset, -2);
  g.vertex( 2,  plane_offset,  1);
  g.vertex(-2.5,  plane_offset,  1);
  g.endShape(CLOSE);
} //<>// //<>//

// Requires the the light direction be facing downwards and pts are have positive y coordinates.
void drawShadow(PVector light_direction)
{
    g.noLights();
    g.noStroke();
    g.fill(0);
  
    // Translate Vector Faces into drawn triangles.  
    
    int count = 0;
    for(int i : faces)
    {
      //println(i);
      // Shapes are of length 3.
      if(count % 3 == 0)
      {
        g.beginShape();
      }
      
      PVector pt = points.get(i);
      
      float dist = (pt.y - plane_offset + .001) / -light_direction.y;
      pt = pt.copy().add(light_direction.copy().mult(dist));
      
      g.vertex(pt.x, pt.y, pt.z);
      
      count++;
      if(count % 3 == 0)
      {
        g.endShape(CLOSE);
      }
    }
    g.endShape(CLOSE);
}

void drawProjection()
{
    g.noLights();
    g.noStroke();
    g.fill(0);

    float plane_offset_z = 2;
    PVector projection_direction = new PVector(0, 0, -1);

    // Translate Vector Faces into drawn triangles.  

    int count = 0;
    for(int i : faces)
    {
      
      // Shapes are of length 3.
      if(count % 3 == 0)
      {
        g.beginShape();
      }
      
      PVector pt = points.get(i);
      
      float dist = (pt.z - plane_offset_z + .001) / projection_direction.z;
      pt = pt.copy().add(projection_direction.copy().mult(dist));
      
      g.vertex(pt.x, pt.y, pt.z);
      
      count++;
      if(count % 3 == 0)
      {
        g.endShape(CLOSE);
      }
    }
    g.endShape(CLOSE);
}