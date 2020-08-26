import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EventModel extends DatabaseItem{
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String equipment;
  final String sender;
  final String senderId;
  final String location;
  final String type_event;
  bool approve;
  EventModel({this.id,this.title, this.description, this.eventDate,this.approve,
    this.equipment,this.senderId,this.sender,this.location,this.type_event,
  }):super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(

      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'].toDate(),
      approve: data['approve'],
      equipment: data['equipment'],
      sender: data['sender'],
      senderId: data['senderId'],
      location: data['location'],
      type_event: data['type_event'],
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'].toDate(),
      approve: data['approve'],
      equipment: data['equipment'],
      sender: data['sender'],
      senderId: data['senderId'],
      location: data['location'],
      type_event: data['type_event'],
    );
  }

  Map<String,dynamic> toMap() {


    return {
      "title":title,
      "description": description,
      "event_date":eventDate,
      "id":id,
      "approve":approve,
        "equipment":equipment,
        "sender":sender,
      "senderId":senderId,
      "type_event":type_event,
      "location":location,
    };
  }
}



