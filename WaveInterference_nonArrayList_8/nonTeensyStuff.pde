void draw() {
  background(255);


  int text_x = 20;
  int text_y = 420;
  for (int r=0; r<MAX_OSCILLATORS; r++) {
    //textAlign(RIGHT);
    fill(0);
    float eng = oscillators[r].energy;
    text(r + " , "+oscillators[r].bAlive+" , "+nf(eng, 1, 3)+" sp "+oscillators[r].mySpeed, text_x, text_y);
    text_y += 20;
  }

  int timeDif = millis() - clickTime;
  text("timeDif "+timeDif, 10, 10);

  pushMatrix();
  translate(width / 2, height / 2 - 200, -900);
  rotateX(xPerspective);
  //rotateZ(PI / 2);
  translate(-width / 2, -height / 2, 0);
  lights();

  pushMatrix();
  //println("mouseX "+mouseX+" "+mouseY);
  translate(mouseX, mouseY, 0);
  fill(255);
  box(2, 2, 50);
  popMatrix();

  pushMatrix();
  //println("myX "+myX);
  translate(myX, myY, 0);
  fill(0);
  box(2, 2, 1450);
  popMatrix();


  for (int x = 0; x < step; x++) {
    for (int y = 0; y < step; y++) {
      float z = 0;
      int a = y*step + x;
      for (int r=0; r<MAX_OSCILLATORS; r++) { //Oscillator osc : oscillators) {
        if (oscillators[r].bAlive == true) {
          z += oscillators[r].getValue(x*step, y*step);
        }
      }        
      allZs[a] = z;
    }
  }

  collectMyZs();
  if (oneRow == false) {
    if (show_grid) drawGrid();
    if (show_particles) drawParticles();
  } else {

    stroke(199, 21, 133);
    fill(199, 21, 133);
    for (int x = 0; x < step; x++) {
      int y = step-1;
      //for (int y = 0; y < step; y++) {
      int a = y*step + x;
      pushMatrix();
      translate(x*step, y*step, allZs[a]); //allZs[temp_zcount]);
      fill(199, 21, 133);
      sphere(5);
      //box(5, 5, z*2);
      popMatrix();
      //}
    }
  }
  if (show_oscill) drawOscillators();
  popMatrix();

  drawMyZs();


  loop();

  stroke(0);
  text("hold spacebar and mouse press in grid ", 300, 30);
}

void drawMyZs() {
  int graphX = 300;
  int graphY = 80;
  fill(0);
  stroke(100);
  line(graphX, 0, graphX, graphY*2);
  line(graphX, graphY, 2000, graphY); 
  for (int i=0; i<oneZ_count; i++) {
    stroke(0);
    ellipse(i/2.0+graphX, onePartical_z[i]+graphY, 1, 1);
    //stroke(0, 0, 255);
    //ellipse(i/2.0+graphX, onePartical_z2[i]+graphY, 1, 1);
    stroke(255, 0, 0);
    ellipse(i/2.0+graphX, onePartical_energy[i]*50+graphY, 1, 1);
  }
}

void collectMyZs() {
  float en = 0;
  int aliveCnt =0;
  float z = 0;
  float z2 = 0;
  for (int r = 0; r < MAX_OSCILLATORS; r++) { //Oscillator osc : oscillators) {
    //      println(oscillators[r].bAlive);
    if (oscillators[r].bAlive == true) {
      //z += oscillators[r].getValue(p);
      float temp_z = oscillators[r].getValue(myX, myY);
      z += temp_z;
      //z2 += temp_z - maxAmp * oscillators[r].myEnergy;
      en += oscillators[r].myEnergy;

      println(aliveCnt+ ", en "+oscillators[r].myEnergy+" , z "+oscillators[r].getValue(myX, myY));

      aliveCnt++;
    }
  }
  println();

  //en = en/float(aliveCnt);
  //println("en "+en+" , z "+z+" z2 "+z2);

  onePartical_z[oneZ_count] = z - maxAmp*en;
  //onePartical_z2[oneZ_count] = z2*-1;
  onePartical_energy[oneZ_count] = en;
  //println(oneZ_count+" , "+onePartical_z[oneZ_count]);
  //println(oneZ_count+" , "+onePartical_energy[oneZ_count]);
  oneZ_count++;
  oneZ_count %= 10000;
}


void mousePressed() {
  if (keyPressed == true) {
    newTrigger(mouseX, mouseY, 1);
    //oscillators.add(new Oscillator(new PVector(mouseX, mouseY)));
    clickTime = millis();
    clickX = mouseY;
  }
}

void keyPressed() {

  if (key == 'r') {
    for (int r=0; r<MAX_OSCILLATORS; r++) {
      //oscillators[r] = new Oscillator(0, 0, 0, millis());
      oscillators[r].init(0, 0, 0, millis(), true);
    }

    for (int i=0; i<oneZ_count; i++) {
      onePartical_z[i]=0;
      onePartical_energy[i]=0;
    }
    oneZ_count = 0;
  }

  oneRow= false;
  if (key == '1') xPerspective = PI/1; 
  if (key == '2') xPerspective = PI/3; 
  if (key == '3') xPerspective = PI/2;
  if (keyCode == UP) xPerspective += 0.01;
  if (keyCode == DOWN) xPerspective -= 0.01;

  if (key == '0') {
    xPerspective = PI/2;
    oneRow = true;
    //oscillators[0] = new Oscillator(382, 839, 1, millis());
    oscillators[0].init(382, 839, 1, millis(), true);
  }

  if (key=='s') {
    cp5.saveProperties(("wave.properties"));
  } else if (key=='l') {
    cp5.loadProperties(("wave.properties"));
  }
}