class Curve{
  ArrayList<PVector> points;
  color c;
  public Curve(float index) {
    points = new ArrayList<PVector>();
    
    this.c = color(index, 100, 100);
  }
  
  public void addPoint(float x, float y) {
    points.add(new PVector(x, y));
  }
  
  public void draw() {
    stroke(c);
    strokeWeight(2);
    noFill();
    beginShape();
    for(PVector p:points) {
      vertex(p.x, p.y);
    }
    endShape();
  }
  
  public void reset() {
    points.clear();
  }
  

}
