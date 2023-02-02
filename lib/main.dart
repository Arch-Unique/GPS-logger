import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unn_gps_logger/src/app/theme/colors.dart';
import 'package:unn_gps_logger/src/features/home/views/home_page.dart';
import 'package:unn_gps_logger/src/global/controller/location_controller.dart';
import 'package:unn_gps_logger/src/global/controller/app_controller.dart';
import 'package:unn_gps_logger/src/utils/constants/constant_barrel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.black.withOpacity(0),
    statusBarIconBrightness: Brightness.dark,
  ));
  await [
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
    Permission.bluetoothAdvertise,
    Permission.location,
    Permission.locationAlways
  ].request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());
    Get.put(AppController());

    return GetMaterialApp(
      title: 'GPS Logger',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'GB'), // English
      ],
      theme: ThemeData(
        fontFamily: Assets.appFontFamily,
        scaffoldBackgroundColor: AppColors.primaryColor,
      ),
      home: HomeScreen(),
    );
  }
}
