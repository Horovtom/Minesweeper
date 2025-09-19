class Grid {
  int x, y, w, h;
  int size;
  int cellSize;
  Cell[][] grid;

  Grid(int size, int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.size = size;
    this.grid = new Cell[size][size];
    this.cellSize = min(w / size, h / size);

    grid = new Cell[size][size];

    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        set(row, col, new Cell(row, col, x +row * cellSize, y + col * cellSize, cellSize, cellSize));
      }
    }
  }

  void generateMines(int mineCount) {
    for (int i = 0; i < mineCount; i++) {
      // Inefficient. Who cares
      int row, col;
      while (true) {
        row = int(random(size));
        col = int(random(size));
        if (!get(row, col).hasMine)
          break;
      }
      get(row, col).hasMine = true;
    }
    computeNeighbors();
  }

  void computeNeighbors() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        Cell cell = get(row, col);
        if (cell.hasMine)
          cell.neighbors = -1;
        else {
          int neighbors = 0;
          for (int i = -1; i < 2; i++) {
            for (int j = -1; j < 2; j++) {
              int neighRow = row + i;
              int neighCol = col + j;
              if (neighRow >=0 && neighRow < size && neighCol >= 0 && neighCol < size) {
                if (get(neighRow, neighCol).hasMine)
                  neighbors++;
              }
            }
          }
          cell.neighbors = neighbors;
        }
      }
    }
  }

  Cell get(int row, int col) {
    if (row < 0 || col < 0 || row >= size || col >= size)
      return null;
    return grid[row][col];
  }

  void set(int row, int col, Cell cell) {
    if (row < 0 || col < 0 || row >= size || col >= size)
      return;
    grid[row][col] = cell;
  }

  void display() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        get(row, col).display();
      }
    }
  }

  void onMousePressed(int mX, int mY, int mB) {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        get(row, col).onMousePressed(mX, mY, mB);
      }
    }
  }

  void revealAll() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        get(row, col).isRevealed = true;
      }
    }
  }

  void reveal(int row, int col) {
    Cell cell = get(row, col);
    if (cell == null || cell.isRevealed)
      return;
    cell.isRevealed = true;
    score++;

    if (cell.neighbors == 0) {
      for (int i = -1; i < 2; i++)
        for (int j = -1; j < 2; j++)
          reveal(row + i, col + j);
    } else {
      revealIfZero(row -1, col);
      revealIfZero(row +1, col);
      revealIfZero(row, col-1);
      revealIfZero(row, col+1);
    }
  }

  void revealIfZero(int row, int col) {
    Cell cell = get(row, col);
    if (cell == null || cell.isRevealed || cell.neighbors != 0)
      return;
    reveal(row, col);
  }

  boolean isWon() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        Cell cell = get(row, col);
        if (!(cell.hasMine || cell.isRevealed))
          return false;
      }
    }
    return true;
  }
}
