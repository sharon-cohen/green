import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp time;
  final bool isMe;
  final String image_u;
  MessageBubble({this.sender, this.text, this.isMe, this.time, this.image_u});

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
        elevation: 5.0,
        color: isMe ? Colors.green : Colors.green.shade200,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    } else
      return Container(
          height: 100,
          width: 100,
          decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new NetworkImage(image_u),
                fit: BoxFit.fill,
              )));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              isMe?
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "$sender ${time.toDate()}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ):Text("$sender ${time.toDate()}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
               ),
              Container(
                child: GestureDetector(
                  onTap: () => DialogUtils.showCustomDialog(
                    context,
                    title: "אתה בטוח רוצה לדווח על הודעה זו למנהל?",
                    okBtnText: "דווח",
                    cancelBtnText: "ביטול",
                    text: text,
                    sender: sender,
                    image_u: image_u,
                    flage_report: report,
                  ),
                  child:!isMe? Container(
                      height: 25,
                      width: 25,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('image/report.png'),
                            fit: BoxFit.fill,
                          ))):Container(),
                ),
              ),
            ],
          ),
          nassege()
        ],
      ),
    );
  }
}
