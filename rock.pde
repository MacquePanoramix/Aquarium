// ==========================================================
// --- NEW/UPDATED ROCK CLASS ---
// ==========================================================
// This class creates physical rock obstacles with a rounded, natural shape.
class Rock {
  PVector position;
  float radius;
  color rColor;
  PVector[] shapePoints;
  float noiseOffset; // Unique offset for each rock's shape

  Rock(PVector position, float radius, color rColor) {
    this.position = position;
    this.radius = radius;
    this.rColor = rColor;
    this.noiseOffset = random(1000); // Initialize the unique offset
    this.shapePoints = generateRockShape();
  }

  // Generates a more rounded, irregular rock shape using Perlin noise
  PVector[] generateRockShape() {
    int points = 30; // More points for a smoother curve
    PVector[] shape = new PVector[points];
    for (int i = 0; i < points; i++) {
      float angle = map(i, 0, points, 0, TWO_PI);
      
      // Use noise() for a smooth, continuous sequence of values.
      // We map the noise output (0 to 1) to a range for the radius variation.
      float xoff = map(cos(angle), -1, 1, 0, 2);
      float yoff = map(sin(angle), -1, 1, 0, 2);
      float noiseVal = noise(noiseOffset + xoff, noiseOffset + yoff);
      float r = radius + map(noiseVal, 0, 1, -radius * 0.4, radius * 0.4);
      
      float x = cos(angle) * r;
      float y = sin(angle) * r;
      shape[i] = new PVector(x, y);
    }
    return shape;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    fill(rColor);
    stroke(50, 45, 40); // Darker, earthy stroke for better definition
    strokeWeight(2);
    
    // Use curveVertex to draw a smooth, closed shape through the points
    beginShape();
    // The first and last points are control points for the curve
    curveVertex(shapePoints[shapePoints.length - 1].x, shapePoints[shapePoints.length - 1].y);
    for (int i = 0; i < shapePoints.length; i++) {
      curveVertex(shapePoints[i].x, shapePoints[i].y);
    }
    // The first two points are repeated to close the curve smoothly
    curveVertex(shapePoints[0].x, shapePoints[0].y);
    curveVertex(shapePoints[1].x, shapePoints[1].y);
    endShape();
    
    popMatrix();
  }
}
