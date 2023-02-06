import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:unn_gps_logger/src/features/home/views/history_page.dart';
import 'package:unn_gps_logger/src/features/home/views/widgets/custom_dropdown.dart';
import 'package:unn_gps_logger/src/features/home/views/widgets/trackpoint_list.dart';
import 'package:unn_gps_logger/src/global/controller/app_controller.dart';
import 'package:unn_gps_logger/src/global/controller/loading_controller.dart';
import 'package:unn_gps_logger/src/global/controller/location_controller.dart';
import 'package:unn_gps_logger/src/global/model/current_ld.dart';
import 'package:unn_gps_logger/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:unn_gps_logger/src/global/ui/widgets/others/containers.dart';
import 'package:unn_gps_logger/src/src_barrel.dart';

import '../../../global/ui/ui_barrel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.bold("GPS Logger"),
        elevation: 0,
        backgroundColor: AppColors.primaryColorBackground,
        actions: [
          IconButton(onPressed: () {
            controller.changeTrackingMode();
          }, icon: Obx(() {
            return Icon(
              Icons.brightness_auto_rounded,
              color: controller.isAuto.value ? AppColors.white : AppColors.grey,
            );
          })),
          IconButton(
              onPressed: () {
                Ui.showBottomSheet(children: [
                  CustomTextField(
                    "5.465776",
                    "Enter Longitude Value",
                    controller.lngTextController,
                    varl: FPL.number,
                  ),
                  CustomTextField(
                    "5.757648",
                    "Enter Latitude Value",
                    controller.latTextController,
                    varl: FPL.number,
                  ),
                  Ui.boxHeight(24),
                  FilledButton.white(() {
                    controller.saveReference();
                    Get.back();
                  }, "Save")
                ]);
              },
              icon: Icon(
                Icons.edit,
                color: AppColors.white,
              )),
          IconButton(
              onPressed: () {
                Get.to(HistoryScreen());
              },
              icon: Icon(
                Icons.history,
                color: AppColors.white,
              )),
        ],
        leading: Obx(() {
          return controller.bluetoothState.value != BluetoothState.STATE_OFF &&
                  controller.bluetoothState.value != BluetoothState.STATE_ON
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgress(24),
                )
              : IconButton(
                  onPressed: () async {
                    FlutterBluetoothSerial.instance.openSettings();
                  },
                  icon: Icon(
                    controller.isConnected.value
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth,
                    color: controller.isConnected.value
                        ? AppColors.blue
                        : AppColors.grey,
                  ));
        }),
      ),
      body: SingleChildScrollView(
        child: Ui.padding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Obx(() {
                  return controller.devicesList.isEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgress(24),
                            Ui.boxHeight(8),
                            AppText.thin14("Getting Bluetooth devices")
                          ],
                        )
                      : CustomTextField.dropdown(
                          controller.devicesList
                              .map((e) => e.name ?? "Unknown Device")
                              .toList(),
                          TextEditingController(),
                          "Choose Bluetooth Device", onChanged: (i) async {
                          int j = controller.devicesList
                              .map((e) => e.name ?? "Unknown Device")
                              .toList()
                              .indexOf(i);
                          await controller.connectBleDevice(j);
                        });
                }),
              ),
              Ui.boxHeight(24),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Obx(() {
                        return FilledButton(
                            onPressed: () {
                              controller.isAuto.value
                                  ? controller.hasStarted.value
                                      ? controller.stopTracking()
                                      : controller.startTracking()
                                  : controller.saveTrackPoint();
                            },
                            color: controller.isAuto.value
                                ? controller.hasStarted.value
                                    ? AppColors.red
                                    : AppColors.white
                                : AppColors.accentColor,
                            text: controller.isAuto.value
                                ? controller.hasStarted.value
                                    ? "STOP"
                                    : "START"
                                : "SAVE");
                      })),
                  Obx(() {
                    return WidgetOrNull(
                      controller.isAuto.value,
                      child: Expanded(
                          flex: 1,
                          child: CurvedContainer(
                            onPressed: () {
                              Ui.showBottomSheet(children: [
                                CustomTextField(
                                  "60",
                                  "Enter in seconds (Min: 60,Max: 900)",
                                  controller.timeTextController,
                                  varl: FPL.number,
                                ),
                                Ui.boxHeight(24),
                                FilledButton.white(() {
                                  int df = 0;
                                  if (controller
                                          .timeTextController.value.text ==
                                      "") {
                                    df = 5;
                                  } else {
                                    df = int.parse(controller
                                        .timeTextController.value.text);
                                  }
                                  controller.changeDuration(df);
                                  Get.back();
                                }, "Save")
                              ]);
                            },
                            child: const SizedBox(
                                height: 32,
                                width: 32,
                                child: Icon(
                                  Icons.timer,
                                  color: AppColors.white,
                                )),
                          )),
                    );
                  }),
                  Expanded(
                      flex: 1,
                      child: CurvedContainer(
                        onPressed: () {
                          Get.to(TrackPointScreen());
                        },
                        margin: EdgeInsets.only(left: 16),
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: Obx(() {
                            return Center(
                                child:
                                    AppText.bold("${controller.clds.length}"));
                          }),
                        ),
                      ))
                ],
              ),
              Ui.boxHeight(24),
              Obx(() {
                return RowCell(
                    "Satellites", "${controller.locationController.sat.value}");
              }),
              Ui.boxHeight(24),
              StreamBuilder<LocationData>(
                  stream:
                      controller.locationController.location.onLocationChanged,
                  builder: (context, snapshot) {
                    CurrentLD cld = CurrentLD.fromLocationData(snapshot.data);
                    return Column(
                      children: [
                        RowCell("Latitude", cld.lat!),
                        RowCell("Longitude", cld.lng!),
                        RowCell("Altitude", "${cld.alt!} m"),
                        RowCell("Accuracy", "${cld.acc!} m"),
                        RowCell("Heading", cld.head!),
                        RowCell("Speed", "${cld.spd!} m/s"),
                        RowCell("Time", cld.time!),
                        RowCell("Distance",
                            "${cld.distance(controller.locs.value)} m")
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    LogController.saveCLDS(controller.clds);
  }
}
