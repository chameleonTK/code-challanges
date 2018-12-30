float cx = width/2;
float cy = height/2;

float WEIGHT_SCALE = 1;
float LENGTH_SCALE = 100;
float dt = 1.0/60.0;

float g = 9.8;
float W = 20;

DoublePendulum[] dp = new DoublePendulum[20];

void setup() {
  size(600, 600);
  
  cx = width/2;
  cy = 100;
  
  for(int i=0; i< 10; i++) {
    SimplePendulum o = new SimplePendulum(10, 1, (i*5+10)*PI/90);
    dp[i] = new DoublePendulum(o, 10, 1, 0); 
  }
}

void showLine() {
  for(int i=0; i< 10; i++) {
    dp[i].showLine = true;
  }
}

void noLine() {
  for(int i=0; i< 10; i++) {
    dp[i].showLine = false;
  }
}

void draw() {
  background(255);
  translate(cx, cy);
  scale(1, -1);
  stroke(0);
  strokeWeight(2);
 
  for(int i=0; i< 10; i++) {
    dp[i].move();
    dp[i].drawWithTracking();
  }
}

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

class DoublePendulum extends SimplePendulum{
  public float M, L, theta, x, y, w, a;
  public color mycolor;
  private SimplePendulum s;
  public boolean showLine = true;
  public DoublePendulum(SimplePendulum s, float M, float L, float theta) {
    super(s.M, s.L, s.theta);
    
    this.M = M;
    this.L = L;
    this.theta = theta;
    this.w = 0;
    this.s = s;
    this.mycolor = color((int)random(255), (int)random(255), (int)random(255));
  }
  
  public void calculate() {
    s.calculate();
    this.px = this.x;
    this.py = this.y;
    
    this.x = s.x + L*LENGTH_SCALE * sin(theta);
    this.y = s.y - L*LENGTH_SCALE * cos(theta);
  }
  
  public void move() {    
    float w1 = s.w;
    float theta1 = s.theta;

    float w2 = w;
    float theta2 = theta;
    
    float a_w1 = calDw1(w1, w2, theta1, theta2);
    float a_w2 = calDw2(w1, w2, theta1, theta2);
    float a_theta1 = calDTheta1(w1, w2, theta1, theta2);
    float a_theta2 = calDTheta2(w1, w2, theta1, theta2);
    
    float b_w1 = calDw1(w1 + 0.5*dt*a_w1, w2 + 0.5*dt*a_w2, theta1 + 0.5*dt*a_theta1, theta2 + 0.5*dt*a_theta2);
    float b_w2 = calDw2(w1 + 0.5*dt*a_w1, w2 + 0.5*dt*a_w2, theta1 + 0.5*dt*a_theta1, theta2 + 0.5*dt*a_theta2);
    float b_theta1 = calDTheta1(w1 + 0.5*dt*a_w1, w2 + 0.5*dt*a_w2, theta1 + 0.5*dt*a_theta1, theta2 + 0.5*dt*a_theta2);
    float b_theta2 = calDTheta2(w1 + 0.5*dt*a_w1, w2 + 0.5*dt*a_w2, theta1 + 0.5*dt*a_theta1, theta2 + 0.5*dt*a_theta2);
    
    float c_w1 = calDw1(w1 + 0.5*dt*b_w1, w2 + 0.5*dt*b_w2, theta1 + 0.5*dt*b_theta1, theta2 + 0.5*dt*b_theta2);
    float c_w2 = calDw2(w1 + 0.5*dt*b_w1, w2 + 0.5*dt*b_w2, theta1 + 0.5*dt*b_theta1, theta2 + 0.5*dt*b_theta2);
    float c_theta1 = calDTheta1(w1 + 0.5*dt*b_w1, w2 + 0.5*dt*b_w2, theta1 + 0.5*dt*b_theta1, theta2 + 0.5*dt*b_theta2);
    float c_theta2 = calDTheta2(w1 + 0.5*dt*b_w1, w2 + 0.5*dt*b_w2, theta1 + 0.5*dt*b_theta1, theta2 + 0.5*dt*b_theta2);
    
    float d_w1 = calDw1(w1 + dt*c_w1, w2 + dt*c_w2, theta1 + dt*c_theta1, theta2 + dt*c_theta2);
    float d_w2 = calDw2(w1 + dt*c_w1, w2 + dt*c_w2, theta1 + dt*c_theta1, theta2 + dt*c_theta2);
    float d_theta1 = calDTheta1(w1 + dt*c_w1, w2 + dt*c_w2, theta1 + dt*c_theta1, theta2 + dt*c_theta2);
    float d_theta2 = calDTheta2(w1 + dt*c_w1, w2 + dt*c_w2, theta1 + dt*c_theta1, theta2 + dt*c_theta2);
    
    w1 = w1 + (dt/6.0) * (a_w1+2*b_w1+2*c_w1+d_w1);
    w2 = w2 + (dt/6.0) * (a_w2+2*b_w2+2*c_w2+d_w2);
    theta1 = theta1 + (dt/6.0) * (a_theta1+2*b_theta1+2*c_theta1+d_theta1);
    theta2 = theta2 + (dt/6.0) * (a_theta2+2*b_theta2+2*c_theta2+d_theta2);
    
    s.w = w1;
    this.w = w2;
    s.theta = theta1;
    this.theta = theta2;
  }
  
  public float calDTheta1(float w1, float w2, float theta1, float theta2) {
    return w1;
  }
  
  public float calDTheta2(float w1, float w2, float theta1, float theta2) {
    return w2;
  }
  
  public float calDw1(float w1, float w2, float theta1, float theta2) {
    float M1 = s.M;
    float L1 = s.L;
    float M2 = M;
    float L2 = L;
    
    float num1 = (-1)*g*(2*M1 + M2) * sin(theta1);
    float num2 = (-1)*M2*g*sin(theta1 - 2*theta2) ;
    float num3 = (-1)*2*sin(theta1 - theta2)*M2;
    float num4 = (w2*w2*L2 + w1*w1*L1*cos(theta1 - theta2));
    float div = (2*M1 + M2 - M2*cos(2*theta1 - 2*theta2));
    
    return (num1+num2+num3*num4) / (L1*div);
  }
  
  public float calDw2(float w1, float w2, float theta1, float theta2) {
    float M1 = s.M;
    float L1 = s.L;
    float M2 = M;
    float L2 = L;
    
    float num5 = w1*w1*L1*(M1+M2);
    float num6 = g*(M1+M2)*cos(theta1);
    float num7 = w2*w2*L2*M2*cos(theta1-theta2);
    float num8 = 2*sin(theta1 - theta2);
    
    float div = (2*M1 + M2 - M2*cos(2*theta1 - 2*theta2));
    return num8*(num5+num6+num7) / (L2*div);
  }
  
  public void draw() {
    
    this.calculate();
    if (showLine) {
      s.draw();
      line(s.x, s.y, this.x, this.y);
    }
    
    fill(mycolor);
    ellipse(x, y, W, W);
  }
  
  public void drawWithTracking() {
    
    //image(pg, 0, 0);
    this.draw();
    //pg.beginDraw();
    //pg.translate(cx, cy);
    //pg.scale(1, -1);
    //strokeWeight(1);
    //if (frameCount > 1) {
    //  pg.line(this.px, this.py, this.x, this.y);
    //}
    //pg.endDraw();
  }
}