import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ForgetPassword extends StatefulWidget {

  @override
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword> {

  TextEditingController nameController = TextEditingController();
  String UserName = '';


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
              automaticallyImplyLeading: false,
              actions: <Widget>[
          new IconButton(
          icon: new Icon(Icons.close,color: Colors.black,),

            onPressed: () => Navigator.of(context).pop(null),
      ),
      ],
          ),

          body: Center(child: Column(children: <Widget>[
            Column(
              children: [
                Container(
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      onChanged: (text)  {
                        setState(() {
                          UserName = text;
                        });

                        },

                    )

                ),
         Center(
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () async{
                await resetPassword(UserName);
                showAlertDialogForgetPassword(context);
                },
              child: Text(
                "שלח למייל",
                style: TextStyle(fontSize: 20.0),
              ),
            )
        ),

              ],
            ),


          ]))),
    );
  }

}
showAlertDialogForgetPassword(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("בעוד כמה רגעים ישלח לך מייל לאיפוס סיסמה"),

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