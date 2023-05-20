import 'package:flutter/material.dart';
import 'package:rainyroute/Utils/color_utils.dart';
import 'package:rainyroute/Utils/constants.dart';

class CustomMessage extends StatelessWidget {
  const CustomMessage(
      {super.key,
      required this.cityName,
      required this.dayName,
      required this.weatherIcon,
      required this.temperature,
      required this.temperatureMin,
      required this.temperatureMax,
      required this.weatherCondition});

  final String cityName;
  final String dayName;
  final double temperature;
  final double temperatureMax;
  final double temperatureMin;
  final String weatherIcon;
  final String weatherCondition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          decoration: BoxDecoration(
            color: hexStringToColor('#8F95B9'),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    cityName,
                    style: kCityNameTextStyle,
                  ),
                  Text(
                    dayName,
                    style: kDayNameTextStyle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    child: Image.network(
                      weatherIcon,
                      height: 130,
                      // scale: 0.5,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '${temperature.toInt()}°',
                            style: kTemperatureTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              weatherCondition.toUpperCase(),
                              style: kConditionTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Image.asset(
                      'assets/images/tempLow.png',
                      height: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      '${temperatureMin.toInt()}°',
                      style: kSmallTemperatureTextStyle,
                    ),
                  ),
                  Image.asset(
                    'assets/images/tempHigh.png',
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      '${temperatureMax.toInt()}°',
                      style: kSmallTemperatureTextStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          left: 10,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(2),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/forecast.png',
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
