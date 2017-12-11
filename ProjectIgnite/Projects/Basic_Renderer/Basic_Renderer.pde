PImage myImage; // Declare the image to be called ‘myImage’.
PGraphics g;
void setup()
{ 
  // Set width and height to be the dimensions of 
  // my computer’s screen.
  //fullScreen();
  // Or use some custom dimensions.
  //size(255, 255);
  size(1000, 1000);
  myImage = createImage(width, height, ARGB);
  g = createGraphics(width, height);

}

void draw()
{
  //*
  renderImage(myImage);
  // Tell Processing that myImage has been 
  // modified.
  myImage.updatePixels();
  image(myImage, 0, 0);// Draw the image onscreen.
  myImage.save("output.png");
  noLoop(); // Only draw once.
  //*/
  
  /*
  g.beginDraw();
  g.fill(255, 0, 0); // Red.
  g.stroke(0, 0, 0); // Black.
  for(int i = 0; i < 100; i++)
  {
    g.ellipse(random(width), random(height), 10, 10);
  }
  g.endDraw();
  image(g, 0, 0);
  g.save("output.png");
  noLoop(); // Only draw once.
  */
}

void renderImage(PImage image)
{
  // Construct the image by sampling coordinates within the domain.
  for(int row = 0; row < height; row++) // For every row in the domain   (all y values.)
  for(int col = 0; col < width;  col++) // For every column in each row. (all x values.)
  { 
    // Convert from 2D indices to 1D array index.
    int pixel_array_index = row*width + col;
    image.pixels[pixel_array_index] = evaluateImageFunction(col, row); // See later slide.
  }
}

color evaluateImageFunction(float x, float y)
{
  /*
  int val = (int)x;
  return color(val, val, val, 255);
  //*/
  
  /*
  int val = (int)y;
  return color(val, val, val, 255);
  //*/
  
  /*
  float val_f = (x + y) <= 255
                ? (x + y)
                : (x + y - 256);
  int val = (int) val_f;
  return color(val, val, val, 255);
  //*/
  
  /*
  x = x*3*PI*2/360;
  y = y*2*PI*2/360;
  int val = (int)(((sin(x*.1)*cos(y) + sin(y*.2)*cos(x*.3))*.25 + cos(x)*sin(y)*.25 + .5)*255);
  return color(val, val, val, 255);
  //*/
  
  /*
  x = x*3*PI*2/360;
  y = y*2*PI*2/360;
  int val = (int)(((sin(x*.1)*cos(y) + sin(y*.2)*cos(x*.3))*.25 + cos(x)*sin(y)*.25 + .5)*255);
  val = val/16 * 16;
  return color(val, val, val, 255);
  /*/
  
  /*
  int val = (int)(x) % 16 * 16;
  return color(val, val, val, 255);
  //*/
  
  /*
  int val = (int)(x / ((y+1)/255.0));
  return color(val, val, val, 255);
  */
  
  x -= width/2;
  y -= height/2;
  
  // y coordinate is now reversed.
  y*= -1;
  y -= height/4;
  y += height/15;
  

  float angle = atan2(y, x);
  float r0 = dist(0, 0, x, y);
 

  
  float r = 2 - 2*sin(angle) + sin(angle)*sqrt(abs(cos(angle)))/(sin(angle) + 1.4);
  
  //r += sin(angle);
    
  //r += sin(angle);
  
  float val = (r*100 - r0)*2;// + sin(abs(x)/500*PI - PI/2)*50;
  if(val > 100)
  {
    val = 100;
  }
  val = abs(val);
  
  val = max(min(val/500*255,255), 0);
  
  
  
  int bin = 15;
  val = (int)val / bin * bin;
  
  int opacity = 255;
  if(val > 250)
  {
    opacity = 0;
  }
  
  return color(val*2, val, val, opacity);
  
}