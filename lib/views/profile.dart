import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';

class ProfilePage extends AppWidget {
  ProfilePage({@required app}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text("Profile", style: TextStyle(fontSize: 20)),
            _logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return OutlineButton(
      child: Text("Logout"),
      onPressed: () {
        widget.app.logout();
      },
    );
  }
}
