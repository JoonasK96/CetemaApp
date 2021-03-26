import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';



class GetForecast extends StatefulWidget {
  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<GetForecast> {
  String key = '1f37f76405b72d05797fa4ada00ab9fe';
  WeatherFactory ws;
  double lat, lon;
  List<Weather> forecastData = [];

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
    queryForecast();
  }

  void queryForecast() async {
    List<Weather> forecasts =
    (await ws.fiveDayForecastByLocation(lat, lon)).cast<Weather>();
    forecastData = forecasts;

  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text('$forecastData'),
    );
  }
}