#include <SPI.h>

class VoltageSensor {
  
    private:
      int sensorPin;
      String commandID;

    public:
      VoltageSensor(int input, String command) {
        sensorPin = input; 
        commandID = command;
      }

      String toCommand() {
        int value = analogRead(sensorPin);
        float voltage = (value/1024.0) * 5.0;
      
        return commandID + "_" + voltage;
      }
};

