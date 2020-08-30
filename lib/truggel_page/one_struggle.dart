import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'dart:convert';
import 'package:greenpeace/globalfunc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
final databaseReference = Firestore.instance;


class one_struggle extends StatefulWidget {
  final StruggleModel struggle;
  one_struggle({this.struggle});
  @override
  _one_struggle createState() => _one_struggle();
}

class _one_struggle extends State<one_struggle> {
  FirebaseUser currentUser;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       body:SingleChildScrollView(
         child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
                 Container(
                  margin: new EdgeInsets.only(left:0, right: 0, top: 0, bottom: 5.0),
                  height: MediaQuery.of(context).size.height / (2.5),
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: new NetworkImage(widget.struggle.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

              Row(
                children: [
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
                  IconButton(icon: Icon(Icons.share), onPressed:() {
                  FlutterShareMe().shareToFacebook(
                      url: widget.struggle.share, msg: "הצטרפו למאבק!");



                },),
                  IconButton(
                    icon: Icon(
                      Icons.border_color,
                    ),
                    iconSize: 30,
                    color: Colors.grey,
                    splashColor: Colors.purple,
                    onPressed:(){ _launchURL(widget.struggle.petition);}
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.all_inclusive,
                    ),
                    iconSize: 30,
                    color: Colors.grey,
                    splashColor: Colors.purple,
                    onPressed:(){ _launchURL(widget.struggle.donation);}
                  ),
                ],
              ),
              new Align(
                child: new Text(
               widget.struggle.title,
                  style: new TextStyle(fontSize: 30),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
               Expanded(

                 child: SingleChildScrollView(
                   padding: const EdgeInsets.all(8.0),
                   child: Align(
                    child: new Text(
                      widget.struggle.description,
                      style: new TextStyle(fontSize: 20),
                    ), //so big text
                    alignment: FractionalOffset.topRight,
              ),
                 ),
               ),

            ],
          ),
      ),
       ),
    );
  }
}

//successshowAlertDialog(BuildContext context, String email, String currentuserId,
//    String name_event, String createby) {
//  FirebaseUser currentUser;
//  // set up the button
//  Widget okButton = FlatButton(
//    child: Text("אישור"),
//    onPressed: () {
//      DocumentReference documentReference =
//      Firestore.instance.collection("personalMess").document();
//      documentReference.setData({
//        "text":
//        'אושר על ידי המנהלים והוסף ללוח האירועים' + name_event + 'האירוע',
//        "sender": email,
//        "time": DateTime.now(),
//        "url": "",
//        "senderID": currentuserId,
//      });
//
//      Firestore.instance.collection("users").document(createby).updateData({
//        "personalMessId": FieldValue.arrayUnion([documentReference.documentID])
//      });
//
//      Navigator.pop(context, true);
//    },
//  );
//
//  // set up the AlertDialog
//  AlertDialog alert = AlertDialog(
//    title: Text("אישור אירוע"),
//    content: Text("האירוע הוסף ללוח השנה ונשלח עיכון ליוצר האירוע"),
//    actions: [
//      okButton,
//    ],
//  );
//
//  // show the dialog
//  showDialog(
//    context: context,
//    builder: (BuildContext context) {
//      return alert;
//    },
//  );
//}
_launchURL(String url) async {

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}