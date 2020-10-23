import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:greenpeace/common/Header.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'dart:io';
import 'dart:async';
import 'package:greenpeace/truggel_page/frameWeb.dart';
import 'package:greenpeace/truggel_page/updateStrugle.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:fab_circular_menu/fab_circular_menu.dart';

final _firestore = Firestore.instance;
final databaseReference = Firestore.instance;

class one_struggle extends StatefulWidget {
  final StruggleModel struggle;
  one_struggle({this.struggle});
  @override
  _one_struggleState createState() => _one_struggleState();
}

class _one_struggleState extends State<one_struggle> {
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: globals.isMeneger
          ? FabCircularMenu(
              fabColor: Color(int.parse("0xff6ed000")),
              ringColor: Colors.white70,
              fabMargin: EdgeInsets.all(30),
              children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => updatestrugle(
                                      strugle: widget.struggle,
                                    )));
                      }),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        ToBeSureDeleteAlertDialog(
                            context, widget.struggle.title);
                      }),
                  IconButton(
                    icon: new Image.asset('image/facebook.png'),
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        //facebook appId is mandatory for andorid or else share won't work
                        Platform.isAndroid
                            ? SocialShare.shareFacebookStory(image.path,
                                    "#ffffff", "#000000", "https://google.com",
                                    appId: "975359176210597")
                                .then((data) {
                                print(data);
                              })
                            : SocialShare.shareFacebookStory(image.path,
                                    "#ffffff", "#000000", "https://google.com")
                                .then((data) {
                                print(data);
                              });
                      });
                    },
                  ),
                  IconButton(
                      icon: new Image.asset('image/whatsapp.png'),
                      onPressed: () {
                        print('Favorite');
                      }),
                  IconButton(
                      icon: new Image.asset('image/signature.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FrameWeb(
                                      title: widget.struggle.title,
                                      Url: widget.struggle.petition,
                                    )));
                      }),
                  IconButton(
                      icon: new Image.asset('image/join.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FrameWeb(
                                      title: widget.struggle.title,
                                      Url: widget.struggle.donation,
                                    )));
                      }),
                ])
          : FabCircularMenu(
              fabColor: Color(int.parse("0xff6ed000")),
              ringColor: Colors.white70,
              fabMargin: EdgeInsets.all(30),
              children: <Widget>[
                  IconButton(
                    icon: new Image.asset('image/facebook.png'),
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        //facebook appId is mandatory for andorid or else share won't work
                        Platform.isAndroid
                            ? SocialShare.shareFacebookStory(image.path,
                                    "#ffffff", "#000000", "https://google.com",
                                    appId: "975359176210597")
                                .then((data) {
                                print(data);
                              })
                            : SocialShare.shareFacebookStory(image.path,
                                    "#ffffff", "#000000", "https://google.com")
                                .then((data) {
                                print(data);
                              });
                      });
                    },
                  ),
                  IconButton(
                      icon: new Image.asset('image/whatsapp.png'),
                      onPressed: () {
                        print('Favorite');
                      }),
                  IconButton(
                      icon: new Image.asset('image/signature.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FrameWeb(
                                      title: widget.struggle.title,
                                      Url: widget.struggle.petition,
                                    )));
                      }),
                  IconButton(
                      icon: new Image.asset('image/join.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FrameWeb(
                                      title: widget.struggle.title,
                                      Url: widget.struggle.donation,
                                    )));
                      }),
                ]),
      body: screenShotStrugle(
        struggle: widget.struggle,
        screenshotController: screenshotController,
      ),
    );
  }
}

class screenShotStrugle extends StatefulWidget {
  final StruggleModel struggle;
  final ScreenshotController screenshotController;
  screenShotStrugle({this.struggle, this.screenshotController});
  @override
  _screenShotStrugle createState() => _screenShotStrugle();
}

class _screenShotStrugle extends State<screenShotStrugle> {
  FirebaseUser currentUser;

  double offset = 0;
  String _platformVersion = 'Unknown';
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  String _colorName = 'No';
  Color _color = Colors.black;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: widget.screenshotController,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyHeader(
              image: widget.struggle.image,
              page: "struggle",
              offset: offset,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Align(
                child: new Text(
                  widget.struggle.title,
                  style: new TextStyle(
                      fontSize: 30,
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                child: new Text(
                  widget.struggle.description,
                  style: new TextStyle(fontSize: 20),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
            ),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}

ToBeSureDeleteAlertDialog(BuildContext context, String nameStruggle) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("בטוח"),
    onPressed: () async {
      String idstruggle = await GetStrugle(nameStruggle);
      await _firestore.collection("struggle").document(idstruggle).delete();
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
  Widget Later = FlatButton(
    child: Text("בטל"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: FittedBox(child: Text("אתה בטוח רוצה למחוק את המאבק?")),
    actions: [
      okButton,
      Later,
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
