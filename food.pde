class Food {
  ArrayList<FishFood> curFood;
  ArrayList<Particle> particles = new ArrayList<Particle>();
  int maxFood = 10;

  Food() {
    curFood = new ArrayList<FishFood>();
  }

  void spawn(PVector pos) {
    if (curFood.size() < maxFood) {
      curFood.add(new FishFood(pos));
    }
  }
  
    void spawnParticles(PVector pos) {
  for (int i = 0; i < 10; i++) {
    particles.add(new Particle(pos));
  }
}


  void update() {
    for (int i = curFood.size()-1; i >= 0; i--) {
  FishFood f = curFood.get(i);
  f.update();
  if (!f.isAlive) {
  // Spawn 10 particles when food decays
  spawnParticles(f.position);
  curFood.remove(i);
}
}

// Update particles
for (int i = particles.size()-1; i >= 0; i--) {
  Particle p = particles.get(i);
  p.update();
  if (p.isDead()) {
    particles.remove(i);
  }
}
}
  
  void display() {
    for (FishFood f : curFood) {
      f.render();
    }
    for (Particle p : particles) {
      p.display();
    }
  }
}
