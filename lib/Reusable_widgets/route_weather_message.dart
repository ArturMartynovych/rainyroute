import 'package:flutter/material.dart';
import 'package:rainyroute/Utils/color_utils.dart';
import 'package:rainyroute/Utils/constants.dart';

class CustomRouteMessage extends StatelessWidget {
  const CustomRouteMessage({
    super.key,
    required this.distance,
    required this.time,
    required this.weatherIcon,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.weatherCondition,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
  });

  final String distance;
  final String time;
  final int temperature;
  final int temperatureMax;
  final int temperatureMin;
  final String weatherIcon;
  final String weatherCondition;
  final String pressure;
  final String humidity;
  final String windSpeed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(2, 5, 2, 5),
        height: 250,
        decoration: BoxDecoration(
          color: hexStringToColor('#8F95B9'),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/time.png',
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      time,
                      style: kSmallTemperatureTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/tempHigh.png',
                              height: 40,
                            ),
                            Text(
                              '$temperatureMax°',
                              style: kSmallRouteTemperatureTextStyle,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/tempAvg.png',
                                height: 40,
                              ),
                              Text(
                                '$temperature°',
                                style: kSmallRouteTemperatureTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/tempLow.png',
                              height: 40,
                            ),
                            Text(
                              '$temperatureMin°',
                              style: kSmallRouteTemperatureTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.network(
                              weatherIcon,
                              height: 120,
                              // scale: 0.5,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              weatherCondition,
                              style: kSmallRouteTemperatureTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/windSpeed.png',
                              height: 25,
                            ),
                            Text(
                              '$windSpeed km/h',
                              style: kSmallRouteTemperatureTextStyle,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/humidity.png',
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '$humidity%',
                                  style: kSmallRouteTemperatureTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/pressure.png',
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '$pressure Pa',
                                style: kSmallRouteTemperatureTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/distance.png',
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    distance,
                    style: kSmallTemperatureTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
