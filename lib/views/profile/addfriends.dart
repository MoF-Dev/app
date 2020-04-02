import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StreamBuilder(
      stream: widget.app.auth.firestore
          .collection("/users")
          .where("username", isGreaterThanOrEqualTo: _searchText)
          .where("username", isLessThanOrEqualTo: _searchText + "\uf8ff")
          .limit(20)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) => Scaffold(
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
                onChanged: (v) => setState(() => _searchText = v.trim()),
              ),
            ),
            snapshot.hasData
                ? Expanded(
                    child: ListView(
                    children: snapshot.data.documents.map(doc2tile).toList(),
                  ))
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget doc2tile(DocumentSnapshot doc) {
    var initials = "";
    if (doc["name"] != null) {
      if (doc["name"]["first"] != null) {
        initials += doc["name"]["first"][0];
      }
      if (doc["name"]["last"] != null) {
        initials += doc["name"]["last"][0];
      }
      if (doc["name"]["display"] != null && initials.isEmpty) {
        initials = doc["name"]["display"][0];
      }
    } else {
      initials = doc["username"][0].toUpperCase();
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/images/jitou.jpg"),
        child: Text(initials),
      ),
      title: Text("@${doc['username']}"),
      subtitle: _parseDisplay(doc),
      onTap: () {
        _showConfirmAdd(doc);
      },
    );
  }

  _parseDisplay(DocumentSnapshot doc) {
    var idStyle = TextStyle(
        fontSize: 12,
        color: Theme.of(context).hintColor,
        fontStyle: FontStyle.italic);
    const displayStyle = TextStyle(fontSize: 18);
    if (doc["name"] != null && doc["name"]["display"] != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(doc["name"]["display"], style: displayStyle),
          Text(doc.documentID, style: idStyle),
        ],
      );
    }
    return Text(doc.documentID, style: idStyle);
  }

  _showConfirmAdd(DocumentSnapshot doc) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Confirm Add Friend"),
              content: Wrap(
                runAlignment: WrapAlignment.center,
                children: <Widget>[
                  Text("Are you sure you want to send "),
                  Text("@" + doc["username"],
                      style: TextStyle(color: Theme.of(context).accentColor)),
                  Text(" a friend request?"),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Send Request"),
                  onPressed: () {
                    // TODO send friend request
                  },
                ),
              ],
            ));
  }
}
