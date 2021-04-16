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

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_app/components/apikey.dart';

class MapScreen2 extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

/* // Starting point latitude
double _originLatitude = 60.20;
// Starting point longitude
double _originLongitude = 24.90;
// Destination latitude
double _destLatitude = 60.22;
// Destination Longitude
double _destLongitude = 24.80;*/
// Markers to show points on the map

double _originLatitude = 68.9225;
double _originLongitude = 21.5662;

double _destLatitude = 68.9204;
double _destLongitude = 21.7108;

Map<MarkerId, Marker> markers = {};

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class _MapScreenState extends State<MapScreen2> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  GoogleMapController _controller;
  Location _location = Location();
  LocationData _locationData;
  bool visibility = false;
  double lat, lon;
  List _user = [];
  Timer timer;
  bool focus = true;

  @override
  void initState() {
    /// add origin marker origin marker
    _addMarker(
      LatLng(_originLatitude, _originLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(_destLatitude, _destLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    _getPolyline();

    super.initState();
  }

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

  void _focusOnPress() {
    setState(() {
      if (focus == true) {
        _location.onLocationChanged.listen((l) {
          _controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(l.latitude, l.longitude), zoom: 10)));
        });
        focus = false;
      } else
        _location.onLocationChanged.listen((l) {
          _controller.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(l.latitude, l.longitude), zoom: 15)),
          );
        });
      focus = true;
    });
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
        myLocationButtonEnabled: false,
        padding: EdgeInsets.only(
          top: 0,
        ),
        mapType: _currentMapType,
        polylines: Set<Polyline>.of(polylines.values),
        markers: Set<Marker>.of(markers.values),
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
            FloatingActionButton(
                onPressed: _focusOnPress, backgroundColor: Colors.cyan)
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

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apikey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
}
