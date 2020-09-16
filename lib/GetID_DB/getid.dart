

import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> Getevent(String title) async {

  final QuerySnapshot result = await Firestore.instance
      .collection('events')
      .where('title', isEqualTo: title)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  if(documents.length == 1)
    return documents[0].documentID;
  else
    return "not exist";



}
Future<String> Getreport(String text,bool isImage) async {
if(isImage==true){
  final QuerySnapshot result = await Firestore.instance
      .collection('report')
      .where('url', isEqualTo: text)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  if(documents.length == 1)
    return documents[0].documentID;
  else
    return "not exist";
}

else{
  final QuerySnapshot result = await Firestore.instance
      .collection('report')
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
Future<String> Getmess(String text,bool isImage) async {
  if(isImage==true){
    final QuerySnapshot result = await Firestore.instance
        .collection('messages')
        .where('url', isEqualTo: text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 1)
      return documents[0].documentID;
    else
      return "not exist";
  }

  else{
    final QuerySnapshot result = await Firestore.instance
        .collection('messages')
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
Future<String> GetPersonalMess(String text,String sender) async {

  final QuerySnapshot result = await Firestore.instance
      .collection('personalMess')
      .where('text', isEqualTo: text)
      .where('sender',isEqualTo: sender)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  if(documents.length == 1)
    return documents[0].documentID;
  else
    return "not exist";



}
Future<String> GetMenagerMess(String text,String sender) async {

  final QuerySnapshot result = await Firestore.instance
      .collection('messageMenager')
      .where('text', isEqualTo: text)
      .where('sender',isEqualTo: sender)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  if(documents.length == 1)
    return documents[0].documentID;
  else
    return "not exist";



}
Future<String> GetHotMess(String text,String sender) async {

  final QuerySnapshot result = await Firestore.instance
      .collection('hotReport')
      .where('text', isEqualTo: text)
      .where('sender',isEqualTo: sender)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  if(documents.length == 1)
    return documents[0].documentID;
  else
    return "not exist";



}