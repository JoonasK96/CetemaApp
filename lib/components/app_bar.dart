import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
Widget appBar() {
  return AppBar(
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text('Home'),
    ),),
    actions: <Widget>[
      IconButton(icon: FaIcon(FontAwesomeIcons.ellipsisV), onPressed: () => {}),

    ],

  );
}
