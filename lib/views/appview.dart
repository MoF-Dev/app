import 'package:flutter/material.dart';

import '../app.dart';

abstract class AppWidget extends StatefulWidget {
  final App app;

  AppWidget({@required this.app, key}) : super(key: key);
}
