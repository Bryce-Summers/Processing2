void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  size(1100, 850);
}


void draw()
{

  PGraphics g = createGraphics(width, height);
  g.beginDraw();
 
  g.fill(255, 255, 255);//White.
  //g.rect(0, 0, width, height);
  g.fill(0);
 
  Bounds b = new Bounds();
  b.min_y =  -1;
  b.max_y =  1;
  b.min_x =  0;
  b.max_x =  PI*6;
  b.s_max_x = "6*Pi";
  
  b.screen_min_x = 100;
  b.screen_max_x = width - b.screen_min_x;
  
  b.screen_min_y = 100;
  b.screen_max_y = height/2 - 100;
  b.y0 = 0;
  b.function = 0; // Use f0(x).
  //b.title = "f0(x) = 2*f1(x - PI/2) = sin(x)";
  b.title = "f0(x) = f1(x - PI) = sin(x)";
  
  drawFunction(g, b);
  
  // Draw Modified function.
  b = new Bounds();
  b.min_y =  -1;//0;
  b.max_y =  1;
  b.min_x =  0;
  b.max_x =  PI*6;
  b.s_max_x = "6*Pi";
  
  b.screen_min_x = 100;
  b.screen_max_x = width - b.screen_min_x;
  
  b.screen_min_y = height/2 + 100;
  b.screen_max_y = height   - 100;
  b.y0 = 0;
  b.draw0 = false;
  b.function = 1; // Use f1(x).
  //b.title = "f(x) = exp(-x/10) + exp(-x/10)*sin(x)*exp(-x/10)";
  //b.title = "f_combine(f(x), f(x + PI/4)";
  b.title = "f_combineSigned(f(x), f(x + PI)*.5";

  drawFunction(g, b);  

  g.endDraw();
  image(g, 0, 0); 

  g.save("output.png");
  noLoop(); 

}

class Bounds
{
  float min_y;
  float max_y;
  
  float min_x;
  float max_x;
  
  float y0;
  
  float screen_min_y;
  float screen_max_y;
  
  float screen_min_x;
  float screen_max_x;
  
  String title;
  int function;
  
  boolean draw0 = true;
  
  String s_max_x = null;
}

void drawFunction(PGraphics g, Bounds b)
{
  float padding = 30;
  shrink_bounds(b, padding);
  
  g.fill(0,0,0);
  g.stroke(0, 0, 0);
  
  float range_y = b.max_y - b.min_y;
  float range_x = b.max_x - b.min_x;
  
  float screen_range_y = b.screen_max_y - b.screen_min_y;
  float screen_range_x = b.screen_max_x - b.screen_min_x;
  
  float per_y0 = (b.y0 - b.min_y) / range_y;
  
  float screen_zero_y = b.screen_max_y - per_y0*screen_range_y;
  
  g.strokeWeight(1);
  g.fill(170, 238, 255, 255);
  g.beginShape();
  g.vertex(b.screen_min_x, screen_zero_y);
  for (int i = (int)(b.screen_min_x); i < b.screen_max_x; i += 1)
  {
    float per = (i - b.screen_min_x)/screen_range_x;
    float x = b.min_x + range_x*per;
    
    float y;
    
    switch(b.function)
    {
       case 0: y = f0(x);break;
       case 1: y = f1(x);break;
       case 2: y = f2(x);break;
       case 3: y = f3(x);break;
       default: y = 0;
    }
    
    float j = -(y - b.min_y)/range_y*screen_range_y + b.screen_max_y;
   
    g.vertex(i, j);
  }
  g.vertex(b.screen_max_x, screen_zero_y);
  g.endShape(CLOSE);
  
  g.fill(0);
  g.stroke(0);
  
  g.textSize(16);
  g.textAlign(CENTER, CENTER);
  
  
  float x  = b.screen_min_x - padding;
  float y0 = screen_zero_y;
  float y_min = b.screen_min_y;
  float y_max = b.screen_max_y;
  g.text("" + b.max_y, x - 40, b.screen_min_y);
  g.text("" + b.min_y, x - 40, b.screen_max_y);
  
  if (b.draw0)
  {
    g.text("" + b.y0,    x - 40, screen_zero_y);
  }

  
  // -- Draw the y Tick marks.
  g.strokeWeight(2);
    
  float tick = 2;
  g.line(x - tick, y_min, x + tick, y_min);
  g.line(x - tick, y_max, x + tick, y_max);
  
  if (b.draw0)
  {
    g.line(x - tick, y0,    x + tick, y0);
  }
  
  // -- Draw the x tick marks.
  x = b.screen_min_x;
  float y = b.screen_max_y + padding;
  g.line(x, y - tick, x,  y + tick);
  g.text("" + b.min_x, x, y + 40);

  x = b.screen_max_x;
  g.line(x, y - tick,  x, y + tick);
  
  if(b.s_max_x == null)
  {
    b.s_max_x = "" + b.max_x;
  }
  g.text(b.s_max_x, x, y + 40);
    

  // Draw the title.
  x = b.screen_min_x + screen_range_x/2;
  y = b.screen_min_y - padding;
  g.text(b.title, x, y);

}

