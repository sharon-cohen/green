import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:greenpeace/global.dart';
import 'package:greenpeace/evants/update_event.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/common/Header.dart';
import 'package:intl/intl.dart';
import 'package:greenpeace/globalfunc.dart';

final _firestore = Firestore.instance;

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double offset = 0;
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    return Scaffold(
      floatingActionButton: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //SizedBox(height: 50),
          isMeneger
              ? FloatingActionButton(
                  heroTag: 'edit',
                  backgroundColor: Color(int.parse("0xff6ed000")),
                  onPressed: () async {
                    String idevent = await Getevent(event.title);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => updateEventPage(
                                 event: this.event,
                                )));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.edit, color: Colors.white), // icon
                    ],
                  ),
                )
              : null,
          SizedBox(height: 10),
          isMeneger
              ? FloatingActionButton(
                  heroTag: 'delete',
                  backgroundColor: Color(int.parse("0xff6ed000")),

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
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        child: Icon(Icons.delete_forever),
                                      ),
                                      Text('האם למחוק אירוע זה?',
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
                                            await Getevent(event.title);
                                        _firestore
                                            .collection("events")
                                            .document(idevent)
                                            .delete();
                                        Navigator.pop(context, true);
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
                  //   String idevent = await Getevent(event.title);
                  //   _firestore.collection("events").document(idevent).delete();
                  //   Navigator.pop(context, true);
                  // },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ImageIcon(
                        AssetImage("image/delete.png"),
                        color: Colors.white,
                      ), // icon
                    ],
                  ),
                )
              : null,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              page: "event",
              image: getimageString(event.type_event),
              offset: offset,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    // style: Theme.of(context).textTheme.display1,
                    style: TextStyle(
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      // color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('ב- ' + cutTimeString(event.eventDate.toString()),
                      style: TextStyle(
                        fontFamily: 'Assistant',
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 20),
                  //SizedBox(height: 20.0),
                  FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        _launchURL(event.whatapp);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'image/whatsapp.png',
                            scale: 2,
                          ),
                          Text('    הצטרף לקבוצת הwhatsapp שלנו',
                              style: new TextStyle(
                                  fontFamily: 'Assistant', fontSize: 20)),
                        ],
                      )),
                  SizedBox(height: 20),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontFamily: 'Assistant',
                      fontSize: 20,
                      // color: Colors.green,
                    ),
                  ),

                  // isMeneger
                  //     ? Row(
                  //         mainAxisAlignment: MainAxisAlignment
                  //             .center, //Center Row contents horizontally,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           RaisedButton(
                  //             onPressed: () async {
                  //               String idevent = await Getevent(event.title);
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => updateEventPage(
                  //                             sender: event.sender,
                  //                             topic: event.title,
                  //                             text: event.description,
                  //                             equipment: event.equipment,
                  //                             eventDate: event.eventDate,
                  //                             senderId: event.senderId,
                  //                             location: event.location,
                  //                             type_event: event.type_event,
                  //                             dataid: idevent,
                  //                           )));
                  //             },
                  //             child: const Text('עריכת אירוע',
                  //                 style: TextStyle(
                  //                     fontFamily: 'Assistant', fontSize: 20)),
                  //             color: Colors.lightGreen,
                  //             textColor: Colors.white,
                  //           ),
                  //           SizedBox(
                  //             width: 40,
                  //           ),
                  //           RaisedButton(
                  //             onPressed: () async {
                  //               String idevent = await Getevent(event.title);
                  //               _firestore
                  //                   .collection("events")
                  //                   .document(idevent)
                  //                   .delete();
                  //               Navigator.pop(context, true);
                  //             },
                  //             child: const Text('מחיקת אירוע',
                  //                 style: TextStyle(
                  //                     fontFamily: 'Assistant', fontSize: 20)),
                  //             color: Colors.lightGreen,
                  //             textColor: Colors.white,
                  //           ),
                  //         ],
                  //       )
                  //     : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
