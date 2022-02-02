void setup() {
  size(800, 800, P3D);
  speed=1;
  for (int q=0; q<15; q++) {
    openrocks[q]=new Asteroid(false);
  }
}
float speed;
float timekeeper;
int oldmill=0;
Asteroid[] openrocks = new Asteroid[15]; //declare asteroids and stars

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
  timekeeper+=speed*(millis()-oldmill);
  oldmill=millis();
  //timekeeper=timekeeper%2000;
  float crunchspeed = 1-((1-speed)*.2);
  if (mousePressed)
    speed+=.003;
  else
    speed*=.98;
  fill(105*(1/crunchspeed), 105*(1/crunchspeed), 255*(1/crunchspeed), 50);
  rect(0, 0, 800, 800);
  pushMatrix();
  float time=(timekeeper%2000/200);
  translate(400, 400);
  scale(((float)(timekeeper%2000)*.0005)+1);
  scale(1);
  rotate(timekeeper%2000*PI*.0015);
  translate(-400, -400);
  translate(0, timekeeper%2000/10);
  stroke(255, 255, 255);
  strokeWeight(1);
  sierpinski(0, 0, 800, constrain((int)pow(2, time), 5, 10000), 1);
  sierpinski(600, 400, 400, constrain((int)pow(2, (10-time)), 5, 10000), -1);
  popMatrix();
  noFill();
  for (int q=0; q<15; q++) {
    if (speed<300) {
      openrocks[q].paint(); //draw asteroids
    }
    if (openrocks[q].coordinates[2]>500) {
      openrocks[q]=new Asteroid(true);
    }
  }
}


class Asteroid { 
  int[] coordinates=new int[3]; //self-explanatory local variable declaration
  int[]velocity = {0, 0, (int)speed};
  float[] torque = new float[3];
  float[]spin = new float[3];
  int shade;
  int[] config = new int[3];  

  Asteroid(boolean far) {
    shade=(int)(random(50, 200)); //give asteroid random color, setup, rotation
    int[] loadcon = {(int)(random(50, 200)), (int)(random(50, 200)), (int)(random(50, 200))};
    float[] loadrot = {random(0, 8), random(0, 8), random(0, 8)};
    float[] loadtor = {random(-.1, .1), random(-.1, .1), random(-.1, .1)};

    int[] loadcoord = {(int)(random(0, 1200)), (int)(random(0, 800)), (int)(random(-5000, 0))};
    if (far==true) { //if its respawning, respawn in middle
      loadcoord[2]=(int)random(-7000, -6000);
    }
    spin=loadrot; //initalize variables from randomly generated
    torque=loadtor;
    coordinates=loadcoord;
    config=loadcon;
  }
  void paint() {

    velocity[2]=(int)speed*10; //update velocity based on global speed
    pushMatrix();
    strokeWeight(1);
    translate(coordinates[0], coordinates[1], coordinates[2]); //move asteroid to location in 3d space
    rotateX(spin[0]); 
    rotateY(spin[1]);//rotate accordingly
    rotateZ(spin[2]);
    for (int i=0; i<3; i++) { //update position and coordinates based on velocity and torque
      spin[i]+=torque[i]/5;
      coordinates[i]+=velocity[i];
    }
    //fill(shade, shade, shade);
    strokeWeight(5);
    sphereDetail(7); //control resolution of asteroid
    box(config[0],config[2],config[1]); //draw asteroid
    popMatrix();
  }
}


