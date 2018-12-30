class Circle{
  float cx, cy, d, r, speed;
  float index;
  color c;
  
  public float px, py;
  public Circle(float index, float cx, float cy, float d, int speed) {
    this.index = index;
    this.cx = cx;
    this.cy = cy;
    this.d = d;
    this.r = d/2;
    this.speed = speed;
    this.c = color(index, 100, 100);
  }
  
  public void calculate(float theta) {
    this.px = cx+r*cos(speed*theta);
    this.py = cy+r*sin(speed*theta);
  }
  
  public void drawPoint(float theta) {
    calculate(theta);
    strokeWeight(8);
    point(px, py);
  }
  
  public void draw(float theta) {
    stroke(this.c);
    strokeWeight(2);
    noFill();
    ellipse(cx, cy, d, d);
  
    drawPoint(theta);
  }
  
  public void drawHorinzontalLine(float theta) {
    calculate(theta);
    
    strokeWeight(1);
    stroke(255, 100);
    line(px, py, width, py);
  }
  
  public void drawVerticalLine(float theta) {
    calculate(theta);
    
    strokeWeight(1);
    stroke(255, 100);
    line(px, py, px, height);
  }
}
