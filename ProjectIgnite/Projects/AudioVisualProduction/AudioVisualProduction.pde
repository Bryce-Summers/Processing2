/*
 * Audio Visual Production Program.
 * Skeleton written by Bryce Summers on 1/19/2016.
 * Project Ignite. Artistic Programming group.
 *
 * Purpose: This code provides a general framework for creating a bunch of proccessing
 *          sketches and playing them one after another.
 *
 *          This should allow wonderful people to experiment making sketches and enable them to 
 *          perform them together like a real time computer generated movie.
 *
 * Note: The Escape key is used to exit the program. You might have to click on the window before it registers though.
 */

Scene[] scenes;
int[] durations;
int current_scene_index;

void setup()
{
  fullScreen();
  textSize(height/10);
  
  current_scene_index  = 0;
  int number_of_scenes = 10;
  int DEFAULT_NUMBER_OF_FRAMES = 300; 
    
  scenes    = new Scene[number_of_scenes];
  durations = new int[number_of_scenes];
   
  // initialize all of the scenes and set how long they will run for.
  scenes[0] = new Scene1();  durations[0] = DEFAULT_NUMBER_OF_FRAMES; 
  scenes[1] = new Scene2();  durations[1] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[2] = new Scene3();  durations[2] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[3] = new Scene4();  durations[3] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[4] = new Scene5();  durations[4] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[5] = new Scene6();  durations[5] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[6] = new Scene7();  durations[6] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[7] = new Scene8();  durations[7] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[8] = new Scene9();  durations[8] = DEFAULT_NUMBER_OF_FRAMES;
  scenes[9] = new Scene10(); durations[9] = DEFAULT_NUMBER_OF_FRAMES;
  
  
  for(int i = 0; i < number_of_scenes; i++)
  {
     scenes[i].setup(); 
  }
}

void draw()
{

  // Changes scenes when the current scene has been running for its duration.
  // The +1's are there just in case processing does special things when frameCount = 0;
  if(frameCount >= durations[current_scene_index] + 1)
  {
    current_scene_index++;
    frameCount = 1;
  }
  
  // Terminate the animation once all scenes have been run.
  if(current_scene_index >= scenes.length || current_scene_index >= durations.length)
  {
   noLoop();
   return;
  }
  
  // Stop if one of the scenes is not defined.
  if(scenes[current_scene_index] == null)
  {
   noLoop();
   return;
  }
  
  // Draw the current scene.
  scenes[current_scene_index].draw();
}