
/*
 Title: "Gravity"
 Author: Frederic Green, 2006
 (with a number of ideas from Daniel Shiffman, at
 <http://www.shiffman.net/itp/classes/nature/week02/>
 Especially the idea of multiplying the force times the
 mass of the object acted upon, which gives more interesting
 behavior. Visualization also partly borrowed from that of
 Mark Roland, <markrolanddesign.com>.)
 
 A program for simulating and visualizing mutually gravitating objects.
 The class for these objects is contained in the class "Body."
 A class for vectors (which allows any number of dimensions) is contained
 in the class "NVector."
 
 There are two modes: Simulation mode (where the objects don't leave
 anything in their tracks), and visualization mode (where the objects
 leave "tracks"). In either mode, drawing can be done in two ways:
 by drawing circles (very simple, not recommended in visualization
 mode) or drawing lines (not so simple, not recommended in simulation mode). 
 The sizes of the circles represent the masses of the bodies. The lines
 are unfilled circles whose intensity and color depend on the speed of
 the objects.
 
 The "v" key toggles between simulation mode and visualization mode.
 
 The "l" key toggles between line mode and drawing nothing. If not
 in line mode, the "c" key toggles between drawing circles and nothing.
 
 A right mouse click stops the simulation. A left mouse click can be
 used to grab and then "drag" an object to any desired location. Its
 velocity is then reset to 0.
 
 In any mode, the constant of gravity can be changed. The "+" key
 adds 0.1, the "-" key subtracts 0.1. The "*" key multiplies it by 2,
 the "/" key divides it by 2.
 
 */
 
 //For exporting to an applet:
 /**
  To use interactive features, click on the applet first:
  <ul>
  <li>up arrow adds a particle</li>
  <li>down arrow deletes one</li>
  <li>'i' re-initializes</li>
  <li>'l' takes you from "circle mode" to "line mode" (hard to see in simulation mode)</li>
  <li>'c' takes you from "line mode" to "circle mode"</li>
  <li>'v' toggles between "visualization mode" and "simulation mode" (the default)</li>
  <li>'/' divides the gravitational constant in half</li>
  <li>'*' multiplies it by 2</li>
  <li>'-' subtracts a little something from it, and '+' adds</li>
  <li>If you're quick, you can grab a particle with the mouse!</li>
  <li>To stop (or start back up) all motion, try ctrl-left-click.</li>
  </ul>
  */


int width, height;
//The objects are collected in the array "b".
ArrayList bodies;
//The constant of gravity is "G".
float G = 0.4;
int previousNumber;
//Various variables for interaction:
int objectdragged;                  //Which Body is being dragged by the mouse.
boolean looping = true;             //Whether or not to loop in "draw()".
boolean drawLines = false;          //To allow drawing "lines" (the "artistic" mode).
boolean drawBackground = false;      //To switch between "simulation" and "art" mode.
boolean drawCircles = true;         //To switch between representing bodies as circles and as lines.

void setup() 
{ 
  width = 800;
  height = 600;
  size(800, 600); 

  ellipseMode(CENTER); 
  background(0);
  bodies  = new ArrayList();
  previousNumber = 3;
  for (int i = 0; i < previousNumber; i++)
    bodies.add(new Body());
  initialize();
} 

void initialize ()
{
  float m;  //Used to record a random mass.

  //To change the number of objects, change the number between square brackets below:
  previousNumber = bodies.size();
  println(previousNumber);
  bodies = new ArrayList();
  for (int i = 0; i < previousNumber; i++)
    //Create the objects:
  {
    m = random(4, 16);
    bodies.add(new Body(new NVector(random(.2*width,.8*width),     //Random x coord.
    random(.2*height,.8*height)),  //Random y coord.
    new NVector(0.0, 0.0),                     //Initial velocity (0 for now).
    m,                                         //Random mass.
    1.0,                                       //Time step = 1
    m,                                          //Radius of circle equal to mass
    false
    ));
  }

  //noFill();

}


void draw() 
{ 

  if (drawBackground)
    background(0);

  //noFill();

  determineForces();

  for (int i = 0; i < bodies.size(); i++)
  {
    ((Body)bodies.get(i)).move();
  }

} 

