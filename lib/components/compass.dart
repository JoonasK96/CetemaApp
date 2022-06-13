import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

Widget buildCompass() {
  return StreamBuilder<CompassEvent>(
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

      double? direction = snapshot.data!.heading;

      // if direction is null, then device does not support this sensor
      // show error message
      if (direction == null)
        return Center(
          child: Text("Device does not have sensors !"),
        );
      int ang;
      if(direction.round().isNegative){
        ang =  360 + direction.round();
      }else ang = direction.round();

      return Stack(
        children: [
          Container(
            width: 320,
            height: 320,

            alignment: Alignment.center,
            child: Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: Image(image: AssetImage('assets/compass.png')),
            ),
          ),
          Positioned.fill(
            child: Image(image: AssetImage('assets/dial.png')),
          ),
          Positioned.fill(
            child: Align(
              child: Text(
                "${ang}",
                style: TextStyle(
                  color: Color(0xFFEBEBEB),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
