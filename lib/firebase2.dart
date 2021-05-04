import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/User.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'components/User.dart';
import 'package:device_info/device_info.dart';

class FirebaseClass2 {
  //GlobalKey<FirebaseClass2> widgetKey = GlobalKey<FirebaseClass2>();
  Location _location = Location();
  LocationData _locationData;
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData> locationSubscription;
  final fb = FirebaseDatabase.instance;
  final testLocation = "testing1";
  List _user = [];
  List<dynamic> dataBlob;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var userIdAndroid;

  var retrievedLocation;
  DatabaseReference _locationRef = FirebaseDatabase.instance.reference();

  addUsers() {
    _user.add("euroshopper");
  }

  Future<void> dearDevice() async {
    //Map<String, dynamic> deviceData = <String, dynamic>{};

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userIdAndroid = androidInfo.androidId;
    print('Running on ${androidInfo.androidId}');
  }

  void sendLocation() {
    //final ref = fb.reference();
    //ref.child(testLocation).set(
    //    "_locationData"); //sijainti pitäs repästä tänne jotenki, globalkey?
    //getLocation();
    dearDevice();
    print('sending location...');
    print(_locationData.latitude);
    print(_locationData.longitude);
    User userObject = User(
        _locationData.latitude, _locationData.longitude, userIdAndroid, false);

    //userObject.latitude = _locationData.latitude;
    //userObject.longitude = _locationData.longitude;
    //userObject.id = "ebin";
    //userObject.needsHelp = false;

    //String megabanger = {"id": userObject.id, "help": userObject.needsHelp, };
    //String megajson = jsonEncode(userObject);

    String json = jsonEncode(userObject);

    //DatabaseReference _someFirstRef =
    //FirebaseDatabase.instance.reference().child(testLocation);
    _locationRef.child(userIdAndroid).set(json);
    //_locationRef.set(json); //userObject
  }

  void retrieveLocation() {
    //final ref = fb.reference();
    var lists = [];
    _locationRef.once().then((DataSnapshot data2) {
      print(data2.value);
      print(data2.key);
      //dataBlob = data.value; //koko db
      //Map<String, dynamic> dbMap = json.decode(data2.value);
      //dataBlob = dbMap["child"];
      //print('perkele $dbMap');
      //Map<String, dynamic> mappens =
      //   new Map<String, dynamic>.from(json.decode(data2.value));
      //print(mappens);
      //final userdata = new Map<dynamic, dynamic>.from(json.decode(data2.value));
      Map<dynamic, dynamic> values = data2.value;
      values.forEach((key, values) {
        var settii = json.decode(values);
        lists.add(User.fromJson(settii));
      });
      print('tää ois tällänen ${lists[0].latitude}');
      countDistance(lists);
    });

    //_locationRef.child("testing1").once().then((DataSnapshot data) {
    //print('help! $data.value');
    // print(data.value);
    // print(data.key);
    //setState(() {

    // Map<String, dynamic> userMap = jsonDecode(data.value);
    // var retrievedData = User.fromJson(
    //    userMap); //tää retrievedData on nyt se DB:stä haettu yhen käyttäjän datamöykky
    //print(retrievedData.latitude);
    //print(retrievedData.longitude);
    //print(retrievedData.id);
    //print(retrievedData.needsHelp);
    //countDistance(retrievedData.latitude, retrievedData.longitude);
    //});
    //});
  }

  void getLocation() async {
    _locationData = await _location.getLocation();
    //countDistance();
    //return _locationData;
  }

  sendHelpNotification() {
    retrieveLocation();
    print("help has been requested by some user");
  }

  void countDistance(allUsers) {
    List _nearest = [];
    double latitudeX = 0;
    double longitudeX = 0;

    for (var i in allUsers) {
      latitudeX = i.latitude;
      longitudeX = i.longitude;
      print('juu elikkäs $latitudeX');
      double distanceInMeters = Geolocator.distanceBetween(
          _locationData.latitude,
          _locationData.longitude,
          latitudeX,
          longitudeX);
      print(distanceInMeters);
      _nearest.add(distanceInMeters);
    }

    _nearest.sort();
    print(_nearest.first);
  }
}
