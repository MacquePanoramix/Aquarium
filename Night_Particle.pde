class NightParticle {
    PVector position;
    float baseAlpha;
    float flickerSpeed;
    float flickerPhase;
    float size;
    float baseBrightness;

    NightParticle(PVector pos) {
      position = pos.copy();
      reset(); // Use a helper function to set initial and respawned properties
    }
    
    // Helper function to set all random properties
    void reset() {
       baseAlpha = random(100, 180);
       flickerSpeed = random(0.05, 0.1);
       flickerPhase = random(TWO_PI);
       size = random(3, 8);
       baseBrightness = random(150, 255);
    }

    void update(float sandHeight) {
      // Move the particle upwards
      position.y -= 0.09;

      // Check if particle is off-screen
      if (position.y < -size) { // Use -size to ensure it's fully off-screen
        // If it is, reset its position to the sand height at a new random x-coordinate
        position.y = height - sandHeight;
        position.x = random(width);
        
        // Make it feel like a completely new particle by resetting its properties
        reset();
      }
      
      // The original random alpha change
      if (random(1) < 0.002) {
        baseAlpha = random(100, 200);
      }
    }

    void display() {
      float flicker = abs(sin(frameCount * flickerSpeed + flickerPhase));
      float alpha = lerp(50, 255, flicker);

      noStroke();

      // Outer glow
      fill(180, 200, 255, alpha * 0.2);
      ellipse(position.x, position.y, size * 4, size * 4);

      // Mid glow
      fill(180, 220, 255, alpha * 0.5);
      ellipse(position.x, position.y, size * 2.5, size * 2.5);

      // Core
      fill(200, 240, 255, alpha);
      ellipse(position.x, position.y, size, size);
    }
  }
