import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';
import 'package:flutter_app/components/app_bar.dart';
import 'package:flutter_app/components/drawer.dart';
class Map extends StatefulWidget {
  Map({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black87,
      body: Column(

        children:  <Widget>[
          Column(
            children: <Widget> [
            /*  Container(
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
          ),*/
            ],
          ),



          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
              child: buildCompass(),
            )
          ),],
      ),

    );
  }
}
