import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
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
    return Stack(children: [
              GoogleMap(
                initialCameraPosition:
                CameraPosition(target: _initialcameraposition),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
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
                        fillColor: Colors.red,
                        onPressed: (){},
                        child: Icon(
                          Icons.compass_calibration,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        constraints: BoxConstraints.tightFor(
                          width: 56.0,
                          height: 56.0,
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

            ]);
  }
}
