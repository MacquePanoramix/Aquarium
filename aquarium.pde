class Aquarium {
  Food food;
  NightEffect night;
  PImage bg;
  boolean lightOn = true;
  float brightnessFactor = 1;
  ArrayList<Particle> waterBubbles;
  ArrayList<Segments> seaweedClump;
  WaterCurrent waterCurrent;
  ArrayList<Rock> groundRocks; // Changed from PVector to Rock
  float sandHeight = 40; // Defines the height of the sandy floor

  Aquarium() {
    food = new Food();
    bg = loadImage("wp.jpg");
    waterBubbles = new ArrayList<Particle>();
    // Pass sandHeight to the NightEffect constructor
    night = new NightEffect(100, sandHeight);
    waterCurrent = new WaterCurrent();
    seaweedClump = new ArrayList<Segments>();
    final int NUM_OF_PLANTS = 20;
    for (int i = 0; i < NUM_OF_PLANTS; i++) {
      float baseX = random(width);
      float baseY = height - 10;
      PVector basePosition = new PVector(baseX, baseY);
      int numOfSegments = (int)random(12, 22);
      float springConstant = random(0.25, 0.4);
      float segmentLength = random(12, 18);
      float maxWidth = random(10, 25);
      seaweedClump.add(new Segments(numOfSegments, springConstant, 0.1, 1.0, segmentLength, maxWidth, basePosition));
    }
    groundRocks = new ArrayList<Rock>();
    for (int i = 0; i < 30; i++) {
      float rockRadius = random(20, 60);
      PVector rockPosition = new PVector(random(width), height - random(5, sandHeight) + rockRadius/2);
      groundRocks.add(new Rock(rockPosition, rockRadius, color(100, 90, 80)));
    }
  }

  void update(Flock flock) {
    food.update();
    if (!lightOn) night.update(sandHeight);
    waterCurrent.update(flock.flockOfCreatures);
    if (random(1) < 0.05) {
      PVector spawnPos = new PVector(random(width), height - random(20, 50));
      waterBubbles.add(new Particle(spawnPos));
    }
    for (int i = waterBubbles.size() - 1; i >= 0; i--) {
      Particle bubble = waterBubbles.get(i);
      bubble.update();
      if (bubble.isDead()) {
        waterBubbles.remove(i);
      }
    }
  }

  void display(Flock flock) {
    tint(255 * brightnessFactor);
    image(bg, 0, 0, width, height);
    noTint();
    drawSeabed();
    for (Segments s : seaweedClump) {
      float waterCurrentForce = waterCurrent.current.x * 0.005;
      for (int i = s.msds.length / 3; i < s.msds.length; i++) {
        s.msds[i].force += waterCurrentForce;
      }
      s.render();
    }
    if (!lightOn) {
      night.update(sandHeight);
      night.display();
    }
    food.display();
    for (Particle bubble : waterBubbles) {
      bubble.display();
    }
  }

  void drawSeabed() {
    noStroke();
    fill(210, 180, 140);
    rect(0, height - sandHeight, width, sandHeight);
    for (Rock rock : groundRocks) {
      rock.display();
    }
  }

  void toggleLight() {
    lightOn = !lightOn;
    brightnessFactor = lightOn ? 1.0 : 0.4;
    if (lightOn) {
      nightMusic.pause();
      dayMusic.play();
    } else {
      dayMusic.pause();
      nightMusic.play();
    }
  }

  void dropFood(PVector pos) {
    food.spawn(pos);
  }
}
