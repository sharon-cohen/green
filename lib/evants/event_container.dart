import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:greenpeace/evants/event_page.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class event_container extends StatelessWidget {
  final EventModel Event;

  event_container({this.Event});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsPage(
                      event: Event,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        constraints: new BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / (5),
          maxHeight: MediaQuery.of(context).size.height / (5),
        ),
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          //  borderRadius: BorderRadius.all(const Radius.circular(20)),
          image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
            image: getimage(Event.type_event),
            fit: BoxFit.cover,
          ),
        ),
        child: new Text(Event.title,
            style: new TextStyle(
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.grey[800],
                  offset: Offset(5.0, 5.0),
                ),
              ],
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
      ),
    );
  }
}
