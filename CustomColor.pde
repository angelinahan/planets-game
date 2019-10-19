//represents an object which holds the rgb values of a color
public class CustomColor {
  private int red;
  private int green;
  private int blue;
  
  //constructor
  CustomColor(int r, int g, int b) {
    this.red = r;
    this.green = g;
    this.blue = b;
  }
  
  //checks if this CustomColor is the same color as the given CustomColor
  public boolean sameColor(CustomColor other) {
    return this.red == other.red //checks the rgb values against each other
    && this.green == other.green //if all values are equal, then the two colors are the same
    && this.blue == other.blue;
  }
}
