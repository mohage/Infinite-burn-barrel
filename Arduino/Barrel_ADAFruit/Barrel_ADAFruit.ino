#include "BLEBarrel.cpp"

BLEBarrel bleBarrel = BLEBarrel();

void setup() {
  Serial.begin(9600);
  bleBarrel.begin();
}

void loop() {
  bleBarrel.sendString("fan_on");

  String string = bleBarrel.receiveString();

  if (string.length() > 0) {
    Serial.println(string);
  }
}

