
void drawOscillators() {

  stroke(255, 0, 0);
  strokeWeight(1);

  for (int r=0; r<MAX_OSCILLATORS; r++) {
    if (oscillators[r].bAlive) {
      pushMatrix();
      translate(oscillators[r].loc_x, oscillators[r].loc_y, 0);

      fill(255, 0, 0);
      box(2, 2, oscillators[r].energy*500);
      noFill();
      ellipse(0, 0, maxDistance*2, maxDistance*2);

      ellipse(0, 0, oscillators[r].moveDist, oscillators[r].moveDist);
      //println(oscillators[r].moveDist);
      popMatrix();
    }
  }
}

void drawParticles() {

  noStroke();
  float z =0;
  for (int x = 0; x < step; x++) {
    for (int y = 0; y < step; y++) {
      int a = y*step + x;
      pushMatrix();
      z = allZs[a];
      //println(z);
      if (z < maxAmp-15) {
        fill(255, 255, 255);
      } else {
        fill(0, 0, 0);
      }
      translate(x*step, y*step, z); //allZs[temp_zcount]);
      sphere(5);
      //box(5, 5, z*2);
      popMatrix();
    }
  }
}
void drawGrid() {
  int a, a1;

  stroke(0);
  strokeWeight(1);
  for (int x = 0; x < step; x++) {
    for (int y = 0; y < step-1; y++) {
      a = y*step + x;
      a1 = (y+1)*step + x;
      line(x*step, y*step, allZs[a], x*step, (y+1)*step, allZs[a1]);
    }
  }

  for (int x = 0; x < step-1; x++) {
    for (int y = 0; y < step; y++) {
      a = y*step + x;
      a1 = (y)*step + x+1;
      line(x*step, y*step, allZs[a], (x+1)*step, y*step, allZs[a1]);
    }
  }
}