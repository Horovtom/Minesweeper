// GAME SETTINGS
final int GRID_SIZE = 8;
final int MINE_COUNT = 10;

Grid grid;
int score = 0;
boolean losingState = false;
boolean winningState = false;

void setup() {
  size(640, 660);
  restartGame();
}

void restartGame() {
  losingState = false;
  winningState = false;
  score = 0;
  grid = new Grid(GRID_SIZE, 0, 20, width, height - 20);
  grid.generateMines(MINE_COUNT);
}

void draw() {
  background(255);
  fill(0);
  textAlign(LEFT, TOP);
  textSize(20);
  text("Score: " + score, 1, 1);
  grid.display();

  if (winningState) {
    textSize(60);
    textAlign(CENTER, CENTER);
    fill(0, 0, 255);
    text("You won!", width / 2, height / 2);
  }
}

void gameLost(int mX, int mY, int mB) {
  if (score == 0) {
    // Try to restart
    restartGame();
    // Recursive
    grid.onMousePressed(mX, mY, mB);
    return;
  }

  grid.revealAll();
  losingState = true;
}

void mousePressed() {
  if (losingState || winningState) {
    restartGame();
    return;
  }

  grid.onMousePressed(mouseX, mouseY, mouseButton);
}

void cellRevealed(int row, int col) {
  grid.reveal(row, col);
  if (grid.isWon()) {
    winningState = true;
  }
}
