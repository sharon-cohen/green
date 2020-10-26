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
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  Widget text_field() {
    return TextField(
      textAlign: TextAlign.right,
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: "תוכן ההודעה",
      ),
      onChanged: (String value) {
        submitStr = value;
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
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          automaticallyImplyLeading: false),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 16,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.clear),
                        iconSize: 30,
                        color: Colors.grey,
                        splashColor: Colors.purple,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      Spacer(),
                      Text(
                        'הודעה למשתמשים',
                        style: TextStyle(
                            fontFamily: 'Assistant',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Text('אל: ',
                                  style: new TextStyle(
                                      fontFamily: 'Assistant',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(' all users ',
                                  style: new TextStyle(
                                      fontSize: 20, fontFamily: 'Assistant')),
                            ],
                          ),
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Text('מאת: ',
                                  style: new TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Assistant')),
                              Text('מנהלים',
                                  style: new TextStyle(
                                      fontSize: 20, fontFamily: 'Assistant')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider(thickness: 1, color: Colors.black),
              Padding(
                //padding: const EdgeInsets.all(8.0),
                padding: EdgeInsets.fromLTRB(8, 1, 8, 8),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.87,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                    child: text_field(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog_mess_send(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "אישור",
      style: TextStyle(color: Colors.black, fontFamily: 'Assistant'),
    ),
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigationBarController(
                    2,
                    2,
                  )));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "נשלח",
      style: TextStyle(color: Colors.black, fontFamily: 'Assistant'),
    ),
    content: Text(
      "ההודעה נשלחה בהצלחה",
      style: TextStyle(color: Colors.black, fontFamily: 'Assistant'),
    ),
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
