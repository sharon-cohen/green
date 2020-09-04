import 'package:flutter/material.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/personal_massage/manage_massage.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
import 'package:greenpeace/evants/calender.dart';
import 'package:greenpeace/evants/list_event.dart';
import 'package:greenpeace/splash_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    List_event(
      key: PageStorageKey('List_event'),

    ),
    create_struggle1(
        key: PageStorageKey(' StepperBody'),
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
    currentIndex: selectedIndex,
    onTap: (int index) async {
      if(index == 0){
        await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(1000.0, 500, 0.0, 0.0),
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
                  setState(() {
                    _selectedIndex=6;
                  });
                },
              ),

            ),
            new PopupMenuItem<String>(
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
                onPressed: (){
                Navigator.pushNamed(context, splash_page.id);
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
      }
      );
    },
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.add,color: Colors.black,), title: Text('אירועים')),
      BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Colors.black,), title: Text('עמוד הבית')),
      BottomNavigationBarItem(
          icon: Icon(Icons.chat,color: Colors.black,), title: Text('הודעות')),
      BottomNavigationBarItem(
          icon:ImageIcon(  AssetImage("image/icon_struggle.png"),color: Colors.black,), title: Text('מאבקים')),
      BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted,color: Colors.black,), title: Text('הודעות')),

    ],

  );

  @override

  void initState() {
    _c = new TextEditingController();
    super.initState();

    print("Df");
setState(() {
  _selectedIndex = widget.page_num;
  _index_bifore=widget.come_from;
});


  }

  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar( _index_bifore),
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