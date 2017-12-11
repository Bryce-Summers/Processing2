/*Bryce Summer's Cubic Spline Class.

  Written on 2 - 28 - 2017

  Purpose: This class implements Hermite Interpolation to determine a cubic polynomial.
           The cubic polynomial may then be converted into Bezier pts and control points.
*/
// Returns a new Hermite Curve constructed from the given set of cubic bezier control points.
public Hermite_Curve newFromBezier(PVector c0, PVector c1, PVector c2, PVector c3)
{
   // Conversion from Bezier control points to Hermite pt, tangent form.
   PVector pt1 = c0;
   PVector pt2 = c3;

   PVector tan1 = c1.copy().sub(c0).mult(3); // 3 = cubic degree.
   PVector tan2 = c3.copy().sub(c2).mult(3);
   
   return new Hermite_Curve(pt1, tan1, pt2, tan2, false);
}

class Hermite_Curve
{

    PVector _A, _B, _C, _D;
  
    // Input_coefs signals that the values should be interpreted as coeficients of a cubic polynomial,
    // rather than points and tangents. 
    public Hermite_Curve(PVector pt1, PVector tan1, PVector pt2, PVector tan2, boolean input_coefs)
    {
      
        // Optional boolean may be used to set inputs to A, B, C, D
        if(input_coefs)
        {
            _A = pt1.copy();
            _B = tan1.copy();
            _C = pt2.copy();
            _D = tan2.copy();
            return;
        }

        // otherwise use point, tangent input convention.

        // Compute the Coefficients of the Cubic Polynomial.
        _A = pt1.copy().mult( 2).sub(pt2.copy().mult(2)).add(tan1).add(tan2);
        _B = pt1.copy().mult(-3).add(pt2.copy().mult(3)).sub(tan1.copy().mult(2)).sub(tan2);
        _C = tan1.copy();
        _D = pt1.copy();
    }

    // Returns a list containing the pts and tangents that represent this curve.
    // [pt1, tan1, pt2, tan2]
    ArrayList<PVector> toPointsAndTangents()
    {
      ArrayList<PVector> output = new ArrayList<PVector>();
      output.add(position(0));
      output.add(tangent(0));
      output.add(position(1));
      output.add(tangent(1));
      return output;
    }

    ArrayList<PVector> toBezierControlPoints()
    {
        ArrayList<PVector> output = new ArrayList<PVector>();
        // 1/3 scaling for hermite to Bezier conversion.
        float scale = 1.0/3.0;
        ArrayList<PVector> ptsAndTangents = toPointsAndTangents();
        PVector pt1  = ptsAndTangents.get(0);
        PVector tan1 = ptsAndTangents.get(1);
        PVector pt2  = ptsAndTangents.get(2);
        PVector tan2 = ptsAndTangents.get(3);

        PVector c0 = pt1;
        PVector c1 = pt1.add(tan1.mult(scale));
        PVector c2 = pt2.sub(tan2.mult(scale));
        PVector c3 = pt2;

        output.add(c0);
        output.add(c1);
        output.add(c2);
        output.add(c3);

        return output;
    }

    // Returns a Bezier Curve representing this curve from the earliest time bound to the latest time bound.
    Hermite_Curve subCurve(float t1, float t2)
    {

        // x in [0, 1]
        // Original curve f(x) = Ax^3 + Bx^2 + Cx + D
        // Sub curve g(x) = f(lerp(t1, t2, x))
        // g(x) = A[-t1^3 + t2^3 - 3t1*t2^2 + 3t1^2*t2] x^3 +
        //        A[        t1^3 + 3t1*t2^2 - 6t1^2*t2] x^2 +
        //        B[              t1^2 + t2^2 - 2t1*t2] x^2 +
        //        A[-3t1^3 + 3t1^2*t2] x   + 
        //        B[  -2t1^2 + 2t1*t2] x   +
        //        C[          t2 - t1] x   +
        //        A[t1^3] +
        //        B[t1^2] +
        //        C[t1] +
        //        D

        float t1_2 = t1*t1;
        float t1_3 = t1*t1*t1;
        float t2_2 = t2*t2;
        float t2_3 = t2*t2*t2;

        // A
        float scale_a = -t1_3 + t2_3 - 3*t1*t2_2 + 3*t1_2*t2;
        PVector A_new = _A.copy().mult(scale_a);

        // B
        scale_a = 3*t1_3 + 3*t1*t2_2 - 6*t1_2*t2;
        float scale_b = t1_2 + t2_2 - 2*t1*t2;
        PVector B_new = _A.copy().mult(scale_a).add(_B.mult(scale_b));

        // C
        scale_a = -3*t1_3 + 3*t1_2*t2;
        scale_b = -2*t1_2 + 2*t1*t2;
        float scale_c = t2 - t1;
        PVector C_new = _A.copy().mult(scale_a).add(_B.copy().mult(scale_b)).add(_C.copy().mult(scale_c));

        // D
        scale_a = t1_3;
        scale_b = t1_2;
        scale_c = t1;
        float scale_d = 1;
        PVector D_new = _A.copy().mult(scale_a).add(_B.copy().mult(scale_b)).add(_C.copy().mult(scale_c)).add(_D);

        Hermite_Curve output = new Hermite_Curve(A_new, B_new, C_new, D_new, true);

        return output;
    }

