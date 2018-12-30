class Curve{
  //ArrayList<PVector> points;
  color c;
  
  PVector prev, curr;
  public Curve(float index) {
    //points = new ArrayList<PVector>();
    this.c = color(index, 100, 100);
  }
  
  public void addPoint(float x, float y) {
    prev = curr;
    curr = new PVector(x, y);
  }
  
  public void draw(PGraphics pg) {
    //stroke(c);
    //strokeWeight(2);
    //noFill();
    //beginShape();
    //for(PVector p:points) {
    //  vertex(p.x, p.y);
    //}
    //endShape();
    pg.stroke(c);
    if (prev != null && curr != null) {
      pg.line(prev.x, prev.y, curr.x, curr.y);
    }
    
  }
  
  public void reset() {
    //points.clear();
  }
  

}
