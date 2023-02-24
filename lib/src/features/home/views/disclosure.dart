import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unn_gps_logger/src/features/home/views/home_page.dart';
import 'package:unn_gps_logger/src/global/controller/app_controller.dart';
import 'package:unn_gps_logger/src/global/controller/location_controller.dart';
import 'package:unn_gps_logger/src/global/ui/ui_barrel.dart';
import 'package:unn_gps_logger/src/global/ui/widgets/others/containers.dart';

class ProminentDisclosurePage extends StatelessWidget {
  const ProminentDisclosurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Location Permission Disclosure",
      isBack: false,
      child: Ui.padding(
        child: Column(
          children: [
            SizedText.thin(
                "To track GPS information automatically, even when the app is running in the background, the GPS Logger app requires permission to access your device's location. This permission is necessary to log your current location as you move about for modeling purposes."),
            Ui.boxHeight(24),
            SizedText.thin(
                "The app allows you to save GPS data either manually or automatically. When using the automatic mode, the app will log GPS data at intervals without requiring you to open the app. However, this feature requires your permission to access your device's location."),
            Ui.boxHeight(24),
            SizedText.thin(
                "Please grant the GPS Logger app permission to access your device's location for optimal performance. Failure to grant this permission may result in the app not functioning correctly."),
            Ui.boxHeight(24),
            FilledButton.white(() async {
              await [
                Permission.bluetoothConnect,
                Permission.bluetoothScan,
                Permission.bluetoothAdvertise,
                Permission.location,
                Permission.locationAlways
              ].request();
              Get.put(LocationController());
              Get.put(AppController());
              await GetStorage().write("UGPROM", true);
              Get.to(HomeScreen());
            }, "Okay")
          ],
        ),
      ),
    );
  }
}
