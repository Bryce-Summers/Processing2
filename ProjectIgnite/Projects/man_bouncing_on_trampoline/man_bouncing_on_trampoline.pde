void setup()
{
   fullScreen();
}

void draw()
{
  background(255);
  drawPerson(width/2, height/2 + (height/2 - 120)*sin(radians(frameCount)), 25 + 10*sin(radians(frameCount + 180)));
  
  int trampoline_w = 300;
  int w_half = width/2;
  
  drawTrampoline(w_half - trampoline_w/2, height - 50, trampoline_w, 15*cos(radians(frameCount + 180 + 90)) );
  //drawTrampoline(w_half + trampoline_w/2 - trampoline_w_2/2, height - 50, trampoline_w_2, 15*cos(radians(frameCount + 180 + 90)) );
}

void drawPerson(float x, float y, float h)
{
  fill(255, 255, 255);
  stroke(0, 0, 0);
  strokeWeight(2);
  
  float radius = 25;
  
  ellipse(x, y, radius*2, radius*2);
  
  
  line(x, y + radius, x, y + 3*h);
  line(x - 2*radius, y + 2*h, x + 2*radius, y + 2*h);
  line(x - 2*radius, y + 5*h, x, y + 3*h);
  line(x + 2*radius, y + 5*h, x, y + 3*h);
  
}

void drawTrampoline(float x, float y, float w, float h)
{
  
  h = (h - 14)*15;
  h = max(0, h);
  
  strokeWeight(5);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  
  float x_last = x;
  float y_last = y;
  for(int i = 0; i < 100; i++)
  {
    int i2 = i >= 50 ? i : 100 - i; 
    
    float x_next = x + w*(i + 1)/100;
    float y_next = y + h*smoothstep(i2/50.0);
    
    
    line(x_last, y_last, x_next, y_next);
    
    x_last = x_next;
    y_last = y_next;
  }
  
  line(x_last, y_last, x + w, y + h);
}

public float smoothstep(float x)
{ 
  // http://en.wikipedia.org/wiki/Smoothstep
  return x*x*(3.0f - 2.0f*x);
}