import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

Widget buildCompass() {
  return StreamBuilder<double>(
    stream: FlutterCompass.events,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error reading heading: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      double direction = snapshot.data;

      // if direction is null, then device does not support this sensor
      // show error message
      if (direction == null)
        return Center(
          child: Text("Device does not have sensors !"),
        );

      int ang = (direction.round());
      return Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: ((direction ?? 0) * (math.pi / 180) * -1),
              child: Image(image: AssetImage('assets/compass.png')),
            ),
          ),
          Center(
            child: Image(image: AssetImage('assets/dial.png')),
          ),
          Center(
            child: Text(
              "$ang",
              style: TextStyle(
                color: Color(0xFFEBEBEB),
                fontSize: 24,
              ),
            ),
          ),
        ],
      );
    },
  );
}
