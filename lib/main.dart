import 'dart:async';

import 'package:cron/cron.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import 'components/navigation.dart';
import 'firebase2.dart';

import 'package:location/location.dart';

import 'package:device_info/device_info.dart';

import 'components/allGoodBoolean.dart' as globals3;

//void main() => runApp(MyApp()); //korvasin tän tolla alemmalla t. Otto
final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();




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
  final testLocation = "testing1";

  //DatabaseReference _dbRef = FirebaseDatabase.instance.ref("user");
  //Location _location = Location();
  //LocationData _locationData2;
  // ignore: cancel_subscriptions
  //final fb = FirebaseDatabase.instance;
  //final testLocation = "testing1";
  //List _user = [];
  List<dynamic>? dataBlob;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var userIdAndroid;
  double? lat;
  double? lon;
  //DatabaseReference _locationRef3 = FirebaseDatabase.instance.reference();
  Timer? _timer;


bool j = false;

  @override
  void initState() {
    super.initState();
    permissions();
  }
  void permissions() async{
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    setState(() {
      j = true;
    });
  }


 updateLocation() {


   // _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      print('preparing to get location...');

      print('updating location...');
      // backend.getLocation2();
      if (globals3.isAllGood = true) {
       // backend.checkIfHelpNeeded();
        //widgetKey2.currentState.checkIfHelpNeeded();
        print('KAIK HYVIN');
      }
    }

    void backend() {
      final backend = FirebaseClass2();
      print('pitäis mennä bäkendiin');
       backend.getLocation2();
    }




  ///////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              print(j);
              print(" pääsi tähän enne navigointia1 ${snapshot.data}");
              if (snapshot.hasError) {
                print('error ${snapshot.error.toString()}');
                return Text('something went wrong');
              } if (snapshot.hasData != true)
              {
                print(" pääsi tähän enne navigointia2 ${snapshot.hasData}");

                return CircularProgressIndicator();
              }
              if(j == false){
                return Center(
                  heightFactor: 100,
                  widthFactor: 100,
                  child: CircularProgressIndicator(),
                );
              }
              backend();
              return Navigation();
            })
        //Navigation(),
        );
  }
}
