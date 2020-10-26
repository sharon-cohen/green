import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'globalfunc.dart';
import 'global.dart' as globals;
import 'package:greenpeace/register.dart';
import 'package:greenpeace/forgetPassword.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String name;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

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
                    //
                    //
                    //
                    //
                    // borderRadius: BorderRadius.circular(25.7),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'הכנס',
                colour: Color(int.parse("0xff6ed000")),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user2 = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user2 != null) {
                      FirebaseUser user1 = user2.user;
                      String t = user1.uid;

                      String userId =
                          (await FirebaseAuth.instance.currentUser()).uid;
                      globals.emailUser = user1.email;
                      var document = await Firestore.instance
                          .collection('users')
                          .document(userId)
                          .get();

                      String name = document.data['name'];
                      String role = document.data['role'];
                      globals.name = name;
                      globals.no_reg = false;
                      globals.UserId = userId;
                      if (role == 'menager') {
                        globals.isMeneger = true;
                      } else {
                        globals.isMeneger = false;
                      }
                      globals.name = name;
                      Navigator.pushNamed(
                          context, BottomNavigationBarController.id,
                          arguments: ScreenArguments_m(t, name, 'menager'));
                    }
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    showAlertDialog_error_login(context);
                  }
                },
              ),
              RoundedButton(
                title: 'שכחתי סיסמא',
                //colour: Color(int.parse("0xff6ed000")),
                colour: Colors.grey[400],
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPassword()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog_error_login(BuildContext context) {
  // set up the button
  Widget cancelButton = FlatButton(
    child: Text("הירשם",
        style: TextStyle(color: Colors.black, fontFamily: 'Assistant')),
    onPressed: () {
      Navigator.pushNamed(context, RegistrationScreen.id);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("נסה שנית",
        style: TextStyle(color: Colors.black, fontFamily: 'Assistant')),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("נכשל",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
    content: Text("הפרטים שהוזנו אינם נכונים",
        style: new TextStyle(
          fontFamily: 'Assistant',
        )),
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
        color: colour,
        // borderRadius: BorderRadius.circular(30.0),
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
        ),
      ),
    );
  }
}

const kSendButtonTextStyle = TextStyle(
  fontFamily: 'Assistant',
  color: Colors.green,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'הקלד הודעה',
  //todo check if good
  border: InputBorder.none,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.green, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
      //borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 1.0),
    //borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
    //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
