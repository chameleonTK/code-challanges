import java.util.Collections;
class WilsonMethod extends Generator{
  Cell[][] cells;
  Direction[][] directionTable;
  ArrayList<Integer> order;
  Cell now, start;
  
  public WilsonMethod(Cell[][] cells) {
    this.cells = cells;
    order = new ArrayList<Integer>();
    directionTable = new Direction[cells.length][cells.length];
    this.reset();
  }
  
  public void run() {
    if (this.order.size() <= 0) {
      return;
    }
    
    if (now == null) {
      setupStartPoint();
      return;
    } 
    
    move();
    if (now.visited) {
      addToMaze();
    }
    
    if (start.visited) {
      for (int i=0; i<n; i++) {
        for (int j=0; j<n; j++) {
          if (!cells[i][j].visited) {
            cells[i][j].c = color(190, 190, 190);
          }
        }
      }
      
      now = null;
      start = null;
    }
    
  }
  
  public void setupStartPoint() {
    int x, y;
    while (true) {
      if (order.size() <= 0) {
        return;
      }
      
      int index = order.remove(0);
      x = index % n;
      y = (int)(index / n);
      
      if (!cells[x][y].visited) {
        break;
      }
    }
    
    now = cells[x][y];
    now.c = color(251, 251, 202);
    start = now;
  }
  
  public void move() {
    if (now.visited) {
      return;
    }
    while(true) {
      int d = (int) random(100);
      Cell next = null;
      switch(d%4){
        case 0:
          directionTable[now.x][now.y] = Direction.LEFT;
          next = getCell(now.x-1, now.y);
          break;
        case 1:
          directionTable[now.x][now.y] = Direction.RIGHT;
          next = getCell(now.x+1, now.y);
          break;
        case 2:
          directionTable[now.x][now.y] = Direction.UP;
          next = getCell(now.x, now.y-1);
          break;
        case 3:
          directionTable[now.x][now.y] = Direction.DOWN;
          next = getCell(now.x, now.y+1);
          break;
      }
      
      if (next == null) {
        continue;
      }
      
      now.c = color(255, 221, 221);
      next.c = color(251, 251, 202);
      now = next;
      break;
    }
  }
  
  public void addToMaze() {
    if (start.visited) {
      return;
    }
    
    start.visited = true;
    switch(directionTable[start.x][start.y]){
      case LEFT:
        start.hideLeft = true;
        start = getCell(start.x-1, start.y);
        break;
      case RIGHT:
        start = getCell(start.x+1, start.y);
        start.hideLeft = true;
        break;
      case UP:
        start.hideTop = true;
        start = getCell(start.x, start.y-1);
        break;
      case DOWN:
        start = getCell(start.x, start.y+1);
        start.hideTop = true;
        break;
      default:
        break;
    }
  }
  
  public Cell getCell(int x, int y) {
    if (x<0 || x >= cells.length) {
      return null;
    }
    
    if (y<0 || y >= cells.length) {
      return null;
    }
    
    return cells[x][y];
  }
  
  public void reset() {
    order.clear();
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        cells[i][j].index = i*n + j;
        order.add(i*n + j);
        cells[i][j].visited = false;
        cells[i][j].hideLeft = false;
        cells[i][j].hideTop = false;
        cells[i][j].c = color(190, 190, 190);
      }
    }
    
    now = null;
    start = null;
    Collections.shuffle(order);
    int init = order.remove(0);
    int x = init % n;
    int y = (int)(init / n);
    cells[x][y].visited = true;
  }
}