void determineForces()
{
  float deltaX, deltaY, distance, origdistance, xdirection, ydirection;
  NVector force = new NVector(0.0, 0.0);
  float forceMagnitude = 0;

  for (int i=0; i < bodies.size(); i++)
  {
    for (int j = 0; j < bodies.size(); j++)
    {
      if (i != j) {
        deltaX = (((Body)bodies.get(j)).getX() - ((Body)bodies.get(i)).getX());
        deltaY = (((Body)bodies.get(j)).getY() - ((Body)bodies.get(i)).getY());
        distance = (float)Math.sqrt(deltaX*deltaX + deltaY*deltaY);
        origdistance = distance;
        xdirection = deltaX/distance;
        ydirection = deltaY/distance;
        distance = constrain(distance,20.0f,100.0f);
        if (drawLines)
        {
          ((Body)bodies.get(i)).drawLines(true);
        }
        else
          ((Body)bodies.get(i)).drawLines(false);

        //Okay, okay, this isn't really gravity. I've added an exponentially increasing
        //attractive force to encourage bound states when objects get really close together:
        forceMagnitude = (float)Math.exp(10.0/distance)*G/((distance)*(distance));

        force.setX(xdirection);
        force.setY(ydirection);

        //Also, in real gravity the factor b[i].getMass() wouldn't be here.
        //(Remember Galileo: The acceleration of a mass in a gravitational field
        // does not depend on its mass!)
        force.multiplyBy(forceMagnitude*((Body)bodies.get(i)).getMass()*(((Body)bodies.get(j)).getMass()));

        ((Body)bodies.get(i)).addForce(force);

      }
    }
    //We know the forces on ONE body. We can draw it:
    ((Body)bodies.get(i)).drawBody();

  }
}

void mousePressed ()
{
  if (mouseButton == RIGHT)
  {
    if (looping)
    {
      looping = false;
      noLoop();
    }
    else
    {
      looping = true;
      loop();
    }
  }
  else if (mouseButton == LEFT)
  {
    for (int i = 0; i < bodies.size(); i++)
      if (((Body)bodies.get(i)).getX()-((Body)bodies.get(i)).getRadius() < mouseX && mouseX < ((Body)bodies.get(i)).getX()+((Body)bodies.get(i)).getRadius() &&
        ((Body)bodies.get(i)).getY()-((Body)bodies.get(i)).getRadius() < mouseY && mouseY < ((Body)bodies.get(i)).getY()+((Body)bodies.get(i)).getRadius())
      {
        objectdragged = i;
        return;
      }
    objectdragged = -1;
  }
}

void mouseDragged ()
{
  if (objectdragged >= 0)
  {
    ((Body)bodies.get(objectdragged)).drag(mouseX, mouseY);
    ((Body)bodies.get(objectdragged)).resetVelocity();
  }
}

void keyPressed ()
{
  if (key == '+')
    G += 0.1;
  else if (key == '-')
    if (G > 0.1)
      G = constrain(G - 0.1, 0.1, 2000);
    else if (G > 0.01)
      G = constrain(G - 0.01, 0.01, 2000);  
    else
      G /= 2.0;   
  else if (key == '*')
    G *= 2.0;
  else if (key == '/')
    G /= 2.0;
  System.out.println("G = " + G);

  if (key == 'c' && drawCircles && !drawLines)
  {
    drawCircles = false;
    //noFill();
  }
  else if (key == 'c' && !drawLines)
  {
    drawCircles = true;
    //fill(250);
  }

  if (key == 'l' && drawLines)
    drawLines = false;
  else if (key == 'l')
  {
    drawLines = true;
    drawCircles = false;
    noFill();
  }

  if (key == 'i')
    initialize();

  if (key == 'v' && drawBackground)
    drawBackground = false;
  else if (key == 'v')
    drawBackground = true;
    
  if (keyCode == UP)
  {
    float m = random(4, 16);
    bodies.add(new Body(new NVector(random(.2*width,.8*width),     //Random x coord.
    random(.2*height,.8*height)),  //Random y coord.
    new NVector(0.0, 0.0),                     //Initial velocity (0 for now).
    m,                                         //Random mass.
    1.0,                                       //Time step = 1
    m,                                         //Radius of circle equal to mass
    false ));
  }
  
  if (keyCode == LEFT)
  {
    float m = random(4, 16);
    bodies.add(new Body(new NVector(random(.2*width,.8*width),     //Random x coord.
    random(.2*height,.8*height)),  //Random y coord.
    new NVector(0.0, 0.0),                     //Initial velocity (0 for now).
    m,                                         //Random mass.
    1.0,                                       //Time step = 1
    m,                                         //Radius of circle equal to mass
    true ));
  }
  if (keyCode == DOWN)
    bodies.remove(bodies.size() - 1);

}