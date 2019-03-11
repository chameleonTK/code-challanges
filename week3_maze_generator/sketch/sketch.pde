


int n = 10;
float offset = 50;
Cell[][] cells = new Cell[n][n];
Generator generator;
Generator kruskal, wilson, eller, prim;

public enum Direction{
  VERTICAL,
  HORIZONTAL,
  UP,
  DOWN,
  LEFT,
  RIGHT
}

void setup() {
  size(800, 800);
  float size = min((width-offset)/n, (height-offset)/n);
  
  for (int i=0; i<n; i++) {
    cells[i] = new Cell[n];
    for (int j=0; j<n; j++) {
      cells[i][j] = new Cell(i*n + j, i, j, size);
    }
  }
  
  kruskal = new KruskalMethod(cells);
  wilson = new WilsonMethod(cells);
  eller = new EllerMethod(cells);
  prim = new PrimMethod(cells);
  generator = prim;
  
  useKruskal();
}

void useKruskal() {
  generator.reset();
  generator = kruskal;
  generator.reset();
}

void useWilson() {
  generator.reset();
  generator = wilson;
  generator.reset();
}

void useEller() {
  generator.reset();
  generator = eller;
  generator.reset();
}

void usePrim() {
  generator.reset();
  generator = prim;
  generator.reset();
}

void draw() {
   generator.run(); 
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      cells[i][j].drawBackground(offset);
    }
  }
  
  int c = 190;
  fill( c, c, c);
  strokeWeight(2);
  stroke(0);
  noFill();
  rect(offset/2, offset/2, width-offset, height-offset);
  
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      cells[i][j].drawBorder(offset);
    }
  }
  
  delay(100);
}

// void mouseClicked() {
// generator.reset();
//}

abstract class Generator {
  abstract void run();
  abstract void reset();
}


class Cell{
  int x, y;
  int index;
  float size;

  boolean visited, hideLeft, hideTop;
  color c;
  public Cell(int index, int x, int y, float size) {
    this.index = index;
    this.x = x;
    this.y = y;
    this.size = size;
    this.visited = false;
    this.hideLeft = false;
    this.hideTop = false;
    this.c = color(190, 190, 190);
  }
  
  public void drawBorder(float offset) {
    stroke(0);
    strokeWeight(2);
    float px = this.x*size+offset/2;
    float py = this.y*size+offset/2;
    if (!hideTop) {
      line(px, py, px+size, py);
    }
    
    if (!hideLeft) {
      line(px, py, px, py+size);
    }
  }
  
  public void drawBackground(float offset) {
    if (this.visited) {
      fill(255, 255, 255);
    } else {
      fill(this.c);
    }
    
    noStroke();
    rect(this.x*size+offset/2, this.y*size+offset/2, size, size);
  }

}

class EllerMethod extends Generator{
  Cell[][] cells;
  int row, col;
  boolean done = false;
  
  public EllerMethod(Cell[][] cells) {
    this.cells = cells;
    this.reset();
  }
  
  public void run() {
    if (done) {
      return;
    }
    
    if (col < n) {
      horizontalConnect();
      col++;
    } else {
      if (row+1 < n) {
        verticalConnect();
      }
      
      for(int i=0; i<n; i++) {
        Cell now = this.cells[i][row];
        now.visited = true;
      }
      col = 0;
      row++;
    }
    
    if (row >= n) {
      finalise();
      done = true;
    }
  }
  
  public void horizontalConnect() {
    Cell now = this.cells[col][row];
    now.c = color(251, 251, 202);
    
    int d = (int) random(100);
    if (d%2==0) {
      now.hideLeft = true;
      if (col!=0) {
        if (this.cells[col-1][row].index < now.index) {
          now.index = this.cells[col-1][row].index;  
        } else {
          this.cells[col-1][row].index = now.index;
        }
        
      }
    }
  }
  
