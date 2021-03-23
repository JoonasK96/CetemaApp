import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';


class Map extends StatefulWidget {
  Map({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return buildCompass();
  }


}
