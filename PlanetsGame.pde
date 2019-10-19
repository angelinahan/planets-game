/*Project 2
 Angelina Han
 May 28, 2019
 */

import processing.sound.*; //imports the Sound library

private ArrayList<Planet> planets; //An ArrayList to hold all planets
private Planet mainPlanet; //the main planet that the user controls
private boolean startScreen; //whether or not to show the start screen
private boolean gameOver; //whether or not the game is over
private PShape planetImage; //custom PShape made from an SVG, used to draw Planets
private PImage starsBg; //background image
private SoundFile collisionNoise; //the sound that is played when a planet absorbs another planet
private float initRadius; //initial radius of the main planet
private int hitCount; //number of smaller planets hit by the main planet
private int secondsPassed; //seconds passed in this round of the game
private int timeOfPreviousRounds; //total milliseconds passed in all rounds of the game since starting the program
//used to restart seconds count to 0 when the game is restarted but the program is not
private int count; //counts how many frames have passed since the last planet was generated
private Button restart = new Button("start over"); //restart button

//initializes variable values the first time the program is run
public void setup() {
  size(1000, 1000); //sets size
  surface.setSize(displayWidth - 2500, displayHeight - 1000); //resizes the window to fit the screen of the device this program is running on
  frameRate(24); //sets the frameRate
  planetImage = loadShape("glowPlanet.svg"); //loads the SVG as a custom PShape
  starsBg = loadImage("stars.jpeg"); //loads the background image
  starsBg.resize(width, height); //resizes the background image to fit the screen
  collisionNoise = new SoundFile(this, "shootingStar.wav"); //loads the collision noise from a .wav file
  timeOfPreviousRounds = 0; //setup is called once when the game has not started yet, therefore there are no previous rounds
  startScreen = true; //set boolean to show start screen at the beginning equal to true
  initValues(); //initializes values of other program variables
}

//draws a new frame 24 times every second
public void draw() {
  background(starsBg); //clears the previous background
  restart.drawButton(100, 70); //draws the restart button
  fill(255);
  textSize(20); //sets text size
  textAlign(CENTER); //sets text alignment
  if (startScreen) { //checks if start screen should be shown
    initValues(); //resets game variables to initial values (useful when user clicks restart while the program is running)
    drawStartScreen(); //draws the start screen with instructions
  } else if (mainPlanet.gameWon()) { //checks if the game as been won
    drawWinScreen(); //draws the win screen
    restart.drawButton(100, 70); //draws the restart button
  } else if (gameOver) { //checks if the game is over (if the user lost)
    drawEndScreen(); //draws the game over screen
    restart.drawButton(100, 70); //draws the restart button
  } else { //else, move planets and check for collisions
    mainPlanet.drawPlanet(); //draws main planet
    if (count%24 == 0) {
      planets.add(new Planet()); //adds a new planet every 24 frames, or 1 second
    }
    moveAndDrawAll(planets); //moves all planets currently in the game (besides main planet)
    checkCollision(); //checks for collisions between main planet and other planets
    count++; //increments count to calculate when to add the next planet
    secondsPassed = (millis() - timeOfPreviousRounds)/1000; //calculates seconds passed since the start of this round of the game
    fill(255); //set text color back to white (previously fill was set to a color when generating a new random Planet)
    textAlign(LEFT); //set text align to left
    text("time passed: " + secondsPassed + " seconds", 50, height - 100); //draws the time passed
    text("planets hit: " + hitCount, 50, height - 50); //draws the hit count
  }
}

//handles key presses for moving the main planet
public void keyPressed() {
  if (key == CODED) { //checks if the input key is coded
    if (keyCode == UP) { //checks for the up arrow
      mainPlanet.moveMainPlanet("UP"); //moves main planet upwards
    } else if (keyCode == DOWN) { //checks for the down arrow
      mainPlanet.moveMainPlanet("DOWN"); //moves main planet downwards
    } else if (keyCode == LEFT) { //checks for the left arrow
      mainPlanet.moveMainPlanet("LEFT"); //moves main planet left
    } else if (keyCode == RIGHT) { //checks for the right arrow
      mainPlanet.moveMainPlanet("RIGHT"); //moves main planet right
    }
  }
}

