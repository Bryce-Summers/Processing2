
/**
 * wave interference in 3D
 *
 * @author aa_debdeb
 * @date 2016/07/21
 * edits by stephanschulz
 * @date 2016/dec/19
 https://www.openprocessing.org/sketch/378924
 http://pages.iu.edu/~kforinas/WJS/Dispersion2JS.html
 http://hyperphysics.phy-astr.gsu.edu/hbase/Waves/watwav2.html
 */

//? dispersion speed = different phase speed
//surface tension

//----only for processing
float[] allZs;

int clickTime =0;
int clickX = -1;

float xPerspective = PI/3;
boolean oneRow = false;

float last_z = 0;

float[] onePartical_z;
float[] onePartical_z2;
int oneZ_count;
float[] onePartical_energy;

//gui
import controlP5.*;
ControlP5 cp5;

boolean show_grid;
boolean show_particles;
boolean show_oscill;


//----teensy
boolean bDebug = false;
long lastFrame;

float width = 500;
float height = 500;

long lastTrigger;

int myX = 5;
int myY = 5;

int step = 35;
float maxAmp = 50;
float maxDistance = 700; //900;
float waveLength = PI / 128; //PI / 328; //
float speed = 0.01; // 0.1 //chanbging myFrameCount +value or speed has same results
int maxTime = 8000; 
float dampening = 0.9995;

float myFrameCount = 0;
//const int MAX_OSCILLATORS = 10; //teensy
int MAX_OSCILLATORS = 10;
//int oscillatorsCnt = 0;
//int oscillatorsIndex = 0;

boolean bEnergy;
float moveSpeed;

boolean newT = false;


//struct Oscillator { //teensy
class Oscillator {

  //PVector loc;
  int myID;
  float loc_x;
  float loc_y;
  float frames;
  float energy;
  boolean bAlive;
  int startTime;
  float moveDist = 0;
  float myWaveLength = waveLength;
  float mySpeed = speed;

  float myEnergy;

  Oscillator() {
  } //float _x, float _y, float _energy, int _time) 

  void init(float _x, float _y, float _energy, int _time, boolean _alive) {
    loc_x = _x;
    loc_y = _y;
    //myFrameCount = frameCount;
    frames = myFrameCount;
    energy = _energy; //1.0;
    startTime = _time;
    bAlive = _alive;
    if (bDebug == true) {
      print(myID);
      print(" init at ");
      print(loc_x);
      print(", ");
      print(loc_y);
      print(" energy = ");
      print(energy);
      println();
    }
  }

  void update() {
    energy *= map(dampening, 0, 1, 0.99, 1);


    if (energy < 0.001) {

      if (bAlive == true && bDebug == true) {
        print(myID);
        print(" dead at ");
        print(loc_x);
        print(", ");
        print(loc_y);
        print(" energy = ");
        print(energy);
        println();
      }

      bAlive = false;
    }
    moveDist = (myWaveLength - (myFrameCount - frames) * mySpeed) * -moveSpeed;
  }

  float getValue(float _x, float _y) {

    float dist = getDistance(loc_x, loc_y, _x, _y);

    if (maxDistance - dist >= 0) {

      float distNorm = ((maxDistance - dist) / maxDistance);// convert dist to 1-0 range, 0 = too far away

      int minTime = int((1-distNorm)*maxTime);
      //float temp_energy =  map(millis() - startTime, minTime, maxTime, 0, energy);
      float temp_energy =  fmap(millis() - startTime, minTime, maxTime, 0, energy);
      //temp_energy = constrain(temp_energy, 0, energy);
      if (temp_energy < 0) temp_energy = 0;
      else if (temp_energy > energy) temp_energy = energy;

      //print(myID);
      //print(" , minTime ");
      //print(minTime);
      //print(", maxTime ");
      //print(maxTime);
      //print(", startTime ");
      //print(millis() - startTime);
      //print(", energy ");
      //print(energy);
      //print(", temp_energy ");
      //println(temp_energy);

      //temp_energy = energy;

      //via time progression generate angle on cos circle
      float angle = cos(dist * myWaveLength - (myFrameCount - frames) * mySpeed);
      myEnergy = temp_energy * distNorm;
      //println(_x+" temp_energy "+temp_energy+" timDiff "+(millis() - startTime)+" ,distNorm "+distNorm+" minTime "+minTime);
      float amp = maxAmp * temp_energy * distNorm; // multiply again with distNorm so further away particles have lower amplitude
      if (bEnergy == false ) amp = maxAmp;
      return fmap(angle, -1, 1, -amp, amp);
    } else {
      return 0;
    }
  }

