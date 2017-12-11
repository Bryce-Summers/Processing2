
/*
 *
 * Standard Movie Poster size is: 24 x 36 inches
 * We want 300 ink dots per inch.
 * Therefore our image size for printing will be:
 * 24*300 x 36*300
 *
 * = 7200 x 10800 pixels.
 */


static class Colors
{
   public static color white = 0xffffffff;
   public static color black = 0xff000000;
   
   public static color blue = 0xFF3DD5FF;
   
}

static class Dimensions
{
  public static int w;
  public static int h;
  public static int scale;
  
  public static int ruler_w = 10;
  
  public static int shadow_offset_x = 10;
  public static int shadow_offset_y = 10;
  public static int shadow_z;
}

void setup()
{
  // 1 pixel = 10 print pixels. We just want to conserve space right now.
  size(720, 720, P3D);
 
}

void draw()
{
  
  //setup_3D_environment();  

  // 10 is poster scale.
  Dimensions.scale = 10;
  int image_w = 720*Dimensions.scale;
  int image_h = 720*Dimensions.scale;
  
  Dimensions.w = image_w;
  Dimensions.h = image_h;
  Dimensions.shadow_z = -20*Dimensions.scale;
  
  
  PGraphics g = createGraphics(image_w, image_h, P3D);
  
  g.beginDraw();
  
  
  PImage ruler_texture = Ruler_texture(720*Dimensions.scale, 200*Dimensions.scale);
  
  // White.
  g.background(Colors.white);

  draw_3D_ruler(g, ruler_texture, image_w, image_h);

  //g.image(ruler_texture, 0, 0);

  g.endDraw();
  g.save("output.png");
  
  // Draw the image to the screen.
  //image(g, 0, 0);
  
  noLoop();
}

void setup_3D_environment()
{
  translate(width/2, height/2, 0);
  stroke(255);
  rotateX(PI/2);
  rotateZ(-PI/6);
}


// Note: PGraphics are PImages.
PImage Ruler_texture(int width, int height)
{
  PGraphics g = createGraphics(width, height);
  g.beginDraw();

  int s = Dimensions.scale;
  float border_width = 5*s;
  float hbw = border_width/2;

  g.strokeWeight(border_width);

  g.stroke(Colors.black);
  g.fill(Colors.blue);
  g.noStroke();

  g.beginShape();
  g.vertex(0,         hbw);
  g.vertex(width, hbw);
  g.vertex(width, height - hbw);
  g.vertex(0,           height - hbw);
  g.endShape(CLOSE);
  
  g.stroke(Colors.black);
  g.line(hbw, hbw, width - hbw, hbw);
  g.line(hbw, height - hbw, width - hbw, height - hbw);

  // graphics, x_spacing, line weight, height divisor, w, h.
  draw_rulings(g, width/20, 1*s, 4, width, height);
  draw_rulings(g, width/10, 2*s, 3, width, height);
  draw_rulings(g, width/5,  3*s, 2, width, height);

  g.endDraw();  
  return g;
}
 
void draw_rulings(PGraphics g, float spacing, float line_width, float height_divisor, int width, int height)
{
  g.strokeWeight(line_width);
  
  for(float x = 0; x < width; x += spacing)
  {
    g.line(x, 0, x, height/height_divisor);
  }
}

void draw_3D_ruler(PGraphics g, PImage texture, int w, int h)
{  
  int width = w;
  int height = h;
  
  // Center ruler on screen.
  g.pushMatrix();
  g.translate(width/2, height/2, 0);
  
   //<>//
  drawShadow(g);
  
  //ortho();
  // Wrap that texture.
  g.lights();
  g.textureWrap(REPEAT);
  g.noStroke();
  g.beginShape(QUADS);  
  g.texture(texture);
  
  int img_h = texture.height;
  
  float total_dist = 0;

  int res = 1000;
  for(int time = 0; time < res; time ++)
  {
    float t1 = time*1.0 / res;
    float t2 = (time + 1)*1.0 / res;
    
    // Compute Geometric positions.
    int ruler_w = Dimensions.ruler_w*Dimensions.scale;

    // Extract coordinates for drawing ruler.
    PVector top1 = position_offset(t1, -ruler_w);
    PVector top2 = position_offset(t2, -ruler_w);
    
    PVector bot1 = position_offset(t1, ruler_w);
    PVector bot2 = position_offset(t2, ruler_w);

    float displacement = top1.dist(top2);
    
   
    //int tex_x1 = (int)(t1*texture.width);//(int)(total_dist*texture.width);
    //int tex_x2 = (int)(t2*texture.width);//(int)(total_dist*texture.width);
    
    float scale = 5;
    int tex_x1 = (int)(total_dist*scale);
    total_dist += displacement; //<>//
    int tex_x2 = (int)(total_dist*scale); //<>//
    
    // Wrapping.
    //tex_x1 = tex_x1 % texture.width;
    //tex_x2 = tex_x2 % texture.width;

    // A Bunch of rectangles along the ruler.
    
    g.vertex(top1.x, top1.y, top1.z, tex_x1, 0);
    g.vertex(top2.x, top2.y, top2.z, tex_x2, 0);
    g.vertex(bot2.x, bot2.y, bot2.z, tex_x2, img_h);
    g.vertex(bot1.x, bot1.y, bot1.z, tex_x1, img_h);
    
    
    /*
    g.vertex(x, 0, 0,                tex_x1, 0);
    g.vertex(x + spacing, height, 0, tex_x2, img_h);
    g.vertex(x, height, 0,           tex_x1, img_h);
    */

  }
  
  g.endShape();
  
  g.popMatrix();
}

