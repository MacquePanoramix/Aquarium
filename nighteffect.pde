class NightEffect {
  ArrayList<NightParticle> particles;

  // Constructor now accepts sandHeight to constrain initial particle positions
  NightEffect(int count, float sandHeight) {
    particles = new ArrayList<NightParticle>();
    for (int i = 0; i < count; i++) {
      // Create particles only above the sand level
      particles.add(new NightParticle(new PVector(random(width), random(height - sandHeight))));
    }
  }

  // This method was updated in the previous request and remains correct
  void update(float sandHeight) {
    for (NightParticle p : particles) {
      p.update(sandHeight);
    }
  }

  void display() {
    for (NightParticle p : particles) {
      p.display();
    }
  }
}
