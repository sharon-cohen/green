import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:intl/intl.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp time;
  final bool isMe;
  final String image_u;
  MessageBubble({this.sender, this.text, this.isMe, this.time, this.image_u});
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  int report = 0;

  Widget nassege() {
    if (image_u == "") {
      return Material(
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            : BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
        elevation: 1,
        //color: isMe ? Colors.white70: Colors.green.shade200,
        color: isMe ? Colors.green[400] : Colors.white70,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                isMe
                    ? Text(
                        globals.name, textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Assistant',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 12,
                        ),
                        //textAlign: TextAlign.end,
                      )
                    : Text(
                        sender,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Assistant',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 12,
                        ),
                      ),
                SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Assistant',
                    // fontSize: 15,
                    // color: Colors.black,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                isMe
                    ? Container(
                        //width: MediaQuery.of(context).size.width,
                        child: Text(
                          GetTime(time.toDate(), true),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Assistant',
                            color: Colors.grey[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          // textAlign: TextAlign.end,
                        ),
                      )
                    : Text(
                        GetTime(time.toDate(), false),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Assistant'),
                      ),
              ],
            ),
          ),
        ),
      );
    } else
      return FlatButton(
        onPressed: () {},
        child: Container(
            height: 100,
            width: 100,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                image: new DecorationImage(
                  image: new NetworkImage(image_u),
                  fit: BoxFit.fill,
                ))),
      );
  }

  final today = DateTime.now();
  String GetTime(DateTime time, bool isMy) {
    int difference = today.difference(time).inDays;
    if (difference == 0 && isMy == true) {
      //return globals.name + "\n" + "Today";
      return "Today";
    }
    if (difference == 0 && isMy == false) {
      //return sender + "\n" + "Today";
      return "Today";
    }
    String TypeTime = '';

    if (difference ~/ 7 > 0) {
      if (difference ~/ 30 > 0) {
        TypeTime = 'Mo ';
        difference = difference ~/ 30;
      } else {
        TypeTime = 'W ';
        difference = difference ~/ 7;
      }
    } else {
      TypeTime = 'd ';
    }

    if (isMy == true) {
      //return globals.name + "\n" + difference.toString() + TypeTime;
      return difference.toString() + TypeTime;
    } else {
      // return sender + "\n" + difference.toString() + TypeTime;
      return difference.toString() + TypeTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () => DialogUtils.showCustomDialog(
                  context,
                  title: "דיווח למנהלים",
                  okBtnText: "דווח",
                  cancelBtnText: "בטל",
                  text: text,
                  sender: sender,
                  image_u: image_u,
                  flage_report: report,
                ),
                child: !isMe
                    ? Container(
                        height: 15,
                        width: 15,
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                          image: new AssetImage('image/3dots.png'),
                          fit: BoxFit.fill,
                        )))
                    : Container(),
              ),
            ),
            nassege(),
          ],
        ),
        isMe ? SizedBox(height: 10) : SizedBox(),
      ],
    );
  }
}
