class Tree {
  float spinAngle = 0;
  float centerX, centerY;
  float[] angles;
  int degree;
  float minAngle, maxAngle;
  float initLength;
  float propDecay;
  float propLevel = 0;
  
  // Construct tree from given parameters
  Tree (float[] centerIn, int degIn, float minAngIn, float maxAngIn, float initLenIn, float propDecayIn) {
    centerX = centerIn[0]; centerY = centerIn[1]; degree = degIn; minAngle = minAngIn;
    maxAngle = maxAngIn; initLength = initLenIn; propDecay = propDecayIn;
    angles = new float[degree];
    for (int i = 0; i < degree; i ++) {
      // The base lines will be spaced at equal angles - same as in UP keypress
      angles[i] = 2*PI/degree*i;
    }
  }
  
  // Starts degree-number of equally spaced branch draws
  void DrawTree(float deltaAngle) {
    spinAngle += deltaAngle;
    pRotate(spinAngle, centerX, centerY);
    for (int i = 0; i < degree; i++) {
      DrawBranch(1, i, centerY);
    }
  }
  
  // Recursively Draws the tree's branches
  void DrawBranch(int depth, int angleIndex, float startY) {
    print(angleIndex);
    // When computing angle, negate mod-degree indexed angles to reflect them across the parent branch
    int flipModifier = 1;
    if (angleIndex >= degree) {
      flipModifier = 2 * (angleIndex % 2) - 1;
    }
    float compAngle = flipModifier * angles[angleIndex];
    float branchLength = initLength / pow(propDecay, depth); // can do without depth ???
    float endY = startY + branchLength;
    pushMatrix();
    pRotate(compAngle, centerX, startY);
    line(centerX, startY, centerX, endY);

    // update angleIndex using magic
    angleIndex = 2 * (angleIndex + 1) + degree - 2;
  
    // Exit if reached the last layer of the array
    if (angleIndex+1 < angles.length) {
      DrawBranch(depth + 1, angleIndex, startY + branchLength / 1.1);
      DrawBranch(depth + 1, angleIndex+1, startY + branchLength / 1.1);
    }
    popMatrix();
  }
  
  // Increase the level of the tree
  void Grow() {
    propLevel += 1;
    for (int i = 0; i < 3*pow(2, propLevel); i++) {
      angles = append(angles, random(minAngle, maxAngle));
    }
  }
  
  // Decrease the level of the tree
  void Shrink() {
    arrayCopy(angles, angles, int(angles.length - 3 * pow(2, propLevel)));
    return;
  }
  
  // Increase the degree of the tree (number of initial branches)
  void DegreeUp() {
    return;
  }
  
  // Decrease the degree of the tree
  void DegreeDown() {
    return;
  }
  
  void PrintAngles() {
    for (int i = 0; i < angles.length; i++) {
      print(angles[i]);
    }
  }
  
  // Rotates coord system around the given point
  void pRotate(float angle, float pCenterX, float pCenterY) {
    translate(pCenterX, pCenterY);
    rotate(angle);
    translate(-1*pCenterX, -1*pCenterY);
  }
  
}
