void setup_gui() {

  cp5 = new ControlP5(this);
  // create a toggle and change the default look to a (on/off) switch look

  int gui_x = 20;
  int gui_y = 20;
  int gui_w = 100;
  int gui_h = 40;

  cp5.addToggle("show_grid")
    .setColorLabel(0)
    .setPosition(gui_x, gui_y)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;
  cp5.addToggle("show_particles")
    .setColorLabel(0)
    .setPosition(gui_x, gui_y+gui_h*1)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;
  cp5.addToggle("show_oscill")
    .setColorLabel(0)
    .setPosition(gui_x, gui_y+gui_h*2)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("bEnergy")
    .setColorLabel(0)
    .setPosition(gui_x, gui_y+gui_h*3)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;
    


  cp5.addSlider("xPerspective")
    .setColorLabel(0)
    .setPosition((gui_x), gui_y+gui_h*4)
    .setSize(20, 100)
    .setRange(0, 1.44);
  ;

  cp5.addSlider("speed")
    .setColorLabel(0)
    .setPosition((gui_x+100), gui_y)
    .setSize(100, 20)
    .setRange(0, 0.2)
    ;
  cp5.addSlider("maxAmp")
    .setColorLabel(0)
    .setPosition((gui_x+100), gui_y+gui_h*1)
    .setSize(100, 20)
    .setRange(10, 100)
    ;
  cp5.addSlider("dampening")
    .setColorLabel(0)
    .setPosition((gui_x+100), gui_y+gui_h*2)
    .setSize(100, 20)
    .setRange(0.5, 0.99)
    ; 
  cp5.addSlider("maxDistance")
    .setColorLabel(0)
    .setPosition((gui_x+100), gui_y+gui_h*3)
    .setSize(100, 20)
    .setRange(500, 1000)
    ;
  cp5.addSlider("maxTime")
    .setColorLabel(0)
    .setPosition((gui_x+100), gui_y+gui_h*4)
    .setSize(100, 20)
    .setRange(1000, 40000)
    ;
  cp5.addSlider("waveLength")
    .setColorLabel(0)
    .setPosition((gui_x+100), gui_y+gui_h*5)
    .setSize(100, 20)
    .setRange(PI/50, PI/500)
    ;

  cp5.addSlider("moveSpeed")
    .setColorLabel(0)
    .setPosition((gui_x+100), gui_y+gui_h*6)
    .setSize(100, 20)
    .setRange(10, 150);
    ;

  cp5.loadProperties(("wave.properties"));
}