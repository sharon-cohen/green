import 'package:cached_network_image/cached_network_image.dart';
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
  String messageText = "";
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

  image_sent_pro(BuildContext context, String image_show) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("בטל"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("אישור"),
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
            messageText = "";
          });
          Navigator.pop(context, true);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("האם לפרסם תמונה זו?"),
      content: CachedNetworkImage(
        imageUrl: image_show,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      actions: [
        continueButton,
        cancelButton,
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
      mass.add(
        Expanded(
          child: TextField(
            controller: messageTextContoller,
            onTap: () {
              if (globals.no_reg == true) {
                GoregisterAlertDialog(context);
              }
            },
            onChanged: (value) {
              messageText = value;
            },
            decoration: kMessageTextFieldDecoration,
          ),
        ),
      );
      mass.add(
        FlatButton(
          onPressed: () async {
            messageTextContoller.clear();
            if (messageText != "") {
              await _firestore.collection("messages").add({
                "text": messageText,
                "sender": globals.name,
                "time": DateTime.now(),
                "url": fileUrl,
              });

              setState(() {
                fileUrl = "";
                messageText = "";
              });
            }
          },
          child: Container(
            child: Text(
              'שלח',
              //style: kSendButtonTextStyle,
              style: TextStyle(
                color: Color(int.parse("0xff6ed000")),
                fontFamily: 'Assistant',
                fontSize: 15,
              ),
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
                color: Color(int.parse("0xff6ed000")),
              ),
              onPressed: () async {
                if(globals.no_reg=true){
                  GoregisterAlertDialog(context);
                }
                else{
                  var image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
                  int timestamp = new DateTime.now().millisecondsSinceEpoch;
                  StorageReference storageReference = FirebaseStorage.instance
                      .ref()
                      .child('chats/img_' + timestamp.toString() + '.jpg');
                  StorageUploadTask uploadTask = storageReference.putFile(image);
                  setState(() {
                    isLoading = true;
                  });
                  await uploadTask.onComplete;

                  try {
                    fileUrl = await storageReference.getDownloadURL();

                    setState(() {
                      isLoading = false;
                      image_sent_pro(context, fileUrl);
                    });
                  } catch (e) {
                    print('errordfd');
                  }

                }

              })

          ,
        ),
      );
      return mass;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: send_botton(),
          );
  }
}
