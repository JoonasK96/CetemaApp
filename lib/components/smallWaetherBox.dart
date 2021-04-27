import 'package:flutter/services.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeatherBox extends StatefulWidget {
  @override
  _WeatherBoxState createState() => _WeatherBoxState();
}

class _WeatherBoxState extends State<WeatherBox> {
  String key = '1f37f76405b72d05797fa4ada00ab9fe';
  WeatherFactory ws;
  double lat, lon;
  String location;
  DateTime date;
  int weather;
  Temperature temp;
  String icon;

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
    getLocation();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lon = position.longitude;
    debugPrint('FYI: $lat');
    getWeather();
  }

  void getWeather() async {
    Weather w = await ws.currentWeatherByLocation(lat, lon);
    location = w.areaName;
    date = w.date;
    weather = w.weatherConditionCode;
    temp = w.temperature;
    icon = w.weatherIcon;
    print(icon);

    debugPrint('sää: $weather');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        decoration:
            BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
        child: Center(
            child: Column(
          children: [
            Wrap(
              children: [
                Image.network(
                  "https://openweathermap.org/img/w/" + icon + ".png",
                  height: 35,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  "${temp.toString().split(" ")[0]} °C",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        )));
  }
}
