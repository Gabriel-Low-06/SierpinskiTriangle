void setup() {
  size(800, 800);
}

void sierpinski(int x, int y, int lens, int end, int direction) {
  if (lens<=end) {
    triangle(x, y, x+(lens*direction), y, x+(lens*direction/2), y+(lens*direction));
  } else {
    sierpinski(x, y, lens/2, end, direction);
    sierpinski(x+(lens*direction/2), y, lens/2, end, direction);
    sierpinski(x+(lens*direction/4), y+(direction*lens/2), lens/2, end, direction);
  }
}

void draw() {
  //loop every two seconds
  float timekeeper=millis()/2;
  fill(105, 105, 255, 50);
  rect(0, 0, 800, 800);
  pushMatrix();
  float time=(timekeeper%2000/200);
  translate(400,400);
  scale(((float)(timekeeper%2000)*.0005)+1);
  scale(1);
  rotate(timekeeper%2000*PI*.0015);
  translate(-400,-400);
  translate(0,timekeeper%2000/10);
  stroke(255,255,255);
  sierpinski(0, 0, 800, constrain((int)pow(2, time), 5, 10000),1);
  sierpinski(600,400,400,constrain((int)pow(2, (10-time)), 5, 10000),-1);
  popMatrix();
}
