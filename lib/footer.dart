import 'package:flutter/material.dart';
import 'package:greenpeace/home_menager.dart';
import 'globalfunc.dart';
import 'test.dart';
class BottomNavigationBarController extends StatefulWidget {
  static String id = "BottomNavigationBarController ";
  BottomNavigationBarController(this.arguments);
  final  ScreenArguments_m arguments;
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState

    extends State<BottomNavigationBarController> {


  final List<Widget> pages = [
   Home_menager(
      key: PageStorageKey('home'),
      arguments: send
    ),
   report(
        key: PageStorageKey('report'),
        arguments: send
    ),

    Home_menager(
        key: PageStorageKey('home'),
        arguments: send
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;
static ScreenArguments_m send;
  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    onTap: (int index) => setState(() => _selectedIndex = index),
    currentIndex: selectedIndex,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home), title: Text('עמוד הבית')),
      BottomNavigationBarItem(
          icon: Icon(Icons.report), title: Text('דיווחים')),
      BottomNavigationBarItem(
          icon: Icon(Icons.contact_phone), title: Text('Second Page')),
    ],
  );

  @override

  void initState() {
    super.initState();
    send = widget.arguments;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
