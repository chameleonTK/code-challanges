
int n = 10;
float offset = 200;
Cell[][] cells = new Cell[n][n];
Generator generator;
Generator kruskal, wilson, eller, prim;
float size;
public enum Direction{
  VERTICAL,
  HORIZONTAL,
  UP,
  DOWN,
  LEFT,
  RIGHT
}

void setup() {
  size(1800, 1000);
  
  size = min((width-offset)/n, (height-offset)/n);
  
  for (int i=0; i<n; i++) {
    cells[i] = new Cell[n];
    for (int j=0; j<n; j++) {
      cells[i][j] = new Cell(i*n + j, i, j, size);
    }
  }
  
  kruskal = new KruskalMethod(cells);
  wilson = new WilsonMethod(cells);
  eller = new EllerMethod(cells);
  prim = new PrimMethod(cells);
  generator = prim;
  
  useKruskal();
}

void useKruskal() {
  generator.reset();
  generator = kruskal;
  generator.reset();
}

void useWilson() {
  generator.reset();
  generator = wilson;
  generator.reset();
}

void useEller() {
  generator.reset();
  generator = eller;
  generator.reset();
}

void usePrim() {
  generator.reset();
  generator = prim;
  generator.reset();
}

void draw() {
  translate(400, 0);
   generator.run(); 
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      cells[i][j].drawBackground(offset);
    }
  }
  
  int c = 190;
  fill( c, c, c);
  strokeWeight(2);
  stroke(0);
  noFill();
  rect(offset/2, offset/2, offset/2+((n-1)*size)-n*2, offset/2+((n-1)*size)-n*2);
  
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      cells[i][j].drawBorder(offset);
    }
  }
  
  delay(100);
}

void mouseClicked() {
 generator.reset();
}

void keyPressed() {
  if (key=='1') {
    useKruskal();
  } else if (key=='2') {
    useWilson();
  } else if (key=='3') {
    useEller();
  } else if (key=='4') {
    usePrim();
  } else {
    generator.reset();
  }
  System.out.println(key);
}
