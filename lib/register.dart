import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home/Home.dart';
import'dart:io' show Platform;
import 'globalfunc.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'global.dart' as globals;
import 'package:greenpeace/GetID_DB/getid.dart';
//final _firestore = Firestore.instance;
enum authProblems { UserNotFound, PasswordNotValid, NetworkError }
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('image/logo_greem.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
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
              SizedBox(
                height: 8.0,
              ),
              TextField(
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
              SizedBox(
                height: 8.0,
              ),
              TextField(
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
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'הירשם',
                colour: Color(int.parse("0xff6ed000")),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    bool existName =await CheckNameUserExist(name);
                    print("sdfsd");


                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                          email: email, password: password);
                    print("sdfsd");
                      if (newUser != null) {
                        FirebaseUser user = newUser.user;
                        String t = user.uid;
                        databaseReference
                            .collection('users')
                            .document(t)
                            .updateData({'name': name});
                        globals.name = name;
                        bool menag = await doesNameAlreadyExist(email);
                        print(menag);
                        if (menag == true) {
                          globals.isMeneger = true;
                          print(globals.isMeneger);
                          await databaseservice(uid: user.uid)
                              .updateUserData(name, 'menager');
                          globals.no_reg = false;
                          Navigator.pushNamed(
                              context, BottomNavigationBarController.id,
                              arguments: ScreenArguments_m(t, name, 'menager'));
                        } else {
                          globals.no_reg = false;
                          globals.isMeneger = false;
                          await databaseservice(uid: user.uid)
                              .updateUserData(name, 'regular');
                          Navigator.pushNamed(
                              context, BottomNavigationBarController.id,
                              arguments: ScreenArguments(t, name, 'regular'));

//                      var document = await Firestore.instance.collection('users').document('ENsyb4kmVkUbDvNS8ILNARKN49m1'
//                      ).get();
//                          print(document.data['name']);
                        // Navigator.pushNamed(context, BasicGridView.id);
                      }

                      setState(() async {
                        showSpinner = false;
                      });
                    }
                    else{
                      showAlertDialogRegisterName(context);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  } catch (e) {

//                    setState(() {
//                      showSpinner = false;
//                    });
//                    ExsistMailhowAlertDialog(context);
                    authProblems errorType;
                    if (Platform.isAndroid) {
                      switch (e.message) {
                        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                          errorType = authProblems.UserNotFound;
                          break;
                        case 'The password is invalid or the user does not have a password.':
                          errorType = authProblems.PasswordNotValid;
                          break;
                        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                          errorType = authProblems.NetworkError;
                          break;
                      // ...
                        default:

                      }
                    } else if (Platform.isIOS) {
                      switch (e.code) {
                        case 'Error 17011':
                          errorType = authProblems.UserNotFound;
                          break;
                        case 'Error 17009':
                          errorType = authProblems.PasswordNotValid;
                          break;
                        case 'Error 17020':
                          errorType = authProblems.NetworkError;
                          break;
                      // ...
                        default:
                          print('Case ${e.message} is not yet implemented');
                      }
                    }
                    setState(() {
                      showSpinner = false;
                    });
                    errorMailhowAlertDialog(context,errorType.toString());
                  }

                },
              ),
            ],
          ),
        ),
      ),
    );
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
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("שם משתמש זה קיים אנא בחר בשם אחר"),

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

errorMailhowAlertDialog(BuildContext context,String error) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("חזור"),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(error+"שגיאה "),

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