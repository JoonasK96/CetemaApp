import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/Models/db_users.dart';
import 'package:flutter_app/Models/user_notifier.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/components/helpAlert.dart';
import 'package:flutter_app/components/helpCallButton.dart';
import 'package:flutter_app/firebase2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_app/components/smallWaetherBox.dart';
import 'package:flutter_app/components/User.dart';
import 'package:provider/provider.dart';
import '../Models/location_stream.dart';


class MapClass extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

final GlobalKey<_MapState> widgetKey2 = GlobalKey<_MapState>();

class _MapState extends State<MapClass> {
  LatLng _initialcameraposition = LatLng(60.00, 25.00);
  late GoogleMapController _controller;
  Location _location = Location();
  late LocationData _locationData;
  late StreamSubscription<LocationData> locationSubscription;
  bool visibility = false;
  Timer? timer;
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
  final _db = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> usersStream;
  List<Users> _dbUser = [];
  List<Users> get users => _dbUser;
  static const USERS_PATH = 'users';
  late BitmapDescriptor mapMarker;
  late BitmapDescriptor helpMapMarker;
  late BitmapDescriptor helpingMapMarker;
  bool markers = false;
  List<String>? markerIdList;
  final backend = FirebaseClass2();
  late double latForB;
  late double lonForB;
  late bool needsHelp = true;
  var isVisible = false;
 var currentUser = User;
  var userIdAndroid;
late Stream myFututre = LocationStream().getUserStream();
late Stream myFututre2 = LocationStream().getStream();

  late bool isHelping = true;
late Marker helpMarker =  Marker(
      markerId: MarkerId("needsHelp"),
      position: LatLng(60, 24),
      icon: helpMapMarker,
      visible: false,
      infoWindow: InfoWindow(
        title: "This user needs help!",
      ));
late Marker isHelpingMarker =  Marker(
      markerId: MarkerId("isHelping"),
      position: LatLng(60, 24),
      icon: helpingMapMarker,
      visible: false,
      infoWindow: InfoWindow(
        title: "This user needs help!",
      ));

