boolean gameStarted = false; // Flag to check if the game has started
boolean playerTurn = true; // true for Player 1's turn, false for Player 2's turn
boolean setupPhase = true; // Flag to indicate if players are in the setup phase (placing ships)
boolean player1Placing = true; // Flag for Player 1 placing ships
boolean player1FinishedPlacing = false; // Flag to check if Player 1 has finished placing ships
boolean player2FinishedPlacing = false; // Flag to check if Player 2 has finished placing ships
int shipsPlaced = 0; // Counter for ships placed by a player

// Handles placing ships on the grid during setup phase
void placeShip() {
  int x = (mouseX < width / 2) ? mouseX / cellSize : (mouseX - (width / 2 + 10)) / cellSize;
  int y = mouseY / cellSize;

  if (player1Placing && x >= 0 && x < gridSize && y >= 0 && y < gridSize && mouseX < width / 2) {
    if (grid1[x][y] == 0 && shipsPlaced < totalShips) {
      grid1[x][y] = 1;
      shipsPlaced++;
    }
  } else if (!player1Placing && x >= 0 && x < gridSize && y >= 0 && y < gridSize && mouseX >= width / 2 + 10) {
    if (grid2[x][y] == 0 && shipsPlaced < totalShips) {
      grid2[x][y] = 1;
      shipsPlaced++;
    }
  }

  if (shipsPlaced == totalShips) {
    if (player1Placing) {
      player1Placing = false;
      shipsPlaced = 0;
      player1FinishedPlacing = true; // Player 1 is done placing ships
    } else {
      setupPhase = false;
      gameStarted = true;
    }
  }
}

void shoot() {
  int x = (mouseX < width / 2) ? mouseX / cellSize : (mouseX - (width / 2 + 10)) / cellSize;
  int y = mouseY / cellSize;

  if (playerTurn && x >= 0 && x < gridSize && y >= 0 && y < gridSize && mouseX >= width / 2 + 10) {
    int adjustedX = x;
    if (!revealed2[adjustedX][y]) {
      revealed2[adjustedX][y] = true;
      if (grid2[x][y] == 0) { // If it's a miss
        randMiss(); // Play miss sound
      }
      else { // If it's a hit
        randExplode();
      }
      playerTurn = false;
    }
  } else if (!playerTurn && x >= 0 && x < gridSize && y >= 0 && y < gridSize && mouseX < width / 2) {
    if (!revealed1[x][y]) {
      revealed1[x][y] = true;
      if (grid1[x][y] == 0) { // If it's a miss
        randMiss(); // Play miss sound
      }
      else { // If it's a hit
        randExplode();
      }
      playerTurn = true;
    }
  }
}

void mousePressed() {
  // If the restart button is clicked, restart the game
  if (mouseX > restartButtonX && mouseX < restartButtonX + restartButtonWidth &&
    mouseY > restartButtonY && mouseY < restartButtonY + restartButtonHeight && canRestart) {
    restartGame();
    type.play(); 
  }

  // Prevent ship placement during name setup phase
  if (nameSetup) return;

  if (setupPhase && mouseButton == LEFT) {
    placeShip();
  } else if (!setupPhase && mouseButton == LEFT && canRestart == false) {
    shoot();
  }
}
