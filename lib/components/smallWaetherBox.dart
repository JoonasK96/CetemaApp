import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WeatherBox extends StatefulWidget {
  @override
  _WeatherBoxState createState() => _WeatherBoxState();
}

class _WeatherBoxState extends State<WeatherBox> {
  String key = 'ba614d1580782f5af7e13e5063d6961e';
  late WeatherFactory ws;
  double? lat, lon;
  Location location = Location();
  DateTime? date;
  int? weather;
  Temperature? temp;
  String? icon;
  bool isLoaded = true;
  late bool _serviceEnabled;
  PermissionStatus? _permissionGranted;
  String? city;
  late LocationData _locationData;
  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
    getLocation();
  }

  void getLocation() async {
    try{
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
    lat = _locationData.latitude;
    lon = _locationData.longitude;
    debugPrint('FYI: $lat');
    getWeather();
  }catch(e){
      print("small weatherbox data fetching failed: $e");
    }
  }

  void getWeather() async {
    Weather w = await ws.currentWeatherByLocation(lat!, lon!);
    date = w.date;
    weather = w.weatherConditionCode;
    temp = w.temperature;
    icon = w.weatherIcon;
    print(icon);

    debugPrint('sää: $weather');
    setState(() {
      isLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? CircularProgressIndicator()
        : Container(
            width: 60,
            height: 60,
            decoration:
                BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
            child: Center(
                child: Column(
              children: [
                Wrap(
                  children: [
                    Image.network(
                      "https://openweathermap.org/img/w/" + icon! + ".png",
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
