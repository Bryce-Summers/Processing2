import java.util.ArrayDeque;
import java.util.Queue;

class DistanceRecord
{
  int row_from;
  int col_from;
  
  int row_going;
  int col_going;
  
  DistanceRecord(int r1, int c1, int r2, int c2)
  {
     row_from = r1;
     col_from = c1;
     
     row_going = r2;
     col_going = c2;
  }
  
  double getDist()
  {
    return dist(row_from, col_from, row_going, col_going);
  }
}

class DistanceFunctionProcessor
{
  
  PImage image;
  double[][] distance_values;
  
  // Width and height.
  int cache_w, cache_h;
  
  DistanceFunctionProcessor(PImage image_in)
  {
    this.image = image_in;
  }
  
  void colorUsingDistantFunction(double[][] cache)
  {
    cache_h = cache.length;
    cache_w = cache[0].length;
    
    initializeDistanceValues();
    Queue<DistanceRecord> Q = initializeQ(cache);
    propogateDistancesUsingBFS(Q);
    ColorImage();
  }
  
  // All distances start out unmarked at -1 distance.
  void initializeDistanceValues()
  {
    distance_values = new double[cache_h][cache_w];
    
    for(int row = 0; row < cache_h;  row++)
    for(int col = 0; col < cache_w; col++)
    {
      distance_values[row][col] = -1.0;
    }
  }
  
  Queue<DistanceRecord> initializeQ(double[][] cache)
  {
    Queue<DistanceRecord> Q = new ArrayDeque();
      
    for(int row = 0; row < cache_h;  row++)
    for(int col = 0; col < cache_w; col++)
    {
      double cache_value = cache[row][col];
      
      // We initialize a bfs starting point at every non zero point in the cache.
      if(cache_value > 0.0)
      {
        // Points themselves are 0 distance away form the set.
        distance_values[row][col] = 0.0;
        
        propogateLocation(row, col, Q, row, col);
      }
    }
    
    return Q;
  }
  
  void propogateLocation(int row, int col, Queue<DistanceRecord> Q, int row_from, int col_from)
  {
    Q.add(new DistanceRecord(row_from, col_from, row + 1, col));
    Q.add(new DistanceRecord(row_from, col_from, row - 1, col));
    Q.add(new DistanceRecord(row_from, col_from, row, col - 1));
    Q.add(new DistanceRecord(row_from, col_from, row, col + 1));    
  }
  
  void propogateDistancesUsingBFS(Queue<DistanceRecord> Q)
  {
    while(!Q.isEmpty())
    {
      DistanceRecord rec =  Q.remove();
 
      // Don't process out of bounds.
      if(rec.row_going < 0 || rec.row_going >= cache_h ||
         rec.col_going < 0 || rec.col_going >= cache_w)
      {
        continue;
      }
      
      double old_dist = distance_values[rec.row_going][rec.col_going];
      double new_dist = rec.getDist();
      
      if(old_dist < 0.0 || new_dist < old_dist)
      {
        propogateLocation(rec.row_going, rec.col_going, Q, rec.row_from, rec.col_from);
        distance_values[rec.row_going][rec.col_going] = new_dist;
      }      
    }
  }
  
  void ColorImage()
  {
    for(int row = 0; row < cache_h;  row++)
    for(int col = 0; col < cache_w; col++)
    {
      double val = distance_values[row][col];
      
      if(val > 0.0)
      {
         int index = row*cache_w + col;
         
         // Normalize the value on the distnace domain that we desire.
         val *= 1.0/ DISTANCE_BOUNDARY_LENGTH;
         
         // Put an interpolation curve here!!!

         
         int val_i = 255 - (int)constrain((float)val*255, 0.0, 255.0);
                  
         image.pixels[index] = color(val_i, val_i, val_i, val_i);
      }
    }
    
    image.updatePixels();
  }
}