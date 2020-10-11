import 'package:flutter/material.dart';
import 'log_in.dart';
import 'register.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'globalfunc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'global.dart' as globals;

FirebaseUser loggedInUser;

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  FirebaseUser currentUser;
  List<Widget> button_in = [];
  final _auth = FirebaseAuth.instance;
  bool no_reg = false;
  AnimationController controller;
  Animation animation;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentUser();
      setState(() {
        isLoading = true;
      });
    });
  }

  _loadCurrentUser() async {
    FirebaseAuth.instance.currentUser().then((firebaseUser) async {
      if (firebaseUser == null) {
        globals.name = "User";
        globals.no_reg = true;
        globals.emailUser = "";
        globals.isMeneger = false;
        globals.UserId = "";

        button_in.add(
          RoundedButton(
            title: 'התחבר',
            colour: Colors.white,
            onPressed: () {
              globals.no_reg = false;
              //Navigator.pushNamed(context,profile.id);
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
        );
        button_in.add(
          RoundedButton(
              title: 'הרשם',
              colour: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              }),
        );
        button_in.add(
          RoundedButton(
              title: 'היכנס מבלי להירשם',
              colour: Colors.white,
              onPressed: () {
                globals.no_reg = true;
                Navigator.pushNamed(context, BottomNavigationBarController.id,
                    arguments:
                        ScreenArguments_m('d', 'no_register', 'no_register'));
              }),
        );
        button_in.add(
          Container(
            height: 80,
          ),
        );
        // button_in.add(
        //   SizedBox(height: 150),
        // );
      } else {
        print("sharon");
        var document = await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .get();
        globals.UserId = firebaseUser.uid;
        globals.emailUser = firebaseUser.email;
        String role = document.data['role'];
        String name = document.data['name'];
        globals.name = name;
        globals.no_reg = false;
        if (role == 'menager') {
          globals.isMeneger = true;
        } else {
          globals.isMeneger = false;
        }
        setState(() {
          button_in.add(
            RoundedButton(
              title: 'התחבר',
              colour: Colors.white,
              onPressed: () {
                globals.no_reg = false;
                //Navigator.pushNamed(context,profile.id);
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          );
          button_in.add(
            RoundedButton(
              title: 'התחברות מהירה- ' + globals.name,
              colour: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, BottomNavigationBarController.id,
                    arguments: ScreenArguments_m('s', 'sharon', 'menager'));
              },
            ),
          );
          button_in.add(
            RoundedButton(
                title: 'היכנס מבלי להירשם',
                colour: Colors.white,
                onPressed: () {
                  globals.no_reg = true;
                  Navigator.pushNamed(context, BottomNavigationBarController.id,
                      arguments:
                          ScreenArguments_m('d', 'no_register', 'no_register'));
                }),
          );
          button_in.add(
            Container(
              height: 80,
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('image/connect3.png', fit: BoxFit.fill),
            !isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: button_in,
                    ),
                  ),
          ],
        ),
      ),
    );
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
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        // borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Assistant',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              // color: Colors.green,
              color: Color(int.parse("0xff6ed000")),
            ),
          ),
        ),
      ),
    );
  }
}
