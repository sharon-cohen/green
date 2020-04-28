import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/test.dart';
import 'welcom.dart';
import 'log_in.dart';
import 'register.dart';
import 'home_menager.dart';
import 'footer.dart';
import 'home.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {

        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
       Home.id: (context) => Home((ModalRoute.of(context).settings.arguments)),
        BottomNavigationBarController.id :(context)=> BottomNavigationBarController((ModalRoute.of(context).settings.arguments)),

      },
    );
  }
}

