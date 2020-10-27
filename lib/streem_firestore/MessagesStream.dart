import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  Widget nassege(BuildContext context) {
    if (image_u == "") {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Material(
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
          elevation: 1,
          //color: isMe ? Colors.white70: Colors.green.shade200,
          color: isMe ? Color(int.parse("0xff6ed000")) : Colors.white70,
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
                  text != null
                      ? Text(
                          text.toString(),
                          style: TextStyle(
                            fontFamily: 'Assistant',
                            // fontSize: 15,
                            // color: Colors.black,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )
                      : Text(
                          " ",
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
                              //fontWeight: FontWeight.bold,
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
        ),
      );
    } else
      return FlatButton(
        padding: EdgeInsets.all(0),
        //todo add onpress
        onPressed: () {
          showAlertDialogImage(context, image_u);
        },
        //todo trying to add a name and date
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            Container(
              height: 100,
              width: 80,
              child: CachedNetworkImage(
                imageUrl: image_u,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
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
                        //fontWeight: FontWeight.bold,
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
//            decoration: new BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                image: new DecorationImage(
//                  image: new NetworkImage(image_u),
//                  fit: BoxFit.fill,
//                ))),
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
            nassege(context),
          ],
        ),
        isMe ? SizedBox(height: 10) : SizedBox(),
      ],
    );
  }
}

showAlertDialogImage(BuildContext context, String image) {
  // set up the butto
  AlertDialog alert = AlertDialog(
    content: Container(
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
