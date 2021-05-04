import 'dart:async';

import 'package:cron/cron.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'components/navigation.dart';
import 'firebase2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/User.dart';
import 'package:flutter_app/components/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:convert';

import 'components/User.dart';
import 'package:device_info/device_info.dart';
import 'components/helpBoolean.dart' as globals;
import 'components/helpLocation.dart' as globals2;
import 'components/allGoodBoolean.dart' as globals3;

//void main() => runApp(MyApp()); //korvasin tän tolla alemmalla t. Otto
final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cron = Cron();
  //final backend = FirebaseClass2();
  cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    print('every minute, minute passes');

    // DatabaseReference _someFirstRef =
    //    FirebaseDatabase.instance.reference().child("testLocation2");
    //_someFirstRef.set("perkele");

    //var juuh = new FirebaseClass();
    //var locationnnnn = new
    //widgetKey3.currentState.backend.getLocation2();
    //widgetKey3.currentState.backend.sendLocation();
    //widgetKey3.currentState.backend.checkIfHelpNeeded();
    //widgetKey3.currentState.getLocation3();
    //widgetKey3.currentState.sendLocation2();
    //backend.getLocation2();
    //backend.sendLocation();
    //backend.gibLocation();
    //backend.checkIfHelpNeeded();
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //Firebase initti siirretty "Staten puolelle"

  @override
  _AppState createState() => _AppState();

//@override
//Widget build(BuildContext context) {
//  return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: FutureBuilder(
//          future: _fbApp,
//          builder: (context, snapshot) {
//            if (snapshot.hasError) {
//              print('error ${snapshot.error.toString()}');
//              return Text('something went wrong');
//            } else if (snapshot.hasData) {
//              return Navigation();
//            } else {
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            }
//          }));
//}

}

GlobalKey<_AppState> widgetKey3 = GlobalKey<_AppState>();

class _AppState extends State<MyApp> {
  //Firebase initti
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  final fb = FirebaseDatabase.instance;
  final testLocation = "testing1";
  final backend = FirebaseClass2();

  Location _location = Location();
  //LocationData _locationData2;
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData> locationSubscription;
  //final fb = FirebaseDatabase.instance;
  //final testLocation = "testing1";
  //List _user = [];
  List<dynamic> dataBlob;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var userIdAndroid;
  double lat;
  double lon;
  DatabaseReference _locationRef3 = FirebaseDatabase.instance.reference();
  Timer _timer;

  @override
  void initState() {
    updateLocation();
    super.initState();
  }

  ///////

  Future<void> dearDevice() async {
    //Map<String, dynamic> deviceData = <String, dynamic>{};

    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userIdAndroid = androidInfo.androidId;
    print('Running on ${androidInfo.androidId}');
  }

  updateLocation() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      print('preparing to get location...');
      backend.getLocation2();
      print('updating location...');
      //backend.sendLocation();
      if (globals3.isAllGood = true) {
        //backend.checkIfHelpNeeded();
        //widgetKey2.currentState.checkIfHelpNeeded();
        print('KAIK HYVIN');
      }
    });
  }

  stopUpdatingLocation() {
    _timer.cancel();
  }

  ///////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('error ${snapshot.error.toString()}');
                return Text('something went wrong');
              } else if (snapshot.hasData) {
                return Navigation();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
        //Navigation(),
        );
  }
}
