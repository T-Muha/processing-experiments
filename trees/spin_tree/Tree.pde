public class Tree {
  
  public class Branch {
    private Branch[] children = new Branch[0];
    private float x1;
    private float y1;
    private float x2;
    private float y2;
    private float theta;
    private float length;
    
    // third angle parameter for initial branches at fixed angles
    Branch (float x, float y, float angle, float inLength) {
      x1 = x;
      y1 = y;
      theta = angle;
      length = inLength;
      x2 = x1 + length * cos(theta);
      y2 = y1 + length * sin(theta);
    }
    
    void Draw () {
      line(x1, y1, x2, y2);
      if (children.length == 0) {
        return;
      }
      for (int i = 0; i < children.length; i++) {
        children[i].Draw();
      }
    }
    
    void Propagate() {
      if (children.length == 0) {
        float attachX = x1 + length * propDecay * cos(theta);
        float attachY = y1 + length * propDecay * sin(theta);
        children = (Branch[]) append(children, new Branch(attachX, attachY, theta + random(minAngle, maxAngle), length * propDecay));
        children = (Branch[]) append(children, new Branch(attachX, attachY, theta - random(minAngle, maxAngle), length * propDecay));
        return;
      }
      for (int i = 0; i < children.length; i++) {
        children[i].Propagate(); 
      }
    }
    
    void Prune() {
      if (children[0].IsLeaf()) {
        // Garbage collection should clear the leaves since they're now unaccessable
        children = new Branch[0];
      }
    }
    
    boolean IsLeaf() {
      return (children.length == 0);
    }
  }
  
  Branch[] roots;  
  float spinAngle = 0;
  float centerX, centerY;
  float[] branchCoords;
  int degree;
  float minAngle, maxAngle;
  float initLength;
  float propDecay;
  float propLevel = 0;
  
  // Construct tree from parameters
  Tree (float[] centerIn, int degIn, float minAngIn, float maxAngIn, float initLenIn, float propDecayIn) {
    centerX = centerIn[0]; centerY = centerIn[1]; degree = degIn; minAngle = minAngIn;
    maxAngle = maxAngIn; initLength = initLenIn; propDecay = propDecayIn;
    roots = new Branch[degree];
    for (int i = 0; i < degree; i ++) {
      // The base lines will be spaced at equal angles - same as in UP keypress
      float compAngle = 2*PI/degree*i;
      roots[i] = new Branch(centerX, centerY, compAngle, initLength);
    }
  }
  
  void DrawTree(float deltaAngle) {    
    stroke(255);
    spinAngle += deltaAngle;
    pRotate(spinAngle, centerX, centerY);
    for (int i = 0; i < degree; i++) {
      roots[i].Draw();
    }
  }
  
  // Increase the level of the tree
  void Grow() {
    propLevel += 1;
    for (int i = 0; i < roots.length; i++) {
      roots[i].Propagate();
    }
  }
  
  // Decrease the level of the tree
  void Shrink() {
    for (int i = 0; i < roots.length; i++) {
      if (!roots[i].IsLeaf()) {
        roots[i].Prune();
      }
    }
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
  
  // Rotates coord system around the given point
  void pRotate(float angle, float pCenterX, float pCenterY) {
    translate(pCenterX, pCenterY);
    rotate(angle);
    translate(-1*pCenterX, -1*pCenterY);
  }
}
