import 'package:flutter/material.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:greenpeace/global.dart';
import 'package:greenpeace/evants/update_event.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/common/Header.dart';
import 'package:intl/intl.dart';
final _firestore = Firestore.instance;

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);



  @override
  Widget build(BuildContext context){
    double offset=0;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return Scaffold(

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              page:"event",
              image: getimageString(event.type_event),
              offset: offset,
            ),

            Text('ב-'+" ${dateFormat.format(event.eventDate)}"),
            Text(event.title, style: Theme.of(context).textTheme.display1,),
            SizedBox(height: 20.0),
            Text(event.description),
            FlatButton(onPressed:(){
              _launchURL(event.whatapp);
            } ,
                child:Image.asset('image/whatsapp.png')),
            Text('הצטרף לקבוצת הwhatsapp שלנו'),
           isMeneger? Row(
             children: [
               RaisedButton(
                  onPressed: () async {
                   String  idevent = await Getevent(event.title);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>updateEventPage(
                              sender:event.sender,
                              topic: event.title,
                              text: event.description,
                              equipment: event.equipment,
                              eventDate: event.eventDate,
                              senderId: event.senderId,
                              location: event.location,
                              type_event: event.type_event,
                              dataid: idevent,
                            )));
                  },
                  child: const Text('עריכת אירוע',
                      style: TextStyle(fontSize: 20)),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
               RaisedButton(
                 onPressed: () async {
                   String  idevent = await Getevent(event.title);
                   _firestore.collection("events").document(idevent).delete();
                   Navigator.pop(context, true);
                 },
                 child: const Text('מחיקת אירוע',
                     style: TextStyle(fontSize: 20)),
                 color: Colors.blue,
                 textColor: Colors.white,
               ),
             ],
           ):null
          ],
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