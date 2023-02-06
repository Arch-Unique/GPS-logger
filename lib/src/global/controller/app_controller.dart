import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:unn_gps_logger/src/global/controller/location_controller.dart';
import 'package:unn_gps_logger/src/global/model/current_ld.dart';
import 'package:unn_gps_logger/src/global/ui/ui_barrel.dart';
import 'package:unn_gps_logger/src/utils/enums/enum_barrel.dart';

import '../../utils/functions/haversine.dart';

class AppController extends GetxController {
  final Rx<BluetoothState> bluetoothState = BluetoothState.UNKNOWN.obs;
  RxBool isAuto = true.obs;
  RxBool isConnected = false.obs;
  RxBool hasStarted = false.obs;
  Rx<Duration> duration = Duration(seconds: 60).obs;
  RxList<CurrentLD> clds = <CurrentLD>[].obs;
  final _pref = GetStorage();
  static final String UGREFLAT = "ugreflat";
  static final String UGREFLNG = "ugreflng";
  static final String UGTIME = "ugtime";

  TextEditingController timeTextController = TextEditingController();
  TextEditingController lngTextController = TextEditingController();
  TextEditingController latTextController = TextEditingController();
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;
  Rx<Loc> locs = Loc(0, 0).obs;

  RxList<BluetoothDevice> devicesList = <BluetoothDevice>[].obs;

  final locationController = Get.find<LocationController>();
  Timer? timer;

  @override
  void onInit() {
    setRefLoc();
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState.value = state;
    });

    // If the Bluetooth of the device is not enabled,
    // then request permission to turn on Bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState.value = state;
      print(bluetoothState.value);

      // For retrieving the paired devices list
      getPairedDevices();
    });
    super.onInit();
  }

  setRefLoc() {
    latTextController.text = _pref.read(UGREFLAT) ?? "";
    lngTextController.text = _pref.read(UGREFLNG) ?? "";
    changeDuration(_pref.read(UGTIME) ?? 0);
  }

  Future<void> enableBluetooth() async {
    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (bluetoothState.value == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
    } else {
      await getPairedDevices();
    }
  }

  Future<void> disableBluetooth() async {
    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (bluetoothState.value == BluetoothState.STATE_ON) {
      await FlutterBluetoothSerial.instance.requestDisable();
    }
  }

  saveReference() {
    if (lngTextController.value.text == "") return;
    if (latTextController.value.text == "") return;
    double d = double.parse(lngTextController.value.text);
    double g = double.parse(latTextController.value.text);
    _pref.write(UGREFLAT, d.toStringAsFixed(8));
    _pref.write(UGREFLNG, d.toStringAsFixed(8));
    locs.value = Loc(d, g);
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } on PlatformException {
      print("Error getting bonded devices");
      Ui.showSnackBar(
          "Error getting paired devices, Please check if bluetooth is on");
    }

    devicesList.value = devices;
  }

  connectBleDevice(int i) async {
    try {
      connection = await BluetoothConnection.toAddress(devicesList[i].address);
      if (connection?.isConnected ?? false) {
        Ui.showSnackBar("Connected Successfully", isError: false);
        isConnected.value = true;
        listenToBle();
      }
    } on PlatformException {
      print("Error connecting to device");
      Ui.showSnackBar("Error connecting to device");
    }
  }

  listenToBle() {
    connection?.input?.listen((event) {
      final d = ascii.decode(event).split(",");
      clds.last.rssi = d[0];
      clds.last.snr = d[1];
    });
  }

  changeTrackingMode() {
    isAuto.value = !isAuto.value;
  }

  changeDuration(int i) {
    if (i < 60) i = 60;
    if (i > 900) i = 900;
    duration.value = Duration(seconds: i);
    _pref.write(UGTIME, i);
  }

  startTracking() {
    hasStarted.value = true;
    if (isAuto.value) {
      timer = Timer.periodic(duration.value, (timer) {
        saveTrackPoint();
      });
    } else {
      saveTrackPoint();
    }
  }

  saveTrackPoint() {
    final cl = locationController.cld.value;
    final dist = cl.distance(locs.value);
    final sat = locationController.sat.value;
    cl.sat = sat.toString();
    cl.dst = dist.toString();
    clds.add(cl);
    connection?.output.add(ascii.encode(cl.toString()));
  }

  stopTracking() {
    hasStarted.value = false;
    timer?.cancel();
  }

  @override
  void dispose() {
    if (isConnected.value) {
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }
}
