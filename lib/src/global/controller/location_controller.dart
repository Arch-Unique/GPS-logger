import 'dart:async';

import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:unn_gps_logger/src/global/model/current_ld.dart';

class LocationController extends GetxController {
  Location location = Location();
  late StreamSubscription<LocationData> locationSubscription;
  Rx<CurrentLD> cld = CurrentLD().obs;

  Future<void> setInitLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    LocationData ld = await location.getLocation();
    cld.value = CurrentLD.fromLocationData(ld);
    location.enableBackgroundMode(enable: true);

    listenToChangesInLocation();
  }

  @override
  void onInit() {
    setInitLocation();
    super.onInit();
  }

  @override
  void onClose() {
    locationSubscription.cancel();
    super.onClose();
  }

  void listenToChangesInLocation() {
    location.onLocationChanged.listen((LocationData cl) async {
      cld.value = CurrentLD.fromLocationData(cl);
    });
  }
}
