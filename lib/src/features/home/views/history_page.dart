import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_gps_logger/src/features/home/views/widgets/trackpoint_list.dart';
import 'package:unn_gps_logger/src/global/controller/app_controller.dart';
import 'package:unn_gps_logger/src/global/controller/loading_controller.dart';
import 'package:unn_gps_logger/src/global/ui/ui_barrel.dart';
import 'package:unn_gps_logger/src/global/ui/widgets/others/containers.dart';
import 'package:unn_gps_logger/src/src_barrel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "History",
      child: FutureBuilder(
          future: LogController.getCLDS(),
          builder: (context, snp) {
            if (snp.data == null) {
              return Center(child: AppText.thin("No History found"));
            }
            return ListView.builder(
              itemBuilder: (ctx, i) {
                return ListTile(
                  title: AppText.medium(snp.data![i].nm),
                  subtitle: AppText.thin(snp.data![i].fp),
                  trailing: IconButton(
                      onPressed: () {
                        LogController.shareCLDS([snp.data![i].fp]);
                      },
                      icon: Icon(Icons.share, color: AppColors.white)),
                  onTap: () {
                    Get.to(TrackPointScreen(
                      clds: snp.data![i].clds,
                    ));
                  },
                );
              },
              itemCount: snp.data!.length,
            );
          }),
    );
  }
}
