import 'dart:async';


import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Models/db_users.dart';
import 'package:geolocator/geolocator.dart';

import '../firebase2.dart';


class UserNotifier extends ChangeNotifier{

List<Users> _user = [];
final _db = FirebaseDatabase.instance.ref();

static const USERS_PATH = 'users';
 late StreamSubscription<DatabaseEvent> usersStream;
final backend = FirebaseClass2();
var userIdAndroid;
late var help;
late var user;
List<Users> get users => _user;
bool visible = false;
late var userNeedingHelp;
late var userHelping;
late var userHelpingObject;
late var userGettingHelp;
late var helpLat, helpLon;
var helpMarker = false;
var userComingToHelp = false;
bool cancelIcon = false;
UserNotifier(){
  print("ajaa notifierin");
  getDeviceId();
  _listenUserNotifications();
}

Future<void> getDeviceId() async {
  try{
    print("pääsi devis id");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userIdAndroid = androidInfo.androidId;

  }catch (e){
    print("Getting android id failed $e");
  }
}


void _listenUserNotifications() {

  usersStream = _db.child(USERS_PATH).onValue.listen((event) {
   print(event.snapshot.value);
   final allUsers = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
   _user = allUsers.values
       .map((userAsJson) =>
       Users.fromRTDB(Map<String, dynamic>.from(userAsJson)))
       .toList();
   showHelpAlert();
   callHelpButton();
   print("object");
   notifyListeners();
  });

}

@override
  void dispose() {
    usersStream.cancel();
    super.dispose();
  }


  helpCalls(){
  if(cancelIcon == false){
    backend.helpCall();
  } else if(_user.any((element) =>
  element.isHelping == userIdAndroid)){
  userHelpingObject = _user.singleWhere((element) => element.isHelping == userIdAndroid);
  backend.cancelHelpCall(userHelpingObject.id);
  }else if(_user.any((element) => element.needsHelp == true && element.id == userIdAndroid)){
    backend.cancelHelpCallWithoutId();
  }
  }

  callHelpButton(){
    try {
      if(_user.any((element) => element.needsHelp == true && element.id == userIdAndroid)){
        userNeedingHelp = _user.any((element) =>
        element.needsHelp == true && element.id == userIdAndroid);
        print("joo on true1");
        cancelIcon = _user.any((element) =>
        element.needsHelp == true && element.id == userIdAndroid);
      }
      else if(_user.any((element) => element.isHelping == userIdAndroid)){
        userHelping = _user.any((element) =>
        element.isHelping == userIdAndroid);
        print("joo on true2");
        userGettingHelp = _user.singleWhere((element) =>
        element.id == userIdAndroid && element.isGettingHelp != "");
        cancelIcon = true;
      }else if (_user.any((element) => element.needsHelp == true && element.id == userIdAndroid) == false &&
          _user.any((element) => element.isHelping == userIdAndroid) == false){
         print("joo on FALSE");
         cancelIcon = false;
       }



    }catch(e){
      print(e);
    }
  }



  dissmissAlert(){
  visible = false;
  }

  showHelpAlert(){
    if(_user.any((element) => element.needsHelp == true)) {
      try {
        help = _user.singleWhere((element) => element.needsHelp == true);
        user = _user.singleWhere((element) => element.id == userIdAndroid);
      } catch (e) {
        print("ERROR $e");
      }
      if (help.id != userIdAndroid && help.needsHelp == true) {
        double distanceInMeters = Geolocator.distanceBetween(
            user.latitude, user.longitude, help.latitude, help.longitude);
        print(distanceInMeters);

        if (distanceInMeters <= 5000) {
          print(distanceInMeters);
          print("tässä distanse $distanceInMeters");
         return visible = _user.any((element) => element.needsHelp == true && element.id != userIdAndroid);
        } else {
        return  visible = false;
        }
      }
    }else {
      print("object");
      return visible = false;
    }
  }

}
