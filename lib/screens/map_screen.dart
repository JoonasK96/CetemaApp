import 'package:flutter/material.dart';
import 'package:flutter_app/components/map.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: appBar(),
        //drawer: drawer(),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body:
            /*Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              */ /*  Container(
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
          ),*/ /*
            ],
          ),
          */
            Stack(
          children: [
            Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: MapClass()),
          ],
        ));
  }
}
