// Explosion Animation & Sounds
void drawExplosion() {
  int randNumber = int(random(1,4));
    if (randNumber == 1){
      e1.play();
    }
    if (randNumber == 2){
      e2.play();
    }
    if (randNumber == 3){
      e3.play();
    }
  for (int i = 0; i < 10; i++) {
    float angle = random(TWO_PI);
    float distance = random(10, 50);
    float x = width / 2 + cos(angle) * distance;
    float y = height / 2 + sin(angle) * distance;
    fill(255, random(150, 255), 0);
    ellipse(x, y, random(10, 20), random(10, 20));
  }
  if (gainingMoney == true) {
      bustedBalls++;
      money += ballValue;
      gainingMoney = false;
  }
}
