
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
 List<Widget> button_in=[];
  final _auth = FirebaseAuth.instance;
  bool no_reg=false;
  AnimationController controller;
  Animation animation;
  List<Widget> log_in(){
button_in.clear();
    if(no_reg==true){
      button_in.add(RoundedButton(
        title: 'Log In',
        colour: Colors.lightBlueAccent,
        onPressed: () {
          //Navigator.pushNamed(context,profile.id);
          Navigator.pushNamed(context, LoginScreen.id);
        },
      ),);
      button_in.add(   RoundedButton(
          title: 'Register',
          colour: Colors.blueAccent,
          onPressed: () {

            Navigator.pushNamed(context, RegistrationScreen.id);
          }
      ),);
      button_in.add( RoundedButton(
         title: 'היכנס מבלי להירשם',
         colour: Colors.blueAccent,
         onPressed: () {
           Navigator.pushNamed(context,BottomNavigationBarController.id,arguments:ScreenArguments_m(
               'd','no_register','no_register'
           ));
         }
     ),);
      return button_in;
}
    else{
      button_in.add(RoundedButton(
        title: 'Log In',
        colour: Colors.lightBlueAccent,
        onPressed: () {
          //Navigator.pushNamed(context,profile.id);
          Navigator.pushNamed(context, LoginScreen.id);
        },
      ),);
      button_in.add(   RoundedButton(
      title:  loggedInUser.email+ ' היכנס בתור ',
      colour: Colors.lightBlueAccent,
      onPressed: () {
        //Navigator.pushNamed(context,profile.id);
        Navigator.pushNamed(context,BottomNavigationBarController.id,arguments:ScreenArguments_m(
            's','sharon','menager'
        ));
      },
    ),);
      return button_in;
}
  }

  @override
  void initState() {

    super.initState();
    getCurrentUser();




  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  void getCurrentUser() async {

    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
      var document = await Firestore.instance.collection('users').document(loggedInUser.uid
      ).get();
      String role=document.data['role'];
      if(role=='menager'){
        globals.isMeneger = true;

      }
    }
    if(user==null){
      no_reg=true;

    }


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
           log_in(),
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
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
