int gridSize = 10; // Number of cells in one grid
int cellSize; // Size of each cell, calculated dynamically
int[][] grid1 = new int[gridSize][gridSize];
int[][] grid2 = new int[gridSize][gridSize];
boolean[][] revealed1 = new boolean[gridSize][gridSize];
boolean[][] revealed2 = new boolean[gridSize][gridSize];
boolean playerTurn = true; // true for Player 1, false for Player 2
boolean setupPhase = true; // Players are placing ships
boolean player1Placing = true;
int shipsPlaced = 0;
int totalShips = 5;
float lerpValue = 0;
boolean increasing = true;
boolean gameStarted = false;
boolean player1FinishedPlacing = false;
boolean player2FinishedPlacing = false;
String player1Name = "";
String player2Name = "";
boolean nameSetup = true;
boolean enteringPlayer2 = false;
boolean canRestart = false;
int restartButtonX, restartButtonY, restartButtonWidth = 200, restartButtonHeight = 50;
void settings() {
  fullScreen(); // Set the game to full-screen mode
}

void setup() {
  // Calculate the cell size based on the screen size, ensuring no gaps
  // Subtracting space for instructions (e.g. 100px) and a small buffer between grids
  cellSize = min((width - 40) / 2 / gridSize, (height - 100) / gridSize); // Adjusting cell size with padding and buffer
}

void draw() {
  if (nameSetup) {
    drawNameSetupScreen();
    return;
  }

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

void drawNameSetupScreen() {
  background(200);
  fill(0);
  textSize(width / 20);  // Scale text size based on window width
  if (!enteringPlayer2) {
    text("Enter Player 1 Name: " + player1Name, 20, height / 4);
  } else {
    text("Enter Player 2 Name: " + player2Name, 20, height / 4);
  }
  text("Press ENTER to confirm", 20, height / 3);
}

void keyPressed() {
  if (nameSetup) {
    if (key == ENTER) {
      if (!enteringPlayer2 && player1Name.length() > 0) {
        enteringPlayer2 = true;
      } else if (enteringPlayer2 && player2Name.length() > 0) {
        nameSetup = false;
      }
    } else if (key == BACKSPACE) {
      if (!enteringPlayer2) {
        if (player1Name.length() > 0) player1Name = player1Name.substring(0, player1Name.length() - 1);
      } else {
        if (player2Name.length() > 0) player2Name = player2Name.substring(0, player2Name.length() - 1);
      }
    } else if (key != SHIFT && key != CODED) {
      if (!enteringPlayer2) {
        player1Name += key;
      } else {
        player2Name += key;
      }
    }
  }
}


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
      playerTurn = false;
    }
  } else if (!playerTurn && x >= 0 && x < gridSize && y >= 0 && y < gridSize && mouseX < width / 2) {
    if (!revealed1[x][y]) {
      revealed1[x][y] = true;
      playerTurn = true;
    }
  }
}

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

void drawInstructionsBackground() {
  fill(200);
  rect(0, height - 100, width, 100); // Increased bottom area height
}

void drawInstructions() {
  fill(0);
  textSize(width / 30);  // Scale text size based on window width
  if (setupPhase) {
    text((player1Placing ? player1Name : player2Name) + ": Place ships (" + (totalShips - shipsPlaced) + " left)", 20, height - 50);
  } else {
    text((playerTurn ? player1Name : player2Name) + "'s Turn", 20, height - 50);
  }
}


void displayWinMessage(String message) {
  background(0, 255, 0);
  fill(255);
  textSize(width / 15); // Larger text for win message
  textAlign(CENTER, CENTER);
  text(message, width / 2, height / 3);

  // Draw Restart Button
  restartButtonX = width / 2 - restartButtonWidth / 2;
  restartButtonY = height / 2 + 50;
  fill(255, 0, 0);
  rect(restartButtonX, restartButtonY, restartButtonWidth, restartButtonHeight);
  fill(255);
  textSize(width / 30);
  text("Restart", width / 2, restartButtonY + restartButtonHeight / 2);
}

void mousePressed() {
  // If the restart button is clicked, restart the game
  if (mouseX > restartButtonX && mouseX < restartButtonX + restartButtonWidth &&
    mouseY > restartButtonY && mouseY < restartButtonY + restartButtonHeight && canRestart) {
    restartGame();
  }

  // Prevent ship placement during name setup phase
  if (nameSetup) return;

  if (setupPhase && mouseButton == LEFT) {
    placeShip();
  } else if (!setupPhase && mouseButton == LEFT && canRestart == false) {
    shoot();
  }
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
  // Redraw the name setup screen
  loop(); // Start the game loop again
}
