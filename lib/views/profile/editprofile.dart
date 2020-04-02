import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';

class EditProfilePage extends AppWidget {
  EditProfilePage({@required app}) : super(app: app);

  @override
  State<StatefulWidget> createState() => new _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _nickname = TextEditingController();
  TextEditingController _displayName = TextEditingController();
  DocumentSnapshot me;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _nickname.dispose();
    _displayName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.app.me().get().then((snapshot) {
      setState(() {
        me = snapshot;
        _refreshData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return me == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                tooltip: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text("Edit Profile"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  tooltip: "Save",
                  onPressed: _saveProfile,
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(32),
                children: <Widget>[
                  Text("@" + me["username"], style: TextStyle(fontSize: 18)),
                  Text(me.documentID,
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).hintColor)),
                  Divider(),
                  _firstNameField(),
                  _lastNameField(),
                  _nicknameField(),
                  _displayNameField(),
                ],
              ),
            ),
          );
  }

  _refreshData() {
    if (me["name"] != null) {
      var name = me["name"];
      orNone(key) => name[key] == null ? "" : name[key];
      _firstName.text = orNone("first");
      _lastName.text = orNone("last");
      _nickname.text = orNone("nick");
      _displayName.text = orNone("display");
    }
  }

  _saveProfile() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var data = Map<String, dynamic>();
      var q = (TextEditingController value, key) {
        if (value.text.trim().isEmpty) {
          data["name." + key] = FieldValue.delete();
        } else {
          data["name." + key] = value.text.trim();
        }
      };
      q(_firstName, "first");
      q(_lastName, "last");
      q(_nickname, "nick");
      q(_displayName, "display");
      print(data);
      widget.app.me().updateData(data).then((d) {
        Navigator.pop(context);
      }).catchError((err) {
        _showError(Text(err.message));
      });
    }
  }

  _showError(Widget content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Error"),
              content: content,
            ));
  }

  Widget _firstNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "First Name",
      ),
      controller: _firstName,
      onChanged: updateDisplay,
    );
  }

  Widget _lastNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Last Name",
      ),
      controller: _lastName,
      onChanged: updateDisplay,
    );
  }

  Widget _nicknameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nickname",
      ),
      controller: _nickname,
    );
  }

  Widget _displayNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Display Name",
      ),
      controller: _displayName,
      onChanged: displayChanged,
    );
  }

  updateDisplay(_) {
    if (displayDefault) {
      _displayName.text =
          "${_firstName.text.trim()} ${_lastName.text.trim()}".trim();
    }
  }

  bool displayDefault = true;

  displayChanged(_) {
    displayDefault =
        "${_firstName.text.trim()} ${_lastName.text.trim()}".trim() ==
            _displayName.text.trim();
  }
}
