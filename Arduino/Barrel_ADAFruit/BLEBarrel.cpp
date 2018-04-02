#include <SPI.h>
#include "Adafruit_BLE_UART.h"

#define ADAFRUITBLE_REQ 10
#define ADAFRUITBLE_RDY 2
#define ADAFRUITBLE_RST 9

class BLEBarrel {

  private:
    Adafruit_BLE_UART BTLEserial = Adafruit_BLE_UART(ADAFRUITBLE_REQ, ADAFRUITBLE_RDY, ADAFRUITBLE_RST);
    aci_evt_opcode_t laststatus = ACI_EVT_DISCONNECTED;

  public:
    void begin() {
      BTLEserial.setDeviceName("Barrel");
      BTLEserial.begin();
    }

    void sendString(String string) {
      BTLEserial.pollACI();

      aci_evt_opcode_t status = BTLEserial.getState();
      if (status != laststatus) {
        laststatus = status;
      }

      if (status == ACI_EVT_CONNECTED) {
        uint8_t sendbuffer[20];
        string.getBytes(sendbuffer, 20);
        char sendbuffersize = min(20, string.length());
        BTLEserial.write(sendbuffer, sendbuffersize);
      }
    }

    String receiveString() {
      BTLEserial.pollACI();

      aci_evt_opcode_t status = BTLEserial.getState();
      if (status != laststatus) {
        laststatus = status;
      }

      String receivedString = "";
      if (status == ACI_EVT_CONNECTED) {
        while (BTLEserial.available()) {
          char c = BTLEserial.read();
          receivedString += c;
        }

        if (receivedString.length() > 0) {
          Serial.println(receivedString);
        }
      }

      return receivedString;
    }
};

