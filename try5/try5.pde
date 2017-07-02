//int start_ripple = 600;
//int stop_ripple =1200;
int col=0;

float j=0.5;
//ripple stuff
import moonlander.library.*;
import ddf.minim.*;
Moonlander moonlander;
double value=0;

//ripple stuff end

//ripple stuff
ArrayList<Circle> drops;
//ripple stuff end

int WIDTH = 1920;
int HEIGHT = 1080;
float ZOOM = 1;
//int num=0;
int N = 500*(int)ZOOM;
//int N = 150*(int)ZOOM;
float RADIUS = HEIGHT/30;
float SPEED = 0.00003;
float FOCAL_LENGTH = 0.5;
float BLUR_AMOUNT = 50;
int MIN_BLUR_LEVELS = 1;
int BLUR_LEVEL_COUNT = 4;
float ZSTEP = 0.015;
color BACKGROUND = color(0, 30, 30);


class ZObject {
  float x, y, z, xsize, ysize;
  color bubble_color;
  color shaded_color;
  float vx, vy, vz;

  ZObject(float ix, float iy, float iz, color icolor) {
    x = ix;
    y = iy;
    z = iz;
    xsize = RADIUS;
    ysize = RADIUS;
    bubble_color = icolor;
    setColor();
    vx = random(-1.0, 1.0);
    vy = random(-1.0, 1.0);
    vz = random(-1.0, 1.0);
    float magnitude = sqrt(vx*vx + vy*vy + vz*vz);
    vx = SPEED * vx / magnitude;
    vy = SPEED * vy / magnitude;
    vz = SPEED * vz / magnitude;
  }

  void setColor() {
    float shade = z;
    float shadeinv = 1.0-shade;
    shaded_color = color( (red(bubble_color)*shade)+(red(BACKGROUND)*shadeinv), 
      (green(bubble_color)*shade)+(green(BACKGROUND)*shadeinv), 
      (blue(bubble_color)*shade)+(blue(BACKGROUND)*shadeinv));
  }

  void zoomIn(float step) {
    z += step;
    if (z > 1.0) {
      z = 0.0 + (z-1.0);
    }
  }

  void zoomOut(float step) {
    z -= step;
    if (z < 0.0) {
      z = 1.0 - (0.0-z);
    }
  }

  void update(boolean doZoomIn, boolean doZoomOut) {
    if (doZoomIn) {
      zoomIn(ZSTEP);
    }
    if (doZoomOut) {
      zoomOut(ZSTEP);
    }
    if (x <= 0) {
      vx = abs(vx);
      x = 0.0f;
    }
    if (x >= 1.0) {
      vx = -1.0 * abs(vx);
      x = 1.0;
    }
    if (y <= 0) {
      vy = abs(vy);
      y = 0.0f;
    }
    if (y >= 1.0) {
      vy = -1.0 * abs(vy);
      y = 1.0;
    }
    if (z < 0 || z > 1.0) {
      z = z % 1.0;
    }
    // float n = (noise(x, y) - 0.5) * 0.00001;
    // vx += n;
    // vy += n;
    x += vx;
    y += vy;
    //z += vz;
    setColor();
    //drops.add(new Circle((int)(randomGaussian()*100+300),(int)(randomGaussian()*100+300), r));
    //drops.add(new Circle((int)(vx),(int)(vy), r));
  }

  void draw(float xoffs, float yoffs) {
    float posX = (ZOOM*x*WIDTH*(1+z*z)) - ZOOM*xoffs*WIDTH*z*z;
    float posY = (ZOOM*y*HEIGHT*(1+z*z)) - ZOOM*yoffs*HEIGHT*z*z;
    float radius = z*xsize;
    if (posX> -xsize*2 && posX < WIDTH+xsize*2 && posY > -xsize*2 && posY < HEIGHT+xsize*2) {
      if ((value<70 && value!=420)) {
        blurred_circle(posX, posY, radius, abs(z-FOCAL_LENGTH), shaded_color, MIN_BLUR_LEVELS + (z*BLUR_LEVEL_COUNT));
      }
    }
    //if (radius<1 && value==1) {
    if (radius<1 && value>20) {
      for (int i=0; i<1; i++) {
        drops.add(new Circle(posX, posY, r-10*i));
      }
    } else if (radius<1 && value>30) {
      for (int i=0; i<1; i++) {
        drops.add(new Circle(posX, posY, r-10*i));
      }
    } else if (radius<1 && value>40 && value<=60) {
      for (int i=0; i<1; i++) {
        drops.add(new Circle(posX, posY, r-10*i));
      }
    }
  }
}

