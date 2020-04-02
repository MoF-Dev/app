import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';

class BankPage extends AppWidget {
  BankPage({@required app}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _BankPageState();
}

class _BankPageState extends State<BankPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(padding: EdgeInsets.all(10), child: Text(r"$$$$$$")),
    );
  }
}
