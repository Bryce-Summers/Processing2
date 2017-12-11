/*

Written on Oct.07.2017 by Bryce Summers
Purpose: Creates sets of triangles representing the extent of a path.
*/

class Triangle
{
  // Points.
  PVector p1;
  PVector p2;
  PVector p3;
  
  // Tangents.
  PVector t1;
  PVector t2;
  PVector t3;
  
  float time1;
  float time2;
  float time3;
  
  color path_start;
  color path_end;
  
  // Cached barycentric coordinates for a given pt.
  float bary1;
  float bary2;
  float bary3;
  
  // Standard reference line side tests for pts of triangle in
  // relation to their perpendcularity to opposite lines.
  float test_val1;
  float test_val2;
  float test_val3;
  
  public Triangle(PVector a, PVector b, PVector c, PVector t1, PVector t2, PVector t3)
  {
       p1 = a;
       p2 = b;
       p3 = c;
       
       this.t1 = t1;
       this.t2 = t2;
       this.t3 = t3;
       
       // Reference values for 3 pts, used for scaling results for query points.
       test_val1 = line_side_test(p2, p3, p1);
       test_val2 = line_side_test(p3, p1, p2);
       test_val3 = line_side_test(p1, p2, p3);
  }
  
  void setTimes(float t1, float t2, float t3)
  {
    time1 = t1;
    time2 = t2;
    time3 = t3;
  }
  
  void setColors(color c1, color c2)
  {
    path_start = c1;
    path_end = c2;
  }
  
  boolean containsPt(PVector pt)
  {
    computeBaryCentricCoordinates(pt);
    return 0 <= bary1 && bary1 <= 1 &&
           0 <= bary2 && bary2 <= 1 &&
           0 <= bary3 && bary3 <= 1;
  }
  
  PVector getRandomPoint()
  {
    float per1 = random(0, 1);
    float per2 = random(0, 1.0 - per1);
    float per3 = 1.0 - per1 - per2;
    
    return p1.copy().mult(per1).add(p2.copy().mult(per2)).add(p3.copy().mult(per3));
  }

  // Uses barycentric coordinates to interpolate the tangent at the given pt.
  PVector interpolateTangentAtPt(PVector pt)
  {
    computeBaryCentricCoordinates(pt);
    
    // Compute barycentric coordinates.
    return t1.copy().mult(bary1).add(t2.copy().mult(bary2)).add(t3.copy().mult(bary3));
  }
  
  float interpolateTimeAtPt(PVector pt)
  {
    computeBaryCentricCoordinates(pt);
    
    return time1*bary1 + time2*bary2 + time3*bary3;
  }
  
  color interpolateColorAtPt(PVector pt)
  {
    float time = interpolateTimeAtPt(pt);
    return lerpColor(path_start, path_end, time);
  }
  
  
  // Sets bary1, bary2, and bary3 from pt.
  void computeBaryCentricCoordinates(PVector pt)
  {
       float v1 = line_side_test(p2, p3, pt);
       float v2 = line_side_test(p3, p1, pt);
       float v3 = line_side_test(p1, p2, pt);
       
       bary1 = v1 / test_val1;
       bary2 = v2 / test_val2;
       bary3 = v3 / test_val3;
  }
  
  float line_side_test(PVector p1, PVector p2, PVector c)
  {
    return (p2.x - p1.x)*(c.y - p1.y) - (p2.y - p1.y)*(c.x - p1.x); 
  }
}

class Path_Visual_Factory
{

    public void Path_Visual_Factory()
    {
    }

    public Curve newCurve()
    {
      Spline spline = new Spline();
      return new Curve(spline);
    }

    // Max length is the maximum length per segment.
    // the curve is the spline that defines the center of the path.
    // width is the width of the path.
    // max_length indicates the prescision of the discretization.
    public ArrayList<Triangle> getVisual(float max_length, Curve curve, float width, color start_color, color end_color)
    {
        float offset_amount = width/2;
        curve.updateDiscretization(max_length);

        // -- Compute various lines for the path.
        
        ArrayList<Float>   times_left  = new ArrayList<Float>(); 
        ArrayList<Float>   times_right = new ArrayList<Float>();
        ArrayList<PVector> verts_left  = new ArrayList<PVector>();
        ArrayList<PVector> verts_right = new ArrayList<PVector>();

        verts_left  = curve.getOffsets(max_length,  offset_amount, times_left);
        verts_right = curve.getOffsets(max_length, -offset_amount, times_right);

        // Compute fill, using time lists to determine indices for the faces.
        ArrayList<Triangle> output = getFillTriangles(verts_left, verts_right, times_left, times_right, curve);
        
        for(Triangle tri : output)
        {
          tri.setColors(start_color, end_color);
        }
        
        return output;
    }

    // Creates a list of Fill triangles based on the given boundary descriptions for a path.
    // Due to line curvature, vertices at higher curvature regions will exhibit higher degrees in this polygonalization.
    // Assumes each list of times ends on the same time, the times increase strictly monototically.
    public ArrayList<Triangle> getFillTriangles(ArrayList<PVector> left_verts, ArrayList<PVector> right_verts, ArrayList<Float> times_left, ArrayList<Float> times_right, Curve curve)
    {
      
        ArrayList<Triangle> output = new ArrayList<Triangle>();

        int l_len = left_verts.size();
        int r_len = right_verts.size();

        int l_index = 0;
        int r_index = 0;

        // 1 of the indices is not at the end of the path.
        while(l_index < l_len - 1 || r_index < r_len - 1)
        {
            float left_time  = times_left.get(l_index);
            float right_time = times_right.get(r_index);

            boolean big_left  = false;
            big_left  = left_time  < right_time;

            // Break tie using by comparing the next couple of points.
            if(left_time == right_time)
            {
                big_left  = times_left.get(l_index + 1) < times_right.get(r_index + 1);
            }


            // Determined indexes based on whether the left or right side is leading.
            int i1, i2, i3;
            
            PVector p1, p2, p3;
            float t1, t2, t3;
            //PVector tan1, tan2, tan3;

            // Use 2 left vertices and 1 right vertex.
            if(big_left)
            {
                i1 = l_index;
                i2 = l_index + 1;
                i3 = r_index;
            
                p1 = left_verts.get(i1);
                p2 = left_verts.get(i2);
                p3 = right_verts.get(i3);
                
                t1 = times_left.get(i1);
                t2 = times_left.get(i2);
                t3 = times_right.get(i3);
                
                l_index += 1;
            }
            else // Big right otherwise.
            {
                i1 = r_index;
                i2 = r_index + 1;
                i3 = l_index;
                
                p1 = right_verts.get(i1);
                p2 = right_verts.get(i2);
                p3 = left_verts.get(i3);
                
                t1 = times_right.get(i1);
                t2 = times_right.get(i2);
                t3 = times_left.get(i3);
                
                r_index += 1;
            }
            
            PVector tan1 = curve.tangent(t1);
            PVector tan2 = curve.tangent(t2);
            PVector tan3 = curve.tangent(t3);
            
            Triangle tri = new Triangle(p1, p2, p3, tan1, tan2, tan3);
            tri.setTimes(t1, t2, t3);
            // We use a model to allow collision queries to pipe back to this road object with time domain knowledge.
            output.add(tri);
            continue;
        }

        // THREE.Geometry
        return output;
    }
}