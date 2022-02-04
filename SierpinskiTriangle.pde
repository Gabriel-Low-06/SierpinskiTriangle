void setup() {
  size(800, 800, P3D);
  speed=1;
  for (int q=0; q<openrocks.length; q++) {
    openrocks[q]=new Asteroid(false);
  }
}
float speed;
float timekeeper;
int oldmill=0;
Asteroid[] openrocks = new Asteroid[7]; //declare asteroids and stars

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
  float crunchspeed = 1-((1-speed)*.35);
  if (mousePressed) {
    speed+=.003;
  } else {
    speed*=.99;
  }
  //background(105/crunchspeed, 105/crunchspeed, 255/crunchspeed, 50);
  fill(105/crunchspeed, 105/crunchspeed, 255/crunchspeed, 55);
  pushMatrix();
  translate(400, 400, -10);
  box(850, 850, 1);
  popMatrix();
  pushMatrix();
  float time=(timekeeper%2000/200);
  translate(400, 400);
  scale(((float)(timekeeper%2000)*.0005)+1);
  rotate(timekeeper%2000*PI*.0015);
  translate(-400, -400 + (timekeeper%2000/10));
  stroke(255, 255, 255);
  strokeWeight(1);
  sierpinski(0, 0, 800, constrain((int)pow(2, time), 10, 10000), 1);
  sierpinski(600, 400, 400, constrain((int)pow(2, (10-time)), 10, 10000), -1);
  popMatrix();
  noFill();
  for (int q=0; q<openrocks.length; q++) {
    if (speed<300) {
      openrocks[q].paint(); //draw asteroids
    }
    if (openrocks[q].coordinates[2]>500) { //respawn
      openrocks[q]=new Asteroid(true);
    }
  }
}
class Asteroid { 
  int[] coordinates=new int[3]; //self-explanatory local variable declaration
  int[]velocity = {0, 0, (int)speed};
  float[] torque = new float[3];
  float[]spin = new float[3];
  int[] config = new int[3];  
  Asteroid(boolean far) {
    int[] loadcon = {(int)(random(20, 180)), (int)(random(20, 180)), (int)(random(20, 180))};
    float[] loadrot = {random(0, 8), random(0, 8), random(0, 8)};
    float[] loadtor = {random(-.1, .1), random(-.1, .1), random(-.1, .1)};
    int[] loadcoord = {(int)(random(0, 800)), (int)(random(0, 800)), (int)(random(-100, 0))};
    if (far==true) { //if its respawning, respawn in middle
      loadcoord[2]=(int)random(-100, -150);
    }
    spin=loadrot; //initalize variables from randomly generated
    torque=loadtor;
    coordinates=loadcoord;
    config=loadcon;
    velocity[2]=(int)speed*10;
  }
  void paint() {
    if(speed>1){
    velocity[2]=(int)speed*10; //update velocity based on global speed
    pushMatrix();
    translate(coordinates[0], coordinates[1], coordinates[2]); //move asteroid to location in 3d space
    rotateX(spin[0]); 
    rotateY(spin[1]);//rotate accordingly
    rotateZ(spin[2]);
    for (int i=0; i<3; i++) { //update position and coordinates based on velocity and torque
      spin[i]+=torque[i]/5;
      coordinates[i]+=velocity[i];
    }
    strokeWeight(5);
    box(config[0],config[2],config[1]); //draw asteroid
    popMatrix();
  }
  }
}
