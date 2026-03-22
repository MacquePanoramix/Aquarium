// ==========================================================
// --- NEW SEAWEED AND WATER CURRENT CLASSES ---
// ==========================================================

// This class calculates and stores the average direction of the fish flock
class WaterCurrent {
  PVector current;
  float easing = 0.05; // To make the current change smoothly

  WaterCurrent() {
    current = new PVector(0, 0);
  }

  // Calculate the average velocity of all creatures
  void update(ArrayList<Creature> creatures) {
    PVector averageVelocity = new PVector(0, 0);
    if (creatures.isEmpty()) {
      return;
    }
    
    for (Creature c : creatures) {
      averageVelocity.add(c.velocity);
    }
    averageVelocity.div(creatures.size());
    
    // Smoothly ease the current towards the new average velocity
    current.lerp(averageVelocity, easing);
  }
}
