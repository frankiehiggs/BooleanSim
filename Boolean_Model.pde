float centreX = 450;
float centreY = 590;
float radius = 390;

//int pointsGenerated = 0;
int numberOfPoints;
//float booleanModelRadius = 50;
float alpha;
//float c = 0;
float booleanModelRadius;

int maxNumberOfPoints = 100000;
float[] xPPP = new float[maxNumberOfPoints];
float[] yPPP = new float[maxNumberOfPoints];

Slider pointsSlider = new Slider(450, 60, "Number of discs, n");
Slider radiusSlider = new Slider(450, 150, "Parameter controlling size of discs, t");
Slider[] sliders = {pointsSlider, radiusSlider};

char mode; // Options are 'f': fixed size, 'c' : coverage regime, 'a': constant total area (percolation regime).
char[] possibleModes = {'f', 'a', 'c'};
String[] buttonLabels = {"r = t", "n r^2 = t", "n r^2 = t log(n)"};
Buttons modeButtons = new Buttons(820, 70, buttonLabels);

Option colourClusters = new Option(50, 950, "Colour clusters separately");

float[] randomPoint() {
  // Returns the x and y coordinates of a random point in the disc.
  // The centre and radius are global variables.
  float r2 = random(1);
  float angle = random(TWO_PI);
  float r = sqrt(r2);
  float[] v = {radius*r*cos(angle)+centreX, radius*r*sin(angle)+centreY};
  return v;
}

void setup() {
  size(900, 1000);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  textAlign(CENTER);
  //noLoop();
  for (int i = 0; i<maxNumberOfPoints; i++) {
    float[] v = randomPoint();
    xPPP[i] = v[0];
    yPPP[i] = v[1];
  }
}

void draw() {
  // Clear screen
  background(200);

  // Setting the parameters using the sliders.
  numberOfPoints = int(pow(10, 2.5*(sliders[0].proportion+1)));
  mode = possibleModes[modeButtons.selectedOption];
  //alpha = sliders[1].proportion + 1;
  if (mode == 'f') {
    alpha = (sliders[1].proportion+1)/20;
    booleanModelRadius = radius*alpha;
  } else if (mode == 'c') {
    alpha = sliders[1].proportion + 1;
    booleanModelRadius = sqrt(alpha)*radius*sqrt((log(numberOfPoints))/numberOfPoints);
  } else if (mode == 'a') {
    alpha = sliders[1].proportion + 1;
    booleanModelRadius = sqrt(alpha)*radius/sqrt(numberOfPoints);
  } else {
    print("The only available options are 'f', 'c' and 'a'. Defaulting to 'f'");
    mode = 'f';
    alpha = 20*(sliders[1].proportion+1);
    booleanModelRadius = alpha;
  }

  //// To control n r^2 log(n) (sparse):
  //booleanModelRadius = alpha*radius/sqrt(numberOfPoints*log(numberOfPoints));

  // The set A:
  noStroke();
  fill(255);
  circle(centreX, centreY, radius);

  // Drawing the balls of the Boolean model (all the locations are chosen in setup() ).
  // We have two cases: (i) colour each cluster separately (based on its size), or (ii) colour every ball in blue.
  if (colourClusters.isSelected) {
    float doubleRadiusSquared = 4*booleanModelRadius*booleanModelRadius;
    int numberOfClusters = 0;
    int[] clusterTags = new int[numberOfPoints];
    int[] clusterSizes = new int[numberOfPoints];
    for (int i=0; i<numberOfPoints; i++) {
      boolean isSingleton = true;
      for (int j=i-1; j>=0; j--) { // Loop through every point before i (which have already been labelled with their clusters). For the first point the condition is never met, so the inside doesn't run.
        float xDistance = xPPP[i] - xPPP[j];
        float yDistance = yPPP[i] - yPPP[j];
        if (xDistance*xDistance + yDistance*yDistance < doubleRadiusSquared) {
          isSingleton = false;
          int currentClusterTag = clusterTags[j];
          clusterTags[i] = currentClusterTag;
          clusterSizes[currentClusterTag] += 1;
          // If point i is in a cluster, it may link two clusters that had previously been separate. So we need to go through all the points which have already been assigned to a cluster and see if they're also linked to point i.
          for (int k=j-1; k>=0; k--) {
            if (clusterTags[k] != currentClusterTag) {
              // We don't need to check things in cluster j -- they already share the same label as point i now.
              xDistance = xPPP[i] - xPPP[k];
              yDistance = yPPP[i] - yPPP[k];
              if (xDistance*xDistance + yDistance*yDistance < doubleRadiusSquared) {
                //clusterSizes[clusterTags[k]] = 0; // Everything in k's cluster will end up merged into j's cluster.
                int mergedTag = clusterTags[k];
                // We need to go through and "get" all of the things which had the same tag as k.
                clusterSizes[mergedTag] = 0;
                for (int l=i-1; l>=0; l--) { // Yes, starts at i-1 not k-1. Otherwise it will miss the non-adjacent things in k's cluster which are numbered later than k.
                  if (clusterTags[l] == mergedTag) {
                    clusterSizes[currentClusterTag] += 1;
                    clusterTags[l] = currentClusterTag;
                  }
                }
              }
            }
          }
          break; // We don't need to check any more values of j, as we've already assigned point i to a cluster and merged older clusters if multiple met in x.
        } // else {continue;}
      }
      if (isSingleton) {
        clusterTags[i] = numberOfClusters;
        clusterSizes[numberOfClusters] = 1;
        numberOfClusters += 1;
      } // else {continue;}
    }
    int maxClusterSize = max(clusterSizes);
    if (maxClusterSize == 1) {
      // All clusters are singletons; everything will be in blue.
      noStroke();
      fill(0, 0, 255);
      for (int i=0; i<numberOfPoints; i++) {
        circle(xPPP[i], yPPP[i], booleanModelRadius);
      }
    } else /* there are non-singleton clusters */ {
      noStroke();
      for (int i=0; i<numberOfPoints; i++) {
        //float redness = 255*(clusterSizes[clusterTags[i]]-1)/(maxClusterSize-1); // Colour by size: largest in red
        float redness = 255*sqrt(sqrt(clusterSizes[clusterTags[i]]))/sqrt(sqrt(numberOfPoints)); // Colour by proportion of points: 100% is red.
        fill(redness, 0, 255-redness);
        circle(xPPP[i], yPPP[i], booleanModelRadius);
      }
    }
  } else /* the user wants to colour all points in blue */ {
    noStroke();
    fill(0, 0, 255);
    for (int i=0; i<numberOfPoints; i++) {
      circle(xPPP[i], yPPP[i], booleanModelRadius);
    }
  }

  // The sliders and buttons:
  for (Slider s : sliders) {
    s.redraw();
  }
  modeButtons.redraw();
  colourClusters.redraw();

  // Readouts.
  fill(0); // Remember that fill() controls text colour.
  textSize(40);
  text(numberOfPoints, 70, 70);
  text(alpha, 70, 160);

  // Animation updates
  //numberOfPoints = int(numberOfPoints*1.01);
}

void mousePressed() {
  for (Slider s : sliders) {
    s.grabbedIfThere();
  }
  loop();
  modeButtons.clickedIfThere();
  colourClusters.clickedIfThere();
}

void mouseReleased() {
  for (Slider s : sliders) {
    s.isGrabbed = false;
  }
  noLoop();
}
