import 'package:flutter/material.dart';
import 'package:mof_friends/auth/authentication.dart';

class App {
  final Auth auth;
  void Function() logout;

  App({this.auth});
}
