float riverX, riverWidth = 400;
float riverSpeed = 2;
float riverOffset = 0;
float waveFrequency = 0.005; // Controls how often the river curves
float waveAmplitude = 100; // Controls how wide the curves are

void riverSetup() {
  riverX = width / 2 - riverWidth / 2;
}

void riverDraw() {
  background(100, 150, 255);
  background(50, 255, 50);
  noStroke();
  fill(30, 100, 200);

  riverOffset += riverSpeed;

  beginShape();
  for (int y = 0; y <= height; y += 5) { // Smaller increments for a smoother curve
    float xOffset = sin((y + riverOffset) * waveFrequency) * waveAmplitude;
    float leftX = riverX + xOffset;
    curveVertex(leftX, y);
  }
  for (int y = height; y >= 0; y -= 5) {
    float xOffset = sin((y + riverOffset) * waveFrequency) * waveAmplitude;
    float rightX = riverX + xOffset + riverWidth;
    curveVertex(rightX, y);
  }
  endShape(CLOSE);
}
