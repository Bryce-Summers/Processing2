void setup()
{
  // 200 base height for beam.
  // 1080 for entire screen.
  size(20, 20);
  //selectFolder("Select a folder to process:", "inSelected");
  //selectFolder("Select a folder to process:", "outSelected");
}

// Input and Output file locations.
File in = null;
File out = null;
void inSelected(File selection)
{
  if(selection == null)
  {
    println("In selection was null.");
  }
  
  in = selection;
}

void outSelected(File selection)
{
  if(selection == null)
  {
    println("Out selection was null.");
  }
  
  out = selection;
}


void draw()
{
  // Don't process  until the files are defined.
  if(in == null || out == null)
  {
    //return;
  }
  
  in  = new File("D:\\GIT\\processing\\examples\\image_directory_scaler\\in");
  out = new File("D:\\GIT\\processing\\examples\\image_directory_scaler\\out");
  
  System.out.println("Hello");
  
  // Get list of all image file names in in/ folder.
  // For each file name:
  //  Load image.
  //   create a graphics context .10 the size.
  //  draw image onto new graphics context.
  //  output image with same name in out/ folder.
  
  File[] listOfImageFiles = in.listFiles();
  
  for(File file : listOfImageFiles)
  {
    PImage img;
    System.out.println(file.getAbsolutePath());
    img = loadImage(file.getAbsolutePath());
    //image(img, 0, 0);// Test that we are loading them.
    
    // 10 percent;
    //float percentage = .1;
    float percentage = .2; // 10 percent;
    
    int w = (int)(img.width*percentage);
    int h = (int)(img.height*percentage);
    
    PGraphics g = createGraphics(w, h);
    g.beginDraw();
    g.image(img, 0, 0, w, h);
    g.endDraw();
    g.save("out/" + file.getName());
    
    
  }
  
  System.out.println("Done");
  noLoop();
}