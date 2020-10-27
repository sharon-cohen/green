import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/home/home_menager.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/personal_massage/manage_massage.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
import 'package:greenpeace/evants/calender.dart';
import 'package:greenpeace/evants/list_event.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:greenpeace/truggel_page/frameWeb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/welcom.dart';
import 'package:greenpeace/HotReport/hotReport.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Color(int.parse("0xff6ed000")),
                          Colors.white
                        ])),
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage("image/petition1.png"),
                              radius: 50.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              globals.name,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Text(
                        //   "Username :",
                        //   style: TextStyle(
                        //       color: Colors.redAccent,
                        //       fontStyle: FontStyle.normal,
                        //       fontSize: 28.0),
                        // ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "דואר אלקטרוני:",
                          //TODO ADD EMAIL
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Assistant',
                              fontSize: 28.0),
                        ),
                        Text(
                          globals.emailUser,
                          //TODO ADD EMAIL
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Assistant',
                              fontSize: 28.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  //width: 600.00,
                  height: 80,
                  child: RaisedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    },
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(80.0)),
                    elevation: 0.0,
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Color(int.parse("0xff6ed000")),
                              Colors.lightGreen
                            ]),
                        //borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Expanded(
                        child: Container(
                          // constraints:
                          //     BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "התנתק",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
