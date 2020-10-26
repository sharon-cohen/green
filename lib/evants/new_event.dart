import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:intl/intl.dart';
import 'event_model.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'event_firestore_service.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:greenpeace/Footer/footer.dart';

class newEventPage extends StatefulWidget {
  final EventModel note;

  const newEventPage({Key key, this.note}) : super(key: key);

  @override
  _newEventPage createState() => _newEventPage();
}

class _newEventPage extends State<newEventPage> {
  FirebaseUser currentUser;
  TextStyle style = TextStyle(fontFamily: 'Assistant', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _location;
  TextEditingController _whatapp;
  final format = DateFormat("dd-MM-yyyy HH:mm");
  final initialValue = DateTime.now();
  final createDateEvent = DateTime.now();
  DateTime value = DateTime.now();
  int savedCount = 0;
  int changedCount = 0;
  String type_event;
  Data data = Data(
    dropdownValue: '',
  );

  var tmpArray = [];

  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
  bool autoValidate = false;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();

    _title = TextEditingController(
        text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    _location = TextEditingController(
        text: widget.note != null ? widget.note.location : "");
    _whatapp = TextEditingController(
        text: widget.note != null ? widget.note.location : "");
    _eventDate = DateTime.now();

    processing = false;
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                  SizedBox(width: 50),
                  Text(
                    'יצירת אירוע חדש',
                    style: TextStyle(
                        fontFamily: 'Assistant',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  cursorColor: Colors.black,
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה נושא הבעיה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                    labelText: "נושא האירוע",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle:
                        TextStyle(fontFamily: 'Assistant', color: Colors.black),
                    focusColor: Colors.lightGreen,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      // borderRadius: BorderRadius.circular(10),
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
                    labelText: "תיאור האירוע",
                    labelStyle:
                        TextStyle(fontFamily: 'Assistant', color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(10)
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      //borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                    labelText: "מיקום - כתובת מדויקת",
                    labelStyle:
                        TextStyle(fontFamily: 'Assistant', color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(10),
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      //borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _whatapp,
                  minLines: 3,
                  maxLines: 5,
                  style: style,
                  decoration: InputDecoration(
                    labelText: "צרף קישור לקבוצת Whatsapp",
                    labelStyle: TextStyle(
                      fontFamily: 'Assistant',
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(10),
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      //borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'תאריך ושעה',
                      style: new TextStyle(
                        fontFamily: 'Assistant',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DateTimeField(
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      autovalidate: autoValidate,
                      validator: (date) => date == null ? 'Invalid date' : null,
                      initialValue: initialValue,
                      onChanged: (date) => setState(() {
                        value = date;
                        changedCount++;
                      }),
                      onSaved: (date) => setState(() {
                        value = date;

                        savedCount++;
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: new Align(
                  child: new Text(
                    "סוג האירוע",
                    style: new TextStyle(
                      fontFamily: 'Assistant',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ), //so big text
                  alignment: FractionalOffset.topRight,
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
                            labels: [
                              "הפגנה",
                              "ניקיון",
                              "הרצאה",
                              "אחר",
                            ],
                            onChange: (String label, int index) {
                              print("label: $label index: $index");
                              type_event = label;
                            },
                            onSelected: (String label) => print(label),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Material(
                        color: Color(int.parse("0xff6ed000")),
                        elevation: 5.0,
                        //borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          onPressed: () async {
                            bool checkExistNameEvent =
                                await CheckNameEventExist(_title.text);
                            if (_location.text != "" &&
                                _description.text != "" &&
                                _title.text != "" &&
                                _whatapp.text != "" &&
                                !checkExistNameEvent) {
                              setState(() {
                                processing = true;
                              });
                              if (widget.note != null) {
                                await eventDBS.updateData(widget.note.id, {
                                  "title": _title.text,
                                  "description": _description.text,
                                  "event_date": widget.note.eventDate,
                                  "time": widget.note.time,
                                  "sender": globals.name,
                                  "senderId": currentUser.uid,
                                  "location": _location.text,
                                  "type_event": type_event,
                                  "whatapp": _whatapp.text,
                                });
                              } else {
                                await eventDBS.createItem(EventModel(
                                  title: _title.text,
                                  description: _description.text,
                                  eventDate: value,
                                  createDateEvent: createDateEvent,
                                  approve: globals.isMeneger?true:false,
                                  time: initialValue,
                                  sender: globals.name,
                                  senderId: currentUser.uid,
                                  type_event: type_event,
                                  location: _location.text,
                                  whatapp: _whatapp.text,
                                ));
                              }

                              setState(() {
                                processing = false;
                              });
                              !globals.isMeneger?AlertDialogCreateEvent(context,
                                 "האירוע נוצר בהצלחה!"+ "\n"+"תשלח הודעה לאחר אישור מנהל"):AlertDialogCreateEvent(context,"האירוע נוצר בהצלחה");
                            } else {
                              if (checkExistNameEvent == true) {
                                AlertDialogCreateEvent(context,
                                    "שם אירוע זה כבר קיים במערכת, אנא בחר בשם אחר");
                              } else {
                                AlertDialogCreateEvent(
                                    context, "חובה למלא את כל השדות");
                              }
                            }
                          },
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "צור אירוע",
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // SizedBox(width: 270),
                              Image.asset(
                                'image/whitearrow.png',
                                width: 30,
                                height: 30,
                              ),
                              // Icon(
                              //   Icons.play_circle_outline,
                              //   color: Colors.white,
                              //   size: 36.0,
                              // ),
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

AlertDialogCreateEvent(BuildContext context, String Mess) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("אישור"),
    onPressed: () {
      Navigator.pop(context, true);
      if (Mess.contains("האירוע נוצר בהצלחה"))
        Navigator.pop(context, true);


        },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(Mess),
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
