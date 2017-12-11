void setup()
{
  size(1920, 1080);
}

void draw()
{

  PGraphics g = createGraphics(width, height);
  
  g.beginDraw();
  
  // White.
  g.background(0xffffffff);

  float[] heights = {20, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 90, 95, 100};
    
  float[] widths = {10, 20, 40};
  
  // White.
  color from = 0xffffffff;
  color to   = 0xFF3D87FF;
  color black = 0xff000000;  
  
  g.fill(0xFF3D87FF);
  g.stroke(0,0,0);
  
  float scale_h  = .1;
  float scale_w  = 1.0;
  float ground_y;

  float h = 0;
  
  float horizon_y = height/3;

  // Draw the initial skyline.
  while(h < 1.01)
  {
    scale_h = log(h + 1) / log(2);
    
    // White to blue.
    g.fill(lerpColor(from, to, scale_h));
    color road_color = lerpColor(from, black, scale_h);
    g.stroke(lerpColor(from, black, scale_h));
    
    ground_y = horizon_y + height/2*scale_h;
    drawSkyline(g, ground_y, heights, widths, scale_h, scale_w, road_color);
    h += .01;
  }
  
  // Clouds.
  h = 0;
  g.noStroke();
  //to = 0xFFFFA77F;
  //to = 0xFFD1E2FF;
  while(h < 1.01)
  {
    scale_h = log(h + 1) / log(2);
    
    // White to blue.
    g.fill(lerpColor(from, to, scale_h));
        
    float y = horizon_y - horizon_y*scale_h;
    drawClouds(g, y, heights, widths, scale_h, scale_w);
    h += .01;
  }
  
  // Waves.
  h = 0;
  //to = ;
  g.noFill();
  while(h < 1.00)
  {
    scale_h = log(h + 1) / log(2);
    
    // White to blue.
    g.stroke(lerpColor(to, from, scale_h));
        
    float y0 = (horizon_y + height/2) + 10;
    float y = lerp(y0, height, scale_h);
    drawWaves(g, y, heights, widths, scale_h, scale_w);
    h += .01;
  }
     
  g.endDraw();
  g.save("output.png");
  
  g.line(0, 0, width, height);
  
  // Draw the image to the screen.
  image(g, 0, 0);
  
  noLoop();  
}

// ASSUMPTION: heights and widths do not contain 0 terms.
void drawSkyline(PGraphics g, float ground_y, float[] heights, float[] widths, float scale_h, float scale_w, color road_color)
{
  // Offset naturally, form a perspective in the middle.
  float x = width/2 - width/2*scale_w - (float)Math.random()*sample(widths, scale_w);
  float y = ground_y;
  
  // Draw start of shape.
  g.beginShape();
  g.vertex(x, y);
  
  // Draw Intermediate buildings.
  while(x < width) //<>//
  {
    // Go back to the ground to create gaps between buildings.
    y = ground_y;
    g.vertex(x, y);    
    x += 10*scale_w;
    g.vertex(x, y);
    
    y = ground_y - sample(heights, scale_h);
    g.vertex(x, y);
    
    
    float x0 = x;
    x += sample(widths, scale_w);
    float x1 = x;
    
    float y0 = ground_y;
    float y1 = height - ground_y; // distance_to_ground.
    
    // Draw the road.
    g.pushStyle();
    g.fill(road_color);
    g.rect(x0, y0, x1 - x0, y1);

    float x_mid = (x0 + x1)/2;

    // Draw the yellow line.
    //g.stroke(0xffADA100);
    g.line(x_mid, y0, x_mid, y0 + y1); 
    
    g.popStyle();
    
    g.vertex(x, y);
  }
  
  // Draw the end of the buildings.
  y = ground_y;
  g.vertex(x, y);
  g.endShape();
  
}

void drawClouds(PGraphics g, float y, float[] heights, float[] widths, float scale_h, float scale_w) 
{
  float x = width/2 - width/2*scale_w - (float)Math.random()*sample(widths, scale_w);
  
  while(x < width)
  {
     float w = sample(widths, scale_w);
     float h = sample(heights, scale_h);
     g.ellipse(x, y, h, h*1.05);
     x += h + 10;
  }
}

void drawWaves(PGraphics g, float y, float[] heights, float[] widths, float scale_h, float scale_w)
{
  float x = width/2 - width/2*scale_w - (float)Math.random()*sample(widths, scale_w);
  
  scale_w *= .1;
  scale_h *= .5;
  
  while(x < width)
  {
     float w = sample(widths, 1.0);
     g.arc(x, y, w, sample(heights, .05), PI + PI/10, PI + 9*PI/10);
     x += w;
  }
}

float sample(float[] heights, float scale)
{
  int len = heights.length;
  
  int index = (int)(Math.random()*len);
  
  return heights[index]*scale;
}