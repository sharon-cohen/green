import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/evants/add_event.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/personal_massage/mass_event_page.dart';
import 'package:greenpeace/report/report_model.dart';
import 'package:greenpeace/report/report_mass.dart';
import 'package:greenpeace/personal_massage/personalMessModel.dart';
import 'package:greenpeace/personal_massage/messMenager.dart';
import 'package:greenpeace/HotReport/HotReportStream.dart';
import 'package:greenpeace/MessForAllUser/CreateMessForAllUser.dart';
import 'package:greenpeace/MessForAllUser/ListMessForAllStream.dart';
import 'package:greenpeace/MessToOnePersonFromMenager/choosePerson.dart';
import 'package:greenpeace/evants/event_model.dart';
final databaseReference = Firestore.instance;
final _firestore = Firestore.instance;

class Allmess extends StatefulWidget {
  Allmess({Key key, this.arguments}) : super(key: key);
  static const String id = " report";
  final ScreenArguments_m arguments;

  @override
  AllmessState createState() => AllmessState();
}

class AllmessState extends State<Allmess> {
  var height_page;
  var width_page;
  final _auth = FirebaseAuth.instance;

  height_width() {
    height_page = MediaQuery.of(context).size.height;
    width_page = MediaQuery.of(context).size.width;
  }

  Future<Widget> listOfMass() async {
    if (globals.isMeneger == true) {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // new Align(
              //   child: new Text(
              //     "דיווחים סביבתיים",
              //     style: new TextStyle(fontSize: 25, color: Colors.redAccent),
              //   ), //so big text
              //   alignment: FractionalOffset.topRight,
              // ),
              Row(
                children: [

                  Spacer(),
                  Text(
                    'הודעות',
                    style: TextStyle(
                        fontFamily: 'Assistant',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  Spacer(),
                ],
              ),
              new Align(
                child: new Text(
                  "דיווחים סביבתיים",
                  style: new TextStyle(
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.redAccent),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
              HotStream(),
              // new Align(
              //   child: new Text(
              //     "דיווחים סביבתיים",
              //     style: new TextStyle(
              //         fontFamily: 'Assistant',
              //         fontWeight: FontWeight.bold,
              //         fontSize: 25,
              //         color: Colors.redAccent),
              //   ), //so big text
              //   alignment: FractionalOffset.topRight,
              // ),
              //todo check if good

              new Align(
                child: new Text(
                  "הודעות",
                  style: new TextStyle(
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
              messMenager(),
              AllUserlMassStream(),
              new Align(
                child: new Text(
                  "דיווחי צ'אט",
                  style: new TextStyle(
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
              reportStream(),

              SizedBox(height: 10),
              new Align(
                child: new Text(
                  "אירועים חדשים לאישור",
                  style: new TextStyle(
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
              eventStream(),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    } else {
      final FirebaseUser user = await _auth.currentUser();
      final document =
          await Firestore.instance.collection('users').document(user.uid).get();
      List<String> myMess = List.from(document['personalMessId']);
      return Container(
        margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: <Widget>[
            // Align(
            //   child: new Text(
            //     "הודעות",
            //     style: new TextStyle(fontSize: 25),
            //   ), //so big text
            //   alignment: FractionalOffset.topRight,
            // ),
            Row(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  'הודעות',
                  style: TextStyle(
                      fontFamily: 'Assistant',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                Spacer(),
              ],
            ),
            // SizedBox(height: 10),
            AllUserlMassStream(),
            personalMassStream(
              myMess: myMess,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          automaticallyImplyLeading: false),
      backgroundColor: Colors.grey[200],
      floatingActionButton: !globals.isMeneger
          ? FloatingActionButton(
              backgroundColor: Color(int.parse("0xff6ed000")),
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddEventPage()));
              })
          : FloatingActionButton(
              backgroundColor: Color(int.parse("0xff6ed000")),
              child: Icon(Icons.add),
              onPressed: () {
                showAlertDialogMessManeger(context);
              }),
      body: new FutureBuilder<Widget>(
          future: listOfMass(),
          builder: (BuildContext context, AsyncSnapshot<Widget> text) {
            return globals.isMeneger
                ? SingleChildScrollView(
                    //todo check if ok
                    padding: new EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: text.data,
                  )
                : SingleChildScrollView(
                    //padding: new EdgeInsets.all(8.0),
                    //todo check if ok
                    padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: text.data,
                  );

            ;
          }),
    );
  }
}

class personalMassStream extends StatelessWidget {
  personalMassStream({this.width_page, this.height_page, this.myMess});
  final height_page;
  final width_page;

  final List<String> myMess;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("personalMess").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(int.parse("0xff6ed000")),
            ),
          );
        }
        final reports = snapshot.data.documents;

        List<personalMessContainer> personalsList = [];
        for (var report in reports) {
          if (myMess.contains(report.documentID)) {
            print(report.documentID);
            final messageText = report.data["text"];
            final messageSender = report.data["sender"];
            final time = report.data["time"].toDate();
            final messageSenderId = report.data["senderId"];
            final personalsContainer = personalMessContainer(
              mess: personalMessModel(
                sender: messageSender,
                senderId: messageSenderId,
                time: time,
                text: messageText,
              ),
              height_page: height_page,
              width_page: width_page,
            );
            personalsList.add(personalsContainer);
            //  reports.sort((a, b) => b.time.compareTo(a.time));
          }
        }
        return Column(
          children: personalsList,
        );
      },
    );
  }
}

class reportStream extends StatelessWidget {
  reportStream({this.width_page, this.height_page});
  final height_page;
  final width_page;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("report").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final reports = snapshot.data.documents;

        List<ReportsContainer> reportsContainers = [];
        for (var report in reports) {
          final sender = report.data['sender'];
          final text = report.data['text'];
          final time = report.data['time'];
          final image = report.data['url'];


          //print( reportModel.getReportfromMess(messId).text.toString());
          final reportsContainer = ReportsContainer(
            report: reportModel(
              sender: sender,
              text: text,
              time: time.toDate(),
              image: image,
            ),
            height_page: height_page,
            width_page: width_page,
          );
          reportsContainers.add(reportsContainer);
          //  reports.sort((a, b) => b.time.compareTo(a.time));
        }
        return Column(
          children: reportsContainers,
        );
      },
    );
  }
}

class ReportsContainer extends StatelessWidget {
  final reportModel report;
  var height_page;
  var width_page;
  ReportsContainer({
    this.report,
    this.height_page,
    this.width_page,
  });


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          leading: Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              child: ImageIcon(
                AssetImage("image/feed2.png"),
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            report.sender.toString(),
            style: TextStyle(
                fontFamily: 'Assistant',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),

          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          subtitle: Text(cutTimeString(report.time.toString())),
          trailing: FlatButton(
            padding: const EdgeInsets.all(0.0),
            child: Container(
                width: 1,
                child: Icon(Icons.keyboard_arrow_left,
                    color: Colors.black, size: 30.0)),
            onPressed: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => reportMass(
                            report: report,
                          )));
            },
          ),
        ),
      ),
    );
  }
}

