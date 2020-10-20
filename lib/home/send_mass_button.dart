import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../globalfunc.dart';
import 'package:flutter_image/network.dart';
import '../register.dart';
import 'package:greenpeace/global.dart' as globals;

final _firestore = Firestore.instance;

class button_send extends StatefulWidget {
  button_send({this.no_reg});
  final bool no_reg;

  @override
  _button_sendState createState() => _button_sendState();
}

class _button_sendState extends State<button_send> {
  bool isLoading = false;
  FirebaseUser currentUser;
  List<Widget> mass = [];
  final messageTextContoller = TextEditingController();
  String fileUrl = "";
  String messageText;
  bool try_send = false;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  image_sent_pro(BuildContext context,String image_show) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("בטל"),
      onPressed: ()
      {

        Navigator.pop(context, true);

      },
    );
    Widget continueButton = FlatButton(
        child: Text("שלח"),
        onPressed: () {
          fileUrl = image_show;
          messageTextContoller.clear();
          _firestore.collection("messages").add({
            "text": "",
            "sender": globals.name,
            "time": DateTime.now(),
            "url": fileUrl,
          });
            setState(() {
              fileUrl = "";
              messageText="";
            });
          Navigator.pop(context, true);


        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("בטוח תרצה לפרסם תמונה זו?"),

      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<Widget> send_botton() {
    print('wiget.reg');
    mass.clear();


    if (try_send == false) {
      //todo check if ok
      mass.add(
        Align(
          alignment: Alignment.centerLeft,
          child: FlatButton(
            onPressed: () {

                try_send = true;
                // if (widget.no_reg == true) {
                if (globals.no_reg == true) {
                  //globals
                  DialogUtils.showCustomDialog(
                    context,
                    title: "יש צורך בהרשמה",
                    okBtnText: "הירשם",
                    cancelBtnText: "חזור",
                    sender: "",
                  );
                }
                setState(() {
                  fileUrl = "";
                  messageText="";
                });

            },
            child: Container(
              child: Text(
                'שלח הודעה',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
      return mass;
    } else {
      // if (widget.no_reg == true) {
      if (globals.no_reg == true) {
        mass.add(
          FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              child: Text('הירשם')),
        );
        return mass;
      } else {
        mass.add(
          Expanded(
            child: TextField(
              controller: messageTextContoller,
              onChanged: (value) {
                messageText = value;
              },
              decoration: kMessageTextFieldDecoration,
            ),
          ),
        );
        mass.add(
          FlatButton(
            onPressed: () async{
              messageTextContoller.clear();
             await _firestore.collection("messages").add({
                "text": messageText,
                "sender": globals.name,
                "time": DateTime.now(),
                "url": fileUrl,

             });
              setState(() {
                fileUrl = "";
                messageText="";
              });
           },
            child: Text(
              'שלח',
              //style: kSendButtonTextStyle,
              style: TextStyle(
                fontFamily: 'Assistant',
                color: Colors.grey[700],
                fontSize: 15,
              ),
            ),
          ),
        );
        mass.add(
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(
                  Icons.photo_camera,
                  color: Colors.lightGreen,
                ),
                onPressed: () async {
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  int timestamp = new DateTime.now().millisecondsSinceEpoch;
                  StorageReference storageReference = FirebaseStorage.instance
                      .ref()
                      .child('chats/img_' + timestamp.toString() + '.jpg');
                  StorageUploadTask uploadTask =
                      storageReference.putFile(image);
                  setState(() {
                    isLoading=true;
                  });
                  await uploadTask.onComplete;

                  try {
                    fileUrl = await storageReference.getDownloadURL();

                    setState(() {

                      isLoading=false;
                      image_sent_pro(context,fileUrl);

                    });

                  } catch (e) {
                    print('errordfd');
                  }
                }),
          ),
        );
        return mass;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator()):Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: send_botton(),
    );
  }
}
