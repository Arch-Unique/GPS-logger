import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unn_gps_logger/src/global/model/current_ld.dart';

class LogController {
  static Future<bool> saveCLDS(List<CurrentLD> clds) async {
    String s = _convertListToString(clds);
    final dir = await getApplicationDocumentsDirectory();
    final dt = DateTime.now().toString();
    Directory("${dir.path}/gpslogger").createSync();
    File file = File("${dir.path}/gpslogger/gpslog-$dt.txt");
    if (file.existsSync()) {
      await file.writeAsString(
        s,
        mode: FileMode.append,
      );
    } else {
      s = "time, latitude, longitude, accuracy, satellites, heading, speed, altitude, RSSI, SNR \n$s";
      await file.writeAsString(
        s,
        mode: FileMode.write,
      );
    }
    return true;
  }

  static Future<List<MCurrentLD>> getCLDS() async {
    final dir = await getApplicationDocumentsDirectory();
    final f = Directory("${dir.path}/gpslogger").listSync();
    List<MCurrentLD> fg = f
        .map((ele) => MCurrentLD(
            basename(ele.path), ele.path, convertFileToCLD(File(ele.path))))
        .toList();

    return fg;
  }

  static shareCLDS(List<String> paths) async {
    final f = paths.map((e) => XFile(e)).toList();
    await Share.shareXFiles(f);
  }

  static String _convertListToString(List<CurrentLD> clds) {
    List<String> cldstr = clds.map((e) {
      return "$e\n";
    }).toList();
    String a = cldstr.join("\n");
    return a;
  }

  static List<CurrentLD> convertFileToCLD(File file) {
    final s = file.readAsLinesSync();

    final clds = s.map((e) {
      List<String> cldstr = e.split(",");
      return CurrentLD(
        time: cldstr[0],
        lat: cldstr[1],
        lng: cldstr[2],
        acc: cldstr[3],
        sat: cldstr[4],
        head: cldstr[5],
        spd: cldstr[6],
        alt: cldstr[7],
        rssi: cldstr[8],
        snr: cldstr[9],
      );
    }).toList();
    return clds;
  }
}

class MCurrentLD {
  final List<CurrentLD> clds;
  final String nm, fp;

  MCurrentLD(this.nm, this.fp, this.clds);
}
