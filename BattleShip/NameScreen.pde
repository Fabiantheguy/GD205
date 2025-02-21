String player1Name = ""; // Store Player 1's name
String player2Name = ""; // Store Player 2's name
boolean nameSetup = true; // Flag to indicate if the name input screen is active
boolean enteringPlayer2 = false; // Flag to track if Player 2's name is being entered
//Creates the name setup screen 
void drawNameSetupScreen() {
  background(200);
  fill(0);
  textSize(width / 40);  // Scale text size based on window width
  if (!enteringPlayer2) {
    text("Enter Player 1 Name:" + player1Name, 20, height / 4);
  } else {
    text("Enter Player 2 Name:" + player2Name, 20, height / 4);
  }
  text("Press ENTER to confirm", 20, height / 3);
}

// Handles keyboard input for entering player names
void keyPressed() {
  if (nameSetup) {
    if (key != ENTER && key != ESC && keyCode != SHIFT) {
    type.play(); 
    }
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
