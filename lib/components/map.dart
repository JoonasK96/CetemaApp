import 'dart:async';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/firebase2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_app/components/smallWaetherBox.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/components/User.dart';
import 'allGoodBoolean.dart' as globals3;
import 'package:geolocator/geolocator.dart';

class MapClass extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

final GlobalKey<_MapState> widgetKey2 = GlobalKey<_MapState>();

class _MapState extends State<MapClass> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  GoogleMapController _controller;
  Location _location = Location();
  LocationData _locationData;
  StreamSubscription<LocationData> locationSubscription;
  bool visibility = false;
  double lat, lon;
  Timer timer;
  final logger = Logger();
  bool isCameraLocked = false;
  bool lockCameraOnUser = true;
  bool color = false;
  bool color2 = false;
  bool color3 = false;
  bool color4 = false;
  bool color5 = false;
  bool color6 = false;
  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;
  BitmapDescriptor helpMapMarker;
  bool markers = false;
  List<String> markerIdList;
  final backend = FirebaseClass2();
  double latForB;
  double lonForB;
  DatabaseReference _locationRef2 = FirebaseDatabase.instance.reference();
  Timer _timer;

  void checkIfHelpNeeded2() {
    getLocation();
    var lists2 = [];
    _locationRef2.once().then((DataSnapshot data2) {
      print(data2.value);
      print(data2.key);

      Map<dynamic, dynamic> values = data2.value;
      values.forEach((key, values) {
        var settii = json.decode(values);
        lists2.add(User.fromJson(settii));
      });
      print('chekattu ${lists2[0].latitude}');

      for (var i in lists2) {
        if (i.needsHelp == false) {
          print('ei avun tarpeessa: ${i.id}');
        } else if (i.needsHelp == true) {
          print('avun tarpeessa: ${i.id}');
          if (_locationData == null) {
            print('_locationData is null');
          } else {
            double ownLatitude = _locationData.latitude;
            double ownLongitude = _locationData.longitude;
            double distanceInMeters = Geolocator.distanceBetween(
                ownLatitude, ownLongitude, i.latitude, i.longitude);
            print(distanceInMeters);
            if (distanceInMeters <= 20000) {
              callForHelp(i.latitude, i.longitude);
            } else {
              print(
                  'The person in need of help is over 20km away, you have not been notified.');
            }
          }
        } else {
          print('ei true eikä false????');
        }
      }
    });
  }

  updateHelp() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      //print('getting location...');
      //backend.getLocation2();
      //print('updating location...');
      //backend.sendLocation();
      if (globals3.isAllGood = true) {
        //backend.checkIfHelpNeeded();
        checkIfHelpNeeded2();
      }
    });
  }

  stopUpdatingLocation() {
    _timer.cancel();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    locationSubscription = _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15)),
      );
    });
  }

  void callForHelp(double needsHelpLat, double needsHelpLon) {
    cameraLock(false);
    _markers.add(Marker(
        markerId: MarkerId("$needsHelpLat"),
        position: LatLng(needsHelpLat, needsHelpLon),
        icon: helpMapMarker,
        infoWindow: InfoWindow(
          title: "This user needs help!",
        )));

    _controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(needsHelpLat, needsHelpLon)),
    );
  }

  void api() async {
    _locationData = await _location.getLocation();
    List<dynamic> features = (await fetchPosts(
        "fi",
        "geographic-names",
        "1000",
        "${_locationData.longitude}",
        "${_locationData.latitude}",
        "50913b6d-2af6-4741-bd12-78ff779e95b2"));
    var i = 0;
    setState(() {
      // ignore: unused_local_variable
      for (var index in features) {
        _markers.add(Marker(
            markerId: MarkerId(features[i]['properties']['label']),
            position: LatLng(features[i]['geometry']['coordinates'][1],
                features[i]['geometry']['coordinates'][0]),
            icon: mapMarker,
            infoWindow: InfoWindow(
              title: features[i]['properties']['label'],
              snippet: features[i]['properties']['label:placeTypeDescription'],
            )));
        i++;
      }
    });

    // await  fetchPosts("fi", "geographic-names", "1000", "24.9432", "60.1668", "4237121f-2d10-4722-bb95-3193dd546af5").then((it) => logger.i(it));
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 10)), 'assets/marker.png');
    helpMapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 10)), 'assets/helpmarker.png');
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
    updateHelp();
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

  void getLocation() async {
    _locationData = await _location.getLocation();
    latForB = _locationData.latitude;
    lonForB = _locationData.longitude;
    //_countDistance();
    //return _locationData;
  }

  /* void bottomMenu(context) {
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
  } */

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
      Positioned(top: 30, right: 10, child: WeatherBox()),
      Positioned(
        bottom: 10,
        left: 4,
        child: Column(
          children: <Widget>[
            RawMaterialButton(
              elevation: 2.0,
              shape: CircleBorder(),
              fillColor: Colors.blue[300],
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
              backgroundColor: Colors.blue[300],
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
              backgroundColor: Colors.blue[300],
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
                              //widgetKey.currentState.sendHelpNotification();

                              //addUsers();
                              backend.sendHelpNotification(); //latForB, lonForB
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
            backgroundColor: Colors.red[600],
            child: const FaIcon(
              FontAwesomeIcons.handHoldingMedical,
            )),
      ),
      Positioned(
        bottom: 10,
        left: 65,
        child: FloatingActionButton(
            onPressed: () {
              setState(() {
                if (markers) {
                  _markers.clear();
                  markers = !markers;
                } else {
                  api();
                  markers = true;
                }
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.blue[300],
            child: const FaIcon(
              FontAwesomeIcons.mapMarker,
            )),
        // bottomMenu(context);
      ),
    ]);
  }
}
