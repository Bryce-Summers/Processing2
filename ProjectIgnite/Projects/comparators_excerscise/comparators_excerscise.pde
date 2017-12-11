import processing.pdf.*;
import java.util.LinkedList;

// See for processing PDF functionailty: https://processing.org/reference/libraries/pdf/
int N;

//LinkedList<Relation>[] 
Object[] relations;

int[] permutation;

String version;

int SIZE_MAJOR;
int SIZE_MINOR;

void setup() {
  size(850, 1100, PDF, "output.pdf");

  noLoop();
  
  version = "v1.0";
  N = 11;
  
  SIZE_MAJOR = 60;
  SIZE_MINOR = 30;
  
  populateRelations(N);

  permutation = new int[N];
  for(int i = 0; i < N; i++)
  {
    permutation[i] = i; 
  }
  
  shuffle(permutation);

}

void draw() {
   
  // Draw the title page. // 100 pixel borders,
  background(255);
  int w = width - 200;
  int tile_w = w/N;
  
  for(int i = 0; i < N; i++)
  {
    drawGlyph(permutation[i], 100 + tile_w/2 + i*1.0/N*w, height/2, tile_w);
  }
  
  fill(0, 0, 0);
  textSize(SIZE_MAJOR);
  textAlign(CENTER, CENTER);
  text("Comparison Activity " + version, width/2, height/2 + tile_w*3);
  textSize(SIZE_MINOR);
  text("By Bryce Summers", width/2, height/2 + tile_w*5);
  
  // Generate a set.
  for(int i = 0; i < N; i++)
  {
    PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer
    pdf.nextPage();  // Tell it to go to the next page
    drawFrame(i);    
  }
  
  println("Done");
  endRecord();
  exit();
}

public void drawFrame(int index)
{
  
  LinkedList<Relation> tuples = (LinkedList<Relation>)relations[index];
  textSize(64);
  stroke(0, 0, 0);
  textAlign(CENTER, CENTER);
  int tile_size = 200;
  
  int x = width/2 - tile_size/2;
  int y = height/2 - (int)(tile_size) + tile_size;
  
  // Draw the carrier glyph.
  fill(230, 230, 230);// Grey.
  float main_x = x - tile_size/3;
  float main_y = y - tile_size*(1.33);
  rect(main_x - tile_size/2, main_y - tile_size/2, tile_size, tile_size);
  drawGlyph(index, main_x, main_y, tile_size*3/4);
  
  int row = 1;
  for(Relation R : tuples)
  {
    if(row >= 3)
    {
       row = 0;
       x += tile_size;
    }
    if(row == 0)
    {
      y = height/2 - (int)(tile_size);
    }    

    fill(255, 255, 255); // White.
    rect(x - tile_size/2, y - tile_size/2, tile_size, tile_size);
    fill(0, 0, 0);// Black.
    text(R.toString(), x - tile_size/4, y);
    drawGlyph(R.i2, x + tile_size/5, y, tile_size/2);
    y += tile_size;
    row++;
  }
  
  drawDisclaimer();

}

// Draw the disclaimer.
void drawDisclaimer()
{
   textSize(SIZE_MINOR);
   text("Comparison Social Activity by Bryce Summers 2016. " + version, width/2, height - 100); 
}

// Draws a glyph of th given index at the square of size size centered at x,y.
void drawGlyph(int index, float x, float y, int size)
{
  float x1 = x;
  float y1 = y;

  int res = 1000;
  for(int i = 0; i < res; i++)
  {
    float angle = i * 1.0 / res *2*PI;
    float mag = size*1.0/2*sin(angle*(permutation[index] + 1));
    float x2 = x + mag*cos(angle);
    float y2 = y + mag*sin(angle);
    
    line(x1, y1, x2, y2);
    x1 = x2;
    y1 = y2;
  }
}


enum COMPARISON{LESS, GREATER, EQUAL}

class Relation
{
   public int i1, i2;
   public COMPARISON relation;
   
   // Reverses this relationship.
   // Maintains its equivalence.
   public void invert()
   {
      int temp = i1;
      i1 = i2;
      i2 = temp;
      
      switch(relation)
      {
       case LESS:
         relation = COMPARISON.GREATER;
         break;
       case GREATER:
         relation = COMPARISON.LESS;
         break;
       case EQUAL:
         break;
      }
   }
   
   public String toString()
   {
     String out;
     
     switch(relation)
     {
        case LESS:    out = "<";break;
        case EQUAL:   out = "=";break;
        case GREATER: out = ">";break;
        default: out = "";
     }
     
     //out += i2;
     
     return out;
   }
}

public void populateRelations(int size)
{
  Relation[] tuples = getAllTuples(size);

  shuffle(tuples);

  relations = new Object[size];

  for(int i = 0; i < size; i++)
  {
    relations[i] = (Object)(new LinkedList<Relation>());
  }

  // Give each index comparison sheet half of the possible tuples.
  int n = tuples.length;
  int max_per_bin = size/2; // 11 -> 5 comparisons per sheet.
  for(int i = 0; i < n; i++)
  {
    Relation tuple = tuples[i];
    int bin_index  = tuple.i1;
       
    LinkedList<Relation> Q = (LinkedList<Relation>)relations[bin_index];
    Q.add(tuple);
    
    // Flow the elements through the queues, until we have a stable configuration.
    while(Q.size() > max_per_bin)
    {
      tuple = Q.remove();
      tuple.invert();
      
      bin_index  = tuple.i1;
       
      Q = (LinkedList<Relation>)relations[bin_index];
      Q.add(tuple);      
    }
  }
  
}

Relation[] getAllTuples(int size)
{
  Relation[] tuples = new Relation[n_choose_k(size, 2)];
  
  int index = 0;
  for(int i1 = 0; i1 < size; i1++)
  for(int i2 = i1 + 1; i2 < size; i2++)
  {
    Relation tuple = new Relation();
    tuple.i1 = i1;
    tuple.i2 = i2;
    tuple.relation = COMPARISON.LESS;
    tuples[index] = tuple;
    index++;
  }
  
  return tuples;
}

void shuffle(Relation[] tuples)
{
  int n = tuples.length;
  for(int i = 0; i < n; i++)
  {
    int swap_index = (int)(Math.random()*(n - i));
    
    Relation temp = tuples[i];
    tuples[i]     = tuples[swap_index];
    tuples[swap_index] = temp;
  }
  
  return;
}

void shuffle(int[] tuples)
{
  int n = tuples.length;
  for(int i = 0; i < n; i++)
  {
    int swap_index = (int)(Math.random()*(n - i));
    
    int temp = tuples[i];
    tuples[i]     = tuples[swap_index];
    tuples[swap_index] = temp;
  }
  
  return;
}

// n > 0, k > 0.
int n_choose_k(int n, int k)
{
  int min = Math.min(k, n - k);
  int max = Math.max(k, n - k); 
  
  return fact(max, n)/fact(min);
}

int fact(int n)
{
  int out = 1;
  for(int i = 2; i <= n; i++)
  {
    out *= i;
  }
  
  return out;
}

// Returns the product n1 + 1 * n1 + 2 * ... * n2 , assuming n1 <= n2 (n1, n2]
// fact(0, n) = fact(n) 
int fact(int n1, int n2)
{
  int out = 1;
  for(int i = n1 + 1; i <= n2; i++)
  {
    out *= i;
  }
  
  return out;
}