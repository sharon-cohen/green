import 'package:flutter/material.dart';
import 'package:greenpeace/report/report_model.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class reportMass extends StatelessWidget {
  final reportModel report;

  const reportMass({Key key, this.report}) : super(key: key);
  Widget mass() {
    if (report.image == null) {
      return Align(
        child: new Text(
          report.text,
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
                "נושא: דיווח",
                style: new TextStyle(fontSize: 20),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            Divider(thickness: 1, color: Colors.black),
            mass(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        if (report.image != null) {
                          String idevent = await Getmess(report.image, true);
                          await _firestore
                              .collection("messages")
                              .document(idevent)
                              .delete();
                          Navigator.pop(context);
                        } else {
                          String idevent = await Getmess(report.text, false);
                          await _firestore
                              .collection("messages")
                              .document(idevent)
                              .delete();
                          Navigator.pop(context);
                        }

                      },
                      child: const Text('מחק דיווח',
                          style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (report.image != null) {

                          String idevent = await Getreport(report.image, true);
                          await _firestore
                              .collection("report")
                              .document(idevent)
                              .delete();
                          Navigator.pop(context);
                        } else {

                          String idevent = await Getreport(report.text, false);
                          await _firestore
                              .collection("report")
                              .document(idevent)
                              .delete();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('מחק הודעה',
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
