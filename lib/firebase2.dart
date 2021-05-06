import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/User.dart';
import 'package:flutter_app/components/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'components/User.dart';
import 'package:device_info/device_info.dart';
import 'components/helpBoolean.dart' as globals;
import 'components/helpLocation.dart' as globals2;
import 'components/allGoodBoolean.dart' as globals3;

class FirebaseClass2 {
  //GlobalKey<FirebaseClass2> widgetKey = GlobalKey<FirebaseClass2>();
  Location _location = Location();
  LocationData _locationData2;
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData> locationSubscription;
  final fb = FirebaseDatabase.instance;
  final testLocation = "testing1";
  List _user = [];
  List<dynamic> dataBlob;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var userIdAndroid;
  double lat;
  double lon;
  //bool ifNeedsHelp = false;
  final MapClass mapClassRef = MapClass();

  var retrievedLocation;
  DatabaseReference _locationRef = FirebaseDatabase.instance.reference();

  //final Function callback;
  //FirebaseClass2(this.callback);

  addUsers() {
    _user.add("euroshopper");
  }

  Future<void> dearDevice() async {
    //Map<String, dynamic> deviceData = <String, dynamic>{};

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userIdAndroid = androidInfo.androidId;
    print('Running on ${androidInfo.androidId}');
  }

  sendLocation() {
    //final ref = fb.reference();
    //ref.child(testLocation).set(
    //    "_locationData"); //sijainti pitäs repästä tänne jotenki, globalkey?
    //getLocation();
    dearDevice();
    print('sending location...');
    print(_locationData2.latitude);
    print(_locationData2.longitude);
    print('tarviiko? ${globals.ifNeedsHelp}');
    globals2.locationHelpLat = _locationData2.latitude;
    globals2.locationHelpLon = _locationData2.longitude;
    User userObject = User(_locationData2.latitude, _locationData2.longitude,
        userIdAndroid, globals.ifNeedsHelp);

    //userObject.latitude = _locationData.latitude;
    //userObject.longitude = _locationData.longitude;
    //userObject.id = "ebin";
    //userObject.needsHelp = false;

    //String megabanger = {"id": userObject.id, "help": userObject.needsHelp, };
    //String megajson = jsonEncode(userObject);

    String jsonString = jsonEncode(userObject);

    //DatabaseReference _someFirstRef =
    //FirebaseDatabase.instance.reference().child(testLocation);
    if (userIdAndroid == null) {
      print('AndroidId is null!');
    } else {
      print('AndroidId is ok :)');

      _locationRef.child(userIdAndroid).set(jsonString);
    }

    //_locationRef.set(json); //userObject
    //gibLocation(_locationData.latitude, _locationData.longitude);
  }

  void gibLocation() {
    lat = _locationData2.latitude;
    lon = _locationData2.longitude;
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

      //countDistance(lists);
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

  void getLocation2() async {
    _locationData2 = await _location.getLocation();
    print('getting location...');

    if (_locationData2 == null) {
      print('perkele location null');
      globals3.isAllGood = false;
    } else {
      print('location not null :)');
      globals3.isAllGood = true;
      sendLocation();
    }
  }

  void sendHelpNotification() {
    //helpLat, helpLon
    globals.ifNeedsHelp = true;

    retrieveLocation();

    print("help has been requested by YOU! GLHF");
    //widgetKey2.currentState.callForHelp(helpLat, helpLon);
  }

  void checkIfHelpNeeded() {
    var lists2 = [];
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
        lists2.add(User.fromJson(settii));
      });
      print('chekattu ${lists2[0].latitude}');

      //countDistance(lists);

      for (var i in lists2) {
        if (i.needsHelp == false) {
          print('kukaan ei avun tarpeessa');
        } else {
          print('joku on avun tarpeessa');
          //widgetKey2.currentState.callForHelp(i.latitude, i.longitude);

        }
      }
    });
  }

  void countDistance(allUsers) {
    List _nearest = [];
    double latitudeX = 0;
    double longitudeX = 0;
    double ownLatitude = _locationData2.latitude;
    double ownLongitude = _locationData2.longitude;

    for (var i in allUsers) {
      latitudeX = i.latitude;
      longitudeX = i.longitude;

      print('juu elikkäs $latitudeX');
      double distanceInMeters = Geolocator.distanceBetween(
          ownLatitude, ownLongitude, latitudeX, longitudeX);
      print(distanceInMeters);
      _nearest.add(distanceInMeters);
    }

    _nearest.sort();
    print(_nearest.first);
  }
}
