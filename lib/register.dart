import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io' show Platform;
import 'globalfunc.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'global.dart' as globals;
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:greenpeace/welcom.dart';
final _firestore = Firestore.instance;
String exsistmail="מייל זה כבר קיים במערכת";
enum authProblems { UserNotFound, PasswordNotValid, NetworkError,exsistmail }
FirebaseUser loggedInUser;
final databaseReference = Firestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}


class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String name;
  String password;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new Scaffold(body: new Builder(
      builder: (BuildContext context) {
        return new Stack(

          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2,
                  color: Colors.green,
                ),
              ],
            ),
            new Image.asset(
              'image/logo_greem.png',
              fit: BoxFit.fitWidth,
            ),
            new Center(

              child: new Container(
                height: 370.0,

                child: Container(

                  height:250.0,
                  child: new Card(
                    color: Colors.white,
                    elevation: 6.0,
                    margin: EdgeInsets.only(right: 15.0, left: 15.0),
                    child: new Wrap(

                      children: <Widget>[

                        new ListTile(
                          title: new TextField(
                            style: TextStyle(fontSize: 20, fontFamily: 'Assistant'),
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              name = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'שם משתמש',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.lightGreen)
                                // borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                // borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),



                        ),
                        new ListTile(

                          title: new TextField(
                            style: TextStyle(fontSize: 20, fontFamily: 'Assistant'),
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'דואר אלקטרוני',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightGreen),
                                // borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                // borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),
                        ),
                        new ListTile(

                          title: new  TextField(
                            style: TextStyle(fontSize: 20, fontFamily: 'Assistant'),
                            obscureText: true,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'סיסמה',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lightGreen),
                                // borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                // borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          },
                          title: Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 15.0),
                            child: Center(
                              child: Text(
                                "חזרה לתפרט הראשי",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 120.0)),

                      ],

                    ),

                  ),


                ),
                padding: EdgeInsets.only(bottom: 30),

              ),

            ),
            new Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 310.0)),
                    RaisedButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          bool existName = await CheckNameUserExist(name);
                          if (!existName) {
                            final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                            if (newUser != null) {
                              print("get in");
                              FirebaseUser user = newUser.user;
                              String t = user.uid;

                              globals.name = name;
                              bool menag = await doesNameAlreadyExist(email);

                              if (menag == true) {
                                globals.isMeneger = true;
                                print(globals.isMeneger);
                                await _firestore
                                    .collection("users")
                                    .document(t)
                                    .setData({
                                  "name": name,
                                  "role": "menager",
                                  "email": email,
                                });

                                globals.no_reg = false;
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.pushNamed(
                                    context, BottomNavigationBarController.id,
                                    arguments: ScreenArguments_m(t, name, 'menager'));
                              } else {
                                globals.no_reg = false;
                                globals.isMeneger = false;
                                await _firestore
                                    .collection("users")
                                    .document(t)
                                    .setData({
                                  "name": name,
                                  "role": "regular",
                                  "email": email,
                                  "personalMessId": FieldValue.arrayUnion(['']),
                                  "personalMessIdDeleted":
                                  FieldValue.arrayUnion(['']),
                                });
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.pushNamed(
                                    context, BottomNavigationBarController.id);
                              }

                              globals.name = name;
                              globals.UserId = t;
                              globals.emailUser = email;
                            } else {
                              print("error new user");
                              showAlertDialogRegisterName(context);
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } else {
                            setState(() {
                              showSpinner = false;
                            });
                            errorMailhowAlertDialog(
                                context, "שם משתמש זה כבר קיים במערכת ");
                          }
                        } catch (e) {
//                    setState(() {
//                      showSpinner = false;
//                    });
//                    ExsistMailhowAlertDialog(context);
                          String  errorType;
                          if (Platform.isAndroid) {
                            print(e.message);
                            switch (e.message) {
                              case 'The email address is already in use by another account.':
                                errorType = "מייל זה כבר קיים במערכת";
                                break;
                              case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                                errorType ="משתמש זה כבר לא קיים במערכת";
                                break;
                              case 'The password is invalid or the user does not have a password.':
                                errorType = "סיסמא לא נכונה";
                                break;
                              case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                                errorType = "זוהה בעיית חיבור לרשת";
                                break;
                            // ...
                              default:
                            }
                          } else if (Platform.isIOS) {
                            switch (e.code) {
                              case 'Error 17011':
                                errorType ="משתמש זה כבר לא קיים במערכת";
                                break;
                              case 'Error 17009':
                                errorType = "סיסמא לא נכונה";
                                break;
                              case 'Error 17020':
                                errorType = "זוהה בעיית חיבור לרשת";
                                break;
                            // ...
                              default:
                                print('Case ${e.message} is not yet implemented');
                            }
                          }
                          setState(() {
                            showSpinner = false;
                          });
                          errorMailhowAlertDialog(context, errorType.toString());
                        }
                      },

                      color: Colors.green,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: new Text('הרשם',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
            )

          ],

        );
      },
    )));
  }
}
class databaseservice {
  final String uid;
  databaseservice({this.uid});
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  Future updateUserData(String name, String role) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'role': role,
    });
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
        color: Color(int.parse("0xff6ed000")),
        //borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Assistant',
                    fontSize: 20),
              ),
              Spacer(),

              //SizedBox(width: 270),
              Image.asset(
                'image/whitearrow.png',
                width: 30,
                height: 30,
              ),
            ],
          ),
          // child: Text(
          //   title,
          //   style: TextStyle(
          //     color: Colors.white,
          //   ),
          // ),
        ),
      ),
    );
  }
}

Future<bool> doesNameAlreadyExist(String email) async {
  final QuerySnapshot result = await Firestore.instance
      .collection('manegar')
      .where('email', isEqualTo: email)
      .limit(1)
      .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  return documents.length == 1;
}

showAlertDialogRegisterName(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("אישור",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("שם משתמש זה קיים אנא בחר בשם אחר",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
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

errorMailhowAlertDialog(BuildContext context, String error) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("חזור",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("שגיאה ",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
    content:Text(error,
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
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



