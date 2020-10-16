import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'welcom.dart';
import 'log_in.dart';
import 'register.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:greenpeace/home/Home.dart';
import 'package:greenpeace/evants/new_event.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  new FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("he", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("he", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales,

      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute:  WelcomeScreen.id,
      routes: {

        "new_event": (_) => newEventPage(),
        WelcomeScreen.id: (context) => WelcomeScreen(analytics: analytics, observer: observer),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        Home.id: (context) => Home((ModalRoute.of(context).settings.arguments),),
        BottomNavigationBarController.id :(context)=> BottomNavigationBarController(2,1),

      },
    );
  }

}