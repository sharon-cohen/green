import 'package:flutter/material.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:greenpeace/global.dart';
import 'package:greenpeace/evants/update_event.dart';
import 'package:greenpeace/globalfunc.dart';
class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);



  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.only(left:0, right: 0, top: 0, bottom: 5.0),
              height: MediaQuery.of(context).size.height / (2.5),
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: getimage(event.type_event),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            Text('ב-'+event.eventDate.toString()),
            Text(event.title, style: Theme.of(context).textTheme.display1,),
            SizedBox(height: 20.0),
            Text(event.description),
            FlatButton(onPressed:(){
              _launchURL(event.whatapp);
            } ,
                child:Image.asset('image/whatsapp.png')),
            Text('הצטרף לקבוצת הwhatsapp שלנו'),
           isMeneger? RaisedButton(
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
            ):null
          ],
        ),
      ),
    );
  }
}
_launchURL(String url) async {
  const url = 'https://chat.whatsapp.com/Eb12U02niq2EEhK290DoiL';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}