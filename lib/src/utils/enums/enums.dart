import 'package:flutter/material.dart';
import '/src/src_barrel.dart';

enum PasswordStrength {
  normal,
  weak,
  okay,
  strong,
}

enum FPL {
  email(TextInputType.emailAddress),
  number(TextInputType.number),
  text(TextInputType.text),
  password(TextInputType.visiblePassword),
  multi(TextInputType.multiline, maxLength: 1000, maxLines: 5),
  phone(TextInputType.phone),
  money(TextInputType.number),

  //card details
  cvv(TextInputType.number, maxLength: 4),
  cardNo(TextInputType.number, maxLength: 20),
  dateExpiry(TextInputType.datetime, maxLength: 5);

  final TextInputType textType;
  final int? maxLength, maxLines;

  const FPL(this.textType, {this.maxLength, this.maxLines = 1});
}

enum CardType {
  masterCard(Assets.mastercard),
  visa(Assets.visa),
  verve(Assets.verve),
  invalid("");

  final String icon;
  const CardType(this.icon);
}

enum UnicabService {
  escort("Escorts", Assets.escort, Assets.escortBig, 1.5, Alignment.centerLeft),
  groupTransport("Group Transport", Assets.groupTransport,
      Assets.groupTransportBig, 1, Alignment.center),
  aeroTrip("AeroTrips", Assets.aeroTrip, Assets.aeroTripBig, 1.5,
      Alignment.centerRight);

  final String name, icon, bigIcon;
  final double scale;
  final Alignment align;

  const UnicabService(
      this.name, this.icon, this.bigIcon, this.scale, this.align);
}

enum VerificationProcess {
  initial,
  inProgress,
  accepted,
  rejected,
}

enum RideStates {
  searchingForDriver(0.5, 0), //0
  foundDriver(0.5, 0), //1
  driverArrived(0.5, 0), //2
  rideStarted(0.24, 2), //3
  rideChanged(1.0, 3), //4 destination changed
  rideCanceled(1.0, 3), //5 from user or driver
  rideFinished(1.0, 3); //6

  final double size;
  final int screen;
  const RideStates(this.size, this.screen);
}
