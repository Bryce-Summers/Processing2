void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  //size(512, 512);
  //size(1920, 1350);
  size(800, 800);
}


void draw()
{

  PGraphics g = createGraphics(width, height);
  g.beginDraw();

  float h = 1080;
  float inc = 80;
  
  // Draw the Axis.
  g.strokeWeight(4);
  Complex origin_location = new Complex(width/2, height/2);
  drawArrow(origin_location.real, 0, origin_location.real, height - 4, inc/3, g);
  drawArrow(0, origin_location.imag, width - 4, origin_location.imag, inc/3, g);


  g.strokeWeight(2);
  g.fill(181, 245, 255, 255); // Light blue.

///*
  for(int x = 0; x <= width;  x += inc)
  for(int y = 0; y <= height; y += inc)
  {    
    Complex z  = new Complex(x, y);
    Complex z2 = f(z.sub(origin_location), inc).add(origin_location);
    drawArrow(z.real, z.imag, z2.real, z2.imag, inc/8, g);

  }
  for(int x = 0; x <= width;  x += inc)
  for(int y = 0; y <= height; y += inc)
  {
    g.ellipse(x, y, inc/4, inc/4);
  }
  //*/

/*
  g.strokeWeight(6);
  Complex z1 = new Complex(2*cos(PI*4/8), 2*sin(PI*4/8));
  Complex z2 = new Complex(3*cos(PI*6/8), 3*sin(PI*6/8));
  Complex z3 = z1.mult(z2);
  
  // first draw angles.
  g.strokeWeight(4);
  float scale = width/12;
  float s = 1.6*scale;
  g.fill(181, 245, 255, 255); // Light blue.
  g.arc(origin_location.real, origin_location.imag, z3.mag()*s, z3.mag()*s, 0, z3.argument() + 2*PI, PIE);
  g.fill(255, 88, 58); // Orange.
  g.arc(origin_location.real, origin_location.imag, z2.mag()*s, z2.mag()*s, 0, z2.argument(), PIE);
  g.fill(181, 245, 255, 255); // Light blue.
  g.arc(origin_location.real, origin_location.imag, z1.mag()*s, z1.mag()*s, 0, z1.argument(), PIE);
  
  // Next draw vectors.
  drawArrow(origin_location, origin_location.add(z1.mult(scale)), inc/4, g);
  drawArrow(origin_location, origin_location.add(z2.mult(scale)), inc/4, g);
  drawArrow(origin_location, origin_location.add(z3.mult(scale)), inc/4, g);
  */
  
  
  


  float ahs = inc/3;
  float size = width/2;
  g.textSize(ahs);
  g.stroke(0, 0, 0, 255);
  //g.fill(181, 245, 255, 255); // Light blue.
  g.fill(255, 88, 58); // Orange.
  // Draw Boxes.
  int offset = 8;
  g.rect(size + ahs*2 - ahs + offset, size*2 - ahs - ahs/2 + 2, ahs*2, ahs);
  g.rect(size*2 - ahs - ahs - offset, size + ahs*2 - ahs/2 + 2, ahs*2, ahs);
  
  g.fill(0,0,0);
  g.textAlign(CENTER, CENTER);
  g.text("+Im", size + ahs*2 + offset, size*2 - ahs);
  g.text("+Re", size*2 - ahs - offset, size + ahs*2);
  
  g.stroke(0, 0, 0, 255); // Black.

  // Draw the derivative arrows.
  g.stroke(255, 88, 58); // Orange.    
  
  g.endDraw();
  image(g, 0, 0); 
  
  g.save("output.png");
  noLoop();
  
  
}

Complex f(Complex z, float inc)
{
  //return z;
  //return z.add(new Complex(inc/2, 0));
  //return z.add(new Complex(inc/2-2, inc/2 - 2));
  //return z.mult(new Complex(cos(PI/16), sin(PI/16)));
  //return z.mult(new Complex(.85*cos(PI/16), .85*sin(PI/16)));
  return z.mult(new Complex(1.15*cos(PI/16), 1.15*sin(PI/16)));
  //return z.mult(new Complex(-1.0, 0));
  //return z.mult(new Complex(1.25, 0));
  //return z.mult(new Complex(.75, 0));
}

class Complex
{
  float real, imag;
  
  public Complex(float real, float imag)
  {
    this.real = real;
    this.imag = imag;
  }
  
  Complex add(Complex other)
  {
     return new Complex(real + other.real, imag + other.imag); 
  }
  
  Complex sub(Complex other)
  {
     return new Complex(real - other.real, imag - other.imag);
  }
  
  // (A + Bi)(C + Di) = AC - BD + (BC + AD)i
  Complex mult(Complex other)
  {
     return new Complex(real*other.real - imag*other.imag, imag*other.real + real*other.imag);
  }
  
  Complex mult(float scale)
  {
    return new Complex(real*scale, imag*scale);
  }
  
  float mag()
  {
    return sqrt(real*real + imag*imag);
  }
  
  float argument()
  {
   return atan2(imag, real); 
  }
  
}

void drawArrow(Complex z1, Complex z2, float head_length, PGraphics g)
{
  drawArrow(z1.real, z1.imag, z2.real, z2.imag, head_length, g); 
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