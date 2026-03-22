class Fish {
  float scale = 1.0;
  Chain spine;
  color bodyColor;
  color finColor;
  
  //random colors
  float bodyR, bodyG, bodyB, finR, finG, finB;
  float[] bodyWidth;

  // Constructor now accepts a scale to ensure correct initialization
  Fish(PVector origin, float initialScale) {
    
    bodyR = random(0,255);
    bodyG = random(0,255);
    bodyB = random(0,255);
    finR = random(0,255);
    finG = random(0,255);
    finB = random(0,255);
    
    bodyColor = color(bodyR,bodyG,bodyB);
    finColor = color(finR,finG,finB);
    
    this.scale = initialScale; // Set scale FIRST
    recalculateBodyWidths(); // Calculate all sizes based on the correct scale
    spine = new Chain(origin, 12, (int)(64 * scale), PI / 8);
  }

  void recalculateBodyWidths() {
    float[] baseWidths = {68, 81, 84, 83, 77, 64, 51, 38, 32, 19};
    bodyWidth = new float[baseWidths.length];
    for (int i = 0; i < baseWidths.length; i++) {
      bodyWidth[i] = baseWidths[i] * scale;
    }
    if (spine != null) {
      spine.linkSize = (int)(64 * scale);
    }
  }

  void updateBody() {
    for (int i = 1; i < spine.joints.size(); i++) {
      float curAngle = PVector.sub(spine.joints.get(i - 1), spine.joints.get(i)).heading();
      spine.angles.set(i, constrainAngle(curAngle, spine.angles.get(i - 1), spine.angleConstraint));
      spine.joints.set(i, PVector.sub(spine.joints.get(i - 1), PVector.fromAngle(spine.angles.get(i)).setMag(spine.linkSize)));
    }
  }

  void display() {
    strokeWeight(max(1, 4 * scale));
    stroke(255);
    fill(finColor);
    ArrayList<PVector> j = spine.joints;
    ArrayList<Float> a = spine.angles;
    float headToMid1 = relativeAngleDiff(a.get(0), a.get(6));
    float headToMid2 = relativeAngleDiff(a.get(0), a.get(7));
    float headToTail = headToMid1 + relativeAngleDiff(a.get(6), a.get(11));
    pushMatrix();
    translate(getPosX(3, PI / 3, 0), getPosY(3, PI / 3, 0));
    rotate(a.get(2) - PI / 4);
    ellipse(0, 0, 160 * scale, 64 * scale);
    popMatrix();
    pushMatrix();
    translate(getPosX(3, -PI / 3, 0), getPosY(3, -PI / 3, 0));
    rotate(a.get(2) + PI / 4);
    ellipse(0, 0, 160 * scale, 64 * scale);
    popMatrix();
    pushMatrix();
    translate(getPosX(7, PI / 2, 0), getPosY(7, PI / 2, 0));
    rotate(a.get(6) - PI / 4);
    ellipse(0, 0, 96 * scale, 32 * scale);
    popMatrix();
    pushMatrix();
    translate(getPosX(7, -PI / 2, 0), getPosY(7, -PI / 2, 0));
    rotate(a.get(6) + PI / 4);
    ellipse(0, 0, 96 * scale, 32 * scale);
    popMatrix();
    beginShape();
    for (int i = 8; i < 12; i++) {
      float tailWidth = 1.5 * headToTail * (i - 8) * (i - 8) * scale;
      curveVertex(j.get(i).x + cos(a.get(i) - PI / 2) * tailWidth, j.get(i).y + sin(a.get(i) - PI / 2) * tailWidth);
    }
    for (int i = 11; i >= 8; i--) {
      float tailWidth = max(-13 * scale, min(13 * scale, headToTail * 6 * scale));
      curveVertex(j.get(i).x + cos(a.get(i) + PI / 2) * tailWidth, j.get(i).y + sin(a.get(i) + PI / 2) * tailWidth);
    }
    endShape(CLOSE);
    fill(bodyColor);
    beginShape();
    for (int i = 0; i < 10; i++) {
      curveVertex(getPosX(i, PI / 2, 0), getPosY(i, PI / 2, 0));
    }
    curveVertex(getPosX(9, PI, 0), getPosY(9, PI, 0));
    for (int i = 9; i >= 0; i--) {
      curveVertex(getPosX(i, -PI / 2, 0), getPosY(i, -PI / 2, 0));
    }
    curveVertex(getPosX(0, -PI / 6, 0), getPosY(0, -PI / 6, 0));
    curveVertex(getPosX(0, 0, 4 * scale), getPosY(0, 0, 4 * scale));
    curveVertex(getPosX(0, PI / 6, 0), getPosY(0, PI / 6, 0));
    curveVertex(getPosX(0, PI / 2, 0), getPosY(0, PI / 2, 0));
    curveVertex(getPosX(1, PI / 2, 0), getPosY(1, PI / 2, 0));
    curveVertex(getPosX(2, PI / 2, 0), getPosY(2, PI / 2, 0));
    endShape(CLOSE);
    fill(finColor);
    beginShape();
    vertex(j.get(4).x, j.get(4).y);
    bezierVertex(j.get(5).x, j.get(5).y, j.get(6).x, j.get(6).y, j.get(7).x, j.get(7).y);
    bezierVertex(j.get(6).x + cos(a.get(6) + PI / 2) * headToMid2 * 16 * scale, j.get(6).y + sin(a.get(6) + PI / 2) * headToMid2 * 16 * scale, j.get(5).x + cos(a.get(5) + PI / 2) * headToMid1 * 16 * scale, j.get(5).y + sin(a.get(5) + PI / 2) * headToMid1 * 16 * scale, j.get(4).x, j.get(4).y);
    endShape();
    fill(255);
    ellipse(getPosX(0, PI / 2, -18 * scale), getPosY(0, PI / 2, -18 * scale), 24 * scale, 24 * scale);
    ellipse(getPosX(0, -PI / 2, -18 * scale), getPosY(0, -PI / 2, -18 * scale), 24 * scale, 24 * scale);
  }
  float getPosX(int i, float angleOffset, float lengthOffset) {
    return spine.joints.get(i).x + cos(spine.angles.get(i) + angleOffset) * (bodyWidth[i] + lengthOffset);
  }
  float getPosY(int i, float angleOffset, float lengthOffset) {
    return spine.joints.get(i).y + sin(spine.angles.get(i) + angleOffset) * (bodyWidth[i] + lengthOffset);
  }
}
