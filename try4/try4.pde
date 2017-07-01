int start_ripple = 600;
int stop_ripple =1200;


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
      if (true) {
        blurred_circle(posX, posY, radius, abs(z-FOCAL_LENGTH), shaded_color, MIN_BLUR_LEVELS + (z*BLUR_LEVEL_COUNT));
      }
    }
    //if (radius<1 && value==1) {
    if (radius<1 && count >start_ripple) {
      for (int i=0; i<2; i++) {
        drops.add(new Circle(posX, posY, r-10*i));
      }


      text("Value from moonlander: " + radius, 10, 20);
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
  moonlander = Moonlander.initWithSoundtrack(this, "Eternal_Terminal.mp3", 120, 4);
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
  m=min((m+0.1), 150);
  n=(int)m;
  if (count>start_ripple+200){
  BACKGROUND = color(0+(count-start_ripple-200)/3, 30+(count-start_ripple-200)/3, 30+(count-start_ripple-200)/3);}
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

  for (int i=0; i<n; i++) {
    ZObject current = (ZObject)objects.get(i);
    current.update(zoomIn, zoomOut);
  }
  sortBubbles();

  for (int i=0; i<n; i++) {
    ((ZObject)objects.get(i)).draw(xoffs, yoffs);
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
  text("Value from moonlander: " + int(frameRate), 10, 20);
  strokeWeight(0.5);
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
    
    strokeWeight(0.5);
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