  public void verticalConnect() {
    HashMap<Integer, Boolean> hasConnection = new HashMap<Integer, Boolean>();
    for(int i=0; i<n; i++) {
      Cell now = this.cells[i][row];
      hasConnection.put(now.index, false);
    }
    //Randomly create vertical connections
    for(int i=0; i<n; i++) {
      int d = (int) random(100);
      if (d%2==0) {
        this.cells[i][row+1].hideTop = true;
        this.cells[i][row+1].index = this.cells[i][row].index;
        hasConnection.put(this.cells[i][row+1].index, true);
      }
    }
    
    //Make sure that at least one vertical connection for each set;
    for(Integer index: hasConnection.keySet()) {
        boolean connected = hasConnection.get(index);
        if (!connected) {
          int count = 0;
          for(int i=0; i<n; i++) {
            Cell now = this.cells[i][row];
            if (now.index == index) {
              count++;
            }
          }
          
          int d = (int) random(count);
          count = 0;
          for(int i=0; i<n; i++) {
            Cell now = this.cells[i][row];
            if (now.index == index && count == d) {
              this.cells[i][row+1].hideTop = true;
              this.cells[i][row+1].index = this.cells[i][row].index;
              break;
            }
            if (now.index == index) {
              count++;
            }
          }
        }
     }
  }
  
  public void finalise() {
    for(int i=0; i<n-1; i++) {
      Cell now = this.cells[i][n-1];
      Cell sibling = this.cells[i+1][n-1];
      if (now.index != sibling.index) {
        int rm = sibling.index;
        sibling.hideLeft = true;
        sibling.index = now.index;
        for(int j=i+1; j<n; j++) {
          if (this.cells[i][n-1].index == rm) {
            this.cells[i][n-1].index = now.index;
          }
        }
      }
    }
  }
  public void reset() {
    row = 0;
    col = 0;
    
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        cells[i][j].index = i*n + j;
        cells[i][j].visited = false;
        cells[i][j].hideLeft = false;
        cells[i][j].hideTop = false;
        cells[i][j].c = color(190, 190, 190);
      }
    }
    
    this.done = false;
  }
  
  
  //public void debug() {
  //  for (int i=0; i<n; i++) {
  //    for (int j=0; j<n; j++) {
  //      this.run();
  //    }
  //  }
    
  //  for(int j=0; j<n; j++) {
  //    for(int i=0; i<n; i++) {
  //      Cell now = this.cells[i][j];
  //      if (now.index > 10) {
  //        System.out.print(now.index+"  ");
  //      } else {
  //        System.out.print(now.index+"   ");
  //      }
        
  //    }
  //    System.out.println();
  //  }
  //}
}




class PrimMethod extends Generator{
  PriorityQueue<Node> frontier;
  Cell[][] cells;
  ArrayList<Direction> direction;
  public PrimMethod(Cell[][] cells) {
    this.cells = cells;
    
    Comparator<Node> cmp = new Comparator<Node>() {
        @Override
        public int compare(Node s1, Node s2) {
            return (int)(s1.priority - s2.priority);
        }
    };
    frontier = new PriorityQueue<Node>(cmp);
    direction = new ArrayList<Direction>();
    direction.add(Direction.UP);
    direction.add(Direction.DOWN);
    direction.add(Direction.LEFT);
    direction.add(Direction.RIGHT);
    this.reset();
  }
  
  public void run() {
    if (frontier.size() <= 0) {
      return;
    }
    
    Node n = frontier.remove();
    while(cells[n.x][n.y].visited) {
      if (frontier.size() <= 0) {
        return;
      }
      n = frontier.remove();
    }
    
    Collections.shuffle(direction);
    for(Direction d: direction) {
      Cell c = null;
      switch(d){
        case LEFT:
          c = getCell(n.x-1, n.y);
          break;
        case RIGHT:
          c = getCell(n.x+1, n.y);
          break;
        case UP:
          c = getCell(n.x, n.y-1);
          break;
        case DOWN:
          c = getCell(n.x, n.y+1);
          break;
        default:
          break;
      }
      
      if (c == null) {
        continue;
      }
      
      if (!c.visited) {
        continue;
      }
      
      switch(d){
        case LEFT:
          cells[n.x][n.y].hideLeft = true;
          break;
        case RIGHT:
          cells[n.x+1][n.y].hideLeft = true;
          break;
        case UP:
          cells[n.x][n.y].hideTop = true;
          break;
        case DOWN:
          cells[n.x][n.y+1].hideTop = true;
          break;
        default:
          break;
      }
      break;
    }
    
    cells[n.x][n.y].visited = true;
    addNeighbors(n.x, n.y);
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
  
  public void addNeighbors(int x, int y) {
    Cell a; 
    a = getCell(x-1, y);
    if (a != null && !a.visited) {
      a.c = color(255, 221, 221);
      frontier.add(new Node(x-1, y, random(100)));  
    }
    
    a = getCell(x+1, y);
    if (a != null && !a.visited) {
      a.c = color(255, 221, 221);
      frontier.add(new Node(x+1, y, random(100)));  
    }
    
    a = getCell(x, y+1);
    if (a != null && !a.visited) {
      a.c = color(255, 221, 221);
      frontier.add(new Node(x, y+1, random(100)));  
    }
    
    a = getCell(x, y-1);
    if (a != null && !a.visited) {
      a.c = color(255, 221, 221);
      frontier.add(new Node(x, y-1, random(100)));  
    }
  }
  
  public void reset() {
    frontier.clear();
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        cells[i][j].index = i*n + j;
        cells[i][j].visited = false;
        cells[i][j].hideLeft = false;
        cells[i][j].hideTop = false;
        cells[i][j].c = color(190, 190, 190);
      }
    }
    
