import 'package:flutter/material.dart';
import 'package:mof_friends/app.dart';
import 'package:mof_friends/auth/authentication.dart';
import 'package:mof_friends/views/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoF Friends',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: new RootPage(
        app: new App(
          auth: new Auth(),
        ),
      ),
    );
  }
}
