class Particle {
  PVector position;
  PVector velocity;
  float alpha;
  float size;

  Particle(PVector pos) {
    float angle = random(TWO_PI);

    // 🚀 Make particles start farther away from center
    float dist = random(36, 72);  // increased from 4–12
    position = pos.copy().add(new PVector(cos(angle), sin(angle)).mult(dist));

    // 🌬️ Give them stronger motion away from center
    float speed = random(1, 3);  // increased from 0.5–1.5
    velocity = new PVector(cos(angle), sin(angle)).mult(speed);

    alpha = 255;
    size = random(4, 8);  // slightly bigger for clarity
  }

  void update() {
    position.add(velocity);
    alpha -= 1;  // fades slower so you can see it longer
    
    size += sin(frameCount * 0.1) * 0.1;  // tiny size pulse
  }

  void display() {
    stroke(255, alpha);
    strokeWeight(1);
    fill(200, 240, 255, alpha);  // pale blue glow
    ellipse(position.x, position.y, size, size);
  }

  boolean isDead() {
    return alpha <= 0;
  }
}
