//this amazing meta-room programmed by James

/*
 * Project Ignite Mystery Game.
 *
 * Programmed by, _____, ________, ________, _______, _________, and ______
 * 
 */


//content rooms
Room entrance_room, living_room, kitchen_room, dining_room, study_room, shed_room, bed_room;

//cutscene rooms
Room intro_room, outro_room;

Player player;
Room current_room;

void setup() {
  
  fullScreen();
  
  entrance_room = new entrance_room();
  entrance_room.setup();
  living_room = new living_room();
  living_room.setup();
  kitchen_room = new kitchen_room();
  kitchen_room.setup();
  dining_room = new dining_room();
  dining_room.setup();
  study_room = new study_room();
  study_room.setup();
  shed_room = new shed_room();
  shed_room.setup();
  bed_room = new bed_room();
  bed_room.setup();
  
  intro_room=new intro_room();
  intro_room.setup();
  outro_room=new outro_room();
  outro_room.setup();
  
  current_room=intro_room;
  
  player = new Player();
}

void draw() {
  current_room.draw();
}
/*murder weapon - knife - creepo
 advisor dialogue - “will” - advisor
 shirt - blood on it
 handprint - bloody
 letter - shows person murdered cheated - sig other
 bloody apron - chef was wearing to kill animal
 maid dialogue - heard person murdered arguing (heard in ____ room)
 secret passage - (way to get around), connects murder to bedroom - sig other
 computer - files, undeleted internet history - advisor
 creepo dialogue - “this knife looked pretty swag” - eliminate creepo
 vegi sack - looks like body - nothing
 butler dialogue - “I’ve never seen the sig other cry before” - sig other 
 chef dialogue - “I’m always underpaid”
 sig other - “i’m sad” like #waytoosad - themself*/
 
//data structure for holding clues
class Player {
  boolean advisor;
  boolean shirt;
  boolean handprint;
  boolean letter;
  boolean apron;
  boolean maid;
  boolean passage;
  boolean computer;
  boolean creepo;
  boolean vegiSack;
  boolean butler;
  boolean chef;
  boolean sigOther;
  
  Player(){
    advisor=false;
    shirt=false;
    handprint=false;
    letter=false;
    apron=false;
    maid=false;
    passage=false;
    computer=false;
    creepo=false;
    vegiSack=false;
    butler=false;
    chef=false;
    sigOther=false;
  }
}

abstract class Room {
  abstract void setup();
  abstract void draw();

  //@todo implement me, lovely UI programmers. Sincerely, me.
  void displayDialogue(){
  }

  
  void goToRoom(Room room) {
    current_room=room;
  }
}

void reset(){
  setup();
}

//Not implemented yet. Maybe later.
void saveGame(){
}

void loadGame(){
}