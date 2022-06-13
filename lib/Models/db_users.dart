import 'dart:math';

import 'package:flutter/foundation.dart';
class Users {
  final String? id;
  final double latitude;
  final double longitude;
  final bool? needsHelp;
  final String? isGettingHelp;
  final String? isHelping;


  Users({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.needsHelp,
    required this.isGettingHelp,
    required this.isHelping
  });

  factory Users.fromRTDB(Map<String, dynamic> data){
    return Users(
        id: data['id'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        needsHelp: data['needsHelp'],
        isGettingHelp: data['isGettingHelp'],
        isHelping: data['isHelping']

    );
  }

}