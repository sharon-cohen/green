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
    return Scaffold(
      body: Container(
         color: Colors.white,
         //height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
        children: [
            IconButton(onPressed: () {
              Navigator.pop(context, true);
            }, icon: Icon(Icons.clear,
              color: Colors.black,
            ),),


              event_stream(),

        ],
      ),
          )),
    );
  }
}