import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/HotReport/HotReportModel.dart';
import 'package:greenpeace/HotReport/HotReportMass.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/personal_massage/TextContainerListMess.dart';
final _firestore = Firestore.instance;

class HotStream extends StatelessWidget {
  HotStream({this.width_page, this.height_page});
  final height_page;
  final width_page;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("hotReport").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final reports = snapshot.data.documents;

        List<HotContainer> reportsContainers = [];
        for (var report in reports) {
          final sender = report.data['sender'];
          final text = report.data['text'];
          final time = report.data['time'];
          final image = report.data['url_image'];
          final location = report.data['location'];
          final senderId = report.data['senderId'];

          //print( reportModel.getReportfromMess(messId).text.toString());
          final reportsContainer = HotContainer(
            report: HotModel(
              sender: sender,
              text: text,
              time: time.toDate(),
              image: image,
              senderId: senderId,
              location: location,

            ),
            height_page: height_page,
            width_page: width_page,
          );
          reportsContainers.add(reportsContainer);
          reportsContainers.sort((a, b) => b.report.time.compareTo(a.report.time));
        }
        return Column(
          children: reportsContainers,
        );
      },
    );
  }
}

class HotContainer extends StatelessWidget {
  final HotModel report;
  var height_page;
  var width_page;
  HotContainer({
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
          title: FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HotMass(
                        report: report,
                      )));
            },
            padding: EdgeInsets.all(0),
            child: TextStyleMess(
              text: report.sender,
              size: 20,
              sizeHeight: MediaQuery.of(context).size.height / 30,
              sizeWidth: MediaQuery.of(context).size.width,
            ),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          subtitle: TextStyleMess(
            text: DayConvert(report.time.weekday.toString()) +
                " " +
                report.time.day.toString() +
                monthConvert(report.time.month.toString())+yearConvert(report.time.year.toString()),
            size: 15,
            sizeHeight: MediaQuery.of(context).size.height / 35,
            sizeWidth: MediaQuery.of(context).size.width,
          ),
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
                      builder: (context) => HotMass(
                            report: report,
                          )));
            },
          ),
        ),
      ),
    );
  }
}