void shrink_bounds(Bounds b, float padding)
{
  b.screen_min_x += padding;
  b.screen_max_x -= padding;
  b.screen_min_y += padding;
  b.screen_max_y -= padding;
}

void enlarge_bounds(Bounds b, float padding)
{
  b.screen_min_x -= padding;
  b.screen_max_x += padding;
  b.screen_min_y -= padding;
  b.screen_max_y += padding;  
}

float f0(float x)
{
   //return sin(x)*exp(-x/10);
   //return .5 + .5*sin(x);
   return sin(x);
}

/*
float f1(float x)
{
   
   float m = .5*exp(-x/10);
   return m + m*sin(x)*exp(-x/10);
   
   float a = f0(x);
   float b = f0(x + PI/2);
   
   float max = Math.max(a, b);
   float min = Math.min(a, b);
   
   float diff = abs(max - min);
   
   //return (1 - min)*max + (1-max)*min;
   return max + (1 - max)*(diff*max + (1 - diff)*min);
}*/

float f1(float x)
{
   // Combine outputs a and b from two functions.
   float a = (f0(x));
   float b = f0(x*2 + PI);
   
   float c = combineSigned(a, b);
   return c;
}

float combineSigned(float a, float b)
{
   int sign_a = a < 0 ? -1 : 1;
   int sign_b = b < 0 ? -1 : 1;
   
   if (sign_a*sign_b > 0)
   {
      // Calls the unsigned combine function, which is the one I designed for you last.
      float out_mag = combine(abs(a), abs(b));
      if (sign_a != 0)
      {
        return sign_a*out_mag;
      }
      return sign_b*out_mag;
   }
   
   return a + b;
}

float combine(float a, float b)
{   
   float max = Math.max(a, b);
   float min = Math.min(a, b);
   
   float diff = abs(max - min);
   
   //diff = interpolate(diff, .1);
   
   // Elegantly smooth between the minnimum and maximum value,
   // keeping the derivatives smooth when the maximum function that
   // was dominating crosses the minimum function. 
   float smoothed_value = (diff*max + (1 - diff)*min);
   
   // We interpolated between contributing the raw min value when min is very low,
   // and the interpolated value when min is higher.
   // The idea is that we want to add very little contribution when min is very low,
   // because then a function can be smoothly animated in without discontinuously influencing the original function from the onset.
   smoothed_value = (1 - min)*min + min*smoothed_value;
   
   // The maximum value will dominate more when it is closer to 1.
   return max + (1 - max)*smoothed_value;
}

float interpolate (float x, float a) {

  float min_param_a = 0.0 + EPSILON;
  float max_param_a = 1.0 - EPSILON;
  a = constrain(a, min_param_a, max_param_a); 

  if (a < 0.5) {
    // emphasis
    a = 2*(a);
    float y = pow(x, a);
    return y;
  } 
  else {
    // de-emphasis
    a = 2*(a-0.5);
    float y = pow(x, 1.0/(1-a));
    return y;
  }
}


float f2(float x)
{
   return cos(x);
}

float f3(float x)
{
   return cos(x);
}

void drawArrow(float x1, float y1, float x2, float y2, float head_length, PGraphics g)
{
  g.line(x1, y1, x2, y2);
  
  float dx = x2 - x1;
  float dy = y2 - y1;
  float mag = dist(x1, y1, x2, y2);
  
  float par_x = dx/mag;
  float par_y = dy/mag;
  
  float perp_x = -par_y;
  float perp_y =  par_x;

  // Draw one of the arrow heads.
  g.line(x2, y2, x2 - par_x*head_length + perp_x*head_length,
    y2 - par_y*head_length + perp_y*head_length);
    
  // Draw the other.
  g.line(x2, y2, x2 - par_x*head_length - perp_x*head_length,
                 y2 - par_y*head_length - perp_y*head_length);
}

void keyPressed()
{  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    save("output.png"); 
  }
}