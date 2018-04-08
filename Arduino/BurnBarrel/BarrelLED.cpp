#include <SPI.h>

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