// This function will draw a blurred circle, according to the "blur" parameter. Need to find a good radial gradient algorithm.
void blurred_circle(float x, float y, float rad, float blur, color col, float levels) {
  float level_distance = BLUR_AMOUNT*(blur)/levels;
  for (float i=0.0; i<levels*2; i++) {
    fill(col, 255*(levels*2-i)/(levels*2));

    ellipse(x, y, rad+(i-levels)*level_distance, rad+(i-levels)*level_distance);
  }
}

ArrayList objects;
void sortBubbles() {

  // Sort them (this ensures that they are drawn in the right order)
  float last = 0;
  ArrayList temp = new ArrayList();
  for (int i=0; i<N; i++) {
    int index = 0;
    float lowest = 100.0;
    for (int j=0; j<N; j++) {
      ZObject current = (ZObject)objects.get(j);
      if (current.z < lowest && current.z > last) {
        index = j;
        lowest = current.z;
      }
    }
    temp.add(objects.get(index));
    last = ((ZObject)objects.get(index)).z;
  }
  objects = temp;
}

void setup() {
  frameRate(24);

  //audio stuff  
  moonlander = Moonlander.initWithSoundtrack(this, "yoyo.mp3", 120, 8);
  moonlander.start();



  //size(800, 600);
  fullScreen(P3D);  
  //size(1920, 1080);
  smooth();
  noStroke();

  objects = new ArrayList();
  //Randomly generate the bubbles
  for (int i=0; i<N; i++) {
    objects.add(new ZObject(random(1.0f), random(1.0f), random(1.0f), color(random(20.0, 20.0), random(150.0, 190.0), random(150.0, 190.0))));
  }

  sortBubbles();
  //ripple stuff
  drops=new ArrayList();


  //ripple stuff end

  setupAlive();
  setupDeath();  
}
//ripple stuff
float r=0;
//ripple stuff end

boolean zoomIn = false;
boolean zoomOut = true;
//void mousePressed() {
//  if (mouseButton == LEFT) {
//    zoomIn = true;
//  } else if (mouseButton == RIGHT) {
//    zoomOut = true;
//  }
//}
//void mouseReleased() {
//  if (mouseButton == LEFT) {
//    zoomIn = false;
//  } else if (mouseButton == RIGHT) {
//    zoomOut = false;
//  }
//}

float xoffs = 0.5;
float yoffs = 0.5;
int count=0;
int n=0;
float m=0;
void draw() {

  if (value < 60) {
    m=min((m+0.1), 150);
    n=(int)m;
  } else {
    n=n-10;
  }
  if (value >=40) {
    BACKGROUND = color(0+col++/3, 30+col++/3, 30+col++/3);
  }
  //objects = new ArrayList();
  //for (int i=0; i<N; i++) {
  //  objects.add(new ZObject(random(1.0f), random(1.0f), random(1.0f), color(random(20.0, 20.0), random(150.0, 190.0), random(150.0, 190.0))));
  //}
  //N++;
  //audio stuff
  moonlander.update();
  value = moonlander.getValue("my_track");


  //temp useless
  count++;
  background(BACKGROUND);
  //xoffs = xoffs*0.9 + 0.1*mouseX/WIDTH;
  //yoffs = yoffs*0.9 + 0.1*mouseY/HEIGHT;
  //while (value==420) {
  //  moonlander.update();
  //  value = moonlander.getValue("my_track");
  //  background(color(0, 30, 30));
  //}
  //if (value<60 && value!=420) {
  for (int i=0; i<n; i++) {
    ZObject current = (ZObject)objects.get(i);
    current.update(zoomIn, zoomOut);
  }
  //} 
  if (value>=60 && value<70) {

    //background(0);
    //blendMode(ADD);
    //stroke(102);
    //strokeWeight(30);
    //line(25, 25, 75, 75);
    //line(75, 25, 25, 75);
  }


  sortBubbles();
  if (value<70 && value!=420) {
    for (int i=0; i<n; i++) {
      ((ZObject)objects.get(i)).draw(xoffs, yoffs);
    }
  }
  //fill(108, 192, 255);
  //noStroke();
  //rect(0, 0, width, height);
  for (int i=0; i<drops.size(); i++) {
    Circle drop=drops.get(i);
    drop.display();
    drop.movement();
  }
  //drops.add(new Circle((int)(randomGaussian()*100+300),(int)(randomGaussian()*100+300), r));
  fill(255);
  strokeWeight(2);
  textSize(16);
  text("Value from moonlander: " + value, 10, 20);
  strokeWeight(0.5);

  if (value!=420 && value == 70) {
    //drawDeath();
    drawAlive();
  }
}


