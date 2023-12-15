// Class for an option button, such as "colour individual clusters". Will sit at the bottom, can be turned on and off individually.

class Option {
  float xPos; // These two give the position of the box.
  float yPos;
  float boxWidth = 50;
  float boxHeight = boxWidth;
  String label;
  boolean isSelected = false;

  Option(float x, float y, String l) {
    xPos  = x;
    yPos  = y;
    label = l;
  }
  
  void redraw() {
    // Draw box
    stroke(0); 
    fill(128);
    rect(xPos, yPos, boxWidth, boxHeight);
    // Draw label
    fill(0);
    textSize(20);
    text(label, xPos+140, yPos+10);
    if (isSelected) {
      // Draw tick inside
      noStroke();
      fill(230);
      rect(xPos, yPos, 0.75*boxWidth, 0.75*boxHeight);
    }
  }
  
  void clickedIfThere() {
    // Toggle the option if the box is clicked.
    if (mouseX >= xPos - boxWidth/2 && mouseX <= xPos + boxWidth/2) {
      if (mouseY >= yPos - boxHeight/2 && mouseY <= yPos + boxHeight/2) {
        isSelected = !isSelected; // Toggles the value of isSelected.
      }
    }
  }
  
}
