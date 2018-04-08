#include <SPI.h>

class BLEConnectable {
  public:
  BLEConnectable(){}
  virtual ~BLEConnectable(){}

  // Interface methods
  virtual void begin()=0;
  virtual void sendString(String string)=0;
  virtual String receiveString()=0;
};

