import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'dart:math';

import 'package:unn_gps_logger/src/utils/functions/haversine.dart';

class CurrentLD {
  String? lat, lng, acc, time, sat, head, spd, alt, rssi, snr, dst;

  CurrentLD(
      {this.lat = "",
      this.lng = "",
      this.acc = "0",
      this.time = "0",
      this.sat = "0",
      this.head = "0",
      this.spd = "0",
      this.dst = "0",
      this.rssi = "0",
      this.snr = "0",
      this.alt = "0"});

  @override
  String toString() {
    return "$time, $lat , $lng, $acc, $sat, $head, $spd, $alt,$dst, $rssi, $snr \n";
  }

  double get rawLat => double.parse(lat ?? "0");
  double get rawLng => double.parse(lng ?? "0");

  String distance(Loc lc) {
    if (lc.latitude == 0) return "0";
    if (lc.longitude == 0) return "0";
    final d = HaversineDistance.haversine(
        Loc(rawLat, rawLng), Loc(lc.latitude, lc.longitude), Unit.METER);
    return d.toStringAsFixed(2);
  }

  factory CurrentLD.fromLocationData(LocationData ld) {
    return CurrentLD(
        lat: ld.latitude?.toString() ?? "0",
        lng: ld.longitude?.toString() ?? "0",
        acc: ld.accuracy?.toStringAsFixed(2) ?? "0",
        time: ld.time == null
            ? ld.time.toString()
            : DateFormat.Hms()
                .format(DateTime.fromMillisecondsSinceEpoch(ld.time!.toInt())),
        sat: ld.satelliteNumber?.toString() ?? "0",
        head: ld.heading?.toStringAsFixed(2) ?? "0",
        alt: ld.altitude?.toStringAsFixed(2) ?? "0",
        spd: ld.speed?.toStringAsFixed(2) ?? "0");
  }
}
