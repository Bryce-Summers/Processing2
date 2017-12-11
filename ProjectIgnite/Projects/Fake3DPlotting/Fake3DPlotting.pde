// This is the buffer of color values that we will display on screen.
PImage screen_image;
PImage image_3d_plot;
int max_3d_height = 100;

void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  fullScreen();
  
  screen_image  = createImage(width, height, ARGB);
  image_3d_plot = createImage(width, height + max_3d_height, ARGB);
}

void draw()
{
  
  renderFunction(screen_image);
  // draw the screen image with a fake 3d approximation.
//  draw3DImageOnScreen(screen_image);
  image(screen_image, 0, 0);
  
  noLoop();
}

float f(float x, float y)
{

  x = x/3;
  y = y/2;
  x = x*PI*2/360;
  y = y*PI*2/360;
      
  return (sin(x*.1)*cos(y) + sin(y*.2)*cos(x*.3))*.25 + cos(x)*sin(y)*.25 + .5;
  
  /*
  return pow(pow((width*.25 + height*.75 - x - y),2)*
             pow((width*.75 + height*.25 - x - y),2)*pow((x + y),2)/width/width/height/height/width/height*8,2);
             */
}

// Normalizes the cache and draws it to the screen.
void renderFunction(PImage image)
{
  int height = image.height;
  int width  = image.width;
    
  for(int row = 0; row < height; row++)
  for(int col = 0; col < width; col++)
  {

     // Compute the image signal value.
     float val_f = (constrain(f(col, row), 0, 1)*255);
     
     /*
     float val_f = f(col, row);
     float val_dx = f(col + 1, row) - val_f;
     float val_dy = f(col, row + 1) - val_f;
     */
     
     //val_f = sqrt(val_dx*val_dx + val_dy*val_dy)*100*5*255;
     
     // Make the level sets stand out by post proccessing the function.
     int half = 255/2;
     int bin_size = 10;
     int val = (int)(val_f/bin_size)*bin_size;//(int)(half*cos(val_f*.1)) + half;
        
     int pixel_index = row*width + col;
     
     //image.pixels[pixel_index] = color(val/4, (val + 100) % 255, (val + 200) % 255, 255);
     image.pixels[pixel_index] = color(val, val, val, 255);
    
  }
     
}

void draw3DImageOnScreen(PImage image)
{
     
  for(int i = 0; i < image_3d_plot.pixels.length; i++)
  {
    image_3d_plot.pixels[i] = color(0,0,0,0);
  }
  
  int width = image_3d_plot.width;
  
  int len = image.pixels.length;
  for(int i = 0; i < len; i++)
  {
    int val = image.pixels[i] >> 16 & 0xFF;
    
    int height = val*max_3d_height/255;
    
    
    // Height.
    for(int h = 0; h < height; h++)
    {
      image_3d_plot.pixels[i + (max_3d_height - h)*width] = image.pixels[i];
    }
  }
  
  image_3d_plot.updatePixels();
  
  
  image(image_3d_plot, 0, 0);
}

void keyPressed()
{
  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    screen_image.save("output.png");
    image_3d_plot.save("output_3d_plot.png");
  }
}