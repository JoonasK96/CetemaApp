import 'package:flutter/material.dart';
import 'components/navigation.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
//import 'dart:math';

//void main() => runApp(MyApp()); korvasin tän tolla alemmalla t. Otto

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Firebase initti
 // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigation(),
    );
  }
}
