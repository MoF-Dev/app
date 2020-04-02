import 'package:flutter/material.dart';
import 'package:mof_friends/views/appview.dart';
import 'package:mof_friends/views/bank.dart';
import 'package:mof_friends/views/home.dart';
import 'package:mof_friends/views/profile/profile.dart';

class MainPage extends AppWidget {
  MainPage({@required app, Key key}) : super(app: app, key: key);

  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

class TabEntry {
  IconData icon;
  String title;
  Widget widget;

  TabEntry({this.icon, this.title, this.widget});
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<TabEntry> _children = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: _children
            .map((e) => BottomNavigationBarItem(
                  icon: new Icon(e.icon),
                  title: new Text(e.title),
                ))
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _children.addAll([
      TabEntry(
        icon: Icons.home,
        title: "Home",
        widget: new HomePage(app: widget.app),
      ),
      TabEntry(
        icon: Icons.attach_money,
        title: "Bank",
        widget: new BankPage(app: widget.app),
      ),
      TabEntry(
        icon: Icons.person,
        title: "Profile",
        widget: new ProfilePage(app: widget.app),
      ),
    ]);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
