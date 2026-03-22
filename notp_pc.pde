// Import the Minim sound library
import ddf.minim.*;

// Declare Minim and AudioPlayer objects for music
Minim minim;
AudioPlayer dayMusic;
AudioPlayer nightMusic; // New player for night music

Aquarium aquarium;
float AREA = 100; // The radius each fish looks for neighbours
int NUM_OF_CREATURES = 30;
Flock flock;

void setup() {
  size(1280, 720);

  // Initialize the Minim object
  minim = new Minim(this);

  // --- MUSIC SETUP ---
  // Load the day music file.
  dayMusic = minim.loadFile("day-music.mp3");
  // Load the night music file. Assumes "night-music.mp3" is in your data folder.
  nightMusic = minim.loadFile("night-music.mp3");

  // We will handle looping manually in the draw() loop.

  // Start with only the day music playing, since lights are on initially.
  dayMusic.play();
  nightMusic.pause();


  aquarium = new Aquarium();
  flock = new Flock(AREA);

  // Create creatures to begin, passing sandHeight to ensure they spawn above the sand
  for (int counter = 0; counter < NUM_OF_CREATURES; counter++) {
    flock.addCreature(random(0.05, 0.12), aquarium.sandHeight);
  }
}

void draw() {
  background(0);
  aquarium.update(flock); // Pass the flock to update the water current
  aquarium.display(flock); // Pass the flock to display to get current

  // Update and render all creatures via flock
  flock.updateCreatures(aquarium);

  // --- MANUAL MUSIC LOOP HANDLING ---
  // This block checks if the active track has finished and loops it.
  // It's smart enough to ignore tracks that are intentionally paused.

  // If it's day time and the day music has stopped playing (meaning it finished)...
  if (aquarium.lightOn && !dayMusic.isPlaying()) {
    dayMusic.rewind(); // ...rewind it...
    dayMusic.play();   // ...and play it again.
  }
  // If it's night time and the night music has finished...
  else if (!aquarium.lightOn && !nightMusic.isPlaying()) {
    nightMusic.rewind(); // ...rewind it...
    nightMusic.play();   // ...and play it again.
  }
}

void keyPressed() {
  if (key == 'l' || key == 'L') {
    aquarium.toggleLight();
  }
}

void mousePressed() {
  aquarium.dropFood(new PVector(mouseX, mouseY));
}

// This function needs to be here to pass the sketch to Minim correctly
void stop() {
  // Always close Minim objects when the sketch is closed.
  dayMusic.close();
  nightMusic.close(); // Close the new audio player
  minim.stop();
  super.stop();
}
