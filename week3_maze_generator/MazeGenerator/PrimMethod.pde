import java.util.Collections;
import java.util.PriorityQueue;
import java.util.Comparator;

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
