import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';

class AddFriendsPage extends AppWidget {
  AddFriendsPage({@required app}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "Go Back",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Find friends"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search),
                prefixText: "@",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: "username",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
