
int radious = 100;
int padding = 10;
int margin = 10;

Circle[] axisX;
Circle[] axisY;
Curve[][] curves;

float speed = 0.01;
float theta = 0;
PGraphics pg;
void setup() {
  size(1050, 1050);
  
  axisX = new Circle[(int)(width/radious)];
  axisY = new Circle[(int)(width/radious)];
  curves = new Curve[axisY.length][axisX.length];
  
  int r = radious - padding;
  for (int i=0; i < axisX.length; i++) {
    float itsColor = i*360/axisX.length;
    
    float cx = i*radious + r/2;
    float cy = r/2 + margin;
    axisX[i] = new Circle(itsColor, cx + margin, cy, r, i);
    axisY[i] = new Circle(itsColor, cy, cx + margin, r, i);
  }
  
  for (int j=0; j < axisY.length; j++) {
    for (int i=0; i < axisX.length; i++) {
      float colorX = i*360/axisX.length;
      float colorY = j*360/axisY.length;
      curves[j][i] = new Curve((colorX+colorY)/2);
    }
  }
  
  pg = createGraphics(width, height);
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();
  
}

void draw() {
  colorMode(HSB);
  background(0);
  stroke(0);
  strokeWeight(2);
 
 image(pg, 0, 0);
  for (int i=1; i<axisX.length; i++) {
    axisX[i].draw(theta);
    axisX[i].drawVerticalLine(theta);
  }
  
  for (int j=1; j<axisY.length; j++) {
    axisY[j].draw(theta);
    axisY[j].drawHorinzontalLine(theta);
  }
  
  pg.beginDraw();
  pg.stroke(255);
  for (int j=0; j < axisY.length; j++) {
    for (int i=0; i < axisX.length; i++) {
      curves[j][i].addPoint(axisX[i].px, axisY[j].py);
      curves[j][i].draw(pg);
    }
  }
  
  pg.endDraw();
  
  theta += speed;
  if (theta >= 2*PI || theta<0) {
    //theta = 0;
    speed *= -1;
    
    //for (int j=0; j < axisY.length; j++) {
    //  for (int i=0; i < axisX.length; i++) {
    //    curves[j][i].reset();
    //  }
    //}
    pg.beginDraw();
    pg.background(0);
    pg.endDraw();
  }
}


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
