import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/Models/db_users.dart';
import 'package:flutter_app/components/User.dart';

class LocationStream{
  final _database = FirebaseDatabase.instance.ref();

  Stream<List<Users>> getUserStream() {
    print("$_database + dawdawdawdawdaw");
    final userStream = _database.child("users").onValue;
   late final streamToUsers = userStream.map((event) {
      final userMap = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
      final userList = userMap.entries.map((element) {
        return Users.fromRTDB(Map<String, dynamic>.from(element.value));
      }).toList();
      return userList;
    });
    return streamToUsers;
  }
  Stream<List<Users>> getStream() {
    print("$_database + dawdawdawdawdaw");
    final userStream = _database.child("users").onValue;
    late final streamToUsers = userStream.map((event) {
      final userMap = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
      final userList = userMap.entries.map((element) {
        return Users.fromRTDB(Map<String, dynamic>.from(element.value));
      }).toList();
      return userList;
    });
    return streamToUsers;
  }


}