#include <SPI.h>
#include "BLEConnectable.cpp"
#include "Adafruit_BLE_UART.h"

// BLEBarrel implementation using AdaFruit nRF8001
class BLEBarrel_AF: public BLEConnectable {

  private:
    // Pinout
    #define ADAFRUITBLE_REQ 10
    #define ADAFRUITBLE_RDY 2
    #define ADAFRUITBLE_RST 9

    /**
    Above pins are variable, but these are static. These are specific for Mega2560.
    SCK -> Digital 52
    MISO -> Digital 50
    MOSI -> Digital 51
    */

    Adafruit_BLE_UART BTLEserial = Adafruit_BLE_UART(ADAFRUITBLE_REQ, ADAFRUITBLE_RDY, ADAFRUITBLE_RST);
    aci_evt_opcode_t laststatus = ACI_EVT_DISCONNECTED;

  public:
    void BLEBarrel_AF::begin() {
      BTLEserial.setDeviceName("Barrel");
      BTLEserial.begin();
    }

    void BLEBarrel_AF::sendString(String string) {
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

    String BLEBarrel_AF::receiveString() {
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