class Circle {
  float x;
  float y;
  float rad;
  Circle(float tempX, float tempY, float tempR) {
    x=tempX;
    y=tempY;
    rad=tempR;
  }

  void display() {
    noFill();
    //stroke(100, 100-rad/2);
    //strokeWeight(0.5);
    stroke(255, 200-2*rad);

    strokeWeight(0.4);
    ellipse(x, y, rad, rad);
    noStroke();
  }

  void movement() {
    rad++;
    if (255-2*rad<0) {
      //if (false) {
      drops.remove(0);
    }
  }
}


// region Alive
Ptc [] ptcs;
ArrayList<PVector> alivePath = new ArrayList();
int aliveIndex = 0;
float gMag = 1, gVelMax = 10, gThres, gThresT = 100, gBgAlpha = 255, gBgAlphaT = 32, sliderForce = 1, sliderGhost = 32, sliderThres = 100;
boolean aliveAnimate = true;

void setupAlive()
{
  initPtcs(160);
  alivePath.add(new PVector(width/2, height/2));
  alivePath.add(new PVector(width/2, height/2));
  alivePath.add(new PVector(width/2, height/2));
  alivePath.add(new PVector(width/2, height/2));
  alivePath.add(new PVector(width/2, height/2));
  alivePath.add(new PVector(width*0.8, height*0.8));
  alivePath.add(new PVector(width*0.8, height*0.8));
  alivePath.add(new PVector(width*0.8, height*0.8));
  alivePath.add(new PVector(width*0.8, height*0.8));
  alivePath.add(new PVector(width*0.8, height*0.8));
  alivePath.add(new PVector(width*0.8, height*0.2));
  alivePath.add(new PVector(width*0.8, height*0.2));
  alivePath.add(new PVector(width*0.8, height*0.2));
  alivePath.add(new PVector(width*0.8, height*0.2));
  alivePath.add(new PVector(width*0.8, height*0.2));
  alivePath.add(new PVector(width*0.2, height*0.8));
  alivePath.add(new PVector(width*0.2, height*0.8));
  alivePath.add(new PVector(width*0.2, height*0.8));
  alivePath.add(new PVector(width*0.2, height*0.8));
  alivePath.add(new PVector(width*0.2, height*0.8));
  alivePath.add(new PVector(width*0.2, height*0.2));
  alivePath.add(new PVector(width*0.2, height*0.2));
  alivePath.add(new PVector(width*0.2, height*0.2));
  alivePath.add(new PVector(width*0.2, height*0.2));
  alivePath.add(new PVector(width*0.2, height*0.2));
  alivePath.add(new PVector(width*0.0, height*0.0));
  alivePath.add(new PVector(width*0.0, height*0.0));
  alivePath.add(new PVector(width*0.0, height*0.0));
  alivePath.add(new PVector(width*0.0, height*0.0));
  alivePath.add(new PVector(width*0.0, height*0.0));
  alivePath.add(new PVector(width*1.0, height*1.0));
  alivePath.add(new PVector(width*1.0, height*1.0));
  alivePath.add(new PVector(width*1.0, height*1.0));
  alivePath.add(new PVector(width*1.0, height*1.0));
  alivePath.add(new PVector(width*1.0, height*1.0));
}

void drawAlive()
{

  gThres = lerp(gThres, gThresT, .02);
  gBgAlpha = lerp(gBgAlpha, gBgAlphaT, .02);
  gMag = sliderForce;

  updatePtcs();

  noStroke();
  fill(255, gBgAlpha);
  rect(0, 0, width, height);

  drawPtcs();
  drawCnts();
}

void initPtcs(int amt) {
  ptcs = new Ptc[amt];
  for (int i=0; i<ptcs.length; i++) {
    ptcs[i] = new Ptc();
  }
}

void updatePtcs() {
  if (aliveAnimate) {
    for (int i=0; i<ptcs.length; i++) {
      ptcs[i].update(alivePath.get(aliveIndex).x, alivePath.get(aliveIndex).y);
      if (aliveIndex + 1 == alivePath.size())
      {
        aliveIndex = 0;
      } else 
      {
        aliveIndex++;
      }
    }
  } else {
    for (int i=0; i<ptcs.length; i++) {
      ptcs[i].update();
    }
  }
}

