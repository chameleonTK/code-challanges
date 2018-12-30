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
  cy = 200;
  
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
