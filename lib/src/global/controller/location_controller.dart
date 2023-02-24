import 'dart:async';

import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:raw_gnss/gnss_status_model.dart';
import 'package:raw_gnss/raw_gnss.dart';
import 'package:unn_gps_logger/src/global/model/current_ld.dart';
import 'package:unn_gps_logger/src/utils/functions/haversine.dart';
import 'package:unn_gps_logger/src/utils/functions/kalman.dart';

class LocationController extends GetxController {
  Location location = Location();
  RawGnss rawGnss = RawGnss();
  KalmanFilter k = KalmanFilter();
  late StreamSubscription<LocationData> locationSubscription;
  late StreamSubscription<GnssStatusModel> gnssSubscription;
  Rx<CurrentLD> cld = CurrentLD().obs;
  RxInt sat = 0.obs;

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
    location.changeSettings(interval: 1000, distanceFilter: 1);
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
    gnssSubscription.cancel();
    print("unsubscribed");
    super.onClose();
  }

  void listenToChangesInLocation() {
    gnssSubscription = rawGnss.gnssStatusEvents.listen((event) {
      sat.value = event.satelliteCount ?? 0;
    });
    locationSubscription = location.onLocationChanged.listen((LocationData cl) {
      Loc c = k.filter(Loc(cl.latitude!, cl.longitude!));
      cld.value = CurrentLD.fromLocationData(cl);
      cld.value.lat = c.latitude.toStringAsFixed(8);
      cld.value.lng = c.longitude.toStringAsFixed(8);
    });
  }
}
