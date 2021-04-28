import 'package:flutter/material.dart';
import 'package:flutter_app/components/forecast_card.dart';
import 'package:flutter_app/components/weather_card.dart';

class WeatherScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

            GetWeather(),

          Container(
            child: GetForecast(),
          )

            //
          ],
        );

  }
}
