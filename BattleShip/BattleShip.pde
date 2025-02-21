/*This game is a battleship copy that involves players choosing their names,
 placing their battleships, and attempting to shoot their opponent's battleships.
 It reflects key concepts from Game Programming Patterns, particularly
 state management. It uses the state pattern with boolean flags
 to track different phases.
 */
PFont arcadeFont;
void settings() {
  fullScreen(); // Set the game to full-screen mode
}

void setup() {
  grabSounds();
  arcadeFont = createFont("ARCADECLASSIC.TTF", 1); // Load the custom font
  textFont(arcadeFont);
  // Calculate the cell size based on the screen size, ensuring no gaps
  // Subtracting space for instructions (e.g. 100px) and a small buffer between grids
  cellSize = min((width - 40) / 2 / gridSize, (height - 100) / gridSize); // Adjusting cell size with padding and buffer
}

// Main draw function that updates and renders the game state
void draw() {
  if (nameSetup) {
    // If name setup is required, display the name setup screen
    drawNameSetupScreen();
    return;
  }
  // Lerp animation to create a pulsating effect on grid selection
  if (increasing) {
    lerpValue += 0.02;
    if (lerpValue >= 1) increasing = false;
  } else {
    lerpValue -= 0.02;
    if (lerpValue <= 0) increasing = true;
  }

  background(180);

  // Adjust the grid drawing for full-screen mode with barrier space
  drawGrid(0, grid1, revealed1, setupPhase ? player1Placing : !playerTurn, player1FinishedPlacing, true);
  drawGrid(width / 2 + 10, grid2, revealed2, setupPhase ? !player1Placing : playerTurn, player2FinishedPlacing, false);

  drawInstructionsBackground();
  drawInstructions();

  if (gameStarted) checkWinCondition();
}
