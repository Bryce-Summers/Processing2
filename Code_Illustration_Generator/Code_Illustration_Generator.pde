
static class Colors
{
   // Odd rows of code, we will start with an odd row.
   /* // Red. Source code.
   public static color odd  = 0xFFFFF2F2;
   
   // Even rows of code.
   public static color even = 0xFFFFCCCC;
   */
   
   // Yellow, G Code.
   /*
   public static color odd  = 0xFFFFFFCE;
   public static color even = 0xFFFFFFF2;
   */
   
   // Green. Machine Code.
   
   public static color odd  = 0xFFF2FFF2;
   public static color even = 0xFFCEFFCE;

   
   // Keep these, they are useful.
   public static color white = 0xFFFFFFFF;
   public static color black = 0xFF000000;
}

static class Dimensions
{
  public static int w = 250;
  public static int h = 440;
  
  // height of the source code table.
  public static int table_height = 440;
  public static int row_height  = 20;
  public static int text_height = 16;
  
  
  public static String font = "Lekton-Regular.ttf";
  
  // The Text file that we are animating.
  //public static String input = "code_rq.txt";
  //public static String input = "code_gcode.txt";
  public static String input = "code_machine.txt";
  
  // Number of frames per keyframe. We duplicate each keyframe to syncronize the animation with other animation, such as fingers.1
  public static int frames_per = 1; // 200 millisecond delay. 15; // 250 milliseconds per frame.
  
  public static int frame_inc = 10;
}

PFont font;
char[] letters; // The file that we are typing out.
int frame = 0;
int end_frame = 10;

void setup()
{
  size(720, 440);

  font = createFont(Dimensions.font, Dimensions.text_height);
  
  // Load the text array with the strings.
  String[] lines = loadStrings(Dimensions.input);
  
  // Compute Total number of characters, including the end of line's
  int len = 0;
  for(String s : lines)
  {
    len += s.length() + 1;
  }

  end_frame = len;
  
  letters = new char[len];
  int index = 0;
  for(String s : lines)
  {    
    for(int i = 0; i < s.length(); i++)
    {
      letters[index] = s.charAt(i);
      index++;
    }
    
    // Carriage Returns.
    letters[index] = '\n';
    index++;
  }
  
  for(int i = 0; i < letters.length; i++)
  {
     System.out.print(letters[i]);
  }
  System.out.println('\n');
  
}

void draw()
{
  int image_w = Dimensions.w;
  int image_h = Dimensions.h;
   
  PGraphics g = createGraphics(image_w, image_h);

  g.beginDraw();
    
  // White.
  g.background(Colors.white);
    
  drawFrame(g, frame);

  g.endDraw();
  
  image(g, 0, 0);
  
  // To syncronize the output with other animations, we duplicate each frame.
  int frames_per = Dimensions.frames_per;
  for(int i = 0; i < frames_per; i++)
  {
    g.save("frame_" + (frame*frames_per + i) + ".png");
  }
  
  // Increment frame, but don't skip the last frame.
  if(end_frame - frame > 0 && end_frame - frame < Dimensions.frame_inc)
  {
    frame = end_frame;
  }
  else
  { 
    frame += Dimensions.frame_inc;
  }

  // Draw the image to the screen.
  //image(g, 0, 0);
  
  if(frame > end_frame)
  {
    noLoop();
  }
}

void drawFrame(PGraphics g, int frame)
{
  drawBackground(g);
  drawText(g, frame, letters);
}

void drawBackground(PGraphics g)
{
  
  int row_height = Dimensions.row_height;
  
  g.noStroke();
  
  int y1 = 0;
  int y2 = y1 + row_height;
  boolean odd = true;
  
  // Tile the image with row rectangles.
  while(y1 < Dimensions.table_height)
  {
    if(odd)
    {
      g.fill(Colors.odd);
    }
    else
    {
      g.fill(Colors.even);
    }
    odd = !odd;
    
    g.rectMode(CORNERS);
    g.rect(0, y1, Dimensions.w, y2);
    y1 = y2 + 1;
    y2 = y2 + row_height;
  }
}

void drawText(PGraphics g, int frame, char[] letters)
{
  
  // Location of next letter.
  int x_start = 10;
  int y_start = 16;
  int y_offset = Dimensions.row_height;
  int x_offset = 16;
  
  int x = x_start;
  int y = y_start;
  
  g.fill(Colors.black);
  g.textFont(font);
  
  for(int i = 0; i < frame && i < letters.length; i++)
  {
    char c = letters[i];
    if (c == '\n')
    {
      // Carriage return.
      x = x_start;
      y = y + y_offset;
      continue;
    }
    
    if(c == ' ')
    {
      frame++;
    }

    g.text(c, x, y);
    x += x_offset;
  }
} //<>// //<>// //<>//