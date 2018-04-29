#include "BLEBarrel_AF.cpp"
#include "BarrelLED.cpp"
#include "TemperatureSensor.cpp"
#include "VoltageSensor.cpp"
#include "CurrentSensor.cpp"
#include "MOSFETSensor.cpp"

// Configuration
BLEConnectable *bleBarrel = new BLEBarrel_AF();
//BarrelLED led = BarrelLED();

// Temperature Sensors
TemperatureSensor *burnTemp = new TemperatureSensor(A0, "btemp");
TemperatureSensor *surfaceTemp = new TemperatureSensor(A1, "stemp");
TemperatureSensor *pumpTemp = new TemperatureSensor(A2, "ptemp");

// Voltage Sensors
VoltageSensor *batVoltage = new VoltageSensor(A0, "batvolt");
VoltageSensor *tegVoltage = new VoltageSensor(A1, "tegvolt");

// Current Sensors
CurrentSensor *batCurrent = new CurrentSensor(A0, "batcurr");
CurrentSensor *tegCurrent = new CurrentSensor(A1, "tegcurr");

// MOSFET Sensors
MOSFETSensor *fan = new MOSFETSensor(A10, "fan");
MOSFETSensor *blower = new MOSFETSensor(A11, "blo");
MOSFETSensor *led = new MOSFETSensor(A12, "led");
MOSFETSensor *speaker = new MOSFETSensor(A13, "spk");
MOSFETSensor *dump = new MOSFETSensor(A14, "dump");

void setup() {  
  Serial.begin(9600);
  bleBarrel->begin();
  fan->begin();
  blower->begin();
  led->begin();
  speaker->begin();
  dump->begin();
}

void loop() {
  // Receive commands from the phone
  String string = bleBarrel->receiveString();
  if (string.length() > 0) {
    // Update each component with the same string. 
    // Component will ignore the command if it doesn't apply to it.
    fan->update(string);
    blower->update(string);
    led->update(string);
    speaker->update(string);
    dump->update(string);
  }

  // Send updated state to the phone
  bleBarrel->sendString(burnTemp->toCommand());
  bleBarrel->sendString(surfaceTemp->toCommand());
  bleBarrel->sendString(pumpTemp->toCommand());
  bleBarrel->sendString(batVoltage->toCommand());
  bleBarrel->sendString(tegVoltage->toCommand());
  bleBarrel->sendString(batCurrent->toCommand());
  bleBarrel->sendString(tegCurrent->toCommand());
  bleBarrel->sendString(fan->toCommand());
  bleBarrel->sendString(blower->toCommand());
  bleBarrel->sendString(led->toCommand());
  bleBarrel->sendString(speaker->toCommand());
  bleBarrel->sendString(dump->toCommand());

  debugPrint();
  //testingPlayground();
  
  delay(500);
}

void debugPrint() {
  Serial.println("======================");
  Serial.println("Temperature Sensors");
  Serial.println(burnTemp->toCommand());
  Serial.println(surfaceTemp->toCommand());
  Serial.println(pumpTemp->toCommand());
  Serial.println("Voltage Sensors");
  Serial.println(batVoltage->toCommand());
  Serial.println(tegVoltage->toCommand());
  Serial.println("Current Sensors");
  Serial.println(batCurrent->toCommand());
  Serial.println(tegCurrent->toCommand());
}

void testingPlayground() {
  fan->update("fan_150");
}

