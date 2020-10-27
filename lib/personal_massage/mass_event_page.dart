import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/evants/add_event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/evants/update_event.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:greenpeace/globalfunc.dart';

final databaseReference = Firestore.instance;

class mass_event extends StatefulWidget {
  EventModel event;
  mass_event({this.event});
  @override
  _mass_eventState createState() => _mass_eventState();
}

class _mass_eventState extends State<mass_event> {
  FirebaseUser currentUser;
  String idevent;

  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          automaticallyImplyLeading: false),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // margin: const EdgeInsets.all(30),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "הודעות",
                      style: new TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Assistant',
                      ),
                    ),
                    Spacer(),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Row(
                        children: [
                          new Text(
                            "מאת: ",
                            style: new TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Assistant',
                            ),
                          ),
                          new Text(widget.event.sender,
                              style: new TextStyle(
                                fontSize: 20,
                                fontFamily: 'Assistant',
                              )),
                        ],
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Row(
                        children: [
                          new Text("נושא: אירוע חדש",
                              style: new TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Assistant',
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 21, 16),
              child: Column(
                children: [
                  new Align(
                    child: FittedBox(
                      child: new Text(widget.event.title,
                          style: new TextStyle(
                            fontFamily: 'Assistant',
                          )),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: FittedBox(
                      child: new Text(widget.event.description,
                          style: new TextStyle(
                            fontFamily: 'Assistant',
                          )),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: FittedBox(
                      child: new Text(
                        "תאריך",
                        style: new TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Assistant',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: Text(
                      DayConvert(widget.event.eventDate.weekday.toString()) +
                          " " +
                          widget.event.eventDate.day.toString() +
                          monthConvert(widget.event.eventDate.month.toString()),
                      style:
                          new TextStyle(fontSize: 15, fontFamily: 'Assistant'),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: FittedBox(
                      child: new Text(
                        "סוג האירוע",
                        style: new TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Assistant',
                            fontWeight: FontWeight.bold),
                      ),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: FittedBox(
                      child: new Text(widget.event.type_event.toString(),
                          style: new TextStyle(
                            fontFamily: 'Assistant',
                          )),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: new Text(
                      "מיקום",
                      style: new TextStyle(
                        fontSize: 20,
                        fontFamily: 'Assistant',
                        fontWeight: FontWeight.bold,
                      ),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Color(int.parse("0xff6ed000")),
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(0.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        launchMap(widget.event.location);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'image/google-maps.png',
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(width: 7),
                          Text(
                            widget.event.location,
                            style: TextStyle(
                                fontSize: 20.0, fontFamily: 'Assistant'),
                          ),
                        ],
                      ),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.height / (5.5), 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.height / 10,

                            //color: Color(int.parse("0xff6ed000")),
                            decoration: BoxDecoration(
                              //color: Color(int.parse("0xff6ed000")),
                              color: Colors.grey,
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
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontFamily: 'Assistant',
                                          )),
                                    ],
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddEventPage(
                                                  sender: widget.event.sender,
                                                  senderId:
                                                      widget.event.senderId,
                                                )));
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.height / 10,
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
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                  onPressed: () async {
                                    String idevent =
                                        await Getevent(widget.event.title);
                                    await databaseReference
                                        .collection("events")
                                        .document(idevent)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                ),
                                // SizedBox(width: 200),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: MediaQuery.of(context).size.height / 10,
                          //   width: MediaQuery.of(context).size.height / 10,
                          //   decoration: BoxDecoration(
                          //     //border: Border.all(color: Colors.grey[600]),
                          //     color: Colors.grey[600],
                          //   ),
                          // child: Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     FlatButton(
                          //       child: Column(
                          //         children: [
                          //           Image.asset(
                          //             'image/send.png',
                          //             color: Colors.white,
                          //             width: 30,
                          //             height: 30,
                          //           ),
                          //           Text('אישור',
                          //               style: TextStyle(
                          //                 fontFamily: 'Assistant',
                          //                 fontSize: 15,
                          //                 color: Colors.white,
                          //               )),
                          //         ],
                          //       ),
                          //       onPressed: () async {
                          //         idevent = await Getevent(widget.event.title);
                          //         databaseReference
                          //             .collection('events')
                          //             .document(idevent)
                          //             .updateData({'approve': true});
                          //         successshowAlertDialog(
                          //             context,
                          //             _email(),
                          //             currentUser.uid,
                          //             widget.event.title,
                          //             widget.event.senderId);
                          //       },
                          //     ),
                          //     // SizedBox(width: 200),
                          //   ],
                          // ),
                          //  ),
                          Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.height / 10,
                            decoration: BoxDecoration(
                              //border: Border.all(color: Colors.grey[600]),
                              color: Colors.grey,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  child: Column(
                                    children: [
                                      Icon(Icons.edit, color: Colors.white),
                                      Text('ערוך',
                                          style: TextStyle(
                                            fontFamily: 'Assistant',
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                  onPressed: () async {
                                    idevent =
                                        await Getevent(widget.event.title);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                updateEventPage(
                                                  event: widget.event,
                                                )));
                                  },
                                ),
                                // SizedBox(width: 200),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: MediaQuery.of(context).size.height / (30)),
                      child: Material(
                        color: Color(int.parse("0xff6ed000")),
                        elevation: 5.0,
                        //borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          onPressed: () async {
                            idevent = await Getevent(widget.event.title);
                            databaseReference
                                .collection('events')
                                .document(idevent)
                                .updateData({'approve': true});
                            successshowAlertDialog(
                                context,
                                _email(),
                                currentUser.uid,
                                widget.event.title,
                                widget.event.senderId);
                          },
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "אשר אירוע",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(width: 270),
                              Image.asset(
                                'image/whitearrow.png',
                                width: 30,
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
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

successshowAlertDialog(BuildContext context, String email, String currentuserId,
    String name_event, String createby) {
  FirebaseUser currentUser;
  // set up the button
  Widget okButton = FlatButton(
    child: Text("אישור",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
    onPressed: () {
      DocumentReference documentReference =
          Firestore.instance.collection("personalMess").document();
      documentReference.setData({
        "text": 'אושר על ידי המנהלים והוסף ללוח האירועים' +
            "\n" +
            name_event +
            'האירוע',
        "sender": email,
        "time": DateTime.now(),
        "url": "",
        "senderID": currentuserId,
      });

      Firestore.instance.collection("users").document(createby).updateData({
        "personalMessId": FieldValue.arrayUnion([documentReference.documentID])
      });
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("אירוע עודכן בהצלחה",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
    content: Text("נשלח עידכון ליוצר האירוע",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_launchURL(String url) async {
  String wazeUrl = "https://waze.com/ul?q=";
  wazeUrl = wazeUrl + url;
  if (await canLaunch(wazeUrl)) {
    await launch(wazeUrl);
  } else {
    throw 'Could not launch $url';
  }
}
