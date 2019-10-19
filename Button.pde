//represents a Button the user can click
public class Button {
  private String text; //text on this Button
  
  //constructor
  Button(String text) {
    this.text = text; //sets the text field to the given String
  }
  
  //draws this Button
  public void drawButton(int xPos, int yPos) {
    fill(40, 70, 245); //sets the fill color of this Button
    rectMode(CENTER); //sets rectMode
    rect(xPos, yPos, 120, 50, 30); //draws a rectangle at the given xPos, yPos, with rounded edges
    fill(255); //sets text color to white
    textAlign(CENTER); //sets text alignment
    text(text, xPos, yPos + 5); //draws the text at the given coordinates
  }
}
