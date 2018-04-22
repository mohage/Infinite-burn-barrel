#include <SPI.h>

class TemperatureSensor {
  
  private:
    int sensorPin;
    String commandID;

  public:
    TemperatureSensor(int input, String command) {
      sensorPin = input; 
      commandID = command;
    }

    String toCommand() {
      int value = analogRead(sensorPin);
      float voltage = (value/1024.0) * 5.0;
      float temp = (voltage - .5) * 100;
      
      return commandID + "_" + temp;
    }
};

