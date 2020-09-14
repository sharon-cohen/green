import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/streem_firestore/event_stream.dart';
import 'package:greenpeace/Footer/footer.dart';
class List_event extends StatefulWidget {

  @override
  _List_event createState() => _List_event();
}

class _List_event extends State<List_event> {
  @override
  Widget build(BuildContext context) {
    return Container(
       color: Colors.white,
        //margin: const EdgeInsets.only(top:20),
        child: Column(
      children: [


           Text('כל האירועים'),


 event_stream(),
      ],
    ));
  }
}