void drawPtcs() {
  for (int i=0; i<ptcs.length; i++) {
    ptcs[i].drawPtc();
  }
}

void drawCnts() {
  for (int i=0; i<ptcs.length; i++) {
    for (int j=i+1; j<ptcs.length; j++) {
      float d = dist(ptcs[i].pos.x, ptcs[i].pos.y, ptcs[j].pos.x, ptcs[j].pos.y);
      if (d<gThres) {
        float scalar = map(d, 0, gThres, 1, 0);
        ptcs[i].drawCnt(ptcs[j], scalar);
      }
    }
  }
}
class Ptc {

  PVector pos, pPos, vel, acc;
  float decay, weight, magScalar;

  Ptc() {
    pos = new PVector(random(width), random(height));
    pPos = new PVector(pos.x, pos.y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);

    weight = random(1, 10);
    decay = map(weight, 1, 10, .95, .85);
    magScalar = map(weight, 1, 10, .5, .05);
  }

  void update(float tgtX, float tgtY) {

    pPos.set(pos.x, pos.y);

    acc.set(tgtX-pos.x, tgtY-pos.y);

    //Use normalize() instead in Java mode
    float accMag = sqrt(sq(acc.x)+sq(acc.y));
    acc.mult(1.0/accMag);
    //------------------------------
    acc.mult(gMag * magScalar);
    vel.add(acc);
    //Use limit() instead in Java mode
    float velMag = sqrt(sq(vel.x)+sq(vel.y));
    if (velMag>gVelMax) vel.mult(gVelMax/velMag);
    //------------------------------
    pos.add(vel);
    acc.set(0, 0, 0);
    boundaryCheck();
  }

  void update() {

    pPos.set(pos.x, pos.y);

    vel.add(acc);
    vel.mult(decay);
    pos.add(vel);
    acc.set(0, 0);

    boundaryCheck();
  }

  void drawPtc() {
    strokeWeight(weight);
    stroke(0, 255);
    if (aliveAnimate)line(pos.x, pos.y, pPos.x, pPos.y);
    else point(pos.x, pos.y);
  }

  void drawCnt(Ptc coPtc, float scalar) {
    strokeWeight((weight+coPtc.weight)*.5*scalar);
    stroke(0, 255*scalar);
    line(pos.x, pos.y, coPtc.pos.x, coPtc.pos.y);
  }

  void boundaryCheck() {
    if (pos.x > width) {
      pos.x = width;
      vel.x *= -1;
    } else if (pos.x < 0) {
      pos.x = 0;
      vel.x *= -1;
    }
    if (pos.y > height) {
      vel.y *= -1;
    } else if (pos.y < 0) {
      vel.y *= -1;
    }
  }
}
// end region Alive
// region Death
final float g = 0.1;
ArrayList<PVector> deathPath = new ArrayList();
int deathIndex = 0;
Body bs[];

class Body {
  float m;
  PVector p, q, s;

  Body(float m, PVector p) {
    this.m = m;
    this.p = p;
    q = p;
    this.s = new PVector(0, 0);
  }

  void update() {
    s.mult(0.98);
    p = PVector.add(p, s);
  }

  void attract(Body b) {
    float d = constrain(PVector.dist(p, b.p), 10, 100);
    PVector f = PVector.mult(PVector.sub(b.p, p), b.m * m * g / (d * d));
    PVector a = PVector.div(f, m);
    s.add(a);
  }

  void show() {
    line(p.x, p.y, q.x, q.y);
    q = p;
  }
}
void setupDeath()
{

  background(255);
  fill(255, 26);
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(30.5, 20.5));
  deathPath.add(new PVector(20.5, 10.5));
  deathPath.add(new PVector(20.5, 10.5));
  deathPath.add(new PVector(20.5, 10.5));
  deathPath.add(new PVector(20.5, 10.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(60.5, 70.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  deathPath.add(new PVector(160.5, 170.5));
  bs = new Body[1000];
  for (int i = 0; i < bs.length; i++) {
    bs[i] = new Body(1, new PVector(random(width), random(height)));
  }
}
void drawDeath()
{
  noStroke();
  rect(0, 0, width, height);

  stroke(0);
  Body a = new Body(1000, deathPath.get(deathIndex));
  if (deathIndex + 1 == deathPath.size())
  {
    deathIndex = 0;
  } else 
  {
    deathIndex++;
  }
  for (Body b : bs) {
    b.show();
    b.attract(a);
    b.update();
  }
}
// end region Death