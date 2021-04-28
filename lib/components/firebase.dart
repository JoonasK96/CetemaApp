import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/map.dart';
import 'package:location/location.dart';

class FirebaseClass extends StatefulWidget {
  @override
  _FirebaseClassState createState() => _FirebaseClassState();
}

GlobalKey<_FirebaseClassState> widgetKey = GlobalKey<_FirebaseClassState>();

class _FirebaseClassState extends State<FirebaseClass> {
  Location _location = Location();
  LocationData _locationData;
  final fb = FirebaseDatabase.instance;
  final testLocation = "testing1";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }

  var retrievedLocation;

  void sendLocation() {
    //final ref = fb.reference();
    //ref.child(testLocation).set(
    //    "_locationData"); //sijainti pitäs repästä tänne jotenki, globalkey?
    print('perkele');

    DatabaseReference _someFirstRef =
        FirebaseDatabase.instance.reference().child(testLocation);
    _someFirstRef.set("sätii"); //_locationData
  }

  void retrieveLocation() {
    final ref = fb.reference();
    ref.child("testing1").once().then((DataSnapshot data) {
      print('help! $data.value');
      print(data.key);
      setState(() {
        retrievedLocation = data.value;
      });
    });
  }

  //void _countDistance() {
  //
  //  for (var i in _user) {
  //    double distanceInMeters = Geolocator.distanceBetween(
  //        _locationData.latitude,
  //        _locationData.longitude,
  //        i.latitude,
  //        i.longitude);
  //    // print(distanceInMeters);
  //    _nearest.add(distanceInMeters);
  //  }

  //  _nearest.sort();
  //   print(_nearest.first);
  //}

  void getLocation() async {
    _locationData = await _location.getLocation();
    //_countDistance();
    //return _locationData;
  }

  sendHelpNotification() {
    retrievedLocation();
  }
}
