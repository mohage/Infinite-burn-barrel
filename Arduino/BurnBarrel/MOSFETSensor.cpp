#include <SPI.h>

class MOSFETSensor {
  
    private:
    int sensorPin;
    String commandID;
    int lastValue = 0;

    public:
      MOSFETSensor(int input, String command) {
        sensorPin = input; 
        commandID = command;
      }

    void begin() {
      pinMode(sensorPin, OUTPUT);
    }

    void update(String command) {
      String valueStr = command.substring(command.indexOf("_") + 1);
      int value = valueStr.toInt();
      setValue(value);
    }

    void setValue(int value) {
      lastValue = value;
      analogWrite(sensorPin, value);
    }
    
    String toCommand() {
      return commandID + "_" + lastValue;
    }
};

