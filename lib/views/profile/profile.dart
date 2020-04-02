import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';
import 'package:mof_friends/views/profile/addfriend.dart';

class ProfilePage extends AppWidget {
  ProfilePage({@required app}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person_add),
          tooltip: "Add Friend",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => AddFriendPage(app: widget.app)));
          },
        ),
        title: Text("@username"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () => {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(28),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).hintColor,
              child: Text('DP'),
            ),
          ),
          Center(
            child: Text(
              "Full Display Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _logoutButton(),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: OutlineButton(
        child: Text("Logout"),
        onPressed: () {
          widget.app.logout();
        },
      ),
    );
  }
}
