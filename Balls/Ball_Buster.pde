//This game incorporates balls, but instead of choosing to play with the affordances 
//people have come to know (bouncing, throwing, rolling, etc), I chose to bust them :).

import processing.sound.*;
// Prolly gonna add save later if I feel like it.
import java.util.ArrayList;
import java.io.File;
import java.io.PrintWriter;
import processing.data.JSONObject;
float ballSize = 1;

// Defining Stats
float growthRate = 0;
int maxSize = 200;
int money = 0;
int ballValue = 1;
int bustedBalls = 0;
boolean autoGrowth = true;
int growthUpgradeCost = 5;
int valueUpgradeCost = 15;
SoundFile b1, b2, b3, b4, e1, e2, e3, p;
float bounceOffset = 0;
float bounceSpeed = 0.2;
boolean bouncingUp = true;
float scaleOffset = 0;
float scaleSpeed = 0.02;
boolean scalingUp = false;
boolean scalingDown = false;
boolean exploding = false;
boolean gainingMoney = false;
int explosionFrames = 0;

void setup() {
  size(600, 400);
  b1 = new SoundFile(this, "blipSelect.wav");
  b2 = new SoundFile(this, "blipSelect (1).wav");
  b3 = new SoundFile(this, "blipSelect (2).wav");
  b4 = new SoundFile(this, "blipSelect (3).wav");
  e1 = new SoundFile(this, "explosion.wav");
  e2 = new SoundFile(this, "explosion (1).wav");
  e3 = new SoundFile(this, "explosion (2).wav");
  p = new SoundFile(this, "powerUp.wav");
}

void draw() {
  rectMode(CENTER);
  fill(0, 45);
  // Fade effect for ball bounce and explosion
  rect(0, 0, 1000000, 1000000);
  rectMode(CORNER);
  if (autoGrowth && !exploding) {
    ballSize += growthRate;
  }
  // Makes the ball explode
  if (ballSize >= maxSize && !exploding) {
    exploding = true;
    gainingMoney = true;
    explosionFrames = 30; // Explosion duration
  }
  // Starts the explosion animation
  if (exploding) {
    drawExplosion();
    explosionFrames--;
    if (explosionFrames <= 0) {
      exploding = false;
      ballSize = 1;
    }
  } else {
    // Bouncy effect
    if (bouncingUp) {
      bounceOffset += bounceSpeed;
      if (bounceOffset >= 5) bouncingUp = false;
    } else {
      bounceOffset -= bounceSpeed;
      if (bounceOffset <= -5) bouncingUp = true;
    }

    // Start bounce-out effect when clicking
    if (scalingUp) {
      scaleOffset += scaleSpeed;
      if (scaleOffset >= 0.1) {
        scalingUp = false;
        scalingDown = true;
      }
    }

    if (scalingDown) {
      scaleOffset -= scaleSpeed;
      if (scaleOffset <= 0) {
        scalingDown = false;
      }
    }

    float displaySize = ballSize * (1 + scaleOffset);
    
    // Slowly make the ball more green as ball value increases
    fill(255 - (ballValue - 1) * 20, 255, 255 - (ballValue - 1) * 20);
    
    // Draw the ball
    ellipse(width / 2, height / 2 + bounceOffset, displaySize, displaySize);
  }

  // Show Stats
  fill(255);
  textSize(20);
  textAlign(LEFT);
  text("Money: " + money, 20, 30);
  text("Busted Balls: " + bustedBalls, 20, 60);
  if (growthRate > 0) {
    text("Secs Till Bust: " + round(200 / (growthRate * 60)), 20, 90);
  }
  text("Ball Value: " + ballValue, 20, 120);

  // Draw Upgrade Buttons
  if (money >= growthUpgradeCost) {
    fill(0, 255, 0);
  } else {
    fill(255, 0, 0);
  }
  rect(420, 10, 160, 70);
  fill(255);
  textSize(22);
  textAlign(CENTER, CENTER);
  text("Ball Generation", 500, 30);
  text("Cost: " + growthUpgradeCost, 500, 55);

  if (money >= valueUpgradeCost) {
    fill(0, 255, 0);
  } else {
    fill(255, 0, 0);
  }
  rect(220, 10, 160, 70);
  fill(255);
  textSize(22);
  textAlign(CENTER, CENTER);
  text("Ball Value", 300, 30);
  text("Cost: " + valueUpgradeCost, 300, 55);
}
