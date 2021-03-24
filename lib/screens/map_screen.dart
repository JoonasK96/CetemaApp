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
    return  Container(
      color: Colors.black87,
      child: Column(

        children:  <Widget>[
          Column(
            children: <Widget> [ Container(
            height: 50.0,
            color: Colors.grey[850],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Text('Original', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                ),
                Text('Satellite',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),)
              ],
            ),
          ),],
          ),





          buildCompass()],
      ),

    );
  }
}
