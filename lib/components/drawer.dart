import 'package:flutter/material.dart';

Widget drawer() {
  return Drawer(
    child: Container(
      color: Colors.transparent.withOpacity(.7),
      child: Column(
      children: <Widget>[
        Container(
          height: 110,
          child: DrawerHeader(
            child: Center(
              child: Text('Styles',
                style: TextStyle(color: Colors.white,),

              ),
            ),
            decoration: BoxDecoration(color: Colors.grey[850]),
          ),
        ),
        Text('Original'),
        Text('Satellite')

      ],
      ),
    ),
  );
}