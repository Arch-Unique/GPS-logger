import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_gps_logger/src/global/ui/widgets/others/containers.dart';
import 'package:unn_gps_logger/src/src_barrel.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

AppBar backAppBar({String? title, Color color = AppColors.white}) {
  return AppBar(
      backgroundColor: Colors.transparent,
      title: title == null
          ? null
          : AppText.bold(title, fontSize: 22, color: color),
      elevation: 0,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        );
      }));
}
