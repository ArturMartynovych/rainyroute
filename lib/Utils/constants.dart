import 'package:flutter/material.dart';
import 'package:rainyroute/Utils/color_utils.dart';

Color weatherLight = hexStringToColor('#F7F6F4');

TextStyle kCityNameTextStyle = TextStyle(
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.bold,
  fontSize: 28.0,
  color: weatherLight,
);

TextStyle kDayNameTextStyle = TextStyle(
  fontFamily: 'Satoshi',
  fontSize: 16.0,
  color: weatherLight,
);

TextStyle kTemperatureTextStyle = TextStyle(
  fontFamily: 'Satoshi',
  fontWeight: FontWeight.bold,
  fontSize: 55.0,
  color: weatherLight,
);

TextStyle kConditionTextStyle = TextStyle(
  fontFamily: 'Satoshi',
  fontSize: 20.0,
  color: weatherLight,
);

TextStyle kSmallTemperatureTextStyle = TextStyle(
  fontFamily: 'Satoshi',
  fontSize: 24.0,
  color: weatherLight,
);

TextStyle kSmallRouteTemperatureTextStyle = TextStyle(
  fontFamily: 'Satoshi',
  fontSize: 16.0,
  color: weatherLight,
);
