import 'dart:async';
import 'dart:math';

import 'package:flutter_app/api/MML_Api.dart';
import 'package:flutter_app/api/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/components/User.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/components/smallWaetherBox.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

GlobalKey<_MapState> widgetKey2 = GlobalKey<_MapState>();

class _MapState extends State<Map> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  GoogleMapController _controller;
  Location _location = Location();
  LocationData _locationData;
  StreamSubscription<LocationData> locationSubscription;
  bool visibility = false;
  double lat, lon;
  List _user = [];
  Timer timer;
  final logger = Logger();
  bool isCameraLocked = false;
  PolylinePoints polylinePoints = PolylinePoints();
  String googleApikey = "AIzaSyCNMlfM0VGigoPrKuYpGs26lFHN4VzGSLs";
  bool lockCameraOnUser = true;
  bool color = false;
  bool color2 = false;
  bool color3 = false;
  bool color4 = false;
  bool color5 = false;
  bool color6 = false;
  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    locationSubscription = _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15)),
      );
    });
  }

  void api() async {
    _locationData = await _location.getLocation();
    List<dynamic> features = (await fetchPosts(
        "fi",
        "geographic-names",
        "1000",
        "${_locationData.longitude}",
        "${_locationData.latitude}",
        "4237121f-2d10-4722-bb95-3193dd546af5"));
    var i = 0;
    for (var index in features) {
      print(features[i]['properties']['label']);
      print(features[i]['properties']['label:placeTypeDescription']);
      print(features[i]['geometry']['coordinates']);
      i++;

      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(60.18, 24.93),
            icon: mapMarker,
            infoWindow: InfoWindow(
              title: 'eka',
              snippet: 'toka',
            )));
      });
    }

    // await  fetchPosts("fi", "geographic-names", "1000", "24.9432", "60.1668", "4237121f-2d10-4722-bb95-3193dd546af5").then((it) => logger.i(it));
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 10)), 'assets/marker.png');
  }

/*  void addMarkers() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(60.18, 24.93),
          icon: mapMarker,
          infoWindow: InfoWindow(
            title: 'joku',
            snippet: 'hello',
          )));
    });
  } */

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void cameraLock(isCameraLocked) {
    setState(() {
      if (isCameraLocked == false) {
        locationSubscription.pause();
      } else {
        locationSubscription.resume();
      }
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

  void addUsers() async {
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
    //return _locationData;
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

  void bottomMenu(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
                color: Colors.grey.shade300,
                height: MediaQuery.of(context).size.height * .27,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height:
                                  ((MediaQuery.of(context).size.height * .12)),
                              width: MediaQuery.of(context).size.width * .3,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade100)),
                                      onPressed: () {
                                        mystate(() {
                                          color = !color;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.wine_bar,
                                              size: 40.0,
                                              color: color
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "Dangers",
                                                  style: TextStyle(
                                                    color: color
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height:
                                  ((MediaQuery.of(context).size.height * 0.12)),
                              width: MediaQuery.of(context).size.width * .3,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade100)),
                                      onPressed: () {
                                        mystate(() {
                                          color2 = !color2;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.wine_bar,
                                              size: 40.0,
                                              color: color2
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "virkistys",
                                                  style: TextStyle(
                                                    color: color2
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height:
                                  ((MediaQuery.of(context).size.height * .12)),
                              width: MediaQuery.of(context).size.width * .3,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade100)),
                                      onPressed: () {
                                        mystate(() {
                                          color3 = !color3;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.wine_bar,
                                              size: 40.0,
                                              color: color3
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "Dangers",
                                                  style: TextStyle(
                                                    color: color3
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height:
                                  ((MediaQuery.of(context).size.height * 0.12)),
                              width: MediaQuery.of(context).size.width * .3,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade100)),
                                      onPressed: () {
                                        mystate(() {
                                          color4 = !color4;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.wine_bar,
                                              size: 40.0,
                                              color: color4
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "virkistys",
                                                  style: TextStyle(
                                                    color: color4
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height:
                                  ((MediaQuery.of(context).size.height * .12)),
                              width: MediaQuery.of(context).size.width * .3,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade100)),
                                      onPressed: () {
                                        mystate(() {
                                          color5 = !color5;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.wine_bar,
                                              size: 40.0,
                                              color: color5
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "Dangers",
                                                  style: TextStyle(
                                                    color: color5
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height:
                                  ((MediaQuery.of(context).size.height * 0.12)),
                              width: MediaQuery.of(context).size.width * .3,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey.shade100)),
                                      onPressed: () {
                                        mystate(() {
                                          color6 = !color6;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(
                                              Icons.wine_bar,
                                              size: 40.0,
                                              color: color6
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  "virkistys",
                                                  style: TextStyle(
                                                    color: color6
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialcameraposition),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        markers: _markers,
        padding: EdgeInsets.only(
          top: 0,
        ),
        mapType: _currentMapType,
      ),
      Positioned(top: 500, left: 60, child: WeatherBox()),
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
              onPressed: (() {
                setState(() {
                  isCameraLocked = !isCameraLocked;
                  cameraLock(isCameraLocked);
                });
              }),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.black,
              child: const Icon(Icons.api_sharp, size: 36.0),
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
                            addUsers(); //ehkä muutaki? ainaki notification
                            //widgetKey.currentState.sendHelpNotification();
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
      Positioned(
        bottom: 0,
        left: 100,
        child: IconButton(
            icon: FaIcon(FontAwesomeIcons.ellipsisV),
            onPressed: () {
              bottomMenu(context);
              api();
            }),
      ),
    ]);
  }
}
