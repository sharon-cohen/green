import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

var kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: OutlineInputBorder(borderSide:
  BorderSide(color: Colors.green),
  borderRadius: BorderRadius.circular(10),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    //top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
class ScreenArguments_m {
  final String idname;
  final String role;
  final String name;
  ScreenArguments_m(this.idname, this.name, this.role);
}
Future<String> GetExistMass(String email,String text,String image) async {
  if(text==""){
    final QuerySnapshot result = await Firestore.instance
        .collection('masseges')
        .where('sender', isEqualTo: email)
        .where('url', isEqualTo: image)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 1)
      return documents[0].documentID;
    else
      return "not exist";

  }
else {
    final QuerySnapshot result = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: email)
        .where('text', isEqualTo: text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 1)
      return documents[0].documentID;
    else
      return "not exist";
  }
}
class movedoc {
  final String uid;

  movedoc({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection(
      'report');

  Future updateUserData(String sender, String text, String url) async {
    return await userCollection.document(uid).setData({
      'sender': sender,
      'text': text,
      'url': url,
    });
  }
}