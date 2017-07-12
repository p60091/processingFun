
public class Body 
{ 
  float mass;
  boolean stationary = false;
  NVector position, velocity, force, acceleration;
  float epsilon;
  float radius;
  float xforce = 0, yforce = 0, zforce = 0;
  float re, ge, be;
  Body [] b;
  int numIterations;
  boolean close = false;
  boolean drawLine = false;
  float zoomScale = 4.0;
  
  Body ()
  {
  }

  Body (NVector position, NVector velocity, float mass, float epsilon, float radius, boolean stationary)
  {
    this.position = position;
    this.velocity = velocity;
    this.mass = mass;
    this.epsilon = epsilon;
    this.radius = radius;
    this.force = new NVector(0.0, 0.0);
    this.stationary = stationary;
    numIterations = 0;
    re = random(100, 100);
    ge = random(100, 140);
    be = random(180, 240);
  }

  NVector getVelocity ()
  {
    return velocity;
  }

  NVector getPosition ()
  {
    return position;
  }

  void setMass(float newMass)
  {
    mass = newMass;
  }

  void resetForces ()
  {
    force.reset();
  }

  void addForce (NVector force)
  {
    this.force = (this.force).add(force);
  }

  NVector getForce ()
  {
    return force;
  }

  void resetVelocity ()
  {
    velocity.reset();
  }

  void drawLines (boolean value)
  {
    drawLine = value;
  }

  void setX (float x)
  {
    this.position.setX(x);
  }

  void setY (float y)
  {
    this.position.setY(y);
  }

  void setZ (float z)
  {
    this.position.setZ(z);
  }

  float getX()
  {
    return this.position.getX();
  }

  float getY()
  {
    return this.position.getY();
  }

  float getZ()
  {
    return this.position.getZ();
  }

  float getMass()
  {
    return mass;
  }

  float getRadius()
  {
    return radius;
  }

  void drawBody ()
  {

    NVector drawPosition = new NVector(position);

    smooth();
    if (drawLine)
    {
      drawCircles = false;
      if (0.04 <= velocity.magnitude() && velocity.magnitude() <= 500)
      {
        //colorMode(RGB, 100, 255, 100);
        //noFill();
        stroke(250 - 50/velocity.magnitude(), 250 - 5.0/velocity.magnitude(), 250 - 0.5/velocity.magnitude(), 40);
        ellipse(drawPosition.getX(), drawPosition.getY(),
                0.1/(velocity.magnitude()*velocity.magnitude()),
                0.1/(velocity.magnitude()*velocity.magnitude()));
      }
    }
    else if (drawCircles)
    {
      //stroke(250);
      fill(250);
      ellipse(drawPosition.getX(), drawPosition.getY(), radius, radius);
    }

  }

  boolean closeToAnother (Body [] b, float maxDist)
  {
    for (int i = 0; i < b.length; i++)
      if (b[i] != this)
        if ((b[i].getPosition().subtract(position)).magnitude() < maxDist)
          return true;
    return false;
  }

  void move()
  {
    if(!this.stationary) {
      numIterations = (numIterations + 1) % 1;
      velocity = velocity.add(force.multiply(epsilon));
      if (velocity.magnitude() > 200.0f)
      {
        velocity.divideBy(velocity.magnitude());
        velocity.multiplyBy(5.0f);
      }
      position = position.add(velocity.multiply(epsilon));
    }
    resetForces();
  }

  void drag(int x, int y)
  {
    this.position.setX(x);
    this.position.setY(y);
    drawBody();
  }
}