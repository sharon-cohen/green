import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'globalfunc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenpeace/welcom.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'global.dart' as globals;
import 'package:greenpeace/GetID_DB/getid.dart';


final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;
enum authProblems { UserNotFound, PasswordNotValid, NetworkError,ExistMail }
FirebaseUser loggedInUser;
final databaseReference = Firestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser res;
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
              RaisedButton(
                child: Text("הרשם עם גוגל"),
                onPressed: () async {
                  res = await signInWithGoogle();

                  if (res == null)
                    print("error logging in with google");
                  else {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      bool existName = await CheckNameUserExist(res.displayName.toString());
                      if (!existName) {

                        if (res != null) {
                          print("get in");

                          String t = res.uid;

                          globals.name = res.displayName.toString();
                          bool menag = await doesNameAlreadyExist(res.email);
                          name=res.displayName.toString();
                          email=res.email;
                          if (menag == true) {
                            globals.isMeneger = true;
                            print(globals.isMeneger);
                            await _firestore
                                .collection("users")
                                .document(t)
                                .setData({
                              "name": name,
                              "role": "menager",
                              "email": email.toLowerCase(),
                            });

                            globals.no_reg = false;
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pushNamed(
                                context, BottomNavigationBarController.id,
                                arguments:
                                    ScreenArguments_m(t, name, 'menager'));
                          } else {
                            globals.no_reg = false;
                            globals.isMeneger = false;
                            await _firestore
                                .collection("users")
                                .document(t)
                                .setData({
                              "name": name,
                              "role": "regular",
                              "email": email.toLowerCase(),
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
                      errorMailhowAlertDialog(context, e.toString());
                    }
                  }
                },
              ),
              RoundedButton(
                title: 'הירשם',
                colour: Color(int.parse("0xff6ed000")),
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
                            "email": email.toLowerCase(),
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
                            "email": email.toLowerCase(),
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

                    String  error;
                    authProblems errorType;
                    if (Platform.isAndroid) {

                      switch (e.message) {

                        case 'The password is invalid or the user does not have a password.':
                          error="סיסמא שגויה";
                          break;
                        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                          error="שגיאת חיבור- קיימת שגיאת חיבור לרשת";
                          break;
                        case 'The email address is already in use by another account.':
                          error="משתמש זה קיים במערכת";

                          break;
                        default:
                      }
                    } else if (Platform.isIOS) {
                      switch (e.code) {

                        case 'Error 17009':
                          error="סיסמא שגויה";
                          break;
                        case 'Error 17020':
                          error="שגיאת חיבור- קיימת שגיאת חיבור לרשת";
                          break;
                        // ...
                        default:
                          print('Case ${e.message} is not yet implemented');
                      }
                    }
                    setState(() {
                      showSpinner = false;
                    });
                    errorMailhowAlertDialog(context, error);
                  }
                },
              ),
              FlatButton(
                child: Text('חזור לתפריט הראשי',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    )),

                //colour: Color(int.parse("0xff6ed000")),

                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
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
    title: Text(error ,
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

Future<FirebaseUser> signInWithGoogle() async {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  print(user.displayName.toString());
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return user;
}
