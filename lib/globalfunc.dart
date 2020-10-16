import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:url_launcher/url_launcher.dart';

const kSendButtonTextStyle = TextStyle(
  fontFamily: 'Assistant',
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

var kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'הקלד הודעה',
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green),
    borderRadius: BorderRadius.circular(10),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
      //top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
      ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'הקלד הודעה',
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

Future<String> GetExistMass(String email, String text, String image) async {
  if (text == "") {
    final QuerySnapshot result = await Firestore.instance
        .collection('masseges')
        .where('sender', isEqualTo: email)
        .where('url', isEqualTo: image)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1)
      return documents[0].documentID;
    else
      return "not exist";
  } else {
    final QuerySnapshot result = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: email)
        .where('text', isEqualTo: text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1)
      return documents[0].documentID;
    else
      return "not exist";
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.colour, @required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

AssetImage getimage(String type) {
  if (type == 'נקיון') {
    return new AssetImage('image/clean.jpg');
  }
  if (type == 'הפגנה') {
    return new AssetImage('image/struggle.jpg');
  }
  if (type == 'הרצאה') {
    return new AssetImage('image/lecture.jpg');
  } else {
    return AssetImage('image/green.jpeg');
  }
}

String getimageString(String type) {
  if (type == 'נקיון') {
    return 'image/clean.jpg';
  }
  if (type == 'הפגנה') {
    return 'image/struggle.jpg';
  }
  if (type == 'הרצאה') {
    return 'image/lecture.jpg';
  } else {
    return 'image/green.jpeg';
  }
}


String DayConvert(String day){
  String res="";
  if(day=="1"){
    res="יום א,";
  }
  if(day=="2"){
    res="יום ב,";
  }
  if(day=="3"){
    res="יום ג,";
  }
  if(day=="4"){
    res="יום ד,";
  }
  if(day=="5"){
    res="יום ה,";
  }
  if(day=="6"){
    res="יום ו,";
  }if(day=="7"){
    res="יום שבת,";
  }
return res;
}
String monthConvert(String val){
  String res="";
  if(val=="1"){
    res="-ינואר";
  }
  if(val=="2"){
    res="-פבואר";
  }
  if(val=="3"){
    res="-מרץ";
  }
  if(val=="4"){
    res="-אפריל";
  }
  if(val=="5"){
    res="-מאי";
  }
  if(val=="6"){
    res="-יוני";
  }if(val=="7"){
    res="-יולי";
  }
  if(val=="8"){
    res="-אוגוסט";
  }
  if(val=="9"){
    res="-ספטמבר";
  }
  if(val=="10"){
    res="-אוקטובר";
  }
  if(val=="11"){
    res="-נובמבר";
  }
  if(val=="12"){
    res="-דצמבר";
  }

  return res;
}