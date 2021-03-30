import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';


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
    print('$forecasts');

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Stack(
        children: [

          AspectRatio(
          aspectRatio: 1.7,

          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                 avgData()
              ),
            ),
          ),
        ),

      ],
        ),
        forecastDays(),
      ],

    );
  }
  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 10,

          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'MA';
              case 2:
                return 'TI';
              case 3:
                return 'KE';
              case 4:
                return 'TO';
              case 5:
                return 'PE';
              case 6:
                return 'LA';
              case 7:
                return 'SU';

            }
            return '';
          },
          margin: 7,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0%';
              case 10:
                return '10%';
              case 20:
                return '20%';
              case 30:
                return '30%';
              case 40:
                return '40%';
              case 50:
                return '50%';
              case 60:
                return '60%';
              case 70:
                return '70%';
              case 80:
                return '80%';
              case 90:
                return '90%';
              case 100:
                return '100%';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),

      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 50),
            FlSpot(1, 10),
            FlSpot(2, 20),
            FlSpot(3, 20),
            FlSpot(4, 35),
            FlSpot(5, 40),
            FlSpot(6, 10),
            FlSpot(7, 25),
          ],
          isCurved: true,
          /*colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],*/
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: Colors.blue, end: Colors.blue).lerp(0.2).withOpacity(0.2),
          ]),
        ),
      ],
    );
  }

  Container forecastDays() {
    return Container(
      color: Colors.blue[200],
      child: Column(
        children: [
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Text('Ma'),
                   Icon(Icons.wb_sunny),
                    Text('+20')
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text('Ti'),
                    Icon(Icons.cloud),
                    Text('+2')
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text('Ke'),
                    Icon(Icons.cloud),
                    Text('+2')
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text('To'),
                    Icon(Icons.wb_sunny),
                    Text('+2')
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text('Pe'),
                    Icon(Icons.wb_sunny),
                    Text('+2')
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text('La'),
                    Icon(Icons.wb_sunny),
                    Text('+2')
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

