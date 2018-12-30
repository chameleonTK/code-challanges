class SimplePendulum{
  public float M, L, theta, x, y, w, a;
  PGraphics pg;
  
  protected float px, py;
  
  public SimplePendulum(float M, float L, float theta) {
    this.M = M;
    this.L = L;
    this.theta = theta;
    
    //pg = createGraphics(width, height);
    //pg.beginDraw();
    //pg.background(255);
    //pg.endDraw();
  }
  
  public void calculate() {
    this.px = this.x;
    this.py = this.y;
    
    this.x = L*LENGTH_SCALE * sin(theta);
    this.y = -1 * L*LENGTH_SCALE * cos(theta);
  }
  
  
  
  public void draw() {
    
    line(0, 0, this.x, this.y);
    fill(0);
    ellipse(this.x, this.y, W/2, W/2);
  }
}
