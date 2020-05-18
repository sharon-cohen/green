import 'package:flutter/material.dart';
import 'package:greenpeace/home_menager.dart';
import 'globalfunc.dart';
import 'test.dart';
import 'create_truggle.dart';
import 'create_struggle1.dart';
import 'All_traggule.dart';
class BottomNavigationBarController extends StatefulWidget {
  static String id = "BottomNavigationBarController ";
  BottomNavigationBarController(this.arguments,this.page_num,this.come_from,);
  final  int page_num;
  final  int come_from;
  final  ScreenArguments_m arguments;

  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState

    extends State<BottomNavigationBarController> {

  static bool is_reg;
  final List<Widget> pages = [
   Home_menager(
      key: PageStorageKey('home'),
      arguments: send

    ),
   report(
        key: PageStorageKey('report'),
        arguments: send
   ),

    All_truggle(
        key: PageStorageKey(' All_truggle'),
        arguments: send
    ),

    create_struggle(
        key: PageStorageKey('create_struggle'),
        arguments: send
    ),
    create_struggle1(
        key: PageStorageKey(' StepperBody'),
        arguments: send
    ),

  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex;
int _index_bifore;
  static ScreenArguments_m send;
  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    onTap: (int index) => setState(() => _selectedIndex = index ),
    currentIndex: selectedIndex,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Colors.black,), title: Text('עמוד הבית')),
      BottomNavigationBarItem(
          icon: Icon(Icons.chat,color: Colors.black,), title: Text('הודעות')),
      BottomNavigationBarItem(
          icon:ImageIcon(  AssetImage("image/icon_struggle.png"),color: Colors.black,), title: Text('מאבקים')),
      BottomNavigationBarItem(
          icon:ImageIcon(  AssetImage("image/date.png"),color: Colors.black,), title: Text('אירועים')),

//      BottomNavigationBarItem(
//          icon: Icon(Icons.add_alarm,color: Colors.black,), title: Text('יצירת מאבק חדש')),
    ],
  );

  @override

  void initState() {
    super.initState();
    send = widget.arguments;
    print("Df");

    _selectedIndex = widget.page_num;
    _index_bifore=widget.come_from;

   }

  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar( _index_bifore),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
