import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mof_friends/auth/authentication.dart';

class App {
  final Auth auth;
  void Function() logout;

  App({this.auth});

  DocumentReference me() {
    if (auth.currentUser == null) return null;
    return auth.firestore.collection("users").document(auth.currentUser.uid);
  }
}
