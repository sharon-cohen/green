import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:greenpeace/common/Header.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'dart:io';
import 'dart:async';
import 'package:greenpeace/truggel_page/frameWeb.dart';
import 'package:greenpeace/truggel_page/updateStrugle.dart';
import 'package:greenpeace/global.dart' as globals;
final databaseReference = Firestore.instance;


class one_struggle extends StatefulWidget {
  final StruggleModel struggle;
  one_struggle({this.struggle});
  @override
  _one_struggle createState() => _one_struggle();
}

class _one_struggle extends State<one_struggle> {
  FirebaseUser currentUser;
  ScreenshotController screenshotController = ScreenshotController();
  double offset=0;
  String _platformVersion = 'Unknown';
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
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
          controller: screenshotController,
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: globals.isMeneger?FloatingActionButton(
              heroTag:2,
              backgroundColor: Colors.red,

              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => updatestrugle(strugle: widget.struggle,)));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.edit), // icon

                ],
              ),
            ):null,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  MyHeader(
                    image: widget.struggle.image,
                    page:"struggle",
                    offset: offset,
                  ),

                        new Align(
                          child: new Text(
                            widget.struggle.title,
                            style: new TextStyle(fontSize: 30),
                          ), //so big text
                          alignment: FractionalOffset.topRight,
                        ),


                           Align(
                            child: new Text(
                              widget.struggle.description,
                              style: new TextStyle(fontSize: 20),
                            ), //so big text
                            alignment: FractionalOffset.topRight,
                          ),







                  RaisedButton(
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        //facebook appId is mandatory for andorid or else share won't work
                        Platform.isAndroid
                            ?

                        SocialShare.shareFacebookStory(image.path,
                            "#ffffff", "#000000", "https://google.com",
                            appId: "9753591s76210597")
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
                    child: Text("Share On Facebook Story"),
                  ),

                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FrameWeb(title: widget.struggle.title,Url: widget.struggle.donation,)));
                    },
                    child: Text("הצטרף אלינו למאבק"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FrameWeb(title: widget.struggle.title,Url: widget.struggle.petition,)));
                    },
                    child: Text("חתימה על עצומה"),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        SocialShare.shareOptions("Hello world").then((data) {
                          print(data);
                        });
                      });
                    },
                    child: Text("Share Options"),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      SocialShare.shareWhatsapp(
                          "Hello World \n https://google.com")
                          .then((data) {
                        print(data);
                      });
                    },
                    child: Text("Share on Whatsapp"),
                  ),

                ],
              ),
            ),
          ),


    );
  }
}


_launchURL(String url) async {

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}