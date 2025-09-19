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
    if (isRevealed) {
      if (isCauseOfLosing)
        fill(255, 0, 0, 50);
      else
        fill(0, 0, 0, 15);

      rect(x, y, w, h);
      if (hasMine) {
        drawMine();
      } else {
        drawNeighbors();
      }
      if (hasFlag)
        drawFlag();
    } else {
      noFill();
      stroke(0);
      rect(x, y, w, h);
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
    int fifth = min(w / 5, h / 5);
    int third = min(w / 3, h / 3);
    int half = min(w / 2, h /2);
    noStroke();
    fill(255, 0, 0);
    triangle(x+fifth, y+fifth, x+w-third, y+(half / 2), x+fifth, y+half);
    stroke(0);
    strokeWeight(2);
    fill(0);
    line(x + fifth, y + fifth, x + fifth, y + h - fifth);
    strokeWeight(1);
  }

  void onMousePressed(int mX, int mY, int mB) {
    if (!(mX >= x && mX < x + w &&mY >= y && mY < y + h)) {
      // Twas not on me
      return;
    }

    if (mB == LEFT) {

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
    } else if (mB == RIGHT) {
      if (!isRevealed) {
        hasFlag = !hasFlag;
      }
    }
  }
}
