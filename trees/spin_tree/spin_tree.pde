// Configuration Values
float lineLength = 500;
float lineCenterX = 750;
float lineCenterY = 500;
float deltaAngle = PI / 256;
float propagationDecay = 1.5;
float minAngle = 0.1*PI;
float maxAngle = 0.3*PI;

// Initial Values
float lineAngle = 0;
int propagationLevel = 0;
float[] propagationAngles = new float[0];

void setup() {
  size(1500, 1000, P2D);
}

// Recursive function that draws child lines
// angleIndex - index of the current child's angle in propogationAngles
void propagateLine(float parentAngle, int depth, int angleIndex, float startX, float startY) {
  // When computing angle, negate even-indexed angles to reflect them across the parent branch
  float compAngle = (2 * (angleIndex % 2) - 1) * propagationAngles[angleIndex] + parentAngle;
  float childLength = lineLength / pow(propagationDecay, depth);
  float endX = startX + childLength * cos(compAngle);
  float endY = startY + childLength * sin(compAngle);
  float midX = startX + childLength * cos(compAngle) / 2;
  float midY = startY + childLength * sin(compAngle) / 2;
  line(startX, startY, endX, endY);
  
  // update angleIndex using magic
  angleIndex = 2 * (angleIndex + 1);
  
  // Exit if reached the last layer of the array
  if (pow(2, depth+1) > propagationAngles.length) {
    return;
  }
  else {
    propagateLine(compAngle, depth + 1, angleIndex, midX, midY);
    propagateLine(compAngle, depth + 1, angleIndex+1, midX, midY);
  }
  
}

void draw() {
  background(0, 0, 0);
  lineAngle -= deltaAngle;
  float offsetX = lineLength / 2 * cos(lineAngle);
  float offsetY = lineLength / 2 * sin(lineAngle);
  float x1 = lineCenterX - offsetX;
  float y1 = lineCenterY - offsetY;
  float x2 = lineCenterX + offsetX;
  float y2 = lineCenterY + offsetY;
  stroke(255);
  //line(x1, y1, x2, y2);
  
  if (propagationLevel != 0) {
    // Begin recursively drawing child lines from the main rotating line  
    propagateLine(lineAngle, 1, 0, lineCenterX-offsetX/2, lineCenterY-offsetY/2);
    //propagateLine(lineAngle, 1, 1, lineCenterX+offsetX/2, lineCenterY+offsetY/2);
  }
}

// Handler for key presses
void keyPressed() { 
  if (key == CODED) { 
    if (keyCode == RIGHT) {
      propagationLevel += 1;
      for (int i = 0; i < pow(2, propagationLevel); i++) {
        propagationAngles = append(propagationAngles, random(minAngle, maxAngle));
      }
    }
    else if (keyCode == LEFT) {
      // propagationAngles = propagationAngles[0:propagationAngles.length - pow(2, propagationLevel)];
      return;
    }
  }
  if (key == ' ') {
    return;
  }
}