import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_gps_logger/src/global/controller/app_controller.dart';
import 'package:unn_gps_logger/src/global/controller/loading_controller.dart';
import 'package:unn_gps_logger/src/global/model/current_ld.dart';
import 'package:unn_gps_logger/src/global/ui/ui_barrel.dart';
import 'package:unn_gps_logger/src/global/ui/widgets/others/containers.dart';

class TrackPointScreen extends StatefulWidget {
  const TrackPointScreen({this.clds, super.key});
  final List<CurrentLD>? clds;

  @override
  State<TrackPointScreen> createState() => _TrackPointScreenState();
}

class _TrackPointScreenState extends State<TrackPointScreen> {
  final controller = Get.find<AppController>();
  List<CurrentLD> cld = [];

  @override
  void initState() {
    cld = widget.clds ?? controller.clds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Track Points",
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          return Ui.padding(
              padding: 8,
              child: Row(
                children: [
                  AppText.thin("${i + 1}  "),
                  Ui.boxWidth(24),
                  SizedText.thin(
                    cld[i].toString(),
                  )
                ],
              ));
        },
        itemCount: cld.length,
      ),
    );
  }
}
