boolean netThrown = false;
boolean netLanded = false;
float netX, netY, netStartX, netStartY;
float boatX = 300, boatY = 400;
float boatTargetX = boatX;
boolean movingLeft = false, movingRight = false;
int netMax = 4; // Amount of cans that fit in the net
float boatSpeed = .8; // Boat's movement speed

// Net movement variables
float netDirX, netDirY;
float netSpeed = 5;
float netDistance = 0;
float maxNetSize = 50; // Max size of the net
float netSize; // Actual size of the net
float targetDistance; // The actual distance the net will travel
float maxRange = 150;  // Maximum net throwing distance
boolean isRetracting = false;

// Velocity-based movement for smooth retraction
float netVelocityX = 0;
float netVelocityY = 0;
float deceleration = 0.95; // Gradual slowdown effect
float fallSpeed = 0.5; // Speed at which the net falls down

void boatSetup() {
  boatX = width / 2;
  boatY = height - 500;
  boatTargetX = boatX; // Set initial target to starting position
}

void boatDraw() {
  move();
  boatX = lerp(boatX, boatTargetX, 0.1);
  drawBoat();
  retract();

  // Track the distance between the boat and the net
  float distanceToBoat = dist(netX, netY, boatX, boatY);
  if (netThrown) {
    if (!netLanded) {
      // Move net forward and shrink it
      if (netDistance < targetDistance) {
        netX += netDirX * netSpeed;
        netY += netDirY * netSpeed;
        netDistance += netSpeed;
        netSize = map(netDistance, 0, targetDistance, 20, maxNetSize);
      } else {
        netLanded = true;
      }
    } else {
      if (distanceToBoat > maxRange) {
        // Allow net to drift smoothly toward the boat
        netVelocityX += (boatX - netX) * 0.002;
        if (netY < boatY) {
          netVelocityY += (boatY - netY) * 0.002;
        }
      } else {
        // Let the net slowly fall down until it reaches max range
        netY += fallSpeed;
      }

      // Apply velocity and gradual slowdown
      netVelocityX *= deceleration;
      netVelocityY *= deceleration;
      netX += netVelocityX;
      netY += netVelocityY;

      // Constrain net position within river bounds at its Y position
      float xOffset = sin((netY + riverOffset) * waveFrequency) * waveAmplitude;
      float leftBound = riverX + xOffset + 10;
      float rightBound = riverX + xOffset + riverWidth - 10;

      netX = constrain(netX, leftBound, rightBound);

      // Once net reaches the boat, reset everything for a new throw
      if (distanceToBoat < 50) {
        netLanded = false; // Ready for a new throw
        netThrown = false;
        isRetracting = false;
        netSize = 0; // Reset net size
      }
    }

    drawNet();
  }
}

class MoveLeftCommand implements Command {
  public void execute() {
    movingLeft = true;
  }
}

class MoveRightCommand implements Command {
  public void execute() {
    movingRight = true;
  }
}

class StopMoveLeftCommand implements Command {
  public void execute() {
    movingLeft = false;
  }
}

class StopMoveRightCommand implements Command {
  public void execute() {
    movingRight = false;
  }
}

class ThrowNetCommand implements Command {
  public void execute() {
    if (!netThrown) {
      netThrown = true;
      netX = boatX;
      netY = boatY;
      netStartX = boatX;
      netStartY = boatY;
      netDistance = 0;
      netSize = 50;

      float dirX = mouseX - boatX;
      float dirY = mouseY - boatY;
      float length = sqrt(dirX * dirX + dirY * dirY);
      targetDistance = min(length, maxRange);
      netDirX = dirX / length;
      netDirY = dirY / length;

      // Constrain net's starting X position within river bounds
      float xOffset = sin((netY + riverOffset) * waveFrequency) * waveAmplitude;
      float leftBound = riverX + xOffset + 10;
      float rightBound = riverX + xOffset + riverWidth - 10;
      netX = constrain(netX, leftBound, rightBound);
    }
    if (netThrown && netLanded) {
      isRetracting = true;
    }
  }
}

void move() {
  if (movingLeft) {
    boatTargetX -= boatSpeed;
  }
  if (movingRight) {
    boatTargetX += boatSpeed;
  }

  // Get river boundaries at the boat's Y position
  float xOffset = sin((boatY + riverOffset) * waveFrequency) * waveAmplitude;
  float leftBound = riverX + xOffset + 25;
  float rightBound = riverX + xOffset + riverWidth - 25;

  boatTargetX = constrain(boatTargetX, leftBound, rightBound);
}

void drawBoat() {
  fill(139, 69, 19);
  stroke(200, 50, 10);
  strokeWeight(2);

  float w = 40;
  float h = 60;

  beginShape();
  vertex(boatX - w / 2, boatY + h / 2);
  vertex(boatX + w / 2, boatY + h / 2);
  vertex(boatX + w * 0.7 / 2, boatY - h / 2);
  vertex(boatX - w * 0.7 / 2, boatY - h / 2);
  endShape(CLOSE);
}

void boatMousePressed() {
  if (!netThrown) {
    netThrown = true;
    netX = boatX;
    netY = boatY;
    netStartX = boatX;
    netStartY = boatY;

    //boatY = getRiverY(boatX);

    netDistance = 0;  // Reset net travel distance
    netSize = 50;  // Reset net size

    // Calculate distance to the mouse
    float dirX = mouseX - boatX;
    float dirY = mouseY - boatY;
    float length = sqrt(dirX * dirX + dirY * dirY);

    // Set the actual target distance (cap at maxRange)
    targetDistance = min(length, maxRange);

    // Normalize direction
    netDirX = dirX / length;
    netDirY = dirY / length;
  }
  if (netThrown && netLanded) {
    isRetracting = true;
  }
}


void retract() {
  if (isRetracting) {
    netVelocityX += (boatX - netX) * 0.002;
    netVelocityY += (boatY - netY) * 0.002;
    netVelocityX *= deceleration;
    netVelocityY *= deceleration;
    netX += netVelocityX;
    netY += netVelocityY;
  }
}

void drawNet() {
  stroke(255);
  fill(200);
  strokeWeight(2);

  // Draw tether from boat to net
  line(boatX, boatY, netX, netY);

  // Draw web structure dependant on maximum amount of cans
  ellipse(netX, netY, netSize, netSize);
  for (int i = 0; i < netMax; i++) {
    float angle = TWO_PI / netMax * i;
    float x = netX + cos(angle) * netSize / 2;
    float y = netY + sin(angle) * netSize / 2;
    line(netX, netY, x, y);
  }

  // Ensure net stays within river bounds
  float xOffset = sin((netY + riverOffset) * waveFrequency) * waveAmplitude;
  float leftBound = riverX + xOffset + 10;
  float rightBound = riverX + xOffset + riverWidth - 10;
  netX = constrain(netX, leftBound, rightBound);
}
