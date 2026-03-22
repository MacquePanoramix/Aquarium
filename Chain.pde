class Chain {
  ArrayList<PVector> joints;
  int linkSize;
  ArrayList<Float> angles;
  float angleConstraint;
  Chain(PVector origin, int jointCount, int linkSize, float angleConstraint) {
    this.linkSize = linkSize;
    this.angleConstraint = angleConstraint;
    joints = new ArrayList<PVector>();
    angles = new ArrayList<Float>();
    joints.add(origin.copy());
    angles.add(0f);
    for (int i = 1; i < jointCount; i++) {
      joints.add(PVector.add(joints.get(i - 1), new PVector(0, this.linkSize)));
      angles.add(0f);
    }
  }
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ HELPER FUNCTIONS ~ ~ ~ ~ ~ ~ ~ ~ ~
// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

float constrainAngle(float angle, float anchor, float constraint) {
  if (abs(relativeAngleDiff(angle, anchor)) <= constraint) {
    return simplifyAngle(angle);
  }
  if (relativeAngleDiff(angle, anchor) > constraint) {
    return simplifyAngle(anchor - constraint);
  }
  return simplifyAngle(anchor + constraint);
}

float relativeAngleDiff(float angle, float anchor) {
  angle = simplifyAngle(angle + PI - anchor);
  anchor = PI;
  return anchor - angle;
}

float simplifyAngle(float angle) {
  while (angle >= TWO_PI) {
    angle -= TWO_PI;
  }
  while (angle < 0) {
    angle += TWO_PI;
  }
  return angle;
}
