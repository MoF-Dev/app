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
    var textShadow = Shadow(
      blurRadius: 32,
      color: Colors.black,
    );
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/OPSSHQ.jpg"), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(32, 128, 32, 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("OMG",
                style: TextStyle(
                    fontSize: 64,
                    color: Colors.white,
                    shadows: [textShadow],
                    fontWeight: FontWeight.bold)),
            Text("Seems like you have no monies.",
                style: TextStyle(
                    fontSize: 28, color: Colors.white, shadows: [textShadow])),
            Divider(),
            FlatButton(
              color: Color.fromARGB(92, 255, 255, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Text("Request new tab account"),
              onPressed: () {
                _abxyz();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _abxyz() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("No U"),
            content: Text("ur mum"),
            actions: <Widget>[
              FlatButton(
                child: Text("no no u"),
                onPressed: () {},
              ),
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