  float getDistance(float x, float y, float x1, float y1) {
    float vx = x-x1;
    float vy = y-y1;
    return (float)sqrt(vx*vx + vy*vy);
  }

  float fmap(float x, float in_min, float in_max, float out_min, float out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  }
};

//Oscillator oscillators [MAX_OSCILLATORS];
Oscillator[] oscillators; //for teensy Oscillator oscillators [MAX_OSCILLATORS];


void setup() {
  //-----only for processing
  size(1200, 650, P3D);
  sphereDetail(4);
  noStroke();  

  int allSize = (step+1)*(step+1);
  allZs = new float[allSize];

  for (int x = 0; x < step; x++) {
    for (int y = 0; y < step; y++) {
      int a = y*step + x;
      allZs[a] = 0;
    }
  }

  onePartical_z = new float[10000];
  onePartical_z2 = new float[10000];
  oneZ_count = 0;
  onePartical_energy = new float[10000];

  setup_gui();

  oscillators = new Oscillator[MAX_OSCILLATORS];
  //------
  for (int r=0; r<MAX_OSCILLATORS; r++) {
    oscillators[r] = new Oscillator(); //random(width), random(height), 0, millis()); //new Oscillator(width / 2.0, height / 2.0, 1);
    oscillators[r].myID = r;
    oscillators[r].init(0, 0, 0, millis(), false);
  }

  newTrigger(7, 7, 1);
}

void loop() {

  //blinkLED();

  //for debug to auto trigger waves
  //if (millis() - lastTrigger > 3000 && newT == false) {
  //  newTrigger(int(random(width)), int(random(height)), random(100)/100.0);
  //  newT = true;
  //}
  //if (millis() - lastTrigger > 3300) {
  //  lastTrigger = millis();
  //  newT = false;
  //}

  //---
  if (millis() - lastFrame > 1) {

    float z = 0;

    for (int r = 0; r < MAX_OSCILLATORS; r++) { //Oscillator osc : oscillators) {
      //      println(oscillators[r].bAlive);
      if (oscillators[r].bAlive == true) {
        //z += oscillators[r].getValue(p);
        z += oscillators[r].getValue(myX, myY);
      }
    }


    /*
    float slope =  (last_z - z) / (lastFrame - millis());
     lastFrame = millis();
     last_z = z;
     //if (z > 0) {
     int m =  int(abs(z));
     print("z "+z + " ,slope " + slope+" \t ");
     for (int i = 0; i < m; i++) {
     print("-");
     }
     println();
     */

    myFrameCount += 1; //0.1; //0.1;
    for (int r=0; r<MAX_OSCILLATORS; r++) {  //for (Oscillator osc : oscillators) {
      oscillators[r].update();
    }
  }
}



void newTrigger(int _x, int _y, float _energy) {

  int newIndex;

  //find a dead oscillator, who's array position can be used for a new oscillator
  int deadIndex = -1;
  for (int r=0; r<MAX_OSCILLATORS; r++) {
    if (oscillators[r].bAlive == false) {
      deadIndex = r;
      break;
    }
  }

  if (deadIndex == -1) {
    //all oscillators are alive
    //lets find the one with the lowest energy
    float lowestEnergy = 100;
    int lowestIndex = -1;
    for (int r=0; r<MAX_OSCILLATORS; r++) {
      if (oscillators[r].energy < lowestEnergy) {
        lowestEnergy = oscillators[r].energy;
        lowestIndex = r;
      }
    }
    newIndex = lowestIndex;
  } else {
    newIndex = deadIndex;
  }

  //oscillators[newIndex] = new Oscillator(_x, _y, 1, millis());
  oscillators[newIndex].init(_x, _y, _energy, millis(), true); // myFrameCount); //
  //oscillators[newIndex].myWaveLength = PI/random(5,128);
  oscillators[newIndex].mySpeed = random(1, 20)/200.0;
}