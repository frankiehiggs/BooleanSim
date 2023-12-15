// Class for buttons -- they'll set the scaling relationship between n and r

class Buttons {
  float xPos; // These two give the position of the first box.
  float yPos; // The remaining boxes are generated automatically, based on the size, spacing and number of options.
  String[] labels;
  int numberOfBoxes;
  int selectedOption = 0;
  // Design parameters
  float boxWidth = 50;
  float boxHeight = boxWidth;
  float spacing = 60;
  
  Buttons(float x, float y, String[] l ) {
    xPos = x;
    yPos = y;
    labels = l;
    numberOfBoxes = labels.length;
  }
  
  void redraw() {
    float currentY = yPos;
    for (int i=0;i<numberOfBoxes;i++){
      stroke(0);
      fill(128);
      rect(xPos,currentY,boxWidth,boxHeight);
      // To do: add labels.
      fill(0);
      textSize(20);
      text(labels[i],xPos, currentY-boxHeight/2-spacing/4); 
      currentY += boxHeight + spacing;
    }
    noStroke();
    fill(230);
    rect(xPos, yPos + selectedOption*(spacing+boxHeight),0.75*boxWidth, 0.75*boxHeight);
  }
  
  void clickedIfThere() {
    // If the mouse is in the column containing the buttons, we'll check which (if any) it clicked.
    // If not, then we don't bother checking the y coordinate.
    if (mouseX >= xPos - boxWidth/2 && mouseX <= xPos + boxWidth/2) {
      float currentY = yPos; // Centre of the top box.
      for (int i=0;i<numberOfBoxes;i++){
        if (mouseY >= currentY - boxHeight/2 && mouseY <= currentY + boxHeight/2) {
          selectedOption = i;
          break;
        }
        currentY += spacing + boxHeight;
      }
    }
  }
}
