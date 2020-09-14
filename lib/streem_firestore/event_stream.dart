import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:greenpeace/evants/event_container.dart';
final _firestore = Firestore.instance;
class event_stream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("events").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          );
        }
        final Events = snapshot.data.documents;
       bool flage=false;
        List<event_container> eventsModel = [];
        for (var event in Events) {
          if(event.data['approve']){
          final title = event.data['title'];
          final description = event.data['description'];
          final eventDate = event.data['event_date'].toDate();
          final approve = event.data['approve'];
          final equipment = event.data['equipment'];
          final sender = event.data['sender'];
          final senderId = event.data['senderId'];
          final location = event.data['location'];
          final type_event = event.data['type_event'];
          final whatapp = event.data['whatapp'];

          final _eventmodel = event_container(
            Event: EventModel(
              title: title,
              description: description,
              eventDate: eventDate,
              approve: approve,
              equipment: equipment,
              sender: sender,
              senderId: senderId,
              location: location,
              type_event: type_event,
              whatapp: whatapp,

            ),


          );
          eventsModel.add(_eventmodel);
          // eventsModel.sort((a, b) => b.eventDate.compareTo(a.eventDate.));
        }
        }
        return
          new Expanded(
            child: new Column(

          children: eventsModel,
        )
          );
      },
    );
  }
}