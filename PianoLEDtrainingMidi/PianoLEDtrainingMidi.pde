import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.signals.*;
import javax.sound.midi.*;

Player player;
int x = 0;
Minim minim;

import themidibus.*;
import processing.serial.*;

ChildApplet child;
boolean mousePressedOnParent = false;
float noteWidth = 147.3;
int blackNoteWidth = 77;
float r=30;//corner radius;
//Note[] notes = new Note[88];
ArrayList<Note> notes = new ArrayList<Note>();
Serial myPort;
MidiBus myBus;    // MidiBus
boolean writing = false;
boolean pause = false;
int tolerance = 200;
long prevTick, tick, deltaTick;

public void settings() {
  //size(400, 400, P2D);
  //size(3840 ,2160, P3D);
  fullScreen(P3D, 2);
}

void setup() {


  hint(DISABLE_DEPTH_TEST);//because we use p3d
  colorMode(HSB, 360, 100, 100, 100);
  //stroke(255);
  //strokeWeight(40);
  noStroke();
  MidiBus.list();                     //MIDI list
  myBus = new MidiBus(this, 0, 2);    //MIDI input,output
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);

  surface.setTitle("Main sketch");
  child = new ChildApplet();
  /*for (int i=0; i<88; i++) {//A0 ~ C8 but show partially
   notes[i] = new Note(21+i);
   }*/

  minim = new Minim(this);
  //new Oscil(13.75*pow(pow(2, 1./12), i), 0.2, out.sampleRate(), Waves.SINE);
  //player = new Player("C:/Asset/ProjectFile/ProcessingData/Releases/Special/Midi/Midi_Single_Sine/data/debussy_Arabesque_1.mid");
  player = new Player("C:/Users/uekaz/Downloads/Summer_Joe_Hisaishi.mid");
  player.start();
  delay(100);
}

void draw() {
  if (player.sequencer != null) {
    tick = player.sequencer.getTickPosition();
    deltaTick = tick - prevTick;
    prevTick = tick;
  }
  //println(frameRate);
  background(0);
  //note.pos.x+=10;
  for (int i=0; i<notes.size(); i++) {
    Note note = notes.get(i);
    //if (!note.pressing)continue;
    if (!note.blackKey) {
      fill(note.channel*50, 80, 99);
      noStroke();
      rect(note.pos.x, height-note.pos.y, noteWidth, note.len, r, r, r, r);
      noFill();
      stroke(note.channel*50, 80, 99, 20);
      for (int j=0; j<3; j++) {

        strokeWeight(j*4);
        rect(note.pos.x, height-note.pos.y, noteWidth, note.len, r, r, r, r);
      }
    }
  }
  for (int i=0; i<notes.size(); i++) {
    Note note = notes.get(i);
    //if (!note.pressing)continue;
    if (note.blackKey) {
      fill(note.channel*50, 80, 99);
      rect(note.pos.x, height-note.pos.y, blackNoteWidth, note.len, r, r, r, r);
      noFill();
      stroke(note.channel*50, 80, 99, 20);
      for (int j=0; j<3; j++) {
        strokeWeight(j*4);
        rect(note.pos.x, height-note.pos.y, blackNoteWidth, note.len, r, r, r, r);
      }
    }
  }

  if (!pause) {
    for (int i=0; i<notes.size(); i++) {
      Note note = notes.get(i);
      note.update();
      if (pause)break;
    }
  }if (pause) {
  } else {
    if (!player.sequencer.isRunning()){
      print("resume");
     player.sequencer.start();
     
    }
  }

  for (int i=notes.size()-1; i>=0; i--) {
    Note note = notes.get(i);
    if (note.pos.y-note.len > height)notes.remove(note);
  }
}

void noteOn(int channel, int pitch, int velocity) {
  //notes[pitch-21].pressing = true;
  myBus.sendNoteOn(channel, pitch, velocity);
  for (Note note : notes) {
    if (note.note == pitch) {
      if (abs(note.pos.y) < tolerance) {
        note.pressed = true;
      }
    }
  }

  print("AA");
  pause = false;
  for (int i=0; i<notes.size(); i++) {
    Note note = notes.get(i);
    if (!note.pressed && note.pos.y < 0) {
      pause = true;
    }
  }
  print("AB");
  if (pause) {
  } else {
    if (!player.sequencer.isRunning()){
      print("try resume");
      player.sequencer.start();
    }
  }
  print("BB");
  //Note note = new Note(pitch);
  //note.pressing = true;
  //notes.add(note);
  if (writing)return;
  writing = true;
  myPort.write(0);
  myPort.write(pitch);
  delay(10);
  writing = false;
  print("FIN");
  // Receive a noteOn
  // draw eye pattern
  //myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
}

void noteOff(int channel, int pitch, int velocity) {
  myBus.sendNoteOff(channel, pitch, velocity);
  for (Note note : notes) {
    if (note.note == pitch)note.pressing = false;
  }

  if (writing)return;
  writing = true;
  myPort.write(1);
  myPort.write(pitch);
  delay(10);
  writing = false;
  // Receive a noteOff
  // draw eye pattern
  //coloteNote(pitch, 0);
  //myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
}


class ChildApplet extends PApplet {
  float zoom = 1.5;
  float ps = 28.8/33.7;//physical scale compare to primary display;
  //JFrame frame;
  int dispSpace = 83;//main display resolution * display width(cm) * space phisical distance(cm);
  int offx = 3840;//main display resolution
  int offy = 1080;
  int w = int(1920*zoom);
  int h = int(1080*zoom);

  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    //size(w, h, P3D);
    fullScreen(P3D);
  }
  public void setup() { 
    colorMode(HSB, 360, 100, 100, 100);
    hint(DISABLE_DEPTH_TEST);//because we use p3d
    //surface.setTitle("Child sketch");
    //surface.setLocation(int(offx*zoom), int(offy*zoom)-41);//41 = tab height
  }

  public void draw() {

    background(0);
    for (int i=0; i<notes.size(); i++) {
      Note note = notes.get(i);
      //if (!note.pressing)continue;
      if (!note.blackKey) {
        fill(note.channel*50, 80, 99);
        rect((note.pos.x-offx-dispSpace)*ps, h-note.pos.y*ps, noteWidth*ps, note.len*ps, r*ps, r*ps, r*ps, r*ps);
        noFill();
        stroke(note.channel*50, 80, 99, 20);
        for (int j=0; j<3; j++) {
          strokeWeight(ps*j*4);
          rect((note.pos.x-offx-dispSpace)*ps, h-note.pos.y*ps, noteWidth*ps, note.len*ps, r*ps, r*ps, r*ps, r*ps);
        }
      }
    }
    for (int i=0; i<notes.size(); i++) {
      Note note = notes.get(i);
      //if (!note.pressing)continue;
      if (note.blackKey) {
        fill(note.channel*50, 80, 99);
        rect((note.pos.x-offx-dispSpace)*ps, h-note.pos.y*ps, blackNoteWidth*ps, note.len*ps, r*ps, r*ps, r*ps, r*ps);
        noFill();
        stroke(note.channel*50, 80, 99, 20);
        for (int j=0; j<3; j++) {
          strokeWeight(j*4);
          rect((note.pos.x-offx-dispSpace)*ps, h-note.pos.y*ps, blackNoteWidth*ps, note.len*ps, r*ps, r*ps, r*ps, r*ps);
        }
      }
    }
  }
}
