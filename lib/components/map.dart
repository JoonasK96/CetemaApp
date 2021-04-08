import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  GoogleMapController _controller;
  Location _location = Location();
  bool visibility = false;

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
      print('kartta nappi');
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  void _compassOnPress(){
    setState(() {
    if(visibility == false){
      visibility = true;
    } else
      visibility = false;
  });
        }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
<<<<<<< HEAD
      GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialcameraposition),
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
              onPressed: () {},
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
=======
              GoogleMap(
                initialCameraPosition:
                CameraPosition(target: _initialcameraposition),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                padding: EdgeInsets.only(top: 0,),
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
                        )
                  ),
            ]);
>>>>>>> 8bc6f017cd9377c58f17901708a37013f66c7f3b
  }
}
