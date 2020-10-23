import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/home/about.dart';
import 'package:greenpeace/streem_firestore/MessagesStream.dart';
import 'package:greenpeace/home/send_mass_button.dart';
import 'package:greenpeace/streem_firestore/StruggleStream.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/common/Header.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/feed.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Home_menager extends StatefulWidget {
  Home_menager({Key key, this.arguments}) : super(key: key);
  static const String id = " home_menager";
  final ScreenArguments_m arguments;
  @override
  Home_menagerState createState() => Home_menagerState();
}

class Home_menagerState extends State<Home_menager> {
  final _auth = FirebaseAuth.instance;
  TextEditingController aboutController;
  bool ok = false;
  bool showSpinner = false;
  double offset = 0;
  bool no_reg = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      aboutController = new TextEditingController();
    });
    getCurrentUser();
  }

  Future<Widget> listOfMass() async {
    return Container(
      child: SingleChildScrollView(child: TruggleStream(page_call: 'home')),
    );
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
    if (user == null) {
      no_reg = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Corrected size W is ${(MediaQuery.of(context).size.width)}");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        scrollDirection: Axis.vertical,
        children: ListTile.divideTiles(context: context, tiles: [
          MyHeader(
            image: "image/green.jpeg",
            offset: offset,
          ),
          Card(
            margin: new EdgeInsets.only(
                left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
            //margin: new EdgeInsets.only(top: 8.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          child: Row(
                            children: <Widget>[
                              FlatButton(
                                child: Container(
                                  child: Text(
                                    "המאבקים שלנו",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Assistant',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => All_truggle()));
                                },
                              ),
                              Spacer(),
                              globals.isMeneger
                                  ? FlatButton(
                                      padding: EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          MediaQuery.of(context).size.width /
                                              2.15,
                                          0),

                                      child: Icon(Icons.add),
                                      // child: Text("מאבק חדש",
                                      //     style: TextStyle(
                                      //         fontSize: 20,
                                      //         color: Colors.green.shade900)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    create_struggle1()));
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Positioned(
                          //top: 31,
                          top: MediaQuery.of(context).size.width / 12.3,
                          right: MediaQuery.of(context).size.width / 13 / 2,
                          child: Text(
                            'בואו נשנה את העולם',
                            style: TextStyle(
                              fontFamily: 'Assistant',
                            ),
                          ),
                        ),
                      ],
                    ),
                    new FutureBuilder<Widget>(
                      future: listOfMass(),
                      builder:
                          (BuildContext context, AsyncSnapshot<Widget> text) {
                        return new SingleChildScrollView(
                          padding: new EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: text.data,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: new EdgeInsets.only(
                left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          //  height: MediaQuery.of(context).size.height / 18,
                          child: Row(
                            children: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Feed()));
                                },
                                child: Text(
                                  "עדכונים",
                                  style: TextStyle(
                                      fontFamily: 'Assistant',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Spacer(),
                              ImageIcon(
                                AssetImage("image/feed1.png"),
                                color: Colors.black,
                                // color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.width / 12.3,
                          right: MediaQuery.of(context).size.width / 13 / 2,
                          child: Text(
                            'דואגים שתהיו מעודכנים',
                            style: TextStyle(
                              fontFamily: 'Assistant',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(child: MessagesStream()),
                    Container(
                      decoration: kMessageContainerDecoration,
                      child: button_send(
                        no_reg: no_reg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: new EdgeInsets.only(
                left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.3,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'אודות גירנפיס',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Assistant',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        globals.isMeneger
                            ? IconButton(
                                icon: new Icon(Icons.edit),
                                onPressed: () async {
                                  showDialog(
                                      child: new Dialog(
                                        child: Container(
                                          width: 100,
                                          height: 270,
                                          child: new Column(
                                            children: <Widget>[
                                              new TextField(
                                                maxLines:
                                                    (MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            60)
                                                        .round(),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: new InputDecoration(
                                                    hintText:
                                                        "מה תרצה שיהיה כתוב באודות?",
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            10, 10, 10, 0)),
                                                controller: aboutController,
                                              ),
                                              // Spacer(),
                                              Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Spacer(),
                                                  new FlatButton(
                                                    child: new Text("שמור"),
                                                    onPressed: () async {
                                                      await Firestore.instance
                                                          .collection('about')
                                                          .document(
                                                              'sYFhYhmjY5zyzL3Rowcg')
                                                          .updateData({
                                                        "text": aboutController
                                                            .text,
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  Spacer(),
                                                  new FlatButton(
                                                    child: new Text("בטל"),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                  ),
                                                  Spacer(),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      context: context);
                                },
                              )
                            : Container(),
                      ],
                    ),
                    About(),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageIcon(
                        AssetImage("image/petition1.png"),
                        color: Colors.black,
                        size: 50,
                        // color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]).toList(),
      ),
    );
  }
}
