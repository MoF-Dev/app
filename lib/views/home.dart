import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';

class HomePage extends AppWidget {
  HomePage({@required app}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(padding: EdgeInsets.all(10), child: Text("Hello World")),
    );
  }
}
