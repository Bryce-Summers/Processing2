/*
 * A demonstration of Interpolation Functions.
 * Written by Bryce Summers on 1/24/2016
 */

int circle_radius = 10;

Interpolation_func f_linear, function_DoubleQuadraticSigmoid, function_DoubleCubicOgee, function_SmoothStep;

void setup()
{
  size(600, 400);
  smooth();
  
  f_linear = new f_linear();
  function_DoubleQuadraticSigmoid = new function_DoubleQuadraticSigmoid();
  function_DoubleCubicOgee = new function_DoubleCubicOgee();
  function_SmoothStep = new function_SmoothStep();
}

void draw()
{
  background(255, 255, 255);
  
  // Drive the animation with an x coordinate that goes from 0 - 1 - 0 linearly.
  float x = frameCount % 120;
  if(x >= 60)
  {
    x = 120 - x;
  }
  
  x /= 60;
    
  textSize(20);
  
  drawFunction(f_linear, 0, 0, 600, 100, x);
  fill(0);
  text("Linear", 0, 50);
  
  drawFunction(function_DoubleQuadraticSigmoid, 0, 100, 600, 100, x);
  fill(0);
  text("Sigmoid", 0, 150);
  
  drawFunction(function_DoubleCubicOgee, 0, 200, 600, 100, x);
  fill(0);
  text("Ogee", 0, 250);
  
  drawFunction(function_SmoothStep, 0, 300, 600, 100, x);
  
  fill(0);
  text("SmoothStep Polynomial", 0, 350);
  
};

interface Interpolation_func
{
  float eval(float x);
}

class f_linear implements Interpolation_func
{
   float eval(float x)
   {
     return x;
   }
}

class function_DoubleQuadraticSigmoid implements Interpolation_func
{
  //------------------------------------------------------------------
  public float eval(float x)
  {
    float y = 0;
    if (x<=0.5){
      y = sq(2.0f*x)/2.0f;
    } 
    else {
      y = 1.0f - sq(2.0f*(x-1.0f))/2.0f;
    }
    return y;
  }
}

class function_DoubleCubicOgee implements Interpolation_func
{
  public float eval(float x)
  {
     return eval(x, .5, .5);  
  }
  public float eval(float x, float a, float b)
  {
    
    float min_param_a = 0.0f + EPSILON;
    float max_param_a = 1.0f - EPSILON;
    float min_param_b = 0.0f;
    float max_param_b = 1.0f;

    a = constrain(a, min_param_a, max_param_a); 
    b = constrain(b, min_param_b, max_param_b); 
    float y = 0;
    if (x <= a){
      y = b - b*pow(1.0f-x/a, 3.0f);
    } 
    else {
      y = b + (1.0f-b)*pow((x-a)/(1.0f-a), 3.0f);
    }
    return y;
  }
}

class function_SmoothStep implements Interpolation_func
{

  public float eval(float x)
  { 
    // http://en.wikipedia.org/wiki/Smoothstep
    return x*x*(3.0f - 2.0f*x);
  }
}

void drawFunction(Interpolation_func foo, float x, float y,  float w, float h, float current_x)
{
  stroke(0, 0, 0); // black.
  fill(255);       // white.
  strokeWeight(1);
  float y_last = foo.eval(0);
  y_last = y + h - y_last*h;
  float x_last = 0;
  int n = 20;
  for(int i = 0; i < n; i++)
  {
    float x_next = (i + 1.0)/n;
    float y_next = foo.eval(x_next);
    y_next = y + h - y_next*h;
    
    line(x + w*x_last, y_last, x + w*x_next, y_next);
    y_last = y_next;
    x_last = x_next;
  }
  
  int radius = circle_radius*2;
  ellipse(x + current_x*w, y + h - h*foo.eval(current_x), radius, radius);
}