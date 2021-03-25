import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';





class GetWeather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<GetWeather> {
  String key = '1f37f76405b72d05797fa4ada00ab9fe';
  WeatherFactory ws;
  double lat, lon;
  List<Weather> wData = [];
  List<Weather> forecastData = [];


  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
    getLocation();
    log('message');
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lon = position.longitude;
    debugPrint('FYI: $lat');
    getWeather();
    queryForecast();
  }

  void queryForecast() async {
    List<Weather> forecasts = (await ws.fiveDayForecastByLocation(lat, lon))
        .cast<Weather>();
    forecastData = forecasts;
  }
  void getWeather() async {

    Weather w = await ws.currentWeatherByLocation(lat, lon);
    setState(() {
      wData = [w];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('$lon $lat $wData'),

      ],
    );
  }
}
