void setup()
{
  size(1080, 1080);
}

float hour = 9;
float minute = 0;
float jig = 2;

void draw()
{

  PGraphics g = createGraphics(width, height);
  
  g.beginDraw();
  
  // White.
  g.background(0xffffffff);


  color c_clock_face = 0xffffffff;//0xff4E73B9;
  color c_white      = 0xffffffff;
  color c_black      = 0xff000000;

  float clock_x = width/2;
  float clock_y = height/2;
  float clock_radius = width/3;

  PShape clock_face  = clockfaceshape(clock_x, clock_y, clock_radius, c_clock_face);
  g.shape(clock_face,  0, 0);
  
  drawTickMarks(g, clock_x, clock_y, clock_radius/2, clock_radius*3/4, c_black, width/100);
  
  // g, x, y, radius of entire clock, color of hands, weight of hour hand, weight of minute hand.
  drawClockHands(g, clock_x, clock_y, clock_radius, c_black, width/50, width/50);

  g.endDraw();
  //g.save("output.png");
  
  g.line(0, 0, width, height);
  
  // Draw the image to the screen.
  image(g, 0, 0);
  
  float minute_inc = .2;
  minute += minute_inc;
  hour += minute_inc/60;
  if(minute > 60)
  {
    minute = minute % 60;
    hour = round(hour) + minute/60;
  }
  
  saveFrame("frames/####.tif");
  
  // Stop looping once we hit 5:30. 
  if(hour > 5.5 && hour < 5.6)
  {
    noLoop();
  }
}

PShape clockfaceshape(float x, float y, float radius, color fill)
{
  PShape s;
  s = createShape();
  s.beginShape();
  
  s.fill(fill);
  
  float inc = PI*2 / 100;

  //for(float angle = 0; angle < 360; angle += inc)
  for(float theta = 0; theta < PI*2; theta += inc) 
  {
    //float theta = angle;//*PI*2/360;
    float vx = x + radius*cos(theta);
    float vy = y + radius*sin(theta);
    
    float jig = 2;
    vx += random(jig);
    vy += random(jig);
    
    s.vertex(vx, vy);
  }

  s.endShape(CLOSE);
  return s;
}

// x, y, inner radius, outer radius, stroke color
void drawTickMarks(PGraphics g, float x, float y, float r0, float r1, color stroke, int weight)
{   
  g.stroke(stroke);
  g.strokeWeight(weight);
  
  float inc = PI*2 / 12;

  //for(float angle = 0; angle < 360; angle += inc)
  for(float theta = 0; theta < PI*2; theta += inc)
  {
    //float theta = angle;//*PI*2/360;
    float vx0 = x + r0*cos(theta);
    float vy0 = y + r0*sin(theta);
    
    float vx1 = x + r1*cos(theta);
    float vy1 = y + r1*sin(theta);
    
    drawJiggedLine(g, vx0, vy0, vx1, vy1, jig);
    //g.line(vx0, vy0, vx1, vy1);
  }
  
}

void drawJiggedLine(PGraphics g, float vx0, float vy0, float vx1, float vy1, float jig_amount)
{
    g.beginShape();
    for(float p = 0; p < 1; p += .1)
    {
      float tx = lerp(vx0, vx1, p);
      float ty = lerp(vy0, vy1, p);
      
      tx += random(jig_amount);
      ty += random(jig_amount);
      
      g.vertex(tx, ty);
    }
    g.endShape();
}

// graphics, center of clock x, y positions, radius of clock, hand stroke color, weight of hour hand, weight of minute hand.
void drawClockHands(PGraphics g, float clock_x, float clock_y, float clock_radius, color stroke, float w_hour, float w_minute)
{
  float hour_hand_angle   = -PI*2*hour/12 + PI/2;
  float minute_hand_angle = -PI*2*minute/60 + PI/2;

  // Draw Hour hand.
  g.strokeWeight(w_hour);  
  g.stroke(stroke);

  float hour_radius = clock_radius/3;
  float hx = clock_x + hour_radius*cos(hour_hand_angle);
  float hy = clock_y - hour_radius*sin(hour_hand_angle);
  //g.line(clock_x, clock_y, hx, hy);
  drawJiggedLine(g, clock_x, clock_y, hx, hy, jig);
  
  // Draw the minute hand.
  g.strokeWeight(w_minute);
  g.stroke(stroke);

  float minute_radius = clock_radius*2/3;
  float mx = clock_x + minute_radius*cos(minute_hand_angle);
  float my = clock_y - minute_radius*sin(minute_hand_angle);
  //g.line(clock_x, clock_y, mx, my);
  drawJiggedLine(g, clock_x, clock_y, mx, my, jig);

}