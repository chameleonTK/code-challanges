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
