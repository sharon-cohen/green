import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class heart_button extends StatefulWidget {
  heart_button({this.name,this.like_or_not});
  final String name;
  bool like_or_not;
  @override
  _heart_buttonState createState() => _heart_buttonState();
}

class _heart_buttonState extends State<heart_button> {
  bool heart_OnOf=false;
  final _auth = FirebaseAuth.instance;
  void inputlike() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    Firestore.instance.collection("users").document(uid).updateData({"likes": FieldValue.arrayUnion([widget.name])});
  }
  void deletelike() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    Firestore.instance.collection("users").document(uid).updateData({"likes": FieldValue.arrayRemove([widget.name])});
  }
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        setState(() {
          if(widget.like_or_not==false){
            inputlike();
            widget.like_or_not=! widget.like_or_not;
          }
          else{
            deletelike();
            widget.like_or_not=! widget.like_or_not;
          }
        });

      },
      child: widget.like_or_not? Image.asset('image/heart_red.png'):Image.asset('image/heart.png'),
    );
  }
}