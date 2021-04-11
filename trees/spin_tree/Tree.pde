class Tree {
  float[] angles;
  int degree;
  float minAngle, maxAngle;
  float initLength;
  float propDecay;
  float propLevel = 0;
  
  // Construct tree from given parameters
  Tree (int degIn, float minAngIn, float maxAngIn, float initLenIn, float propDecayIn) {
    degree = degIn; minAngle = minAngIn; maxAngle = maxAngIn; initLength = initLenIn; propDecay = propDecayIn;
    angles = new float[degree];
    for (int i = 0; i < degree; i ++) {
      // The base lines will be spaced at equal angles - same as in UP keypress
      angles[i] = 2*PI/degree*i;
    }
  }
  
  // Starts degree-number of equally spaced branch draws
  void StartDraw(float centerAngle, float centerX, float centerY) {
    for (int i = 0; i < degree; i++) {
      DrawBranch(centerAngle, 1, i, centerX, centerY);
    }
  }
  
  // Recursively Draws the tree's branches
  void DrawBranch(float parentAngle, int depth, int angleIndex, float startX, float startY) {
    // When computing angle, negate mod-degree indexed angles to reflect them across the parent branch
    int flipModifier = 1;
    if (angleIndex >= degree) {
      flipModifier = 2 * (angleIndex % 2) - 1;
    }
    float compAngle = flipModifier * angles[angleIndex] + parentAngle;
    float childLength = initLength / pow(propDecay, depth);                          // can do without depth??
    float endX = startX + childLength * cos(compAngle);
    float endY = startY + childLength * sin(compAngle);
    float midX = startX + childLength * cos(compAngle) / 2;
    float midY = startY + childLength * sin(compAngle) / 2;
    line(startX, startY, endX, endY);

    // update angleIndex using magic
    angleIndex = 2 * (angleIndex + 1) + degree - 2;
  
    // Exit if reached the last layer of the array
    if (angleIndex+1 < angles.length) {
      DrawBranch(compAngle, depth + 1, angleIndex, midX, midY);
      DrawBranch(compAngle, depth + 1, angleIndex+1, midX, midY);
    }
  }
  
  // Increase the level of the tree
  void Grow() {
    propLevel += 1;
    for (int i = 0; i < pow(degree, propLevel); i++) {
      angles = append(angles, random(minAngle, maxAngle));
    }
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
  
}
