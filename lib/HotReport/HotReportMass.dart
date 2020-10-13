import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/HotReport/HotReportModel.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/evants/add_event.dart';

final _firestore = Firestore.instance;

class HotMass extends StatelessWidget {
  final HotModel report;

  const HotMass({Key key, this.report}) : super(key: key);
  Widget mass() {
    if (report.image == "") {
      return Align(
        child: new Text(
          "ללא תמונה",
          style: new TextStyle(
            fontSize: 15,
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontFamily: 'Assistant',
          ),
        ), //so big text
        alignment: FractionalOffset.bottomRight,
      );
    } else {

      return Container(
          height: 300,
          width: 300,
          child: Image.network(report.image, fit: BoxFit.fitWidth));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          automaticallyImplyLeading: false),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Spacer(),
                      Text(
                        "דיווחים חמים",
                        style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Assistant',
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                        ),
                        iconSize: 30,
                        color: Colors.black,
                        splashColor: Colors.purple,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Row(
                            children: [
                              Text(
                                "מאת: ",
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Assistant',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                report.sender,
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Assistant',
                                ),
                              ),
                            ],
                          )),
                      Divider(thickness: 1, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          children: [
                            new Text(" נושא: ",
                                style: new TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Assistant',
                                    fontWeight: FontWeight.bold)),
                            new Text(" דיווח חם",
                                style: new TextStyle(
                                    fontSize: 20, fontFamily: 'Assistant')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider(thickness: 1, color: Colors.black),
              Padding(
                //padding: const EdgeInsets.all(8.0),
                padding: EdgeInsets.fromLTRB(8, 1, 8, 8),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.87,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(
                          report.text,
                          style: new TextStyle(
                              fontSize: 20, fontFamily: 'Assistant'),
                        ),
                        mass(),
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50),
                  Container(
                    //color: Color(int.parse("0xff6ed000")),
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(int.parse("0xff6ed000")),
                      //border: Border.all(color: Colors.grey[600])
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          child: Column(
                            children: [
                              Image.asset(
                                'image/reply.png',
                                color: Colors.white,
                                width: 30,
                                height: 30,
                              ),
                              Text('השב ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'Assistant',
                                  )),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEventPage(
                                          sender: report.sender,
                                          senderId: report.senderId,
                                        )));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 100),
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.grey[600]),
                      color: Colors.black87,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          child: Column(
                            children: [
                              Image.asset(
                                'image/delete.png',
                                color: Colors.white,
                                width: 30,
                                height: 30,
                              ),
                              Text('מחק',
                                  style: TextStyle(
                                    fontFamily: 'Assistant',
                                    fontSize: 20,
                                    color: Colors.white,
                                  )),
                            ],
                          ),

                          onPressed: () {
                            showDialog(
                                child: new Dialog(
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: new Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 0, 5, 0),
                                                child:
                                                    Icon(Icons.delete_forever),

                                                // ImageIcon(
                                                //
                                                //   AssetImage("image/alert.png"),
                                                //   color: Colors.black,
                                                //   // color: Colors.black,
                                                // ),
                                              ),
                                              Text('האם למחוק הודעה זו?',
                                                  style: TextStyle(
                                                    fontFamily: 'Assistant',
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Spacer(),
                                            new FlatButton(
                                              child: new Text("מחק",
                                                  style: TextStyle(
                                                    fontFamily: 'Assistant',
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                              onPressed: () async {
                                                String idevent =
                                                    await GetHotMess(
                                                        report.text,
                                                        report.sender);
                                                await _firestore
                                                    .collection("hotReport")
                                                    .document(idevent)
                                                    .delete();
                                                Navigator.pop(context);
                                              },
                                            ),
                                            new FlatButton(
                                              child: new Text("בטל",
                                                  style: TextStyle(
                                                    fontFamily: 'Assistant',
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                context: context);
                          },

                          // onPressed: () async {
                          //   String idevent =
                          //       await GetHotMess(report.text, report.sender);
                          //   await _firestore
                          //       .collection("hotReport")
                          //       .document(idevent)
                          //       .delete();
                          //   Navigator.pop(context);
                          // },
                        ),
                        // SizedBox(width: 200),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Container(
    //     height: MediaQuery.of(context).size.height,
    //     margin: const EdgeInsets.all(30),
    //     child: Column(
    //       children: <Widget>[
    //         IconButton(
    //           icon: Icon(
    //             Icons.keyboard_arrow_left,
    //           ),
    //           iconSize: 30,
    //           color: Colors.grey,
    //           splashColor: Colors.purple,
    //           onPressed: () {
    //             Navigator.pop(context, true);
    //           },
    //         ),
    //         new Align(
    //           child: new Text(
    //             "מאת " + report.sender,
    //             style: new TextStyle(fontSize: 20),
    //           ), //so big text
    //           alignment: FractionalOffset.topRight,
    //         ),
    //         Divider(thickness: 1, color: Colors.black),
    //         new Align(
    //           child: new Text(
    //             " נושא: דיווח חם",
    //             style: new TextStyle(fontSize: 20),
    //           ), //so big text
    //           alignment: FractionalOffset.topRight,
    //         ),
    //         Divider(thickness: 1, color: Colors.black),
    //         new Align(
    //           child: new Text(
    //             report.text,
    //             style: new TextStyle(fontSize: 20),
    //           ), //so big text
    //           alignment: FractionalOffset.topRight,
    //         ),
    //         mass(),
    //         Expanded(
    //           child: Align(
    //             alignment: Alignment.bottomCenter,
    //             child: Row(
    //               children: [
    //                 RaisedButton(
    //                   onPressed: () async {
    //
    //                       String idevent = await GetHotMess(report.text, report.sender);
    //                       await _firestore
    //                           .collection("hotReport")
    //                           .document(idevent)
    //                           .delete();
    //                       Navigator.pop(context);
    //
    //
    //                   },
    //                   child: const Text('מחק הודעה',
    //                       style: TextStyle(fontSize: 20)),
    //                   color: Colors.blue,
    //                   textColor: Colors.white,
    //                 ),
    //                 RaisedButton(
    //                   onPressed: () async {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //
    //                             builder: (context) =>
    //                                 AddEventPage (
    //                                   sender: report.sender,senderId: report.senderId, )));
    //
    //                   },
    //                   child: const Text('השב',
    //                       style: TextStyle(fontSize: 20)),
    //                   color: Colors.blue,
    //                   textColor: Colors.white,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
