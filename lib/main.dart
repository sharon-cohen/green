import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/personal_massage/manage_massage.dart';
import 'welcom.dart';
import 'log_in.dart';
import 'register.dart';
import 'package:greenpeace/evants/list_event.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:greenpeace/evants/new_event.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("he", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("he", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales,


      initialRoute:  WelcomeScreen.id,
      routes: {

        "new_event": (_) => newEventPage(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        Allmess.id:(context) =>BottomNavigationBarController(4,4),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        List_event.id :(context)=> BottomNavigationBarController(3,1),
        BottomNavigationBarController.id :(context)=> BottomNavigationBarController(2,1),
        All_truggle.id :(context)=> BottomNavigationBarController(0,1),

      },
    );
  }

}