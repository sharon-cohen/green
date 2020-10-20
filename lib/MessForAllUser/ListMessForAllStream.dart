import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/personal_massage/personalMessModel.dart';
import 'package:greenpeace/personal_massage/messMenager.dart';

final _firestore = Firestore.instance;
class AllUserlMassStream extends StatelessWidget {
  AllUserlMassStream({this.width_page, this.height_page,this.myMessdeleted});
  final height_page;
  final width_page;
  final List<String> myMessdeleted;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("MessForAll").snapshots(),
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
          if (!myMessdeleted.contains(report.documentID)){
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
            MessForAll:true,
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