import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'welcom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:flutter/services.dart';


import 'global.dart' as globals;

class splash_page extends StatefulWidget {
  static const String id = 'splash_page';
  @override
  _splash_pageState createState() => new _splash_pageState();
}

class _splash_pageState extends State<splash_page> {
//  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//
//  Position _currentPosition;
//  String _currentAddress;
  FirebaseUser currentUser;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();

  }
  _loadCurrentUser()  {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      var document = await Firestore.instance.collection('users').document(user.uid
      ).get();
      setState(() { // call setState to rebuild the view
        currentUser = user;
        globals.UserId=currentUser.uid;
        globals.emailUser=currentUser.email;
        if (user != null) {
          String role=document.data['role'];
          String name=document.data['name'];
          globals.name=name;
          if(role=='menager'){
            globals.isMeneger = true;

          }
        }
        if(user==null){
          globals. no_reg=true;
          globals.name="User";
        }

      });

    }

    );
  }


  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new WelcomeScreen(),
      title: new Text('Welcome Greenpeace"',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
        ),
      ),
      image: new Image.asset("image/green.jpeg"),

      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.red,
    );
  }
}