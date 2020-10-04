import 'package:flutter/material.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/personal_massage/manage_massage.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
import 'package:greenpeace/evants/calender.dart';
import 'package:greenpeace/evants/list_event.dart';

import 'package:greenpeace/ConnectUs/connect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/welcom.dart';
import 'package:greenpeace/HotReport/hotReport.dart';
import 'package:greenpeace/global.dart' as globals;
final _firestore = Firestore.instance;
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

  TextEditingController _c;

  final List<Widget> pages = [

    connect(
        key: PageStorageKey('connect')
    ),
    Home_menager(
        key: PageStorageKey('home'),
        arguments: send
    ),
    All_truggle(
        key: PageStorageKey(' All_truggle'),
        arguments: send
    ),
    Allmess(
        key: PageStorageKey('report'),
        arguments: send
    ),

    create_struggle1(
        key: PageStorageKey('create_struggle1'),
        arguments: send
    ),
    Calender(
      key: PageStorageKey('Calender'),

    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex;
  int _index_bifore;
  static ScreenArguments_m send;
  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(

    currentIndex: _selectedIndex,
    onTap: (int index) async {
      if(index == 0){
        await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(kBottomNavigationBarHeight, MediaQuery.of(context).size.height-240-kBottomNavigationBarHeight, 0.0, 0),
          items: <PopupMenuItem<String>>[
            new PopupMenuItem<String>(
              child: FlatButton(
                child: Row(
                  children: [
                    const Icon(Icons.event),
                    const Text('יומן'),
                  ],
                ),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Calender() ));
                },
              ),

            ),
            new PopupMenuItem<String>(
              child: FlatButton(
                child: Row(

                  children: [
                    const Icon(Icons.contact_phone),
                    const Text('אירועים'),

                  ],
                ),
                onPressed: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              List_event(

                              )));
                },
              ),
            ),
           if(globals.isMeneger==true) new PopupMenuItem<String>(
              child: FlatButton(
                child: Row(
                  children: [
                    const Icon(Icons.add),
                    const Text('הוספת מנהל'),
                  ],
                ),
                onPressed: (){
                  showDialog(child: new Dialog(
                    child: new Column(
                      children: <Widget>[
                        new TextField(
                          decoration: new InputDecoration(hintText: "איימל של המנהל החדש"),
                          controller: _c,

                        ),
                        new FlatButton(
                          child: new Text("Save"),
                          onPressed: (){
                            _firestore.collection("manegar").add({
                             "email":_c.text.toString(),
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),

                  ), context: context);

                },
              ),

            ),
            new PopupMenuItem<String>(
              child: FlatButton(
                child: Row(

                  children: [
                    const Icon(Icons.exit_to_app),
                    const Text('התנתק'),

                  ],
                ),
                onPressed: ()async{
                  await FirebaseAuth.instance.signOut();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WelcomeScreen()));
                },
              ),
            ),
          ],

          elevation: 1,
          color: Colors.white,
        );
      }
      setState(() {
        if(index!=0)
          _selectedIndex = index;
        print(kBottomNavigationBarHeight);
      }
      );
    },
    items:!globals.no_reg? const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          // ignore: deprecated_member_use
          icon: Icon(Icons.add,color: Colors.black,), title: Text('אירועים')),
      BottomNavigationBarItem(
        // ignore: deprecated_member_use
          icon: Icon(Icons.all_inclusive,color: Colors.black,), title: Text('התחבר')),
      BottomNavigationBarItem(
        // ignore: deprecated_member_use
          icon: Icon(Icons.home,color: Colors.black,), title: Text('עמוד הבית')),
      BottomNavigationBarItem(
          // ignore: deprecated_member_use
          icon:ImageIcon(  AssetImage("image/icon_struggle.png"),color: Colors.black,), title: Text('מאבקים')),



      BottomNavigationBarItem(
        // ignore: deprecated_member_use
          icon: Icon(Icons.chat,color: Colors.black,), title: Text('הודעות')),
    ]:const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        // ignore: deprecated_member_use
          icon: Icon(Icons.add,color: Colors.black,), title: Text('אירועים')),
      BottomNavigationBarItem(
        // ignore: deprecated_member_use
          icon: Icon(Icons.all_inclusive,color: Colors.black,), title: Text('התחבר')),
      BottomNavigationBarItem(
        // ignore: deprecated_member_use
          icon: Icon(Icons.home,color: Colors.black,), title: Text('עמוד הבית')),
      BottomNavigationBarItem(
        // ignore: deprecated_member_use
          icon:ImageIcon(  AssetImage("image/icon_struggle.png"),color: Colors.black,), title: Text('מאבקים')),


    ],

  );

  @override

  void initState() {
    _c = new TextEditingController();
    super.initState();

setState(() {
  _selectedIndex = widget.page_num;
  _index_bifore=widget.come_from;
});


  }

  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar( _index_bifore),
      floatingActionButton: !globals.isMeneger?FloatingActionButton(
        heroTag:2,
        backgroundColor: Colors.red,

        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HotReport()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.message), // icon
            Text("דווח"), // text
          ],
        ),
      ):null,
      body: PageStorage(
        child: pages[_selectedIndex-1],
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
  initState(){
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
              new RaisedButton(onPressed: () {
                showDialog(child: new Dialog(
                  child: new Column(
                    children: <Widget>[
                      new TextField(
                        decoration: new InputDecoration(hintText: "Update Info"),
                        controller: _c,

                      ),
                      new FlatButton(
                        child: new Text("Save"),
                        onPressed: (){
                          setState((){
                            this._text = _c.text;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ), context: context);
              },child: new Text("Show Dialog"),)
            ],
          )
      ),
    );
  }
}