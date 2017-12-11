//
// Bryce Summer's Spline Class.
//
// Written on 11/29/2016. Transcribed to processing on 10/31/2017
//
// Purpose: Extends the THREE.js spline classes with better features.
/*
//
// Planned:
// 1. Offset Curves.
// 2. Inset Curves.
// 3. Maximum-length interval discretizations for producing renderable line segments.
//
// Currently we are implementing this as a reduction to THREE.CatmullRomCurve3, but we may remove the dependancy if we have time and go sufficiently beyond it.
// FIXME: Sandardize the curve class and instantiate it from interfacial curves.
*/
class Curve
{
    public Spline _spline;
    public ArrayList<PVector> _point_discretization; 
  
    public Curve(Spline spline)
    {
        // A spline that dynamically parameterizes itself to between 0 and 1.
        this._spline = spline;

        // A list of points in the discretization.
        _point_discretization = new ArrayList<PVector>();
    }

    // p : THREE.Vector3.
    public void addPoint(PVector p)
    {
        _spline.addPoint(p);
    }

    public int numPoints()
    {
        return _spline.numPoints();
    }

    public PVector getPointAtIndex(int i)
    {
        return _spline.getPointAtIndex(i);
    }

    public PVector getLastPoint()
    {
        return getPointAtIndex(numPoints() - 1);
    }

    public PVector removeLastPoint()
    {
        return _spline.removeLastPoint();
    }

    public PVector position(float t)
    {
        return _spline.getPoint(t);
    }

    public PVector tangent(float t)
    {
        return _spline.getTangent(t);
    }

    public PVector offset(float t, float amount)
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


    /*
    # Returns a list of points representing this spline.
    # They will be no more than max_length apart.
    # They will be as sparse as is practical. # FIXME: Do some studying of this.
    # See: https://github.com/Bryce-Summers/Bryce-Summers.github.io/blob/master/p5/Physics/Visuals/visual_conservation_of_energy.js
    # This is more efficient than the built in THREE.js version, because it does the binary searches for all of the points at the same time.
    # It may produce up to 2 times as many points though...
    # FIXME: Do an analysis of differnt spline discretization techniques.
    # I believe I will compensate for this algorithms problems, by designing my user interactions such that when they click near the original spline, that is a signal to go back.
    */
    ArrayList<PVector> getDiscretization()
    {
        return _point_discretization;
    }

    void updateDiscretization(float max_length)
    {
        ArrayList<PVector> output = new ArrayList<PVector>();
        PVector p0 = _spline.getPoint(0);
        output.add(p0);

        ArrayList<Float> S = new ArrayList<Float>(); //# Stack.
        S.add(1.0);
        
        float low   = 0;
        PVector p_low = _spline.getPoint(low);

        // The stack stores the right next upper interval.
        // The lower interval starts at 0 and is set to the upper interval
        // every time an interval is less than the max_length, subdivision is terminated.

        // Left to right subdivision loop. Performs a binary search across all intervals.
        while(S.size() != 0)
        {
            float high   = S.remove(S.size() - 1);
            PVector p_high = _spline.getPoint(high);
        
            // Subdivision is sufficient, move on to the next point.
            while(p_low.dist(p_high) > max_length)
            {
                // Otherwise subdivide the interval and keep going.
                S.add(high);
                high   = (low + high)/2.0;
                p_high = _spline.getPoint(high);
            }
        
            output.add(p_high);
            low   = high;
            p_low = p_high;
            continue;
        }

        _point_discretization = output;
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
        S.add(1.0);
        float low = 0;
        PVector p_low = offset(low, amount);

        // The stack stores the right next upper interval.
        // The lower interval starts at 0 and is set to the upper interval.
        // every time an interval is terminated after subdivision is sufficient.

        // Left to right subdivision loop.
        while(S.size() != 0)
        {        
            float high = S.remove(S.size() - 1);
            PVector p_high = offset(high, amount);

            // Subdivision is sufficient, move on to the next point.
            while(p_low.dist(p_high) > max_length)
            {            
                // Otherwise subdivide the interval and keep going.
                S.add(high);
                high = (low + high)/2.0;
                p_high = offset(high, amount);
            }

            output.add(p_high);
            if(times_output != null)
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