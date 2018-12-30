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