class eventStream extends StatelessWidget {
  eventStream({this.width_page, this.height_page});
  final height_page;
  final width_page;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("events").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final events = snapshot.data.documents;
        List<eventContainer> eventContainers = [];
        for (var event in events) {
          final eventtitle = event.data["title"];
          final eventdis = event.data["description"];
          final eventapprove = event.data["approve"];
          final sender = event.data["sender"];
          final senderId = event.data["senderId"];
          final date = event.data["event_date"];
          final dateCreateEvent = event.data["time"];
          final location = event.data["location"];
          final type_event = event.data["type_event"];
          final whatapp = event.data['whatapp'];
          if (eventapprove == false) {
            final evenContainer = eventContainer(
              event:EventModel(
              title: eventtitle,
              approve: eventapprove,
              eventDate: dateCreateEvent.toDate(),
              time: date.toDate(),

              description: eventdis,


              sender: sender,
              senderId: senderId,
              location: location,
              type_event: type_event,
              whatapp: whatapp,
              ),
            );
            eventContainers.add(evenContainer);
          }

          //  reports.sort((a, b) => b.time.compareTo(a.time));
        }
        return Column(
          children: eventContainers,
        );
      },
    );
  }
}

class eventContainer extends StatelessWidget {
  EventModel event;
  eventContainer(
      {this.event});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: Container(
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: ImageIcon(
              AssetImage("image/feed2.png"),
              color: Colors.black,
            ),
          ),
          title: Text(
            this.event.sender,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Flexible(
                child: Text(cutTimeString(this.event.eventDate.toString())),
              ),
            ],
          ),
          trailing: FlatButton(
            child: Icon(Icons.keyboard_arrow_left,
                color: Colors.black, size: 30.0),
            onPressed: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => mass_event(
                           event:this.event,
                          )));
            },
          ),
        ),
      ),
    );
  }
}

showAlertDialogMessManeger(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "לכולם",
      style: TextStyle(
        fontFamily: 'Assistant',
        color: Colors.black,
      ),
    ),
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SendMessForAllUser()));
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "למשתמש מסוים",
      style: TextStyle(
        fontFamily: 'Assistant',
        color: Colors.black,
      ),
    ),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => userStream()));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "שלח הודעה ל:",
      style: TextStyle(
        fontFamily: 'Assistant',
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      cancelButton,
      continueButton,
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
