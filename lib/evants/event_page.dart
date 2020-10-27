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

import 'list_event.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //SizedBox(height: 50),
          Spacer(),
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
              : Container(),
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
                                      onPressed: () {
                                        ToBeSureDeleteAlertDialogEvent(
                                            context, event.title);
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
              : Container(),
          Spacer(),
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
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                            DayConvert(event.eventDate.weekday.toString()) +
                                " " +
                                event.eventDate.day.toString() +
                                monthConvert(event.eventDate.month.toString()),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Assistant',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Spacer(),
                      FittedBox(
                        child: Text(
                            event.eventDate.hour.toString() +
                                ":" +
                                event.eventDate.minute.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Assistant',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      //  Spacer(),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  new Align(
                    child: new Text(
                      "מיקום האירוע:",
                      style: TextStyle(
                        fontFamily: 'Assistant',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
                  ),
                  new Align(
                    child: FlatButton(
                      textColor: Colors.black,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(0.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        launchMap(event.location);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'image/icon-waze.png',
                            scale: 7,
                          ),
                          FittedBox(
                            child: Text(
                              '    ' + event.location,
                              style: TextStyle(
                                fontFamily: 'Assistant',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), //so big text
                    alignment: FractionalOffset.center,
                  ),
                  FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        _launchURL(event.whatapp);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'image/whatsapp2.png',
                            scale: 170,
                          ),
                          FittedBox(
                            child: Text('    הצטרף לקבוצת הwhatsapp שלנו',
                                style: new TextStyle(
                                    fontFamily: 'Assistant', fontSize: 14)),
                          ),
                        ],
                      )),
                  SizedBox(height: 10),
                  FittedBox(
                    child: Text(
                      event.description,
                      style: TextStyle(fontFamily: 'Assistant', fontSize: 14
                          // color: Colors.green,
                          ),
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

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

ToBeSureDeleteAlertDialogEvent(BuildContext context, String eventTitle) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("מחק",
        style: TextStyle(
          fontFamily: 'Assistant',
        )),
    onPressed: () async {
      String idevent = await Getevent(eventTitle);
      await _firestore.collection("events").document(idevent).delete();
      Navigator.pushNamed(
        context,
        List_event.id,
      );
    },
  );
  Widget Later = FlatButton(
    child: Text("בטל",
        style: TextStyle(
          fontFamily: 'Assistant',
        )),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: FittedBox(
        child: Text("האם ברצונך למחוק את האירוע זה?",
            style: TextStyle(
              fontFamily: 'Assistant',
            ))),
    actions: [
      okButton,
      Later,
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
