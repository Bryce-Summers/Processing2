int resolution = 128;

void setup()
{
  // Call this first to set the width and height variables to the correct sizes.
  //fullScreen();
  //size(512, 512);
  size(1280, 1280);
}


void draw()
{
    background(255);
  
    stroke(45, 45, 45);
    strokeWeight(1);
    //drawLines(16);
    
    stroke(30, 30, 30);
    strokeWeight(1.5);
    //drawLines(32);
    
    stroke(15, 15, 15);
    strokeWeight(2);
    drawLines(64);
    
    stroke(0, 0, 0);
    strokeWeight(4);
    drawLines(128);
    
    stroke(0, 0, 0);
    strokeWeight(8);
    //drawLines(256);
  
    strokeWeight(4);
  
    int n = 4;
    for(int x = 0; x <= n; x++)
    for(int y = 0; y <= n; y++)
    {
      int pixel_x = resolution*x/n;
      int pixel_y = resolution*y/n;
          
      drawImage(x*resolution*2, y*resolution*2, pixel_x, pixel_y);
      //save("out_" + x +"_" + y+".png");
    }
  
  save("output.png");
  noLoop();
  
}

void drawImage(int loc_x, int loc_y, int pixel_x, int pixel_y)
{
 
  int px = pixel_x;
  int py = pixel_y;
  
  pixel_x = (pixel_x + resolution/2)/resolution*resolution;
  pixel_y = (pixel_y + resolution/2)/resolution*resolution;
  
  //fill(
    
  stroke(0, 0, 0);
  fill(255, 0, 0);
  int size = 10;
  
  textSize(resolution/2);
  textAlign(CENTER, CENTER);
  int index = 0;
  
  
  for(int x = resolution/2; x < width;  x += resolution)
  for(int y = resolution/2; y < height; y += resolution)
  for(int i = 0; i < 1; i++)
  {
    
     //ellipse(x + random(resolution), y + random(resolution), size, size);
     //ellipse(x + resolution/2, y + resolution/2, size, size);

     //text("" + index, x, y);    
     index++;
  }
  
  int res = resolution;
  double per_x = (resolution - pixel_x)*1.0/resolution;
  double per_y = (resolution - pixel_y)*1.0/resolution;


  // Draw all 4 rectangles.
  fill((int)(per_x*per_y*255));
  rect(loc_x, loc_y, res, res);
  
  fill((int)((1.0 - per_x)*per_y*255));
  rect(loc_x + res, loc_y, res, res);
 
  fill((int)(per_x*(1.0 - per_y)*255));
  rect(loc_x, loc_y + res, res, res);
  
  fill((int)((1.0 - per_x)*(1.0  - per_y)*255));
  rect(loc_x + res, loc_y + res, res, res);
  
  noFill();
  
  // -- draw the pixel virtual bounding box.
  fill(255, 255, 255, 100);
  rect(loc_x + px, loc_y + py, resolution, resolution);
  
  // Draw the small point of the sample.
  fill(255, 0, 0);
  ellipse(loc_x + px + resolution/2,
          loc_y + py + resolution/2,
          resolution/4, resolution/4);
}

void drawLines(int resolution)
{
  // Draw horizontal lines.
  for(int y = 0; y < height;  y += resolution)
  {    
    line(0, y, width, y); 
  }
  
  // Draw Vertical Lines.
  for(int x = 0; x < width; x += resolution)
  {
    line(x, 0, x, height); 
  } 
}

void keyPressed()
{
  
  // If the user presses space, then this program will save a nice transparent image of the fractal in the local file output.png.
  if (key == ' ')
  {
    save("output.png");
    
  }
  
  
}