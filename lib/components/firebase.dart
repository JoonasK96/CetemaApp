import 'package:firebase_database/firebase_database.dart';

class _FirebaseLocationTest {
  void _locationTest() {
    DatabaseReference _someFirstRef =
        FirebaseDatabase.instance.reference().child("first test");
    _someFirstRef.set("blabla test");
  }
}
