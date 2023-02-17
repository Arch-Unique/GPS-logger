// This example code is in the Public Domain (or CC0 licensed, at your option.)
// By Evandro Copercini - 2018
//
// This example creates a bridge between Serial and Classical Bluetooth (SPP)
// and also demonstrate that SerialBT have the same functionalities of a normal Serial

#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;
int cnt = 0;

void setup()
{
  Serial.begin(115200);
  SerialBT.begin("ESP32test"); // Bluetooth device name , it can be changed
  Serial.println("The device started, now you can pair it with bluetooth!");
}

void loop()
{
  // Read the incoming bluetooth info
  if (SerialBT.available())
  {
    Serial.write(SerialBT.read());
  }
  delay(100);

  // get the rssi and snr value from the LoRa
  // NB , it must be sent as
  //  [rssi, snr]
  // as shown below
  // below is just a demo
  String rssi = "10" + String(cnt);
  String snr = "11" + String(cnt);
  String rsmsg = rssi + "," + snr;

  // convert the string to charArray
  char rdata[rsmsg.length() + 1];
  rsmsg.toCharArray(rdata, rsmsg.length() + 1);

  // send the data to the app
  SerialBT.print(rdata);
  delay(100);

  cnt++;
}