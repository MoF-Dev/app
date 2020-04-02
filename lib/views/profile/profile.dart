import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';
import 'package:mof_friends/views/profile/addfriends.dart';
import 'package:mof_friends/views/profile/editprofile.dart';

class ProfilePage extends AppWidget {
  ProfilePage({@required app}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.app.me().snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.person_add),
              tooltip: "Add Friend",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => AddFriendsPage(app: widget.app)));
              },
            ),
            title: Text("@" + snapshot.data['username']),
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
                child: Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Theme.of(context).hintColor,
                    backgroundImage: AssetImage("assets/images/jitou.jpg"),
                    child: Text('DP'),
                  ),
                ),
              ),
              Center(
                child: Text(
                  _displayName(snapshot),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(snapshot.data.documentID,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).hintColor,
                    )),
              ),
              _editProfileButton(),
              _logoutButton(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Logout"),
            content: Text("Are you sure you want to logout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Logout"),
                onPressed: () {
                  widget.app.logout();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _displayName(AsyncSnapshot<DocumentSnapshot> snapshot) {
    if (snapshot.data["name"] != null &&
        snapshot.data["name"]["display"] != null) {
      return snapshot.data["name"]["display"];
    }
    return snapshot.data["username"];
  }

  Widget _editProfileButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: OutlineButton.icon(
        icon: Icon(Icons.edit),
        label: Text("Edit Profile"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EditProfilePage(app: widget.app)));
        },
      ),
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: OutlineButton.icon(
        icon: Icon(Icons.exit_to_app),
        label: Text("Logout"),
        onPressed: () {
          _confirmLogout();
        },
      ),
    );
  }
}
