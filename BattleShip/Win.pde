boolean canRestart = false; // Flag to enable or disable the restart option
boolean playedWinSound = false; // Ensures "yay" sound only plays once
int restartButtonX, restartButtonY, restartButtonWidth = 500, restartButtonHeight = 150; // Position and size for restart button

void checkWinCondition() {
  if (allShipsDestroyed(grid1, revealed1)) {
    canRestart = true;
    displayWinMessage(player2Name + " Wins!");
  } else if (allShipsDestroyed(grid2, revealed2)) {
    canRestart = true;
    displayWinMessage(player1Name + " Wins!");
  }
}

boolean allShipsDestroyed(int[][] grid, boolean[][] revealed) {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (grid[i][j] == 1 && !revealed[i][j]) {
        return false;
      }
    }
  }
  return true;
}

void displayWinMessage(String message) {
  background(0, 255, 0);
  fill(255);
  textSize(width / 30); // Larger text for win message
  textAlign(CENTER, CENTER);
  text(message, width / 2, height / 3);

  // Play win sound once
  if (!playedWinSound) {
    yay.play();
    playedWinSound = true; // Prevents replaying
  }

  // Draw Restart Button
  restartButtonX = width / 2 - restartButtonWidth / 2;
  restartButtonY = height / 2 + 50;
  fill(255, 0, 0);
  rect(restartButtonX, restartButtonY, restartButtonWidth, restartButtonHeight);
  fill(255);
  textSize(width / 30);
  text("Restart", width / 2, restartButtonY + restartButtonHeight / 2);
}

void restartGame() {
  // Reset all variables to their initial values
  grid1 = new int[gridSize][gridSize];
  grid2 = new int[gridSize][gridSize];
  revealed1 = new boolean[gridSize][gridSize];
  revealed2 = new boolean[gridSize][gridSize];
  playerTurn = true;
  setupPhase = true;
  player1Placing = true;
  shipsPlaced = 0;
  totalShips = 5;
  lerpValue = 0;
  increasing = true;
  gameStarted = false;
  player1FinishedPlacing = false;
  player2FinishedPlacing = false;
  player1Name = "";
  player2Name = "";
  nameSetup = true;
  enteringPlayer2 = false;
  textAlign(LEFT, BASELINE);
  canRestart = false;
  playedWinSound = false; // Reset sound flag so it can play again
  loop(); // Start the game loop again
}
