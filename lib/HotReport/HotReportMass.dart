import 'package:flutter/material.dart';
import 'package:greenpeace/HotReport/HotReportModel.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/evants/add_event.dart';
final _firestore = Firestore.instance;

class HotMass extends StatelessWidget {
  final HotModel report;

  const HotMass ({Key key, this.report}) : super(key: key);
  Widget mass() {
    if (report.image == "") {
      return Align(
        child: new Text(
        "ללא תמונה",
          style: new TextStyle(fontSize: 15),
        ), //so big text
        alignment: FractionalOffset.topRight,
      );
    } else {
      return Image(
        image: NetworkImage(report.image),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
              ),
              iconSize: 30,
              color: Colors.grey,
              splashColor: Colors.purple,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            new Align(
              child: new Text(
                "מאת " + report.sender,
                style: new TextStyle(fontSize: 20),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            Divider(thickness: 1, color: Colors.black),
            new Align(
              child: new Text(
                " נושא: דיווח חם",
                style: new TextStyle(fontSize: 20),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            Divider(thickness: 1, color: Colors.black),
            new Align(
              child: new Text(
                report.text,
                style: new TextStyle(fontSize: 20),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            mass(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    RaisedButton(
                      onPressed: () async {

                          String idevent = await GetHotMess(report.text, report.sender);
                          await _firestore
                              .collection("hotReport")
                              .document(idevent)
                              .delete();
                          Navigator.pop(context);


                      },
                      child: const Text('מחק הודעה',
                          style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(

                                builder: (context) =>
                                    AddEventPage (
                                      sender: report.sender,senderId: report.senderId, )));

                      },
                      child: const Text('השב',
                          style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
