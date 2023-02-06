import 'dart:async';

import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:raw_gnss/raw_gnss.dart';
import 'package:unn_gps_logger/src/global/model/current_ld.dart';
import 'package:unn_gps_logger/src/utils/functions/haversine.dart';
import 'package:unn_gps_logger/src/utils/functions/kalman.dart';

class LocationController extends GetxController {
  Location location = Location();
  RawGnss rawGnss = RawGnss();
  KalmanFilter k = KalmanFilter();
  late StreamSubscription<LocationData> locationSubscription;
  Rx<CurrentLD> cld = CurrentLD().obs;
  RxInt sat = 0.obs;
  int cdate = DateTime.now().millisecondsSinceEpoch;

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
    super.onClose();
  }

  int gcdate() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void listenToChangesInLocation() {
    rawGnss.gnssStatusEvents.listen((event) {
      sat.value = event.satelliteCount ?? 0;
    });
    // location.onLocationChanged.listen((LocationData cl) {
    //   Loc c = k.filter(Loc(cl.latitude!, cl.longitude!));
    //   if (gcdate() - cdate > 5000) {
    //     cld.value = CurrentLD.fromLocationData(cl);
    //     cld.value.lat = c.latitude.toString();
    //     cld.value.lng = c.longitude.toString();
    //     cdate = gcdate();
    //   }
    // });
  }
}
