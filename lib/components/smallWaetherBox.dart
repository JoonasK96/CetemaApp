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

    debugPrint('sää: $weather');
  }
  @override
  Widget build(BuildContext context) {
    return Container();


}}