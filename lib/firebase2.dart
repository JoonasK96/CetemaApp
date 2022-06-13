import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/User.dart';
import 'package:flutter_app/components/map.dart';
import 'package:geolocator/geolocator.dart';


import 'components/User.dart';
import 'package:device_info/device_info.dart';
import 'components/helpBoolean.dart' as globals;
import 'components/helpLocation.dart' as globals2;
import 'components/allGoodBoolean.dart' as globals3;

class FirebaseClass2 {
  //GlobalKey<FirebaseClass2> widgetKey = GlobalKey<FirebaseClass2>();

  late Position position;
  // ignore: cancel_subscriptions

  final fb = FirebaseDatabase.instance;
  List _user = [];
  List<dynamic>? dataBlob;

  var userIdAndroid;
  double? lat;
  double? lon;
  final MapClass mapClassRef = MapClass();
  Map<String, dynamic>? userData;
  var retrievedLocation;
  DatabaseReference _dbRef = FirebaseDatabase.instance.ref();



  Future<void> getDeviceId() async {
    try{
      print("pääsi devis id");
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      userIdAndroid = androidInfo.androidId;

    }catch (e){
      print("Getting android id failed $e");
    }
  }

  collectDataFromDevice() {
    Future.delayed(const Duration(seconds: 2), () {
      print('sending location...');
      print(position.latitude);
      print(position.longitude);
      print('tarviiko? ${globals.ifNeedsHelp}');
      globals2.locationHelpLat = position.latitude;
      globals2.locationHelpLon = position.longitude;
      User userObject = User(position.latitude, position.longitude, userIdAndroid, false, "", "");
      String user = jsonEncode(userObject);
      print(user);
      userData = jsonDecode(user);
      print(userData);
      setDataToDb();


    });
  }
  Future<void> setDataToDb() async{
    Future.delayed(const Duration(seconds: 1), ()
    {
      print("datan lähetys");
      final userRef = _dbRef.child("users/${userData!['id']}");
      userRef.set({
        'id': userData!['id'],
        'latitude': userData!['latitude'],
        'longitude': userData!['longitude'],
        'needsHelp': userData!['needsHelp'],
        'isGettingHelp': userData!['isGettingHelp'],
        'isHelping': userData!['isHelping']
      })
          .then((_) => print("User has been added!"))
          .catchError((onError) =>
          print("Error when trying to add user $onError"));
    });
  }


  Future<void> goingToHelp(String id) async{

    getDeviceId();
    Future.delayed(const Duration(milliseconds: 500), () {
      print("userREF:${userIdAndroid.toString()}");


      final userRef = _dbRef.child("users/${userIdAndroid.toString()}");
      final userRef2 = _dbRef.child("users/${id}");
      print("täsID" + id.toString());
      userRef.update({
        'isHelping' : id
      })
          .then((_) =>
          userRef2.update({
            'isGettingHelp' : userIdAndroid.toString(),
            'needsHelp' : false,


          })
              .then((_) => print("User is getting help!"))
              .catchError((onError) => print("Error when trying to add user $onError")));

    });

  }

  Future<void> updateHelpLocation() async{

// location jostain syystä null kun kutsutaan koita ottaa lokatio data mapin puolella
    //ja lähettää location update functioon :))
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userIdAndroid = androidInfo.androidId;
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("lokation ${userIdAndroid}");
    if (userIdAndroid != null) {
      print("userREF:${userIdAndroid.toString()}");
      final userRef = _dbRef.child("users/${userIdAndroid.toString()}");
      print("lokation ${position}");

        scheduleMicrotask(() {
          userRef.update({
            'longitude': position.longitude,
            'latitude': position.latitude
          }).then((_) => print("Location updated"))
              .catchError((onError) =>
              print("Error when trying to update users locations $onError"));

      });

    }

  }


  Future<void> cancelHelpCall(String id) async{

    getDeviceId();
    Future.delayed(const Duration(milliseconds: 500), () {
      print("userREF:${userIdAndroid.toString()}");
      print("$id tässä bäkkärissä menevä id miksi ei toimi enään");
      final userRef = _dbRef.child("users/${userIdAndroid.toString()}");
      final userRef2 = _dbRef.child("users/$id");
      print("täsID" + id.toString());
      userRef2.update({
        'isHelping' : ""
      }).then((_) =>
          userRef.update({
            'isGettingHelp' : "",
            'needsHelp' : false,
          })
              .then((_) => print("User is getting help!"))
              .catchError((onError) => print("Error when trying to add user $onError")));

    });

  }

  Future<void> cancelHelpCallWithoutId() async{

    Future.delayed(const Duration(milliseconds: 500), () {
      print("userREF:${userIdAndroid.toString()}");

      final userRef = _dbRef.child("users/${userIdAndroid.toString()}");


      userRef.update({
        'needsHelp' : false,
      })
          .then((_) => print("User is getting help!"))
          .catchError((onError) => print("Error when trying to add user $onError"));

    });

  }


  Future<void> helpCall() async{

    getDeviceId();
    Future.delayed(const Duration(milliseconds: 500), () {
      print("userREF:${userIdAndroid.toString()}");

      final ref = _dbRef.child("users/${userIdAndroid.toString()}");

      ref.update({
        'needsHelp' : true
      })
          .then((_) => print("User is getting help!"))
          .catchError((onError) => print("Error when trying to add user $onError"));
    });



  }


  void gibLocation() {
    lat = position.latitude;
    lon = position.longitude;
  }



  getLocation2()  async {
    try{
      print('getting location...');
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (position == null) {
        print('location null');
        globals3.isAllGood = false;
      } else {
        print('location not null :)');
        globals3.isAllGood = true;
        getDeviceId();
        collectDataFromDevice();
        Timer.periodic(Duration(seconds: 4), (timer) {
          updateHelpLocation();
        });


      }

    }catch(e){
      print("Getting location failded $e");
    }

  }




  /* void checkIfHelpNeeded() {
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
  }*/

  /*void countDistance(allUsers) {
    List _nearest = [];
    double? latitudeX = 0;
    double? longitudeX = 0;
    double? ownLatitude = position.latitude;
    double? ownLongitude = position.longitude;

    for (var i in allUsers) {
      latitudeX = i.latitude;
      longitudeX = i.longitude;

      print('juu elikkäs $latitudeX');
      double distanceInMeters = Geolocator.distanceBetween(
          ownLatitude!, ownLongitude!, latitudeX!, longitudeX!);

      _nearest.add(distanceInMeters);
    }

    _nearest.sort();
    print(_nearest.first);
  }*/
}
