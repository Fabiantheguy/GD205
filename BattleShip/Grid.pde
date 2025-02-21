int gridSize = 10; // // Number of cells on each grid (Change to 300 for haha mode)
int cellSize; // Size of each cell, calculated dynamically
int[][] grid1 = new int[gridSize][gridSize]; // Grid for Player 1's ships
int[][] grid2 = new int[gridSize][gridSize]; // Grid for Player 2's ships
boolean[][] revealed1 = new boolean[gridSize][gridSize]; // Revealed state for Player 1's grid
boolean[][] revealed2 = new boolean[gridSize][gridSize]; // Revealed state for Player 2's grid
int totalShips = 5; // Total number of ships each player has
float lerpValue = 0; // Used for creating a smooth animation (e.g., pulsating effect)
boolean increasing = true; // Flag to control the lerp animation direction
void drawGrid(int xOffset, int[][] grid, boolean[][] revealed, boolean isTarget, boolean finishedPlacing, boolean isPlayer1) {
  int activeColor = lerpColor(color(150), color(255), lerpValue);
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (revealed[i][j]) {
        if (grid[i][j] == 1) {
          fill(255, 0, 0); // Red for hits
        } else {
          fill(0, 0, 255); // Blue for water
        }
      } else if (grid[i][j] == 1 && setupPhase && !finishedPlacing && isPlayer1) {
        // Make Player 1's ships green while placing
        fill(0, 255, 0);  // Green ships while Player 1 places them
      } else if (grid[i][j] == 1 && setupPhase && !finishedPlacing && !isPlayer1) {
        // Make Player 2's ships green while placing
        fill(0, 255, 0);  // Green ships while Player 2 places them
      } else if (grid[i][j] == 1 && setupPhase && finishedPlacing && isPlayer1) {
        // Once Player 1 finishes placing, make ships grey
        fill(150);  // Grey ships after Player 1 finishes placing them
      } else {
        fill((setupPhase && isTarget) || (!setupPhase && isTarget) ? activeColor : 150);
      }
      rect(xOffset + i * cellSize, j * cellSize, cellSize, cellSize);
      stroke(0);
    }
  }
}

void drawInstructionsBackground() {
  fill(200);
  rect(0, height - 100, width, 100); // Increased bottom area height
}

void drawInstructions() {
  fill(0);
  textSize(width / 40);  // Scale text size based on window width
  if (setupPhase) {
    text((player1Placing ? player1Name : player2Name) + ": Place ships (" + (totalShips - shipsPlaced) + " left)", 20, height - 35);
  } else {
    text((playerTurn ? player1Name : player2Name) + "'s Turn", 20, height - 35);
  }
}