void drawShadow(PGraphics g)
{
  // Shadow.
  PShape s = createShape();
  s.beginShape();
  s.fill(0, 0, 0);
  s.strokeWeight(Dimensions.scale*2);
  s.stroke(100, 100, 100);
  //s.noStroke();
  
  PVector center = new PVector(0, 0, 0);

  // Add all of the interior points.
  for(int i = 0; i < 1000; i++)
  {
    float t = i/1000.0;
    
    float offset = Dimensions.ruler_w*Dimensions.scale;
    
    PVector p0 = position_offset(t, -offset);
    PVector p1 = position_offset(t, offset);
    
    // Find the interior shadow projection points.
    PVector in;
    
    if (p0.dist(center) < p1.dist(center))
    {
      in = p0;
    }
    else
    {
      in = p1;
    }
    
    s.vertex(in.x, in.y, Dimensions.shadow_z);
  }
  
  // Add all of the exterior points.
  for(int i = 999; i >= 0; i--)
  {
    // Backwards.
    float t = i/1000.0;
    
    float offset = Dimensions.ruler_w*Dimensions.scale;
    
    PVector p0 = position_offset(t, -offset);
    PVector p1 = position_offset(t, offset);

    // Find the interior shadow projection points.
    PVector out;
    
    if (p0.dist(center) > p1.dist(center))
    {
      out = p0;
    }
    else
    {
      out = p1;
    }
    
    //println(out.x +" y = " + out.y);
    s.vertex(out.x, out.y, Dimensions.shadow_z);
  }
    
  s.endShape(CLOSE);
  
  g.pushMatrix();
  
  g.shape(s, Dimensions.shadow_offset_x, Dimensions.shadow_offset_y);
  g.popMatrix();
}

// Time from 0 to 1.
// Offset indicates how far along the perpendicular direction.
// The perp direction will twist over time.
PVector position_offset(float t, float offset)
{
  PVector position = position(t); 
  
  
  PVector up = twist(t);
  
  PVector tan = tangent(t);
  
  PVector perp = up.cross(tan);
  
  return position.add(perp.mult(offset));
  
}

PVector tangent(float t)
{
  float e = .000001;
  PVector p0 = position(t - e);
  PVector p1 = position(t + e);
  
  PVector tan = p1.sub(p0);
  
  tan.div(e*2);
  tan.normalize();
  return tan;
}

PVector position(float t)
{
   // Radius along spiral.
   float max_r = Dimensions.w/2;
   float min_r = Dimensions.w/10;
   
   // from, to, time.
   float r = lerp(min_r, max_r, t);
     
   int loops = 4;
   float max_angle = PI*2*loops;
   float angle = t*max_angle;
  
   r += t*t*t*Dimensions.w/100*cos(angle*10);
  
   float x = r*cos(angle);
   float y = r*sin(angle);
   
   // We will keep z to be 0 for now.
   float z = 0;
   
   return new PVector(x, y, z);
   
}

PVector twist(float t)
{
  
   // Radius along spiral. 
   int loops = 4;
   float max_angle = PI*2*loops;
   float angle = max_angle*t;
   //angle = t*t*Dimensions.w/10*cos(angle*5);
  
   float x = cos(angle);
   float y = sin(angle);
   
   // Apply the twist.
   x *= cos(angle);
   y *= cos(angle);
   float z = sin(angle);
  
   PVector output = new PVector(x, y, z);
  
   return output.normalize();
}