#include <SPI.h>

class CurrentSensor {
  
    private:
      int sensorPin;
      String commandID;
      const int mVperAmp = 66; // use 100 for 20A Module and 66 for 30A Module
      const int ACSoffset = 2493;

    public:
      CurrentSensor(int input, String command) {
        sensorPin = input; 
        commandID = command;
      }

      String toCommand() {
        int value = analogRead(sensorPin);
        float voltage = (value/1024.0) * 5.0;
        float amps = ((voltage - ACSoffset) / mVperAmp);
      
        return commandID + "_" + amps;
      }
};

