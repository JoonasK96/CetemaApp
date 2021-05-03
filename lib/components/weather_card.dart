import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cron/cron.dart';

class GetWeather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<GetWeather> {
  String key = '1f37f76405b72d05797fa4ada00ab9fe';
  WeatherFactory ws;
  double lat, lon;
  String location;
  DateTime date;
  int weather;
  Temperature temp;
  String icon;
  bool loading = true;

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
    weatherImg();
    debugPrint('sää: $weather');
  }

  void reload() async {
    final cron = Cron();
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      print('every minute, minute passes');
    });
  }

  AssetImage weatherImg() {
    int num = weather;
    if(weather != 800) {
       num = int.tryParse(weather.toString().split("")[0]);
    }
    debugPrint('num: $num');
    debugPrint('FYI: $weather');
    switch(num){
      case 2: {loadingDone();return AssetImage("assets/thunder.jp");}
      break;
      case 3: {loadingDone();return AssetImage("assets/drizzle.jpg");}
      break;
      case 5: {loadingDone();return AssetImage("assets/rain.jpg");}
      break;
      case 6: {loadingDone();return AssetImage("assets/snow.jpg");}
      break;
      case 7: {loadingDone();return AssetImage("assets/mist.jpg");}
      break;
      case 800: {loadingDone();return AssetImage("assets/sunny2.jpg");}
      break;
      case 8: {loadingDone(); return AssetImage("assets/clouds.jpg");}
      break;

    }

    return AssetImage("assets/sunny2.jpg");

  }
  void loadingDone(){
  setState(() {
    loading = false;
  });
  }




  @override
  Widget build(BuildContext context) {
    return loading? CircularProgressIndicator() : Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Padding(

        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0 ),
        child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
       // color: Colors.grey[400],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
          ),
          image: DecorationImage(

            image: weatherImg(),
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.70),
                 BlendMode.dstATop
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$temp',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,

                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    DateFormat('E, ha').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}