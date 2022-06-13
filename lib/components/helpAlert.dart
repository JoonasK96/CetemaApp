import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/user_notifier.dart';
import 'package:flutter_app/components/map.dart';
import 'package:flutter_app/firebase2.dart';
import 'package:flutter_app/screens/map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AlertView extends StatefulWidget {

  @override
  _AlerviewState createState() => _AlerviewState();
  }

  final GlobalKey<_AlerviewState> widgetKey2 = GlobalKey<_AlerviewState>();

  class _AlerviewState extends State<AlertView> {

  final backend = FirebaseClass2();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(builder: ( context, model, child) {



          return  Visibility(visible: model.visible, child: AlertDialog(
            title: Text("Someone needs help, can you help them? "),
            actions: [
              TextButton(
                  onPressed: () {
                    backend.goingToHelp(model.users.firstWhere((element) => element.needsHelp == true).id.toString());

                  },
                  child: Text("YES")),
              TextButton(
                  onPressed: () => setState(() {
                    model.dissmissAlert();
                  }),
                  child: Text("NO"))
            ],
          ));
        }
    ); }



  }


