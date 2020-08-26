import 'package:flutter/material.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/personal_massage/manage_massage.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
import 'package:greenpeace/evants/calender.dart';

class BottomNavigationBarController extends StatefulWidget {
  static String id = "BottomNavigationBarController ";
  BottomNavigationBarController(this.page_num,this.come_from,);
  final  int page_num;
  final  int come_from;

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

    All_truggle(
        key: PageStorageKey(' All_truggle'),
        arguments: send
    ),

    Calender(
      key: PageStorageKey('Calender'),

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
    currentIndex: selectedIndex,
    onTap: (int index) async {
      if(index == 4){
        await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(1000.0, 500, 0.0, 0.0),
          items: <PopupMenuItem<String>>[
            new PopupMenuItem<String>(
              child: FlatButton(
                child: Row(
                  children: [
                    const Text('עבודה/התנדבות'),
                    const Icon(Icons.print),
                  ],
                ),
                onPressed: (){
                  setState(() {
                    _selectedIndex=2;
                  });
                },
              ),

            ),
            new PopupMenuItem<String>(
              child: FlatButton(
                child: Row(

                  children: [
                    SizedBox(width:70,),
                    const Text('אודות'),
                    const Icon(Icons.print),
                  ],
                ),
                onPressed: (){
                  setState(() {
                    _selectedIndex=0;
                  });
                },
              ),
            ),
          ],

          elevation: 1,
          color: Colors.green,
        );
      }
      setState(() {
        if(index!=4)
          _selectedIndex = index;
      }
      );
    },
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Colors.black,), title: Text('עמוד הבית')),
      BottomNavigationBarItem(
          icon: Icon(Icons.chat,color: Colors.black,), title: Text('הודעות')),
      BottomNavigationBarItem(
          icon:ImageIcon(  AssetImage("image/icon_struggle.png"),color: Colors.black,), title: Text('מאבקים')),
      BottomNavigationBarItem(
          icon:ImageIcon(  AssetImage("image/date.png"),color: Colors.black,), title: Text('אירועים')),
      BottomNavigationBarItem(
          icon: Icon(Icons.add,color: Colors.black,), title: Text('אירועים')),
    ],

  );
  @override

  void initState() {
    super.initState();

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
