class Flock {
  ArrayList<Creature> flockOfCreatures;
  float neighbourArea;

  Flock(float area) {
    neighbourArea = area;
    flockOfCreatures = new ArrayList<Creature>();
  }

  void addCreature(float fishSize, float sandHeight) {
    flockOfCreatures.add(new Creature(neighbourArea, fishSize, sandHeight));
  }

  void setNeighbours(Creature main, int ownPosition) {
    main.neighbours = new ArrayList<Creature>();
    for (int other = 0; other < flockOfCreatures.size(); other++) {
      if (other != ownPosition) {
        main.neighbours.add(flockOfCreatures.get(other));
      }
    }
  }

  void updateCreatures(Aquarium aquarium) {
    ArrayList<FishFood> foodToRemove = new ArrayList<FishFood>();
    for (int i = 0; i < flockOfCreatures.size(); i++) {
      Creature c = flockOfCreatures.get(i);
      setNeighbours(c, i);
      c.calculateCohesion();
      c.calculateSeparation();
      c.calculateAlignment();
      // --- MODIFIED: Pass rocks and sand height for avoidance ---
      c.calculateAvoidance(aquarium.groundRocks, aquarium.sandHeight);
      c.calculateEating(aquarium.food.curFood);
      ArrayList<FishFood> eaten = c.eating(aquarium.food.curFood);
      foodToRemove.addAll(eaten);
      c.update();
      c.render();
    }
    for (FishFood food : foodToRemove) {
      aquarium.food.curFood.remove(food);
    }
  }
}
