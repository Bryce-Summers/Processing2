/*
 * Basic Processing Sketch by Bryce Summers on 1/7/2016.
 * Expanded, utilized, or adapted by __________________ on __________.
 *
 * Purpose: This sketh shows some of the minumum requirements for a processing sketch and
 *          some essential built in functions and variables.
 */

// Processing will call this function to set up all of the initial parameters,
// EVERY processing sketch should have this function.
void setup()
{
  size(300, 300);
}

// Processing calls this function once per frame to draw objects to the screen.
// You can also modify the state's of these object from frame to frame to create an animation.
// EVERY processing sketch should have this function.
void draw()
{
  // Draw a white background on the screen every frame to clear away the old drawings.
  background((frameCount + 255/2)%255);
  
  // Set the thickness of the lines (rather than filled shapes.)
  strokeWeight((frameCount/10)%10);
  
  // Set the color of the lines, such as the outline of the rectangle.
  int gray_val = (-frameCount)%255; 
  stroke(gray_val, gray_val, gray_val);
  
  // Make's the following filled shapes filled from a gradient of 0 - 255, where 0 is black and 255 is white.
  fill(frameCount%255); // Note % is the mod operator and a % b returns the remainder of a / b
  
  // Draw a rectangle to the screen. It is a certain color because of the previous fill command.
  rect(frameCount % (width/2), frameCount*2 % (height/2), width/2, height/2);
  
  // Draw a nice message.
  textAlign(CENTER, CENTER);
  textSize(50);
  fill(255);// white
  text("Press a key!", width/2, height/2);
}

void keyPressed() 
{
  noLoop(); // Every time the user presses any key, the animation stops.
}

void keyReleased()
{
  loop(); // Every time the user releases any key, the animation starts going again.
}