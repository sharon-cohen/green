import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenpeace/streem_firestore/StruggleStream.dart';
import 'event_model.dart';
import 'package:flutter/material.dart';
import 'event_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/global.dart' as globals;
final _firestore = Firestore.instance;
class AddEventPage extends StatefulWidget {
  final EventModel note;
  final String sender;
  final String senderId;
  const AddEventPage({Key key, this.note,this.sender,this.senderId}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _controller = new TextEditingController();
  FirebaseUser currentUser;

  String str = "";
  String submitStr = "";
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }
  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }
  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }
  //not used
  // int votes = 0;
  // void countT() {
  //   setState(() {
  //     votes++;
  //   });
  // }

  Widget text_field(){
    return TextField(
      textAlign: TextAlign.right,
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: "תוכן ההודעה",
      ),
      onChanged: (String value) {
        submitStr=value;

      },
      controller: _controller,
      onSubmitted: (String submittedStr) {

        _controller.text = "";
      },
    );



  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      body: new Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(

                children: <Widget>[
                  IconButton(
                    icon: Icon(
                        Icons.clear
                    ),
                    iconSize: 30,
                    color: Colors.grey,
                    splashColor: Colors.purple,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),

                  Spacer(), // use Spacer
                  IconButton(
                    icon: Icon(
                      Icons.send,
                    ),
                    iconSize: 30,
                    color: Colors.grey,
                    splashColor: Colors.purple,
                    onPressed: () {

                      if(globals.isMeneger==false) {
                        _firestore.collection("report").add({
                          "text": '$submitStr',
                          "sender": _email(),
                          "time": DateTime.now(),
                          "url": "",
                          "senderID": currentUser.uid,

                        });
                      }
                      else{
                        DocumentReference documentReference = Firestore.instance.collection("personalMess").document();
                        documentReference.setData({

                          "text": '$submitStr',
                          "sender": _email(),
                          "time": DateTime.now(),
                          "url": "",
                          "senderID": currentUser.uid,

                        });

                        Firestore.instance.collection("users").document(widget.senderId).updateData({"personalMessId": FieldValue.arrayUnion([documentReference.documentID])});

                      }

                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'אל המנהלים',
              ),

            ),
            Divider(
                thickness: 1,
                color: Colors.black
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                  'מאת: '+_email(),

              ),

            ),
            Divider(
                thickness: 1,
                color: Colors.black
            ),
            text_field(),



          ],
        ),
      ),
    );
  }
  }


