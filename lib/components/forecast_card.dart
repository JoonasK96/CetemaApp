import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/weatherValues.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GetForecast extends StatefulWidget {
  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<GetForecast> {
  String key = '1f37f76405b72d05797fa4ada00ab9fe';
  WeatherFactory ws;
  double lat, lon;
  List<Weather> forecastData = [];
  String temp;
  bool weatherValuesLoading = true;
  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key, language: Language.FINNISH);
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
    temp = forecastData[1].temperature.toString();
    setState(() {
      weatherValuesLoading = false;
    });
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
                decoration: const BoxDecoration(color: const Color(0xC2E0FF)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(avgData()),
                ),
              ),
            ),
          ],
        ),
        Container(
            child: weatherValuesLoading
                ? CircularProgressIndicator()
                : forecastDays()),
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
            color: const Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff000000),
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
            color: Color(0xff000000),
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
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff000000), width: 1)),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 34),
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
            ColorTween(begin: Colors.blue, end: Colors.blue)
                .lerp(0.2)
                .withOpacity(0.4),
          ]),
        ),
      ],
    );
  }

  Container forecastDays() {
    return Container(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: this.forecastData.length,
        separatorBuilder: (context, index) => Divider(
          height: 100,
          color: Colors.white,
        ),
        padding: EdgeInsets.only(left: 10, right: 10),
        itemBuilder: (context, index) {
          final item = this.forecastData[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: WeatherValues(
              DateFormat('E, ha').format(DateTime.parse(item.date.toString())),
              '${item.temperature.toString().split(" ")[0]}°C',
              iconData: "https://openweathermap.org/img/w/" +
                  item.weatherIcon +
                  ".png",
            )),
          );
        },
      ),
    );
  }
}
