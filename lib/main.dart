import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/map_screen.dart';
import 'package:logger/logger.dart';
import 'api/MML_Api.dart';
import 'components/navigation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_app/screens/map_screen.dart';
import 'package:cron/cron.dart';
//void main() => runApp(MyApp()); //korvasin tän tolla alemmalla t. Otto
final logger = Logger();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cron = Cron();
  cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    print('every minute, minute passes');

    DatabaseReference _someFirstRef =
        FirebaseDatabase.instance.reference().child("testLocation");
    _someFirstRef.set("blabla test");
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

class _AppState extends State<MyApp> {
  //Firebase initti
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  final fb = FirebaseDatabase.instance;
  final testLocation = "testing1";
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

  var retrievedLocation;

  void sendLocation() {
    final ref = fb.reference();
    ref.child(testLocation).set("ebin");
  }

  void retrieveLocation() {
    final ref = fb.reference();
    ref.child("testing1").once().then((DataSnapshot data) {
      print(data.value);
      print(data.key);
      setState(() {
        retrievedLocation = data.value;
      });
    });
  }
}