  void _onMapCreated(GoogleMapController _cntlr) async {

    _controller = _cntlr;
    locationSubscription = _location.onLocationChanged.listen((l) {

      print("${l.latitude} ja longitude ${l.longitude}");
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15)),
      );

    });

  }
  Future<void> getDeviceId() async {
    try{
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
       userIdAndroid = androidInfo.androidId;
      print('Running on ${androidInfo.androidId}');
    }catch (e){
      print("Getting android id failed $e");
    }
  }



  void api() async {
    _locationData = await _location.getLocation();
    List<dynamic>? features = (await fetchPosts(
        "fi",
        "geographic-names",
        "1000",
        "${_locationData.longitude}",
        "${_locationData.latitude}",
        "50913b6d-2af6-4741-bd12-78ff779e95b2"));
    var i = 0;
    setState(() {
      // ignore: unused_local_variable
      for (var index in features!) {
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
    helpingMapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(0.01, 0.01)), 'assets/red-cross.png');
  }
  void dbStream() {

    usersStream = _db.child(USERS_PATH).onValue.listen((event) {
      print(event.snapshot.value);
      final allUsers = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
      _dbUser = allUsers.values
          .map((userAsJson) =>
          Users.fromRTDB(Map<String, dynamic>.from(userAsJson)))
          .toList();
      setState(() {
        createMarker(_dbUser);
        removeMarkers(_dbUser);
      });

    print("DB STReAM");
    });

  }



  @override
  void initState() {
    super.initState();
    setCustomMarker();
    getDeviceId();
    getUserlocation();
    dbStream();
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

  void getUserlocation() async{
    _locationData = await _location.getLocation();
  }

  void _compassOnPress() {
    setState(() {
      if (visibility == false) {
        visibility = true;
      } else
        visibility = false;
    });
  }


Future<void> callForHelp (double needsHelpLat, double needsHelpLon) async  {
  cameraLock(false);
//TEE USER NOTIFIERIIN FUNKKARI JOKA CHECKAA KUKA AUTTAA JA KETÄ AUTETAAN JONKA PERUSTEELLA MARKERIN LISÄYS.
  isVisible = true;


     try {
       helpMarker = Marker(
           markerId: MarkerId("needsHelp"),
           position: LatLng(needsHelpLat, needsHelpLon),
           icon: helpMapMarker,
           visible: true,
           infoWindow: InfoWindow(
             title: "This user needs help!",
           ));
       _markers.add(helpMarker);
       if(needsHelp) {
       _controller.animateCamera(
         CameraUpdate.newLatLng(LatLng(needsHelpLat, needsHelpLon)),
       );
       }
      needsHelp = false;

     } catch (e) {
       print("ERROR while creating help marker $e");
     }


  }
Future<void> userComingToHelp (double helpingLat, double helpingLon) async  {
    cameraLock(false);
      isVisible = true;
      print("object");
      try {
        isHelpingMarker = Marker(
            markerId: MarkerId("isHelping"),
            position: LatLng(helpingLat, helpingLon),
            icon: helpingMapMarker,
            visible: isVisible,
            infoWindow: InfoWindow(
              title: "User coming to help",
            ));
         _markers.add(isHelpingMarker);
        if(isHelping) {
        _controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(helpingLat, helpingLon)),
        ); }

        isHelping = false;


      } catch (e) {
        print("ERROR while creating help marker $e");
      }



  }
  Future<void> removeMarkers(List<Users> model)async {


    try {

      late var myUserNeedsHelp = model.singleWhere((element) => element.id == userIdAndroid);
      late var myElement = model.singleWhere((element) => element.id == userIdAndroid);

      if (myElement.isHelping == ""){
        setState(() {
        _markers.removeWhere((marker) => marker.markerId.value == "needsHelp");
        needsHelp = true;
       print("positaaaaaaaaa 1");
        });
      }
       if(myUserNeedsHelp.isGettingHelp == "") {
      setState(() {
        print("positaaaaaaaaa 2");
       _markers.removeWhere((marker) => marker.markerId.value == "isHelping");
        isHelping = true;

      });
      }
    }catch(e){
      print("ERROR: $e");
    }
  }

  Future<void> createMarker(List<Users> model)async {
    try {
      print("pääseekö");
      late final userNeedingHelp =  model.singleWhere((element) =>
      element.isGettingHelp != "");
      late final userHelping = model.singleWhere((element) =>
      element.isHelping != "");

      if( userNeedingHelp.isGettingHelp == userIdAndroid){
            print("skeert");
            callForHelp(userNeedingHelp.latitude, userNeedingHelp.longitude);
      }
      if(userHelping.isHelping == userIdAndroid) {
        userComingToHelp(userHelping.latitude, userHelping.longitude);
      }


    }catch(e){
      print("ERROR: $e");
    }
  }

  /*
  StreamBuilder checkIfCallingForHelp(){
    //kokeile samalla tavalla kun help alertti jos silloin ei tulisi ongelmia streamin kuuntelun kanssa.

     return StreamBuilder(
        stream: myFututre2,
        builder:  (context, AsyncSnapshot snapshot) {

    print("dadadadadadadad adadada addadadda");
    print(snapshot .hasData);

    if(snapshot.hasData) {
      print(snapshot);
      print("pääsi ohi tässä");
      late final myUser = snapshot.data as List<Users>;
      try {
       userNeedingHelp = myUser.singleWhere((element) =>
        element.needsHelp == true);

       userHelping = myUser.singleWhere((element) =>
       element.isHelping != "" && element.isHelping == userIdAndroid);

       userGettingHelp = myUser.singleWhere((element) =>
       element.id == userIdAndroid && element.isGettingHelp != "");
      }catch(e){
        print(e);
      }

      print("tässä mennään fkjasghfqwieufgwqeiuf");
      print("${userHelping} dawhdvbaujwhydawudawdaw");
      print(userGettingHelp);
      print(userNeedingHelp);

     if(userGettingHelp != null  && userGettingHelp.id == userIdAndroid || userNeedingHelp != null && userNeedingHelp.needsHelp != false &&  userNeedingHelp.id == userIdAndroid ){
      return Positioned(
          bottom: 120,
          right: 12,
          child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Do you want  to cancel help call?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            print("$userHelping tässä");
                            if(userHelping == null || userHelping.id == ""){
                              backend.cancelHelpCallWithoutId();

                            }else{
                              backend.cancelHelpCall(userHelping.id.toString());
                            }


                            Navigator.pop(context, false);

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
          backgroundColor: Colors.white70,
          child: const Icon(
            Icons.close,
          )));
    }
     else{

      return Positioned(
          bottom: 120,
          right: 12,
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
                            backend.helpCall();
                            Navigator.pop(context, false);

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
          )));
    }}else return SizedBox(width: 0, height: 0,);

  });}*/



/*void doesSomeOneNeedHelp(double lat, double lon) async {
  StreamBuilder(
      stream: LocationStream().getUserStream(),
      builder:  (context, AsyncSnapshot snapshot){

        if(snapshot.hasData){
          var myUsers = snapshot.data as List<Users>;
          print("TÄMÄ on ENNEN MAPIN LUONTIA ${myUsers[0].latitude}");
          try{
            print("${snapshot.data['needsHelp']}");


            //   print("${needHelp.needsHelp}");
            //if(needHelp != null && needHelp.needsHelp == true){
            switch(visibility){
              case true: {

                Future.delayed(Duration.zero, () =>
                    setState(() {
                      isVisible = true;
                    })
                );
                break;
              }
              case false: {
                print("kukaan ei tarvitse apua");
                break;

              }
            }

            //LUO ALERT DIALOG JOSSA VASTAAT AUTATKO VAI ET JA JOS AUTAT NIIN LUO MARKER STREAMBUILDERISTA VOI OLLA
            //APUA ALERTDIALOGIN KANSSA.



          }catch(e){
            print("ERROR $e");
          }

        }
        return  Visibility(
            visible: isVisible,
            child:
        );
      }),

}*/

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



    ChangeNotifierProvider<UserNotifier>(
    create: (_) => UserNotifier(),
    child: HelpCallButton()),

    ChangeNotifierProvider<UserNotifier>(
    create: (_) => UserNotifier(),
    child: AlertView()),



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