    int init = (int) random(n*n);
    int x = init % n;
    int y = (int)(init / n);
    cells[x][y].visited = true;
    addNeighbors(x, y);
  }
}

class Node{
  int x, y;
  float priority;
  public Node(int x, int y, float d) {
    this.x = x;
    this.y = y;
    this.priority = d;
  }
}


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



class Edge{
  int x, y;
  Direction d;
  public Edge(int x, int y, Direction d) {
    this.x = x;
    this.y = y;
    this.d = d;
  }
}


class KruskalMethod extends Generator{
  Cell[][] cells;
  ArrayList<ArrayList<Cell>> setIndex;
  ArrayList<Edge> edges;
  int bigestSet = 1;
  public KruskalMethod(Cell[][] cells) {
    this.cells = cells;
    this.reset();
  }
  
  public Edge next() {
    Cell a = null;
    Cell b = null;
    Edge e;
    do {
      e = edges.remove(0);
      int x = e.x;
      int y = e.y;
      a = this.cells[x][y];
      b = null;
      if (e.d.equals(Direction.HORIZONTAL)) {
        b = this.cells[x+1][y];        
      } else {
        b = this.cells[x][y+1];
      }
    } while(a.index==b.index);
    
    return e;
  }
  
  public void run() {
      if (this.bigestSet >= setIndex.size()) {
        return;
      }
      
      Edge e = next();
      Cell a, b;
      int x = e.x;
      int y = e.y;
      a = this.cells[x][y];
      b = null;
      if (e.d.equals(Direction.HORIZONTAL)) {
        b = this.cells[x+1][y];        
      } else {
        b = this.cells[x][y+1];
      }
      
      if (a.index != b.index) {
        a.visited = true;
        b.visited = true;
        if (e.d.equals(Direction.HORIZONTAL)) {
          b.hideLeft = true;
        } else {
          b.hideTop = true;
        }
        
        this.bigestSet = setIndex.get(a.index).size() + setIndex.get(b.index).size();
        
        
        //System.out.println("Before "+setIndex.get(a.index).size() +" "+setIndex.get(b.index).size());
        if (setIndex.get(a.index).size() > setIndex.get(b.index).size()) {
          ArrayList<Cell> bigger = setIndex.get(a.index);
          for (Cell c: setIndex.get(b.index)) {
            c.index = a.index;
            bigger.add(c);
          }
          
          setIndex.set(b.index, bigger);
        } else {
          ArrayList<Cell> bigger = setIndex.get(b.index);
          for (Cell c: setIndex.get(a.index)) {
            c.index = b.index;
            bigger.add(c);
          }
          
          setIndex.set(a.index, bigger);
        }
        
        //System.out.println("After "+setIndex.get(a.index).size() +" "+setIndex.get(b.index).size());
      }
  }
  
  public void reset() {
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        cells[i][j].index = i*n + j;
        
        cells[i][j].visited = false;
        cells[i][j].hideLeft = false;
        cells[i][j].hideTop = false;
        cells[i][j].c = color(190, 190, 190);
      }
    }
    
    this.bigestSet = 1;
    setIndex = new ArrayList<ArrayList<Cell>>();
    edges = new ArrayList<Edge>();
    
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        ArrayList<Cell> tmp = new ArrayList<Cell>();
        cells[i][j].index = i*n + j;
        tmp.add(cells[i][j]);
        setIndex.add(tmp);
      }
    }
    
    edges.clear();
    for (int i=0; i<n-1; i++) {
      for (int j=0; j<n; j++) {
        edges.add(new Edge(i, j, Direction.HORIZONTAL));
      }
    }
    
    for (int i=0; i<n; i++) {
      for (int j=0; j<n-1; j++) {
        edges.add(new Edge(i, j, Direction.VERTICAL));
      }
    }
    Collections.shuffle(edges);  
  }
}
