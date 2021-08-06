import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:greenpeace/common/Header.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'dart:io';
import 'dart:async';
import 'package:greenpeace/truggel_page/frameWeb.dart';
import 'package:greenpeace/truggel_page/updateStrugle.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:greenpeace/paragraphStruggleDescription.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/globalfunc.dart';

final _firestore = Firestore.instance;
final databaseReference = Firestore.instance;

class one_struggle extends StatefulWidget {
  StruggleModel struggle;
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
              fabOpenIcon: Icon(Icons.menu, color: Colors.white),
              fabCloseIcon: Icon(Icons.close, color: Colors.white),
              fabMargin: EdgeInsets.only(
                right: 40,
                bottom: 20,
              ),
              children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => create_struggle1(
                                    gotStruggle: widget.struggle,
                                  )));
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/edit2.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {

                            return MyDialog(nameStruggle: widget.struggle.title);
                          });
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/del2.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
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
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/fb.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        SocialShare.shareWhatsapp(widget.struggle.share);
                      });
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/whatsapp.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FrameWeb(
                                    fromFooter: false,
                                    title: widget.struggle.title,
                                    Url: widget.struggle.petition,
                                  )));
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/su.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FrameWeb(
                                    fromFooter: false,
                                    title: widget.struggle.title,
                                    Url: widget.struggle.donation,
                                  )));
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/donation.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                ])
          : FabCircularMenu(
              fabColor: Color(int.parse("0xff6ed000")),
              ringColor: Colors.white70,
              fabOpenIcon: Icon(Icons.menu, color: Colors.white),
              fabCloseIcon: Icon(Icons.close, color: Colors.white),
              fabMargin: EdgeInsets.only(
                right: 40,
                bottom: 20,
              ),
              children: <Widget>[
                  RawMaterialButton(
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
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/fb.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        SocialShare.shareWhatsapp(widget.struggle.share);
                      });
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/whatsapp.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FrameWeb(
                                    fromFooter: false,
                                    title: widget.struggle.title,
                                    Url: widget.struggle.petition,
                                  )));
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/su.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FrameWeb(
                                    fromFooter: false,
                                    title: widget.struggle.title,
                                    Url: widget.struggle.donation,
                                  )));
                    },
                    elevation: 2.0,
                    fillColor: Color(int.parse("0xff6ed000")),
                    child: new Image.asset(
                      'image/donation.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.all(8),
                    shape: CircleBorder(),
                  ),
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
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
                  padding: const EdgeInsets.all(12),
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
                  padding: const EdgeInsets.all(12),
                  child: Container(
                      child: new paragraphStruggleDescription(
                          widget.struggle.description1,
                          widget.struggle.image1)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                      child: new paragraphStruggleDescription(
                          widget.struggle.description2,
                          widget.struggle.image2)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                      child: new paragraphStruggleDescription(
                          widget.struggle.description3,
                          widget.struggle.image3)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                      child: new paragraphStruggleDescription(
                          widget.struggle.description4,
                          widget.struggle.image4)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                      child: new paragraphStruggleDescription(
                          widget.struggle.description5,
                          widget.struggle.image5)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 8,

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ToBeSureDeleteAlertDialog(BuildContext context, String nameStruggle) {
  // set up the button
  bool isLoading = false;
  int sumStruggle = 0;
  Future UpdatePriorety() async {
    int priorety = 0;
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("struggle").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == "sumStruggle") {
        sumStruggle = priorety = querySnapshot.documents[i].data["sum"];
      } else {
        if (querySnapshot.documents[i].documentID != "render") {
          if (querySnapshot.documents[i].data["title"] == nameStruggle) {
            priorety = querySnapshot.documents[i].data["title"];
          }
        }
      }
    }
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].data["title"] != nameStruggle &&
          querySnapshot.documents[i].documentID != "render") {
        if (querySnapshot.documents[i].documentID == "sumStruggle") {
        } else {
          if (querySnapshot.documents[i].data["place"] > priorety) {
            await updatePlaceStruggleDB(querySnapshot.documents[i].documentID,
                querySnapshot.documents[i].data["place"] - 1);
          }
        }
      }
    }
    await Firestore.instance
        .collection("struggle")
        .document("sumStruggle")
        .updateData({'sum': sumStruggle - 1});
  }

  Widget okButton = FlatButton(
    child: Text("מחק"),
    onPressed: () async {
      isLoading = true;
      String idstruggle = await GetStrugle(nameStruggle);
      await UpdatePriorety();
      await _firestore.collection("struggle").document(idstruggle).delete();
      isLoading = false;
      Navigator.pushNamed(context, BottomNavigationBarController.id);
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
    title: FittedBox(child: Text("האם ברצונך למחוק את המאבק?")),
    actions: [
      CircularProgressIndicator(),
      okButton,
      Later,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return isLoading ? Center(child: CircularProgressIndicator()) : alert;
    },
  );
}

class MyDialog extends StatefulWidget {
  String nameStruggle;
  MyDialog({this.nameStruggle});
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool isLoading = false;
  int sumStruggle = 0;
  Future UpdatePriorety() async {
    int priorety = 0;
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("struggle").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == "sumStruggle") {
        sumStruggle = querySnapshot.documents[i].data["sum"];
      } else {
        if (querySnapshot.documents[i].documentID != "render") {
          if (querySnapshot.documents[i].data["title"] == widget.nameStruggle) {
            priorety = querySnapshot.documents[i].data["place"];
          }
        }
      }
    }
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != "render" && querySnapshot.documents[i].documentID != "sumStruggle") {
        print("pri");
        print(priorety);
        print(querySnapshot.documents[i].data["place"]);
        if(querySnapshot.documents[i].data["place"]>priorety ){
          print("place");
          print(querySnapshot.documents[i].data["place"]);

          await updatePlaceStruggleDB(querySnapshot.documents[i].documentID,
              querySnapshot.documents[i].data["place"] - 1);
        }

      }
    }
    await Firestore.instance
        .collection("struggle")
        .document("sumStruggle")
        .updateData({'sum': sumStruggle - 1});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: FittedBox(child: Text("האם ברצונך למחוק את המאבק?")),
      actions: <Widget>[
        FlatButton(
          child: Text("מחק"),
          onPressed: () async {
            setState(() {
              isLoading = true;

            });
            print("test delete");
            String idstruggle = await GetStrugle(widget.nameStruggle);
            await UpdatePriorety();
            await _firestore
                .collection("struggle")
                .document(idstruggle)
                .delete();

            setState(() {
              isLoading = false;
            });
            Navigator.pushNamed(context, BottomNavigationBarController.id);
          },
        ),
        FlatButton(
          child: Text("בטל"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
       isLoading? CircularProgressIndicator():Container(),
      ],
    );
  }
}
