import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/components/User.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  GoogleMapController _controller;
  Location _location = Location();
  LocationData _locationData;
  bool visibility = false;
  double lat, lon;
  List _user = [];
  Timer timer;

  Position _position;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

  @override
  Future<void> initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_position.latitude, _position.longitude),
          zoom: 11.0,
        ),
      ),
    );
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      print('kartta nappi');
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _compassOnPress() {
    setState(() {
      if (visibility == false) {
        visibility = true;
      } else
        visibility = false;
    });
  }

  void addUsers() {
    var user1 = new User();
    user1.longitude = 56.5;
    user1.latitude = 4.5;
    var user2 = new User();
    user2.longitude = 60.5;
    user2.latitude = 10.5;
    var user3 = new User();
    user3.longitude = 100.5;
    user3.latitude = 20.5;

    _user.add(user1);
    _user.add(user2);
    _user.add(user3);

    getLocation();
  }

  void getLocation() async {
    _locationData = await _location.getLocation();
    _countDistance();
  }

  void _countDistance() {
    List _nearest = [];

    for (var i in _user) {
      double distanceInMeters = Geolocator.distanceBetween(
          _locationData.latitude,
          _locationData.longitude,
          i.latitude,
          i.longitude);
      // print(distanceInMeters);
      _nearest.add(distanceInMeters);
    }

    _nearest.sort();
    print(_nearest.first);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialcameraposition),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        padding: EdgeInsets.only(
          top: 0,
        ),
        mapType: _currentMapType,
      ),
      Positioned(
        bottom: 10,
        left: 4,
        child: Column(
          children: <Widget>[
            RawMaterialButton(
              elevation: 2.0,
              shape: CircleBorder(),
              fillColor: Colors.blue,
              onPressed: _compassOnPress,
              child: FaIcon(FontAwesomeIcons.compass),
              constraints: BoxConstraints.tightFor(
                width: 40.0,
                height: 40.0,
              ),
            ),
            FloatingActionButton(
              onPressed: _onMapTypeButtonPressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.green,
              child: const Icon(Icons.map, size: 36.0),
            ),
          ],
        ),
      ),
      Visibility(
          visible: visibility,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: buildCompass(),
          )),
      Positioned(
        bottom: 120,
        right: 10,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Do you want  to call for help?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            addUsers();
                          },
                          child: Text("YES")),
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("NO"))
                    ],
                  );
                });
          },
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Colors.red,
          child: const Icon(Icons.add, size: 36.0),
        ),
      ),
    ]);
  }
}
