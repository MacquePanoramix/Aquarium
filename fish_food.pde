class FishFood {
  PVector position;
  float radius = 5;
  int decayTime = 300;
  int age = 0;
  boolean isAlive = true;
  int RGBA;
  float timeOffset;

  FishFood(PVector position) {
    this.position = position.copy();
    this.RGBA = color(255, 200, 100, 200);
    this.timeOffset = random(1000);
  }

  void update() {
    age++;
    float t = (frameCount + timeOffset) * 0.05;
    position.x += sin(t) * 0.3; // gentle swaying
    position.y += 0.5;  // Simulate falling
    decayTime--;
    if (decayTime <= 0) {
      isAlive = false;
    }
  }

  void render() {
    noStroke();
    fill(255,100,0);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}
