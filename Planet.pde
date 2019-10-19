//represents a Planet which is drawn using a custom PShape
public class Planet {
  private float xPos; //this Planet's x position
  private float yPos; //this Planet's y position
  private float xVelo; //this Planet's x velocity
  private float yVelo; //this Planet's y velocity
  private float diameter; //this Planet's diameter
  private boolean visible; //whether or not this Planet is visible onscreen
  private ArrayList<CustomColor> colors; //ArrayList of all possible Planet colors
  private int colorIndex; //this Planet's color as an index in the ArrayList of colors
  private CustomColor planetColor; //this Planet's color as a CustomColor

  //constructor for random planets
  Planet() {
    this.diameter = random(initRadius - 10.0, mainPlanet.diameter + 20.0); //random diameter within a range
    this.xVelo = random(-5.0, 5.0); //random x velocity within a range
    this.yVelo = random(this.diameter / 6, this.diameter / 4); //random y velocity within a range, relating to the diameter of this Planet, so that bigger planets move faster
    this.xPos = random(width); //initial x position is somewhere along the width of the window
    this.yPos = -this.diameter; //initial y position is off the screen to create a smooth movement of the planet onto the screen
    this.visible = true; //initially, all planets are visible
    this.initColors(); //initializes the ArrayList of colors
    this.colorIndex = (int)random(4.9); //randomly chooses a color for this Planet
    this.planetColor = colors.get(colorIndex); //gets the chosen color from the ArrayList
  }

  //constructor for the main planet that the user can control
  Planet(float xVelo, float yVelo, float diameter) {
    this.xPos = width / 2; //initial position is at the middle of the screen
    this.yPos = height / 2;
    this.xVelo = xVelo; //velocity is set to the given values
    this.yVelo = yVelo;
    this.diameter = diameter; //diameter is set to the given value
    this.visible = true; //this planet is visible
    this.initColors(); //initializes the ArrayList of colors
    this.colorIndex = (int)random(4.9); //randomly assigns a color to this Planet
    this.planetColor = colors.get(colorIndex); //gets the chosen color from the ArrayList
  }
  
  //initializes the ArrayList of possible Planet colors
  public void initColors() {
    colors = new ArrayList<CustomColor>(); //creates an empty ArrayList for CustomColors
    CustomColor orange = new CustomColor(242, 100, 25); //creates five different CustomColors
    CustomColor yellow = new CustomColor(246, 174, 45);
    CustomColor green = new CustomColor(117, 142, 79);
    CustomColor skyBlue = new CustomColor(134, 187, 216);
    CustomColor darkBlue = new CustomColor(51, 101, 138);
    colors.add(orange); //adds the colors to the ArrayList
    colors.add(yellow);
    colors.add(green);
    colors.add(skyBlue);
    colors.add(darkBlue);
  }

  //moves this Planet by its velocity
  public void move() {
    this.xPos+=this.xVelo; //adds the xVelocity to the xPosition, same for yPos and YVelo
    this.yPos+=this.yVelo;
  }

  //moves the main planet depending on the key input received
  public void moveMainPlanet(String direction) {
    if (direction.equals("UP")) { //checks the direction of the key input
      this.yPos = Math.max(this.yPos - this.yVelo, 0); //moves the specified direction, while preventing the main planet from going completely offscreen
    } else if (direction.equals("DOWN")) {
      this.yPos = Math.min(this.yPos + this.yVelo, height); 
    } else if (direction.equals("LEFT")) {
      this.xPos = Math.max(this.xPos - this.xVelo, 0);
    } else if (direction.equals("RIGHT")) {
      this.xPos = Math.min(this.xPos + this.xVelo, width);
    }
  }

  //draws this Planet
  public void drawPlanet() {
    if (this.visible) { //checks if this Planet is visible
      shapeMode(CENTER); //sets the shape mode to draw from the center of the shape
      planetImage.disableStyle(); //disables the style of the PShape planetImage
      this.planetColor = colors.get(colorIndex); //updates the color of this Planet
      fill(this.planetColor.red, this.planetColor.green, this.planetColor.blue); //sets the fill to this Planet's color
      noStroke(); //turns off stroke
      shape(planetImage, this.xPos, this.yPos, this.diameter, this.diameter); //draws the planet as a PShape with the specified fill color
    }
  }

  //checks if this Planet has collided with the given Planet
  public boolean collided(Planet other) {
    return sq(this.xPos - other.xPos) + sq(this.yPos - other.yPos) <= sq(this.diameter/3  + other.diameter/3); 
    //because each Planet has a light glow around its edge, the collision is more visually accurate when comparing the sides to diameter/3 rather than diameter/2, which is mathematically correct
  }

  //checks if this Plannet has a bigger diameter than the given Planet
  public boolean biggerDiameter(Planet other) {
    return this.diameter > other.diameter;
  }

  //'absorbs' the given Planet into this Planet
  public void absorb(Planet other) {
    this.diameter+=other.diameter; //adds the given Planet's diameter to this Planet's diameter
    this.xVelo+=Math.abs(other.xVelo); //adds the given Planet's xVelo to this Planet's xVelo
    this.yVelo+=other.yVelo; //adds the given Planet's yVelo to this Planet's yVelo
    collisionNoise.amp(0.1); //sets volume level of the collision noise
    collisionNoise.play(); //plays collision noise
  }

  //checks if the mouse is over this Planet, given the mouseX and mouse Y positions
  public boolean mouseOverPlanet(int mouseX, int mouseY) {
    return Math.abs(mouseX - xPos) <= this.diameter && Math.abs(mouseY - yPos) <= this.diameter;
  }

  //checks if the user has won the game
  public boolean gameWon() {
    return this.diameter > 2 * width && this.diameter > 2 * height; //returns true if the diameter of the main planet is bigger than the screen
  }
}
