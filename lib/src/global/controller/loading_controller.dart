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
    print(file.path);
    if (file.existsSync()) {
      await file.writeAsString(
        s,
        mode: FileMode.append,
      );
    } else {
      s = "time, latitude, longitude, accuracy, satellites, heading, speed, altitude,distance, RSSI, SNR \n$s";
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
    print(f.length);
    print("${dir.path}/gpslogger");
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
    print(s);
    List<CurrentLD> clds = [];

    for (var e in s) {
      if (e.isNotEmpty) {
        List<String> cldstr = e.split(",");
        print(cldstr);
        final cld = CurrentLD(
          time: cldstr[0],
          lat: cldstr[1],
          lng: cldstr[2],
          acc: cldstr[3],
          sat: cldstr[4],
          head: cldstr[5],
          spd: cldstr[6],
          alt: cldstr[7],
          dst: cldstr[8],
          rssi: cldstr[9],
          snr: cldstr[10],
        );
        clds.add(cld);
      }
    }
    return clds;
  }
}

class MCurrentLD {
  final List<CurrentLD> clds;
  final String nm, fp;

  MCurrentLD(this.nm, this.fp, this.clds);
}
