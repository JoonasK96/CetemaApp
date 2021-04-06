import 'package:flutter/material.dart';
import 'components/navigation.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
//import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

//void main() => runApp(MyApp()); korvasin tän tolla alemmalla t. Otto

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Firebase initti
 // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // home: Navigation(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  GoogleMapController _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                mapType: _currentMapType,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }
}
