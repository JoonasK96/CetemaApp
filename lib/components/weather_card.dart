import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



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
  
  AssetImage weatherImg() {
    int num = weather;
    if(weather != 800) {
       num = int.tryParse(weather.toString().split("")[0]);
    }
    debugPrint('num: $num');
    debugPrint('FYI: $weather');
    switch(num){
      case 2: {return AssetImage("assets/thunder.jp");}
      break;
      case 3: {return AssetImage("assets/drizzle.jpg");}
      break;
      case 5: {return AssetImage("assets/rain.jpg");}
      break;
      case 6: {return AssetImage("assets/snow.jpg");}
      break;
      case 7: {return AssetImage("assets/mist.jpg");}
      break;
      case 800: {return AssetImage("assets/sunny2.jpg");}
      break;
      case 8: {return AssetImage("assets/clouds.jpg");}
      break;

    }

  }




  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Padding(

        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0 ),
        child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
       // color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(

            image: weatherImg(),
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.75),
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
                    '$date',
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