//handles mouse released events (for pressing start and restart button)
public void mouseReleased() {
  if (startScreen) { //if the game is currently displaying the start screen
    startScreen = !startScreen; //falsify the startScreen boolean, changing the display to the actual game
  }
  if (mouseX >= 40 && mouseX <= 160 && mouseY >=45 && mouseY <= 95) { //if mouse is over the restart button
    startScreen = true; //show start screen
    timeOfPreviousRounds = millis(); //store how many milliseconds have passed so far, to calculate the second count starting back at 0 when the game restarts
  }
}

//handles mouse clicks for changing the color of the main planet
public void mouseClicked() {
  if (this.mainPlanet.mouseOverPlanet(mouseX, mouseY)) { //checks if the mouse is over the main planet
    mainPlanet.colorIndex = (mainPlanet.colorIndex + 1) % 5; //changes the main planet's color to the next color in the ArrayList of colors
  }
}

//initializes variable values to starting values
public void initValues() {
  gameOver = false; //at the beginning, gameOver is false
  hitCount = 0; //planets hit at the beginning
  secondsPassed = 0; //seconds passed at the beginning
  count = 0; //count = 0 at the beginning; updated every frame to determine when to add a new planet
  initRadius = 30.0; //initial radius of main planet
  planets = new ArrayList<Planet>(); //creates an empty ArrayList of planets
  mainPlanet = new Planet(5.0, 5.0, initRadius); //initializes the main planet
}

//moves and draws all planets in the Arraylist of planets
public void moveAndDrawAll(ArrayList<Planet> planets) {
  for (Planet p : planets) { //for each loop running through each planet in the list of planets
    p.move(); //delegates to the move method in the Planet class
    p.drawPlanet(); //delegates to the drawPlanet method in the Planet class
  }
}

//checks for collisions between planets
public void checkCollision() {
  for (Planet p : planets) { //for each loop that runs through each planet in the list of planets
    if (mainPlanet.collided(p) && p.visible) { //checks if there has been a collision with a visible planet
      if (mainPlanet.biggerDiameter(p) && mainPlanet.planetColor.sameColor(p.planetColor)) { //checks if the main planet has a bigger radius and same color as the given planet
        mainPlanet.absorb(p); //if yes, the main planet can absorb the given planet
        p.visible = false; //once absorbed, the given planet is no longer visible
        hitCount++; //increases the hit count
      } else if (p.biggerDiameter(mainPlanet)) { //checks if main planet has been absorbed by a bigger planet
        gameOver = true; //if so, the game is over
      }
    }
  }
}

//draws the start screen with instructions for gameplay
public void drawStartScreen() {
  background(starsBg); //draws the background image
  text("You control a small planet in the depths of outer space."
    + "\n\nYour objective is to increase the size of your planet by hitting smaller planets," 
    + "\nwhile avoiding being pulled into the gravitational field of bigger planets."
    + "\n\nYou can only absorb smaller planets of the same color, but you must avoid colliding with bigger planets of any color."
    + "\n\nClick on your planet to change its color, and use arrow keys to move your planet. \n \nClick anywhere to begin.", width/2, height/2 - 100); //instructions
}

//draws a victory message if you win 
public void drawWinScreen() {
  text("You absorbed all the other planets and took over the universe!" + "\n Planets hit: " + hitCount + "\n Seconds survived: " + secondsPassed, width/2, height/2); //draws the number of hits and seconds passed
}

//draws a game over message if you lose
public void drawEndScreen() {
  text("Game Over! \nYour planet was hit by a bigger planet and obliterated!" + "\n Planets hit: " + hitCount + "\n Seconds survived: " + secondsPassed, width/2, height/2); //draws the number of planets hit and the seconds passed
}
