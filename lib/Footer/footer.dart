import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/personal_massage/manage_massage.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
import 'package:greenpeace/evants/calender.dart';
import 'package:greenpeace/evants/list_event.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:greenpeace/truggel_page/frameWeb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/welcom.dart';
import 'package:greenpeace/HotReport/hotReport.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:greenpeace/User_Page.dart';

final _firestore = Firestore.instance;

class BottomNavigationBarController extends StatefulWidget {
  static String id = "BottomNavigationBarController ";
  BottomNavigationBarController(
    this.page_num,
    this.come_from,
  );
  final int page_num;
  final int come_from;

  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  TextEditingController _c;

  final List<Widget> pages = [
    All_truggle(key: PageStorageKey(" All_truggle"),),
    FrameWeb(
      fromFooter: true,
      Url:
          "https://joinus.gpi.org.il/?_ga=2.44008870.2086395743.1602839988-1666277170.1598274308&_gac=1.57860696.1602855372.CjwKCAjwiaX8BRBZEiwAQQxGx8LD5KgD6mbHUOZQodvFWGlxKE9YbuqDN8kudiAm42PJ3eE58dyKtBoCwXgQAvD_BwE",
      title: "הצטרפו אלינו",
    ),

    Home_menager(key: PageStorageKey('home'), arguments: send),
    List_event(key: PageStorageKey('All_truggle')),
    Allmess(key: PageStorageKey('report'), arguments: send),
    create_struggle1(key: PageStorageKey('create_struggle1'), arguments: send),


  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex;
  int _index_bifore;
  static ScreenArguments_m send;
  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(int.parse("0xff6ed000")),
        unselectedItemColor: Colors.black,
        unselectedFontSize: 8,
        selectedFontSize: 10,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Assistant'),
        onTap: (int index) async {

          setState(() {
            print(index);
            _selectedIndex = index;
          });
        },
        items: !globals.no_reg
            ? const <BottomNavigationBarItem>[
                BottomNavigationBarItem(

            // ignore: deprecated_member_use
              icon: ImageIcon(
                AssetImage("image/Struggle1.png"),
              ),
              title: Text('מאבקים',
                  style: TextStyle(
                    //color: Colors.black,
                    fontFamily: 'Assistant',
                  ))),
                BottomNavigationBarItem(

                    // ignore: deprecated_member_use
                    icon: ImageIcon(
                      AssetImage("image/donate1.png"),
                    ),
                    title: Text('הצטרפו אלינו',
                        style: TextStyle(
                          //color: Colors.black,
                          fontFamily: 'Assistant',
                        ))),
                BottomNavigationBarItem(
                    // ignore: deprecated_member_use
                    icon: ImageIcon(
                      AssetImage("image/home.png"),
                      // color: Colors.black,
                      // color: Colors.black,
                    ),
                    title: Text('עמוד הבית',
                        style: TextStyle(
                          fontFamily: 'Assistant',
                          // color: Colors.black
                        ))),
                BottomNavigationBarItem(
                    // ignore: deprecated_member_use
                    icon: ImageIcon(
                      AssetImage("image/Struggle2.png"),
                      // color: Colors.black,
                      // color: Colors.black,
                    ),
                    title: Text('אירועים',
                        style: TextStyle(
                          //color: Colors.black,
                          fontFamily: 'Assistant',
                        ))),
                BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                  icon: ImageIcon(
                    AssetImage("image/feed2.png"),

                    // color: Color(int.parse("0xff6ed000")),
                    // color: Colors.black,
                  ),
                  title: Text('צור קשר',
                      style: TextStyle(
                        //color: Colors.black,
                        fontFamily: 'Assistant',
                      )),
                ),
              ]
            : const <BottomNavigationBarItem>[
                BottomNavigationBarItem(

            // ignore: deprecated_member_use
              icon: ImageIcon(
                AssetImage("image/Struggle1.png"),
              ),
              title: Text('מאבקים',
                  style: TextStyle(
                    //color: Colors.black,
                    fontFamily: 'Assistant',
                  ))),
                BottomNavigationBarItem(

                    // ignore: deprecated_member_use
                    icon: ImageIcon(
                      AssetImage(
                        "image/donate1.png",
                      ),
                      //size: 40,
                      //  color: Colors.black,
                    ),
                    title: Text('הצטרפו אלינו',
                        style: TextStyle(
                          //color: Colors.black,
                          fontFamily: 'Assistant',
                          //fontSize: 6
                        ))),
                BottomNavigationBarItem(
                    // ignore: deprecated_member_use
                    icon: ImageIcon(
                      AssetImage("image/home.png"),
                      // color: Colors.black,
                      // color: Colors.black,
                    ),
                    title: Text('עמוד הבית',
                        style: TextStyle(
                          //  color: Colors.black,
                          fontFamily: 'Assistant',
                          //fontSize: 6
                        ))),
                BottomNavigationBarItem(
                    // ignore: deprecated_member_use
                    icon: ImageIcon(
                      AssetImage("image/Struggle2.png"),
                      // color: Colors.black,
                      // color: Colors.black,
                    ),
                    title: Text('אירועים',
                        style: TextStyle(
                          //color: Colors.black,
                          fontFamily: 'Assistant',
                        ))),
              ],
      );

  @override
  void initState() {
    _c = new TextEditingController();
    super.initState();

    setState(() {
      _selectedIndex = widget.page_num;
      _index_bifore = widget.come_from;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_index_bifore),
      floatingActionButton: !globals.isMeneger && _selectedIndex!=1
          ? Padding(
        padding: EdgeInsets.fromLTRB(
            0,
            0,
            MediaQuery.of(context).size.height / 8.5,
            MediaQuery.of(context).size.height / 1.3),
        child: FloatingActionButton(
                heroTag: 2,
                backgroundColor: Colors.red,
                onPressed: () {
                  if (globals.no_reg == true) {
                    GoregisterAlertDialog(context);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HotReport()));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.message), // icon
                    Text("דווח"), // text
                  ],
                ),
              ),
          )
          : null,
      body: PageStorage(
        child: pages[_selectedIndex ],
        bucket: bucket,
      ),
    );
  }
}

class DialogExample extends StatefulWidget {
  @override
  _DialogExampleState createState() => new _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  String _text = "initial";
  TextEditingController _c;
  @override
  initState() {
    _c = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(_text),
          new RaisedButton(
            onPressed: () {
              showDialog(
                  child: new Dialog(
                    child: new Column(
                      children: <Widget>[
                        new TextField(
                          decoration:
                              new InputDecoration(hintText: "עדכן מידע"),
                          controller: _c,
                        ),
                        new FlatButton(
                          child: new Text("שמור"),
                          onPressed: () {
                            setState(() {
                              this._text = _c.text;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  context: context);
            },
            child: new Text("Show Dialog"),
          )
        ],
      )),
    );
  }
}
