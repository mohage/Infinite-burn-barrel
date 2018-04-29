#include <SPI.h>

/* NOTE:
This class is not following the standard pattern that we have in place. 
It was supposed to be used only for testing. 
If we end up using it in production, refactor it to the pattern.
*/

class BarrelLED {
  
  private:
    // Pinout
    #define BARREL_LED_PIN 5

    // Constants
    const String ON_COMMAND = "led_on";
    const String OFF_COMMAND = "led_off";

    bool isOn = false;
    void turnOn() {
      digitalWrite(BARREL_LED_PIN, HIGH);
      isOn = true;
    }

    void turnOff() {
      digitalWrite(BARREL_LED_PIN, LOW);
      isOn = false;
    }

  public:
    void begin() {
      pinMode(BARREL_LED_PIN, OUTPUT);
      turnOff();
    }

    void update(String command) {
      if (command == ON_COMMAND) {
        turnOn();
      } else if (command == OFF_COMMAND) {
        turnOff();
      }
    }

    String toCommand() {
      if (isOn == true) {
        return ON_COMMAND;
      } else {
        return OFF_COMMAND;
      }
    }
};