    // At^3 + Bt^2 + Ct + D
    // ((At + B)t + C)t + D
    PVector position(float t)
    {
        return _A.copy().mult(t).add(_B).mult(t).add(_C).mult(t).add(_D);
    }

    // 3At^2 + 2Bt + C
    PVector tangent(float t)
    {
        return _A.copy().mult(3*t).add(_B.copy().mult(2)).mult(t).add(_C);
    }

    PVector offset(float t, float amount)
    {
        PVector tan = tangent(t);
        tan.setMag(amount);
        
        // Perpendicularlize the vector.
        float x = tan.x;
        float y = tan.y;
        tan.x =  y;
        tan.y = -x;
        
        return position(t).add(tan);
    }

    // Returns a list of points representing this spline.
    // They will be no more than max_length apart.
    // They will be as sparse as is practical. # FIXME: Do some studying of this.
    // See: https://github.com/Bryce-Summers/Bryce-Summers.github.io/blob/master/p5/Physics/Visuals/visual_conservation_of_energy.js
    // This is more efficient than the built in THREE.js version, because it does the binary searches for all of the points at the same time.
    // It may produce up to 2 times as many points though...
    // FIXME: Do an analysis of differnt spline discretization techniques.
    // I believe I will compensate for this algorithms problems, by designing my user interactions such that when they click near the original spline, that is a signal to go back.
    ArrayList<PVector> toPolyline(float max_length_per_segment, ArrayList<Float> times_output)
    {
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector p0 = position(0);
        output.add(p0);
        if (times_output != null)
        {
          times_output.add(0.0f);
        }

        ArrayList<Float> S = new ArrayList<Float>(); // Stack.
        S.add(1.0f);
        
        float   low   = 0;
        PVector p_low = position(low);

        // The stack stores the right next upper interval.
        // The lower interval starts at 0 and is set to the upper interval
        // every time an interval is less than the max_length, subdivision is terminated.

        // Left to right subdivision loop. Performs a binary search across all intervals.
        while(S.size() != 0)
        {        
            float high   = S.remove(S.size() - 1);
            PVector p_high = position(high);
        
            // Subdivision is sufficient, move on to the next point.
            while(PVector.dist(p_low, p_high) > max_length_per_segment)
            {
                // Otherwise subdivide the interval and keep going.
                S.add(high);
                high   = (low + high)/2.0f;
                p_high = position(high);
            }
        
            output.add(p_high);
            if(times_output != null)
            {
              times_output.add(high);
            }
            
            low   = high;
            p_low = p_high;
            continue;
        }

        //return new BDS.Polyline(false, output)
        return output;
    }

    // max_length:float, maximum length out output segment.
    // amount: the distance the offset curve is away from the main curve. positive or negative is fine.
    // time_output (optional) will be populated with the times for the output points.
    ArrayList<PVector> getOffsets(float max_length, float amount, ArrayList<Float> times_output)
    {
        PVector o0 = offset(0, amount);
        ArrayList<PVector> output = new ArrayList<PVector>();
        output.add(o0);
        if (times_output != null)
        {
          times_output.add(0.0f);
        }

        ArrayList<Float> S = new ArrayList<Float>(); // Stack.
        S.add(1.0f);
        float low = 0;
        PVector p_low = offset(low, amount);

        // The stack stores the right next upper interval.
        // The lower interval starts at 0 and is set to the upper interval.
        // every time an interval is terminated after subdivision is sufficient.

        // Left to right subdivision loop.
        while(S.size() != 0)
        {        
            float high   = S.remove(S.size() - 1);
            PVector p_high = offset(high, amount);

            // Subdivision is sufficient, move on to the next point.
            while(PVector.dist(p_low, p_high) > max_length)
            {
                // Otherwise subdivide the interval and keep going.
                S.add(high);
                high   = (low + high)/2.0;
                p_high = offset(high, amount);
            }
            
            output.add(p_high);
            if (times_output != null)
            {
              times_output.add(high);
            }
            low = high;
            p_low = p_high;
            continue;
        }
        
        return output;
    }
}