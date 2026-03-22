// This class manages a single strand of seaweed.
class Segments {
  MSDS[] msds;
  PVector position;
  float segmentLength;
  float maxWidth;

  Segments(int numOfSegments, float springConstant, float damping, float massStemSegment, float segmentLength, float maxWidth, PVector position) {
    this.position = position;
    this.segmentLength = segmentLength;
    this.maxWidth = maxWidth;
    msds = new MSDS[numOfSegments];
    float noiseSeed = random(1000);
    for (int i = 0; i < numOfSegments; i++) {
      float restAngle = (noise(i * 0.4 + noiseSeed) - 0.5) * 0.5;
      msds[i] = new MSDS(massStemSegment, springConstant, damping, restAngle);
    }
  }

  void render() {
    pushMatrix();
    translate(position.x, position.y);
    for (int i = 0; i < msds.length; i++) {
      if (i == 0) {
        msds[i].update(0, msds[i+1].force);
      } else if (i == msds.length - 1) {
        msds[i].update(msds[i-1].angularVelocity, 0);
      } else {
        msds[i].update(msds[i-1].angularVelocity, msds[i+1].force);
      }
      
      float sineValue = sin(map(i, 0, msds.length - 1, 0, PI));
      float dynamicWidth = map(sineValue, 0, 1, 2, this.maxWidth);
      
      strokeWeight(dynamicWidth);
      stroke(30, 150 - i*3, 20 + i*2);
      
      rotate(msds[i].angle);
      line(0, 0, 0, -segmentLength);
      translate(0, -segmentLength);
    }
    popMatrix();
  }
}
