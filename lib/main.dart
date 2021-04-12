import 'package:flutter/material.dart';
import 'package:flutter_app/screens/map_screen.dart';
import 'components/navigation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_app/screens/map_screen.dart';
import 'package:cron/cron.dart';
//void main() => runApp(MyApp()); //korvasin tän tolla alemmalla t. Otto

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cron = Cron();
  cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    print('every minute, minute passes');
  });
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  //Firebase initti
 // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
void time () async{

}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigation(),

    );
  }
}

