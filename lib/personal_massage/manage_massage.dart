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
final databaseReference = Firestore.instance;
final _firestore = Firestore.instance;

class report extends StatefulWidget {
  report({Key key, this.arguments}) : super(key: key);
  static const String id = " report";
  final ScreenArguments_m arguments;

  @override
  reportState createState() => reportState();
}

class reportState extends State<report> {
  var height_page;
  var width_page;
  final _auth = FirebaseAuth.instance;

  height_width() {
    height_page = MediaQuery
        .of(context)
        .size
        .height;
    width_page = MediaQuery
        .of(context)
        .size
        .width;
  }

  Future<Widget> listOfMass() async {
    if (globals.isMeneger == true) {
      return Container(

        child: SingleChildScrollView(

          child: Column(
            children: <Widget>[
              new Align(
                child: new Text(
                  "דיווחים והודעות מנהל",
                  style: new TextStyle(fontSize: 25, color: Colors.black),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
              messMenager(),
              reportStream(),

              new Align(
                child: new Text(
                  "אירועים",
                  style: new TextStyle(fontSize: 25),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),

              eventStream(),

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
        margin: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Align(
              child: new Text(
                "הודעות",
                style: new TextStyle(fontSize: 25),
              ), //so big text
              alignment: FractionalOffset.topRight,
            ),

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
      bottomNavigationBar: !globals.isMeneger?FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEventPage()));
          }):null,
      body: new FutureBuilder<Widget>(
          future: listOfMass(),
          builder: (BuildContext context, AsyncSnapshot<Widget> text) {
            return new SingleChildScrollView(
              padding: new EdgeInsets.all(8.0),
              child: text.data,
            );
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
              backgroundColor: Colors.lightBlueAccent,
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
  Widget build(BuildContext context){
    return  StreamBuilder<QuerySnapshot>(
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
          final  sender=report.data['sender'];
          final  text=report.data['text'];
          final  time=report.data['time'];
          final  image=report.data['image'];

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
  ReportsContainer(
      {
      this.report,
        this.height_page,
      this.width_page,
     });
  Widget thereport() {

    if (report.image!=null) {
      return Container(
          height: 100,
          width: 100,
          decoration: new BoxDecoration(
              image: new DecorationImage(
            image: new NetworkImage(report.image),
            fit: BoxFit.fill,
          )));
    } else {
      return Text('דיווח חדש', style: TextStyle(color: Colors.black,fontSize: 8),
          overflow: TextOverflow.ellipsis);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        leading: Container(
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Container(
              padding: const EdgeInsets.all(0.0),
              child: Icon(Icons.receipt, color: Colors.black)),
        ),
        title: Text(
         report.sender.toString(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        subtitle: thereport(),
        trailing: FlatButton(
          padding: const EdgeInsets.all(0.0),
          child:
              Container(
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 30.0)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>reportMass(
                            report: report,
                        )));
          },
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
          final sender =event.data["sender"];
          final senderId=event.data["senderId"];
          final equipment=event.data["equipment"];
          final date=event.data["event_date"];
          final location=event.data["location"];
          final type_event=event.data["type_event"];
          final whatapp=event.data['whatapp'];
          if (eventapprove == false) {
            final evenContainer = eventContainer(
              title: eventtitle,
              approve: eventapprove,
              time: date.toDate(),
              dis: eventdis,
              id: event.documentID,
              height_page: height_page,
              width_page: width_page,
              sender: sender,
              equipment: equipment,
              senderId: senderId,
              location:  location,
              type_event: type_event,
                whatapp: whatapp,
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
  final String title;
  final String dis;
  final DateTime time;
  final bool approve;
  final String equipment;
  var id;
  var height_page;
  var width_page;
  final String sender;
  final String senderId;
  final String type_event;
  final String location;
final String whatapp;
  eventContainer(
      {this.approve,
     this.whatapp,
      this.location,
        this.type_event,
        this.equipment,
       this.sender,
        this.senderId,
        this.title,
      this.time,
      this.dis,
      this.height_page,
      this.width_page,
      this.id});
  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: Container(

        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.receipt, color: Colors.black),
      ),
      title: Text(
        this.sender,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(

        children: <Widget>[
          Flexible(
              child: Text('אירוע חדש:'+this.title, style: TextStyle(color: Colors.black,fontSize: 8),)
          ),

        ],
      ),
      trailing: FlatButton(
        child:
        Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 30.0),
        onPressed: () {

            print(this.equipment.runtimeType);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => mass_event(
                    sender: this.sender,
                    topic: this.title,
                    text: this.dis,
                    equipment: this.equipment,
                    eventDate: this.time,
                    senderId: this.senderId,
                    location: this.location,
                    type_event: this.type_event,
                    whatapp:this.whatapp,
                  )));
        },
      ),
    );
  }
}
