import processing.sound.*;
SoundFile miss1, miss2, miss3, explode1, explode2, explode3, yay, type;

// Set sounds at the start of the game
void grabSounds() {
  miss1 = new SoundFile(this, "click.wav");
  miss2 = new SoundFile(this, "click (1).wav");
  miss3 = new SoundFile(this, "click (2).wav");
  explode1 = new SoundFile(this, "hitHurt.wav");
  explode2 = new SoundFile(this, "explosion (3).wav");
  explode3 = new SoundFile(this, "explosion (4).wav");
  yay = new SoundFile(this, "yay.mp3");
  type = new SoundFile(this, "Type.wav");  
}
// Play a random miss sound
void randMiss() {
  int rand = int(random(1, 4));
  if (rand == 1) {
    miss1.play();
  } else if (rand == 2) {
    miss2.play();
  } else if (rand == 3) {
    miss3.play();
  }
}

// Play a random explosion sound
void randExplode() {
  int rand = int(random(1, 4));
  if (rand == 1) {
    explode1.play();
  } else if (rand == 2) {
    explode2.play();
  } else if (rand == 3) {
    explode3.play();
  }
}
