//  TODO:  Improve angle storage access; right now it is not possible for growth to be irregular
//         Use Rotate, PushMatrix, and PopMatrix to rotate the tree - make sure to reduce drawing overhead as well  
//
//  Fixes: Correctly repopulate angle matrix on degree increase
//
//  Minor Improvements: Eliminate depth from DrawBranch - would it perform better/worse?
//       
//  IDEAS:  make it so when the propagation level is increased, there is only a chance that a branch will grow out of each existing one
//          this makes the tree look much more organic since it will grow more in certain branches than others
//
//          then make it so the lines draw/pulse outwards, so only a layer of lines is visible at once

// Configuration Values
int treeDegree = 3;
float initLength = 500;
float centerX = 750;
float centerY = 500;
float deltaAngle = PI / 256;
float propDecay = 1.3;
float minAngle = 0.1*PI;
float maxAngle = 0.3*PI;

// Initial Values
float centerAngle = 0;
int propagationLevel = 0;
float[] propagationAngles = new float[treeDegree];

Tree mainTree = new Tree(treeDegree, minAngle, maxAngle, initLength, propDecay); 

void setup() {
  size(1500, 1000, P2D);
}

void draw() {
  background(0, 0, 0);
  centerAngle -= deltaAngle;
  stroke(255);
  mainTree.StartDraw(centerAngle, centerX, centerY);
}

// Handler for key presses
void keyPressed() { 
  if (key == CODED) { 
    if (keyCode == RIGHT) {
      mainTree.Grow();      
    } else if (keyCode == LEFT) {
      // propagationAngles = propagationAngles[0:propagationAngles.length - pow(2, propagationLevel)];
      return;
    } else if (keyCode == UP) {
      treeDegree += 1;
      propagationAngles = new float[treeDegree];
      for (int i = 0; i < treeDegree; i ++) {
        // The base lines will be spaced at equal angles
        propagationAngles[i] = 2*PI/treeDegree*i;
      }
      return;
    }
  }
  if (key == ' ') {
    return;
  }
}
