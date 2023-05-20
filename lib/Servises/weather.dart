import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:rainyroute/Servises/location.dart';
import 'package:rainyroute/Servises/network.dart';

const apiKey = 'YOUR_API_KEY';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric&lang=pl');

    var weatherData = await networkHelper.getData();
    print('$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric&lang=pl');
    return weatherData;
  }

  Future<dynamic> getLocationWeather(LatLng location) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric&lang=pl');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return 'thunder';
    } else if (condition < 400) {
      return 'drizzle';
    } else if (condition == 500) {
      return 'rain';
    } else if (condition < 600) {
      return 'heavy_rain';
    } else if (condition < 700) {
      return 'snow';
    } else if (condition < 800) {
      return 'fog';
    } else if (condition == 800) {
      return 'sun';
    } else if (condition <= 804) {
      return 'cloud';
    } else {
      return 'thermometer';
    }
  }
}
