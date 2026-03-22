class Creature { //<>//
  PVector pos, velocity, acceleration, cohesion, separation, alignment, avoidance, eating;
  ArrayList<Creature> neighbours;
  float direction, cohesionRange, alignmentRange, separationRange, avoidanceRange, proximityArea, eatingRange;
  float cohesionWeight, alignmentWeight, separationWeight, avoidanceWeight, directionWeight, eatingWeight;

  // The "Body" of the creature
  Fish fish;

  Creature(float area, float size, float sandHeight) {
    // Starting position, constrained to be above the sand level
    pos = new PVector(random(width), random(height - sandHeight));
    direction = random(TWO_PI);

    // --- INTEGRATION ---
    // Create the fish object, passing the desired scale directly to its constructor.
    fish = new Fish(pos, size);

    //initial velocity/acceleration
    velocity = new PVector(random(-5, 5), random(-5, 5));
    acceleration = new PVector(0, 0);

    proximityArea = area;

    // multipliers for proximity area:
    cohesionRange = 1 * (1+0.02/fish.scale);
    separationRange = 0.3 * pow((fish.scale/0.05), 2);
    alignmentRange = 1.2 * pow(1+0.05/fish.scale, 2);
    avoidanceRange = 0.7;
    eatingRange = 1;


    //Weights:
    cohesionWeight = 0.001 * pow((0.05/fish.scale), 3.5);
    alignmentWeight = 0.01 * pow((0.05/fish.scale), 4);
    separationWeight = 0.025 * pow((0.05/fish.scale), 6.5);
    avoidanceWeight = 0.005 * pow((0.05/fish.scale), 2);
    directionWeight = 1.8 * pow((0.05/fish.scale), 1);
    eatingWeight = 0.005;

    // Initial parameters:
    cohesion = new PVector(0, 0);
    separation = new PVector(0, 0);
    alignment = new PVector(0, 0);
    avoidance = new PVector(0, 0);
    eating = new PVector(0, 0);
  }

  // This now renders the fish instead of a triangle
  void render() {
    fish.display();
  }

  // Your original update logic, with the added fish control
  void update() {
    updateAcceleration();
    updateOrientation();

    velocity.add(acceleration);

    //move
    pos.add(velocity);

    // --- THIS IS THE CRITICAL LINK ---
    // 1. Tell the fish's head where to be.
    this.fish.spine.joints.set(0, this.pos);
    // 2. Tell the fish which direction to face.
    this.fish.spine.angles.set(0, this.direction);
    // 3. Tell the fish's body to update and follow the head.
    this.fish.updateBody();
  }

  void calculateCohesion() {
    cohesion = new PVector(0, 0);
    float neighboursInRange = 0;
    for (int k = 0; k < neighbours.size(); k++) { //Only compare with neighbours within range
      if (pos.dist(neighbours.get(k).pos) <= cohesionRange * proximityArea) {
        PVector distance = new PVector(neighbours.get(k).fish.spine.joints.get(4).x - fish.spine.joints.get(4).x, neighbours.get(k).fish.spine.joints.get(4).y - fish.spine.joints.get(4).y);
        cohesion.add(distance.mult(pow(neighbours.get(k).fish.scale/0.05, 1.5)));
        neighboursInRange++;
      }
    }
    if (neighboursInRange > 0) {
      cohesion.div(neighboursInRange);
    }
  }

  void calculateSeparation() {
    separation = new PVector(0, 0);
    float neighboursInRange = 0;
    for (int k = 0; k < neighbours.size(); k++) {
      if (pos.dist(neighbours.get(k).fish.spine.joints.get(4)) <= separationRange * proximityArea) {
        PVector distance = new PVector(fish.spine.joints.get(4).x - neighbours.get(k).fish.spine.joints.get(4).x, fish.spine.joints.get(4).y - neighbours.get(k).fish.spine.joints.get(4).y);
        if (distance.x < 0) {
          distance.x += separationRange * proximityArea;
        } else {
          distance.x -= separationRange * proximityArea;
        }
        if (distance.y < 0) {
          distance.y += separationRange * proximityArea;
        } else {
          distance.y -= separationRange * proximityArea;
        }
        separation.sub(distance.mult(pow(neighbours.get(k).fish.scale/0.05, 1.5)));
        neighboursInRange++;
      }
    }
    if (neighboursInRange > 0) {
      cohesion.div(neighboursInRange);
    }
  }

  void calculateAlignment() {
    alignment = new PVector(0, 0);
    float neighboursInRange = 0;
    for (int k = 0; k < neighbours.size(); k++) {
      if (pos.dist(neighbours.get(k).pos) <= alignmentRange * proximityArea) {
        PVector neighbourDirection = new PVector(cos(neighbours.get(k).direction), sin((neighbours.get(k).direction)));
        alignment.add(neighbourDirection.mult(pow(neighbours.get(k).fish.scale/0.05, 2)));
        neighboursInRange++;
      }
    }
    if (neighboursInRange > 0) {
      cohesion.div(neighboursInRange);
    }
  }

  // --- MODIFIED AVOIDANCE LOGIC ---
  // Now accepts rocks and avoids them based on their size.
  void calculateAvoidance(ArrayList<Rock> rocks, float sandHeight) {
    avoidance.set(0, 0); // Reset avoidance

    // --- NEW: Rock avoidance ---
    for (Rock rock : rocks) {
      float dist = PVector.dist(pos, rock.position);
      // Check if fish is within the rock's radius plus a buffer
      if (dist < rock.radius + (avoidanceRange * proximityArea)) {
        // Calculate a steering vector away from the rock
        PVector steer = PVector.sub(pos, rock.position);
        // The strength of the push is stronger for larger rocks
        float baselineRadius = 40.0;
        float strength = (rock.radius / baselineRadius); // Larger rocks push harder
        steer.setMag(strength);
        avoidance.add(steer);
      }
    }
    
    // --- Your original wall and floor avoidance ---
    if (pos.x <= avoidanceRange * proximityArea * 0.25) { //Left wall of the aquarium
      avoidance.x += 0 - pos.x + avoidanceRange * proximityArea;
    }

    if (pos.x >= width - avoidanceRange * proximityArea * 0.25) { //Right wall of the aquarium
      avoidance.x -=  pos.x - (width - avoidanceRange * proximityArea);
    }

    if (pos.y <= avoidanceRange * proximityArea * 0.25) { //Ceiling of the aquarium
      avoidance.y += 0 - pos.y + avoidanceRange * proximityArea;
    }

    if (pos.y >= (height - sandHeight) - avoidanceRange * proximityArea * 0.25) { //Sand of the aquarium
      avoidance.y -= (pos.y - ((height - sandHeight) - avoidanceRange * proximityArea)) * 2; //Repel especially hard
    }
  }

  ArrayList<FishFood> eating(ArrayList<FishFood> curFood) {
    float applesInRange = 0;
    ArrayList<FishFood> eatenFood = new ArrayList<FishFood>();

    for (int k = 0; k < curFood.size(); k++) {
      FishFood food = curFood.get(k);

      if (food.age > 30 && pos.dist(food.position) <= eatingRange * proximityArea * 0.1) {
        PVector distance = PVector.sub(food.position, pos);
        applesInRange++;
        eatenFood.add(food);
      }
    }

    return eatenFood;
  }

  void calculateEating(ArrayList <FishFood> curFood) {
    eating = new PVector(0, 0);
    float applesInRange = 0;
    for (int k = 0; k < curFood.size(); k++) {
      if (pos.dist(curFood.get(k).position) <= eatingRange * proximityArea) {
        PVector distance = new PVector(curFood.get(k).position.x - pos.x, curFood.get(k).position.y - pos.y);
        eating.add(distance);
        applesInRange++;
      }
    }
    if (applesInRange > 0) {
      eating.div(applesInRange);
    }
  }

  void updateOrientation() {
    direction = alignment.mult(alignmentWeight).add(velocity.normalize().mult(directionWeight)).heading();
  }

  void updateAcceleration() {
    acceleration.set(0, 0);
    acceleration.add(cohesion.mult(cohesionWeight));
    acceleration.add(separation.mult(separationWeight));
    acceleration.add(alignment.mult(alignmentWeight));
    acceleration.add(avoidance.mult(avoidanceWeight));
    acceleration.add(eating.mult(eatingWeight));
  }
}
