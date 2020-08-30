import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/streem_firestore/event_stream.dart';
import 'package:greenpeace/Footer/footer.dart';
class List_event extends StatefulWidget {
  List_event({Key key}) : super(key: key);
  static const String id = "List_event";

  @override
  _List_event createState() => _List_event();
}

class _List_event extends State<List_event> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top:20),
        child: Column(
      children: [
        Row(
          children: [
            new Align(
              child: new Text(
                "כל האירועים",
                style: new TextStyle(fontSize: 30),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            IconButton(
                icon: Icon(
                  Icons.calendar_today,
                ),
                iconSize: 30,
                color: Colors.grey,
                splashColor: Colors.purple,
                onPressed:(){   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BottomNavigationBarController(
                              5, 4,)));}
            ),
          ],
        ),
        event_stream(),
      ],
    ));
  }
}