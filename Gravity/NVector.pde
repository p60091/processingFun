
public class NVector
{
  //In 3-space, v[0] = v_x, v[1] = v_y, and v[2] = v_z.
  private float [] v;
  private int dimension;
  
  public NVector (int dimension)
  {
    v = new float [dimension];
    this.dimension = dimension;
    reset();
  }
  
  public NVector (float x, float y)
  {
    v = new float [2];
    dimension = 2;
    v[0] = x;
    v[1] = y;
  }
  
  public NVector (NVector toCopy)
  {
    this.dimension = toCopy.dimension;
    this.v = new float[dimension];
    
    for (int i = 0; i < dimension; i++)
       v[i] = toCopy.v[i];
  }
  
  public void reset ()
  {
    for (int i = 0; i < v.length; i++)
       v[i] = 0;
  }
  
  public float magnitude ()
  {
    float answer = 0;
    for (int i=0; i < v.length; i++)
      answer = answer + v[i]*v[i];
    return (float) Math.sqrt(answer);
  }
  
  /* For 2- and 3-vectors only */
  public float getX ()
  {
    return v[0];
  }
  
  public float getY()
  {
    return v[1];
  }
  
  public float getZ()
  {
    return v[2];
  }
  
  public void setX (float x)
  {
    this.v[0] = x;
  }
  
  public void setY (float y)
  {
    this.v[1] = y;
  }
  
  public void setZ (float z)
  {
    this.v[2] = z;
  }
  
  public NVector add (NVector w)
  {
    NVector sum = new NVector(dimension);
    
    for (int i = 0; i < v.length; i++)
    {
      sum.v[i] = v[i] + w.v[i];
    }
    return sum;
  }
  
  public NVector subtract (NVector w)
  {
    NVector sum = new NVector(dimension);
    
    for (int i = 0; i < v.length; i++)
      sum.v[i] = v[i] - (w.v[i]);
      
    return sum;
  }
  
  public NVector multiply (float n)
  {
    NVector product = new NVector(dimension);
    
    for (int i = 0; i < v.length; i++)
      product.v[i] = v[i]*n;
      
    return product;
  }
  
  public void multiplyBy (float n)
  {
    
    for (int i = 0; i < v.length; i++)
      v[i] = v[i]*n;
      
  }

  public NVector divide (float n)
  {
    NVector quotient = new NVector(dimension);
    
    for (int i = 0; i < v.length; i++)
      quotient.v[i] = v[i]/n;
      
    return quotient;
  }
  
  public void divideBy (float n)
  {
    
    for (int i = 0; i < v.length; i++)
      v[i] = v[i]/n;
      
  }
      
  public float dotProduct (NVector w)
  {
    float sum = 0;
    
    for (int i = 0; i < v.length; i++)
       sum = sum + v[i]*(w.v[i]);
    
    return sum;
  }
  
  public NVector direction ()
  {
    NVector quotient = new NVector (this);
    
    return quotient.divide(magnitude());
  }
}
