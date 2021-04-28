import 'package:flutter/material.dart';

class WeatherValues extends StatelessWidget {
  final String label;
  final String value;
  final String iconData;

  WeatherValues(this.label, this.value, {this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.label,
          style: TextStyle(
              color: Colors.black),
        ),
        SizedBox(
          height: 5,
        ),
         Image.network(
          iconData,
           height: 35,
           fit: BoxFit.fitWidth
        ),

        SizedBox(
          height: 10,
        ),
        Text(
          this.value,
          style:
          TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}