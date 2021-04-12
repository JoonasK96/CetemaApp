import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  GoogleMapController _controller;
  Location _location = Location();
  bool visibility = false;

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });

    //setState(() {
    //  _markers.add(Marker(markerId: MarkerId('id1'), position: LatLng(loc)));
    //});
    //populateClients();
  }

  // populateClients() {
  // clients = {};
  // Firestore.instance.collection
  //}

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
    ]);
  }
}
