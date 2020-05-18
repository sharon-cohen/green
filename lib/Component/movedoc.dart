

import 'package:cloud_firestore/cloud_firestore.dart';


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
      "time": DateTime.now(),
    });
  }
}