#include "BLEBarrel_AF.cpp"
#include "BarrelLED.cpp"

// Configuration
BLEConnectable *bleBarrel = new BLEBarrel_AF();
BarrelLED led = BarrelLED();

void setup() {  
  Serial.begin(9600);
  bleBarrel->begin();
  led.begin();
}

void loop() {
  // Receive commands from the phone
  String string = bleBarrel->receiveString();
  if (string.length() > 0) {
    // Update each component with the same string. 
    // Component will ignore the command if it doesn't apply to it.
    led.update(string);
  }

  // Send updated state to the phone
  bleBarrel->sendString(led.toCommand());
  
  delay(500);
}

