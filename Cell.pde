class Cell {
  int x, y, w, h;
  boolean hasMine = false;
  int neighbors = 0;
  boolean isRevealed = false;
  boolean hasFlag = false;
  boolean isCauseOfLosing = false;


  Cell(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    noFill();
    stroke(0);
    rect(x, y, w, h);

    if (isRevealed) {
      fill(0, 0, 0, 15);
      rect(x, y, w, h);
      if (hasMine) {
        drawMine();
      } else {
        drawNeighbors();
      }
    } else {
      if (hasFlag) {
        drawFlag();
      }
    }
  }

  void drawMine() {
    fill(0);
    int third = min(w/3, h/3);
    int fifth = min(w / 4, h / 4);
    circle(x + w / 2, y + h / 2, 2 * third);
    strokeWeight(5);
    line(x + fifth, y + fifth, x + w - fifth, y + h - fifth);
    line(x + w - fifth, y + fifth, x + fifth, y + h - fifth);
    strokeWeight(1);
  }

  void drawNeighbors() {
    fill(0);
    textSize( 2 * h / 3);
    textAlign(CENTER, CENTER);
    text(neighbors, x + w / 2, y + h / 2);
  }

  void drawFlag() {
    stroke(0);
    line(x + 3, y + 3, x + 3, y + h - 3);
    noStroke();
    fill(255, 0, 0);
    triangle(x+3, y+3, x+w-3, y+(h/3) / 2, x+3, y+h/3);
  }

  void onMousePressed(int mX, int mY, int mB) {
    if (!(mX >= x && mX < x + w &&mY >= y && mY < y + h)) {
      // Twas not on me
      return;
    }

    if (isRevealed || hasFlag) {
      // Does not do anything
      return;
    }

    isRevealed = true;
    if (hasMine) {
      isCauseOfLosing = true;
      gameLost(mX, mY, mB);
    } else {
      cellRevealed();
    }
  }
}
