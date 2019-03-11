import java.util.Collections;

import java.util.Map;
import java.util.Iterator;

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
