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
  mass_event(
      {this.event});
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
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(30),
        child: ListView(
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
              child: Row(
                children: [
                  new Text(
                    "מאת: ",
                    style: new TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Text(
                    widget.event.sender,
                    style: new TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            Divider(thickness: 1, color: Colors.black),
            new Align(
              child: Row(
                children: [
                  new Text(
                    "נושא: " + "אירוע חדש",
                    style: new TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                ],
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            Divider(thickness: 1, color: Colors.black),
            new Align(
              child: FittedBox(
                child: new Text(
                    widget.event.title,

                ),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            new Align(
              child: FittedBox(
                child: new Text(
                  widget.event.description,

                ),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            new Align(
              child: FittedBox(
                child: new Text(
                  "תאריך",
                  style: new TextStyle(color: Colors.green),
                ),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            new Align(
              child: Text(DayConvert(widget.event.eventDate.weekday.toString())+" "+widget.event.eventDate.day.toString()+monthConvert(widget.event.eventDate.month.toString()),
                style: new TextStyle(fontSize: 15),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            new Align(
              child: FittedBox(
                child: new Text(
                  "סוג האירוע",
                  style: new TextStyle(color: Colors.green),
                ),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            new Align(
              child: FittedBox(
                child: new Text(
                  widget.event.type_event,

                ),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            new Align(
              child: FlatButton(

                onPressed: () {
                  _launchURL(widget.event.whatapp);
                },
                child: FittedBox(
                  child: new Text(
                    "הצרפות לקבוצת whatapp",
                    style: new TextStyle(color: Colors.green),
                  ),
                ),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),

            new Align(
              child: new Text(
                "מיקום",
                style: new TextStyle(fontSize: 30),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            new Align(
              child: FlatButton(
                color: Colors.white,
                textColor: Colors.green,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  launchMap(widget.event.location);
                },
                child: Text(
                         widget.event.location,
                  style: TextStyle(fontSize: 20.0),
                ),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async {
                        String idevent = await Getevent(widget.event.title);
                        await databaseReference
                            .collection("events")
                            .document(idevent)
                            .delete();
                        Navigator.pop(context);
                      },
                      child: const Text('הסר', style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEventPage(
                                      sender: widget.event.sender,
                                      senderId: widget.event.senderId,
                                    )));
                      },
                      child: const Text('השב', style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async {
                        idevent = await Getevent(widget.event.title);
                        databaseReference
                            .collection('events')
                            .document(idevent)
                            .updateData({'approve': true});
                        successshowAlertDialog(context, _email(),
                            currentUser.uid, widget.event.title, widget.event.senderId);
                      },
                      child:
                          const Text('אישור', style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async {
                        idevent = await Getevent(widget.event.title);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => updateEventPage(
                                      event: widget.event,
                                    )));
                      },
                      child:
                          const Text('עריכה', style: TextStyle(fontSize: 20)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ),
                ],
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
    child: Text("אישור"),
    onPressed: () {
      DocumentReference documentReference =
          Firestore.instance.collection("personalMess").document();
      documentReference.setData({
        "text":
            'אושר על ידי המנהלים והוסף ללוח האירועים' + name_event + 'האירוע',
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
    title: Text("אירוע עודכן בהצלחה"),
    content: Text("נשלח עידכון ליוצר האירוע"),
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
  String wazeUrl="https://waze.com/ul?q=";
  wazeUrl=wazeUrl+url;
  if (await canLaunch(wazeUrl)) {
    await launch(wazeUrl);
  } else {
    throw 'Could not launch $url';
  }
}