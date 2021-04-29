import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/map.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_app/components/User.dart';
import 'dart:async';
import 'components/User.dart';

class FirebaseClass2 {
  //GlobalKey<FirebaseClass2> widgetKey = GlobalKey<FirebaseClass2>();
  Location _location = Location();
  LocationData _locationData;
  StreamSubscription<LocationData> locationSubscription;
  final fb = FirebaseDatabase.instance;
  final testLocation = "testing1";

  var retrievedLocation;
  DatabaseReference _locationRef = FirebaseDatabase.instance.reference();

  void sendLocation() {
    //final ref = fb.reference();
    //ref.child(testLocation).set(
    //    "_locationData"); //sijainti pitäs repästä tänne jotenki, globalkey?
    //getLocation();
    print('sending location...');
    print(_locationData.latitude);
    print(_locationData.longitude);
    User userObject =
        User(_locationData.latitude, _locationData.longitude, "ebin", false);

    //userObject.latitude = _locationData.latitude;
    //userObject.longitude = _locationData.longitude;
    //userObject.id = "ebin";
    //userObject.needsHelp = false;

    //String megabanger = {"id": userObject.id, "help": userObject.needsHelp, };
    //String megajson = jsonEncode(userObject);

    String json = jsonEncode(userObject);

    //DatabaseReference _someFirstRef =
    //FirebaseDatabase.instance.reference().child(testLocation);
    _locationRef.child(testLocation).set(json);
    //_locationRef.set(json); //userObject
  }

  void retrieveLocation() {
    //final ref = fb.reference();

    _locationRef.child("testing1").once().then((DataSnapshot data) {
      //print('help! $data.value');
      print(data.value);
      print(data.key);
      //setState(() {

      Map<String, dynamic> userMap = jsonDecode(data.value);
      var retrievedData = User.fromJson(
          userMap); //tää retrievedData on nyt se DB:stä haettu yhen käyttäjän datamöykky

      //});
    });
  }

  void getLocation() async {
    _locationData = await _location.getLocation();
    //_countDistance();
    //return _locationData;
  }

  sendHelpNotification() {
    retrieveLocation();
    print("help has been requested by some user");
  }
}
