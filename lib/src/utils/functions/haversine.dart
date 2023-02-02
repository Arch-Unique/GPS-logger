import 'dart:math';

class Loc {
  final double latitude;
  final double longitude;

  Loc(this.latitude, this.longitude);
}

class RADII {
  int km;
  int mile;
  int meter;
  int nmi;

  RADII(this.km, this.mile, this.meter, this.nmi);
}

enum Unit { KM, MILE, METER, NMI }

class HaversineDistance {
  static RADII radii = RADII(6371, 3960, 6371000, 3440);

  static double toRad(double num) {
    return num * pi / 180;
  }

  static int getUnit(Unit unit) {
    switch (unit) {
      case (Unit.KM):
        return radii.km;
      case (Unit.MILE):
        return radii.mile;
      case (Unit.METER):
        return radii.meter;
      case (Unit.NMI):
        return radii.nmi;
      default:
        return radii.km;
    }
  }

  static double haversine(Loc startCoordinates, Loc endCoordinates, Unit unit) {
    final R = getUnit(unit);
    final dLat = toRad(endCoordinates.latitude - startCoordinates.latitude);
    final dLon = toRad(endCoordinates.longitude - startCoordinates.longitude);
    final lat1 = toRad(startCoordinates.latitude);
    final lat2 = toRad(endCoordinates.latitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }
}
