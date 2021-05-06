#include <Adafruit_NeoPixel.h>
#define PIN 2
#define NUMPIXELS 300
#define DELAY 10
int count = 0;

Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  pixels.begin();
  Serial.begin(9600);
}

void serialEvent() {
  if (Serial.available()!=0 && Serial.available()%2==0) {
    //Serial.write(Serial.read());
    byte flag = Serial.read();
    byte note = Serial.read()-21;
    //Serial.write(flag);
    //Serial.write(note);
    int pos = 24.0 + (165.0 - 24.0) * note / 87.0;
    //pixels.clear();
    if(flag == 0){
      pixels.setPixelColor(NUMPIXELS / 2 - (pos + 1) / 2 - 1, pixels.ColorHSV(0, 255, 255)); //~65536?, ~256, ~256
      pixels.setPixelColor(NUMPIXELS / 2 + pos / 2, pixels.ColorHSV(0, 255, 255)); //~65536?, ~256, ~256      
    }else if(flag == 1){
      pixels.setPixelColor(NUMPIXELS / 2 - (pos + 1) / 2 - 1, pixels.ColorHSV(0, 0, 0)); //~65536?, ~256, ~256
      pixels.setPixelColor(NUMPIXELS / 2 + pos / 2, pixels.ColorHSV(0, 0, 0)); //~65536?, ~256, ~256
    }
    pixels.show();    
  }
}

void loop() {

}
