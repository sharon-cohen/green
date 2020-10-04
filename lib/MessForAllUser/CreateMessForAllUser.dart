import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenpeace/global.dart' as globals;

import 'package:flutter/material.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = Firestore.instance;
class SendMessForAllUser extends StatefulWidget {


  const SendMessForAllUser({Key key}) : super(key: key);

  @override
  _SendMessForAllUser createState() => _SendMessForAllUser();
}

class _SendMessForAllUser extends State<SendMessForAllUser> {
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

                      
                        _firestore.collection("MessForAll").add({
                          "text": '$submitStr',
                          "sender": globals.name,
                          "time": DateTime.now(),
                          "senderID": currentUser.uid,

                        });



                      showAlertDialog_mess_send(context);

                    },
                  ),
                ],
              ),
            ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'אל all users ',
              ),

            ),
            Divider(
                thickness: 1,
                color: Colors.black
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                  'מאת: מנהלים'

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


showAlertDialog_mess_send(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BottomNavigationBarController(
                    2, 2,)));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("נשלח"),
    content: Text("ההודעה נשלחה בהצלחה"),
    actions: [
      okButton,
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