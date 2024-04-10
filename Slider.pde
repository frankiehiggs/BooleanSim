// Class for sliders -- they adjust the number of points, and the radius.
// We need the position on the screen, the label.
// The slider won't need to hold its own value (number of points, R_n, etc.),
// just the position of the handle, then I can use that in a calculation later.

class Slider {
  // Declare variables
  float proportion = 0; // From -1 to 1, how far along the handle is.
  String name;
  float xPos, yPos;
  float sliderWidth  = 600;
  float sliderHeight =  20;
  float handleWidth  =  50;
  float handleHeight =  40;
  boolean isGrabbed  = false;
  float grabOffset;
  
  // The funny initialisation statement
  Slider( float x, float y, String n ) {
    xPos = x;
    yPos = y;
    name = n;
  }
  
  void redraw() {
    if (isGrabbed) {
      // Adjust the slider if the mouse has grabbed it.
      //float newHandleX = mouseX + grabOffset;
      proportion = min(max(2*(mouseX + grabOffset - xPos)/sliderWidth,-1),1);
    }
    stroke(0);
    fill(0,0,255);
    rect(xPos, yPos, sliderWidth, sliderHeight);
    fill(0,255,255);
    float handleX = xPos + 0.5*proportion*sliderWidth; // x coordinate of the centre of the handle.
    rect(handleX,yPos,handleWidth, handleHeight);
    fill(0);
    textSize(20);
    text(name, xPos, yPos - sliderHeight-10);
  }
  
  void grabbedIfThere() {
    float handleX = xPos + 0.5*proportion*sliderWidth; // x coordinate of centre of the handle
    if ( (mouseX >= handleX - handleWidth/2) && (mouseX <= handleX+handleWidth/2) && (mouseY >= yPos-handleHeight/2) && (mouseY <= yPos+handleHeight/2) ){
            isGrabbed = true;
            grabOffset = handleX - mouseX;
            return;
    } else {
      return;
    }
  }
}
