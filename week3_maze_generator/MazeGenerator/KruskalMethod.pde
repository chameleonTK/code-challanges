import java.util.Collections;
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

class Edge{
  int x, y;
  Direction d;
  public Edge(int x, int y, Direction d) {
    this.x = x;
    this.y = y;
    this.d = d;
  }
}
