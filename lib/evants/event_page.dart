import 'package:auto_size_text/auto_size_text.dart';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:greenpeace/global.dart';
import 'package:greenpeace/evants/update_event.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/common/Header.dart';
import 'package:greenpeace/GoogleMap.dart';
import 'package:greenpeace/global.dart' as globals;
import 'list_event.dart';

final _firestore = Firestore.instance;
class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, @required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

      body: Container(
        color: Colors.grey.shade200,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.vertical,

          child: Container(
            color: Colors.grey.shade200,
            child: Column(
              children: <Widget>[
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    MyHeader(
                      page: "event",
                      image: getimageString(event.type_event),
                      offset: 0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:  MediaQuery.of(context).size.height/4),
                      child: B(event: event,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/1.7),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        margin: EdgeInsets.all(14),
                        child: AutoSizeText(
                          event.description,
                          style: TextStyle(fontFamily: 'Assistant', fontSize:20,
                            // color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class B extends StatelessWidget {
  final EventModel event;
  const  B ({Key key, @required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/3,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        event.title,
                        // style: Theme.of(context).textTheme.display1,
                        style: TextStyle(
                          fontFamily: 'Assistant',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                DayConvert(event.eventDate.weekday.toString()) +
                                    " " +
                                    event.eventDate.day.toString() +
                                    monthConvert(event.eventDate.month.toString()),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Assistant',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Expanded(
                          child: Center(
                              child: AutoSizeText(event.eventDate.hour.toString()+":"+event.eventDate.minute.toString(),
                                style: TextStyle(fontSize: 14),maxLines: 2,)),
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),


          Expanded(
            flex: 10,
            child: Container(


              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex:3,
                            child: Container(

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF3F3FE),
                              ),
                              child: FlatButton(
                                onPressed: (){
                                  launchMap(event.location);
                                },
                                child: Image.asset(
                                  'image/google-maps.png',
                                  scale: 12,
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                              child: Center(
                                  child: AutoSizeText(event.location,
                                      style: TextStyle(fontSize: 14),maxLines: 2,)),
                            ),

                        ],
                      ),
                    ),
                  ),

                  event.whatapp!=""?  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                           Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffEEFBFA),
                              ),
                              child: FlatButton(
                                onPressed: (){
                                  _launchURL(event.whatapp);
                                },
                                child: Image.asset(
                                  'image/whatsapp2.png',
                                  scale: 110,
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                                child: AutoSizeText( ' קבוצת הwhatsapp שלנו ',
                                  style: TextStyle(fontSize: 14),maxLines: 2,)),
                          ),

                        ],
                      ),
                    ),
                  ):Container(),

                ],
              ),
            ),
          ),
          Spacer(),
          globals.isMeneger? Expanded(
            flex:4,
            child: Container(
              child: Row(
                children: [
                  Spacer(),
                  CircleAvatar(
                    backgroundColor:  Color(int.parse("0xff6ed000")),
                    radius: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () async {
                        String idevent = await Getevent(event.title);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => updateEventPage(
                                  event: this.event,
                                  cameFrom: "event",
                                )));
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(int.parse("0xff6ed000")),
                    radius: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () {
                        ToBeSureDeleteAlertDialogEvent(
                            context, event.title);
                      },

                    ),
                  ),
                ],
              ),
            ),
          ):Container(),
        ],
      ),
    );
  }
}

class CurveShape extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

ToBeSureDeleteAlertDialogEvent(BuildContext context, String eventTitle) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("מחק",
        style: TextStyle(
          fontFamily: 'Assistant',
        )),
    onPressed: () async {
      String idevent = await Getevent(eventTitle);
      await _firestore.collection("events").document(idevent).delete();
      Navigator.pushNamed(
        context,
        List_event.id,
      );
    },
  );
  Widget Later = FlatButton(
    child: Text("בטל",
        style: TextStyle(
          fontFamily: 'Assistant',
        )),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: FittedBox(
        child: Text("האם ברצונך למחוק את האירוע זה?",
            style: TextStyle(
              fontFamily: 'Assistant',
            ))),
    actions: [
      okButton,
      Later,
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