// Click Animation & Sounds
void mousePressed() {
  if (!exploding) {
    ballSize += 5;
    int randNumber = int(random(1, 5));
    println(randNumber);
    if (randNumber == 1) {
      b1.play();
    }
    if (randNumber == 2) {
      b2.play();
    }
    if (randNumber == 3) {
      b3.play();
    }
    if (randNumber == 4) {
      b4.play();
    }
  }

  // Trigger scaling effect on click
  scalingUp = true;
  scalingDown = false;
  scaleOffset = 0.05; // Start from a noticeable increase

  // Check if Upgrade Button is Clicked
  if (mouseX > 420 && mouseX < 580 && mouseY > 10 && mouseY < 80 && money >= growthUpgradeCost) {
    money -= growthUpgradeCost;
    growthRate += .05;
    growthUpgradeCost *= 1.2; // Increase cost of next upgrade
  }
  if (mouseX > 220 && mouseX < 380 && mouseY > 10 && mouseY < 80 && money >= valueUpgradeCost) {
    money -= valueUpgradeCost;
    ballValue += 1;
    valueUpgradeCost *= 2; // Increase cost of next upgrade
  }
}
