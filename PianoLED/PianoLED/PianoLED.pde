import themidibus.*;
import javax.sound.midi.MidiMessage; 
import javax.sound.midi.ShortMessage; 
import processing.serial.*;

Serial myPort;
MidiBus myBus;    // MidiBus
boolean writing = false;

void setup() {
  size(300, 300);
  background(255);
  MidiBus.list();                     //MIDI list
  myBus = new MidiBus(this, 0, 4);    //MIDI input,output
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
}

void noteOn(int channel, int pitch, int velocity) {
  //myPort.write(100);
  if(writing)return;
  writing = true;
  myPort.write(0);
  myPort.write(pitch);
  //print(myPort.read());
  //print(myPort.read());
  delay(10);
  writing = false;
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  // draw eye pattern
  //myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
}

void noteOff(int channel, int pitch, int velocity) {
  //myPort.write(100);
  if(writing)return;
  writing = true;
  myPort.write(1);
  myPort.write(pitch);
  //print(myPort.read());
  //print(myPort.read());
  delay(10);
  writing = false;
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  // draw eye pattern
  //coloteNote(pitch, 0);
  //myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
}
