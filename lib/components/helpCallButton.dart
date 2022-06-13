import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/user_notifier.dart';
import 'package:flutter_app/components/map.dart';
import 'package:flutter_app/firebase2.dart';
import 'package:flutter_app/screens/map_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HelpCallButton extends StatefulWidget {

  @override
  _HelpCallButtonState createState() => _HelpCallButtonState();
}

final GlobalKey< _HelpCallButtonState> widgetKey2 = GlobalKey< _HelpCallButtonState>();

class  _HelpCallButtonState extends State<HelpCallButton> {
  var help;

  final backend = FirebaseClass2();
  var userIdAndroid;
  final navigatorKey = GlobalKey<NavigatorState>();
  var userNeedingHelp = false;
  var userGettingHelp;
  var userHelping = false;
  Future<void> getDeviceId() async {
    try{
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      userIdAndroid = androidInfo.androidId;
    }catch (e){
      print("Getting android id failed $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    getDeviceId();
    return Consumer<UserNotifier>(builder: ( context, model, child) {
    //  print(model.users);
        return  Positioned(
              bottom: 120,
              right: 12,
              child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: model.cancelIcon ?
                            Text("Do you want  to cancel help call?") :
                            Text("Do you want  to call for help?"),

                            actions: [
                              TextButton(
                                  onPressed: () {
                                    model.helpCalls();
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
                  backgroundColor: model.cancelIcon ? Colors.white70 : Colors.red[600],
                  child: model.cancelIcon ? const Icon(
                    Icons.close,
                  ) : const FaIcon(
                    FontAwesomeIcons.handHoldingMedical,
                  )
              )
          );
        }




  );
  }
}