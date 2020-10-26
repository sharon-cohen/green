import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'event_model.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:flutter/material.dart';
import 'event_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:greenpeace/GetID_DB/getid.dart';

class updateEventPage extends StatefulWidget {
  EventModel event;

  updateEventPage({this.event});

  @override
  _updateEventPage createState() => _updateEventPage();
}

class _updateEventPage extends State<updateEventPage> {
  FirebaseUser currentUser;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _location;
  TextEditingController _whatapp;
  Data data = Data(
    dropdownValue: '',
  );

  var tmpArray = [];

  DateTime _eventDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  List<String> equipmentList = [];
  bool processing;
  String temp = "";
  String chooseType;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    chooseType = widget.event.type_event;
    _title = TextEditingController(
        text: widget.event != null ? widget.event.title : "");
    _description = TextEditingController(
        text: widget.event != null ? widget.event.description : "");
    _location = TextEditingController(
        text: widget.event != null ? widget.event.location : "");
    processing = false;
    _whatapp = TextEditingController(
        text: widget.event != null ? widget.event.location : "");
    _title = TextEditingController(text: widget.event.title);
    _description = TextEditingController(text: widget.event.description);
    _location = TextEditingController(text: widget.event.location);
    _whatapp = TextEditingController(
        text: 'https://chat.whatsapp.com/Eb12U02niq2EEhK290DoiL');
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          automaticallyImplyLeading: false),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: new Align(
                  child: new Text(
                    "עריכת אירוע",
                    style: TextStyle(
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      // color: Colors.green,
                    ),
                  ), //so big text
                  alignment: FractionalOffset.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה נושא הבעיה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                    labelText: "נושא האירוע:",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(10)
                        ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה תיאור הבעיה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "תיאור הבעיה",
                      border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10),
                          )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _whatapp,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "קישור לקבוצת Whatapp",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(10)
                          )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _location,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה המיקום חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "מיקום",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          //      borderRadius: BorderRadius.circular(10)
                          )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: new Text(
                  "סוג האירוע",
                  style: new TextStyle(
                    fontSize: 25,
                    fontFamily: 'Assistant',
                  ),
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3.4,
                      width: MediaQuery.of(context).size.height / 2.5,
                      child: Column(children: <Widget>[
                        Expanded(
                          child: RadioButtonGroup(
                            picked: chooseType,
                            labels: ["הפגנה", "ניקיון", "הרצאה", "אחר"],
                            onChange: (String label, int index) {
                              print("label: $label index: $index");
                              setState(() {
                                chooseType = label;
                              });
                              //type_event=label;
                            },
                            onSelected: (String label) => print(label),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text(
                  "בחר תאריך",
                  style: new TextStyle(
                    fontSize: 25,
                    fontFamily: 'Assistant',
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: widget.event.title != ""
                      ? Text(
                          "${widget.event.eventDate.year} - ${widget.event.eventDate.month} - ${widget.event.eventDate.day}")
                      : Text(
                          "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                ),
                onTap: () async {
                  print(this.data.dropdownValue);
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: widget.event.title == ""
                          ? _eventDate
                          : widget.event.eventDate,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      widget.event.eventDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Material(
                        elevation: 5.0,
                        //borderRadius: BorderRadius.circular(30.0),
                        // Color(int.parse("0xff6ed000")),
                        color: Color(int.parse("0xff6ed000")),
                        child: MaterialButton(
                          onPressed: () async {
                            bool CreateEventIsManeger=false;//init value
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              String IdEvent =
                                  await Getevent(widget.event.title);
                              await eventDBS.updateData(IdEvent, {
                                "title": _title.text,
                                "description": _description.text,
                                "event_date": widget.event.eventDate,
                                "location": _location.text,
                                "type_event": chooseType,
                                "whatapp": _whatapp.text,
                              });

                               CreateEventIsManeger= await TypeManegeRoleuser(widget.event.senderId);
                              if(CreateEventIsManeger==false) {
                                DocumentReference documentReference =
                                Firestore.instance.collection("personalMess")
                                    .document();
                                await documentReference.setData({
                                  "text": widget.event.title + 'האירוע שיצרת-' +
                                      'בוצע עדכון על ידי המנהלים',
                                  "sender": globals.name,
                                  "time": DateTime.now(),
                                  "url": "",
                                  "senderID": globals.UserId,
                                });

                                await Firestore.instance.collection("users")
                                    .document(widget.event.senderId)
                                    .updateData({
                                  "personalMessId": FieldValue.arrayUnion(
                                      [documentReference.documentID])
                                });
                              }
                              setState(() {
                                processing = false;
                              });
                            }
                            successshowAlertDialog(
                                context, CreateEventIsManeger);
                          },
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'שמור שינויים',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Assistant',
                                    fontSize: 20),
                              ),
                              Spacer(),

                              //SizedBox(width: 270),
                              Image.asset(
                                'image/whitearrow.png',
                                width: 30,
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}

class Data {
  String dropdownValue;
  Data({this.dropdownValue});
}

successshowAlertDialog(BuildContext context,bool ifCreateEventIsMenager) {

  Widget okButton = FlatButton(
    child: Text("אישור"),
    onPressed: () async{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigationBarController(
                    3,
                    3,
                  )));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("האירוע עודכן בהצלחה"),
    content: ifCreateEventIsMenager==false?Text("נשלח התראה ליוצר האירוע"):Text(' '),
    actions: [
      okButton,
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
