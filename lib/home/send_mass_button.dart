import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../globalfunc.dart';
import '../register.dart';
FirebaseUser loggedInUser;
final _firestore = Firestore.instance;
class button_send extends StatefulWidget {
  button_send({this.no_reg});
  final bool no_reg;
  @override
  _button_sendState createState() => _button_sendState();
}
class _button_sendState extends State<button_send> {
  List<Widget> mass=[];
  final messageTextContoller = TextEditingController();
  String fileUrl = "";
  String messageText;
  bool try_send=false;
  image_sent_pro(BuildContext context, String image_show) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
        child: Text("send"),
        onPressed: () {
          fileUrl = image_show;
          messageTextContoller.clear();
          _firestore.collection("messages").add({
            "text": "",
            "sender": loggedInUser.email,
            "time": DateTime.now(),
            "url": fileUrl,
          });

          Navigator.of(context).pop();
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Image.network(image_show),
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
  List<Widget> send_botton(){
    print('wiget.reg');
    mass.clear();
    if(try_send==false){
      mass.add(  Align(
        alignment: Alignment.centerLeft,
        child: FlatButton(
          onPressed: (){
            setState(() {
              try_send=true;
              if(widget.no_reg==true){ DialogUtils.showCustomDialog(
                context,
                title: "לא ניתן לעלות הודעה ללא הרשמה רוצה להירשם?",
                okBtnText: "הירשם",
                cancelBtnText: "חזור",
                sender: "",
              );}
            });

          },
          child: Container(
            child: Text('שלח הודעה',textAlign: TextAlign.center,),
          ),
        ),
      ),);
      return mass;
    }
    else{

      if(widget.no_reg==true){
        mass.add(FlatButton(
            onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);

            },
            child: Text('הירשם')),) ;
        return mass;
      }

      else{
        mass.add(Expanded(
          child: TextField(
            controller: messageTextContoller,
            onChanged: (value) {
              messageText = value;
            },
            decoration: kMessageTextFieldDecoration,
          ),
        ),);
        mass.add( FlatButton(
          onPressed: () {
            messageTextContoller.clear();
            _firestore.collection("messages").add({
              "text": messageText,
              "sender": loggedInUser.email,
              "time": DateTime.now(),
              "url": fileUrl,
            });
          },
          child: Text(
            'Send',
            style: kSendButtonTextStyle,
          ),
        ),);
        mass.add( new Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: new IconButton(
              icon: new Icon(
                Icons.photo_camera,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async {

                var image = await ImagePicker.pickImage(
                    source: ImageSource.gallery);
                int timestamp = new DateTime.now()
                    .millisecondsSinceEpoch;
                StorageReference storageReference =
                FirebaseStorage.instance.ref().child(
                    'chats/img_' +
                        timestamp.toString() +
                        '.jpg');
                StorageUploadTask uploadTask =
                storageReference.putFile(image);

                await uploadTask.onComplete;

                try {
                  fileUrl = await storageReference
                      .getDownloadURL();
                  image_sent_pro(context, fileUrl);

                } catch (e) {
                  print('errordfd');
                }
              }),
        ),);
        return mass;
      }

    }


  }

  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
      send_botton(),

    );
  }
}