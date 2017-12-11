void setup()
{
  size(800, 800);
}

ArrayList<PVector> points = new ArrayList<PVector>();

boolean draw_line = false;
boolean draw_hole = false;

int count_line = 0;
int count_hole = 0;

int prev_x = 0;
int prev_y = 0;

ArrayList<PShape> shapes = new ArrayList<PShape>();
PShape temp_shape = null;

void draw()
{
  background(color(255, 255, 255));
  
  for(int i = 0; i < shapes.size(); i++)
  {
    PShape s = shapes.get(i);
    shape(s, 0, 0);
  }
  
  if(temp_shape != null)
  {
    shape(temp_shape, 0, 0);
  }
  
}

void mouseMoved()
{
  if(!draw_line && !draw_hole)
  {
    return;
  }

  if(dist(prev_x, prev_y, mouseX, mouseY) > 5)
  {
    addCurrentMousePoint();
  }
}

void mousePressed() {

  // End the previous line.
  if(draw_line || draw_hole)
  {
    if(points.size() > 0)
    {
       String out = "";
       if(draw_line)
       {
         out = "line_" + count_line;
         count_line++;
       }
       else
       {
         out = "hole_" + count_hole;
         count_hole++;
       }

       saveStrings(out + ".txt", pointsToStrings(points));
       shapes.add(pointsToShape(points));
       points = new ArrayList<PVector>();
    }
    draw_line = false;
    draw_hole = false;
    return;
  }
  
  
  // -- Begin a new shape.
  
  if(mouseButton == LEFT)
  {
    draw_line = true;
    draw_hole = false;
  }
  else
  {
    draw_line = false;
    draw_hole = true;
  }
  
  addCurrentMousePoint();
}

String[] pointsToStrings(ArrayList<PVector> points)
{
  String[] output = new String[points.size()*2];
  
  for(int i = 0; i < points.size(); i++)
  {
    PVector pt = points.get(i);
    output[2*i + 0] = "" + pt.x;
    output[2*i + 1] = "" + pt.y;
  }

  return output;
}

// Shapes are used to provide feedback to the user.
PShape pointsToShape(ArrayList<PVector> points)
{
  PShape s;
  s = createShape();
  s.beginShape();
  s.noFill();
  s.stroke(0, 0, 0);
  
  for(int i = 0; i < points.size(); i++)
  {
    PVector vec = points.get(i);
    s.vertex(vec.x, vec.y);
  }
  
  s.endShape();
  return s;
}

void addCurrentMousePoint()
{
  prev_x = mouseX;
  prev_y = mouseY;
  
  points.add(new PVector(prev_x, prev_y));
  temp_shape = pointsToShape(points);
}