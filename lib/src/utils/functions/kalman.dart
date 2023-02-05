import 'package:unn_gps_logger/src/utils/functions/haversine.dart';

class KalmanFilter {
  double? lastEstimateLat;
  double? lastEstimateLng;
  double lastErrorCovarianceLat;
  double lastErrorCovarianceLng;
  double processNoiseLat;
  double processNoiseLng;
  double measurementNoiseLat;
  double measurementNoiseLng;

  KalmanFilter({
    this.processNoiseLat = 0.000001,
    this.processNoiseLng = 0.000001,
    this.measurementNoiseLat = 0.00000001,
    this.measurementNoiseLng = 0.00000001,
    this.lastErrorCovarianceLat = 1,
    this.lastErrorCovarianceLng = 1,
    this.lastEstimateLat,
    this.lastEstimateLng,
  });

  Loc filter(Loc measurement) {
    if (lastEstimateLat == null) {
      lastEstimateLat = measurement.latitude;
      lastEstimateLng = measurement.longitude;
    }

    double currentEstimateLat = lastEstimateLat!;
    double currentEstimateLng = lastEstimateLng!;
    double currentErrorCovarianceLat = lastErrorCovarianceLat + processNoiseLat;
    double currentErrorCovarianceLng = lastErrorCovarianceLng + processNoiseLng;

    double kalmanGainLat = currentErrorCovarianceLat /
        (currentErrorCovarianceLat + measurementNoiseLat);
    double kalmanGainLng = currentErrorCovarianceLng /
        (currentErrorCovarianceLng + measurementNoiseLng);
    currentEstimateLat = currentEstimateLat +
        kalmanGainLat * (measurement.latitude - currentEstimateLat);
    currentEstimateLng = currentEstimateLng +
        kalmanGainLng * (measurement.longitude - currentEstimateLng);
    currentErrorCovarianceLat = (1 - kalmanGainLat) * currentErrorCovarianceLat;
    currentErrorCovarianceLng = (1 - kalmanGainLng) * currentErrorCovarianceLng;

    lastEstimateLat = currentEstimateLat;
    lastEstimateLng = currentEstimateLng;
    lastErrorCovarianceLat = currentErrorCovarianceLat;
    lastErrorCovarianceLng = currentErrorCovarianceLng;

    return Loc(currentEstimateLat, currentEstimateLng);
  }
}
