import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;

// number of concurrent players.
int len = 4; 
//AudioPlayer[] tick1 = new AudioPlayer[len];
FilePlayer[] tick1 = new FilePlayer[len];
int i1 = 0;
//AudioPlayer[] tick2 = new AudioPlayer[len];
FilePlayer[] tick2 = new FilePlayer[len];
int i2 = 0;

AudioRecorder recorder;
AudioOutput out;
 
void setup()
{
  size(100, 100);
 
  // Minim library.
  minim = new Minim(this);

  // Set audio out.
  out = minim.getLineOut();
 
  // this loads mysong.wav from the data folder
  for(int i = 0; i < len; i++)
  {
    //tick1[i] = minim.loadFile("tick1.mp3");
    tick1[i]   = new FilePlayer( minim.loadFileStream("tick1.mp3"));
    tick1[i].patch(out);
  }
  
  for(int i = 0; i < len; i++)
  {
    //tick2[i] = minim.loadFile("tick2.mp3");
    tick2[i]   = new FilePlayer( minim.loadFileStream("tick2.mp3"));
    tick2[i].patch(out);
  }
 
  recorder = minim.createRecorder(out, "out.wav");
  recorder.beginRecord();
  
  //tick2[0].patch(out);
}

int duration = 60;
int tick1_time = 0;
int tick2_time;

void draw()
{
  background(0);
  
  text("Press s to save recording once it is done.", 40, 40);
  
  if(tick1_time < 1)
  {
    tick1[i1].rewind();
    tick1[i1].play();
    i1 = (i1 + 1) % len;
    
    println("Playing tick1");
    tick2_time = duration/2;
    tick1_time = duration;
    duration--;
    duration = max(duration, 1);
    return;
  }
  
  if(tick2_time == 0)
  {
    tick2[i2].rewind();
    tick2[i2].play();
    i2 = (i2 + 1) % len;
    tick2_time = -1; // Don't play again unless a tick 1 sets it so.
    return;
  }
  
  tick1_time--;
  tick2_time--;

  return;
}

void keyReleased()
{
  if ( key == 's' )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    println("Done saving.");
  }
}