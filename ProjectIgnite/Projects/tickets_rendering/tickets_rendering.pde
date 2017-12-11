


void setup()
{
  size(6000, 6000);
}

void draw()
{

  PGraphics g = createGraphics(width, height);
  
  g.beginDraw();
  
  g.stroke(0, 0, 0);
  //g.stroke(230, 148, 81);
  
  float x0 = width/2;
  float y0 = height/2;
  
  float r = width/2; // radius.
  
  float row_gap = 3;
  
  g.strokeWeight(1);
  g.noFill();
  
  float max_angle = 2*PI*(r/row_gap);
  float angle = 1;
  
  float ticket_length = 600;
  float gap_length = 50;
  
  while(angle < max_angle)
  {
    float dist_per_angle = angle*row_gap;

    float per = angle / max_angle;

    float angle_inc = ticket_length/dist_per_angle;
    float new_angle = angle + angle_inc;
    float angle1 = angle + gap_length/dist_per_angle;
    float angle2 = new_angle - gap_length/dist_per_angle;

    float x1 = x0 + r*per*cos(angle1);
    float y1 = y0 + r*per*sin(angle1);

    float x2 = x0 + r*per*cos(angle2);
    float y2 = y0 + r*per*sin(angle2);

    g.arc(x0, y0 - 100 + 100*per, r*per*2, r*per*2, angle1, angle2);

    //g.line(x1, y1, x2, y2);

    // Loop incrementation.
    angle = new_angle;    
  }
 
  g.endDraw();
  g.save("output.png");
  
  // Draw the image to the screen.
  image(g, 0, 0);
  
  noLoop();  
}