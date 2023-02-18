# GPS Logger App

This is a GPS logger app written in Flutter that allows users to log their current location's latitude and longitude. The app provides the ability to save location data on the phone or share it as a .txt file. The app also has the capability to communicate with an ESP32 Bluetooth device.
[This app was developed as a part of TetFund Assisted Research Projects for LoRa Assisted Smart Institution]

## Features

- Log the current location's latitude,longitude and other GPS info along with the LoRa module's info such as rssi and snr
- Save the location data on the phone
- Share the location data as a .txt file (comma separated)
- Communicate with an ESP32 Bluetooth device which communicates with the LoRa Module

## Requirements

- Android Studio or Visual Studio Code with Flutter SDK installed
- Android or iOS device to run the app

## Installation

- Clone the repository from GitHub
- Open the project in Android Studio or Visual Studio Code
- Run the commands below

```dart
flutter pub get
flutter build apk --no-shrink
```

## Usage

- For proper operation, make sure your location and bluetooth is ON
- Open the app
- Grant location permission if requested\
  <img src="assets/location.png" width=360>

- Choose the mode of logging by pressing the <b>A</b> button in the menu bar, Auto Mode by default logs every 60 seconds and Manual Mode let you choose the frequency of logging<br>  
  Auto Mode\
  <img src="assets/automode.png" width=360>\
  <br>  
  Manual Mode\
  <img src="assets/manualmode.png" width=360>

- The location data will be displayed on the screen
- To view trackpoints, click the number icon. In the example pic above it would be (9).\
  <img src="assets/viewtrack.png" width=360>

- The trackpoints are automatically saved anytime you terminate the app as the app continues to run in the background until it is cleared from memory or you can save it manually.\
  <img src="assets/saveman.png" width=360>
- To set reference location, press the pencil icon on the menu bar. You can either set it manually or automatically.\
  <img src="assets/setloc.png" width=360>

- To edit the time of interval of saving trackoint , press the timer icon. This is only available when the mode is set to auto\
  <img src="assets/edittime.png" width=360>

- To share the location data as a .txt file, click on the History icon and choose the logs you want to share\
  <img src="assets/share.png" width=360>
- You can also view the previous trackpoints in the history.\
  <img src="assets/phist.png" width=360>
- To communicate with an ESP32 Bluetooth device, make sure the bluetooth is ON, click on the bluetooth icon to switch it ON or choose the bluetooth devices.Once the ESP32 device comes up, click on it and choose it again from the list.\
  <img src="assets/blu.png" width=360>
- Once connected, data is sent to the bluetooth device and then the rssi and snr from the LoRa is sent back to the app.

## Contributing

Contributions to the project are welcome. To contribute, follow these steps:

Fork the repository
Create a new branch
Make your changes
Submit a pull request

# GPS Bluetooth Server

Just run the ESP32 code in the folder `esp32\blutest.ino`,\
replace the demo below with the procedure for using integrating LoRa with ESP32 and getting the RSSI and SNR values

```c++
  // *************START OF REPLACE*************
  // get the rssi and snr value from the LoRa
  // NB , it must be sent as
  //  [rssi, snr]
  // as shown below which is just a demo
  String rssi = "10" + String(cnt);
  String snr = "11" + String(cnt);
  String rsmsg = rssi + "," + snr;
  //****************END OF REPLACE*******************
```
