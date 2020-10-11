import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'event_model.dart';
import 'package:flutter/material.dart';
import 'event_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:greenpeace/Footer/footer.dart';

class updateEventPage extends StatefulWidget {
  final EventModel note;
  final String sender;
  final String text;
  final String senderId;
  final String topic;
  final DateTime eventDate;
  final String equipment;
  final String type_event;
  final String location;
  final String dataid;
  final String whatapp;
  updateEventPage({
    this.sender,
    this.whatapp,
    this.text,
    this.senderId,
    this.topic,
    this.equipment,
    this.eventDate,
    this.type_event,
    this.location,
    this.dataid,
    this.note,
  });

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
  Map<String, bool> values = {
    'שלטים': false,
    'מגפון': false,
    'אישור משטרה': false,
    'פרסום ברשתות חברתיות': false,
    'חולצות': false,
    'שקיות אשפה': false,
    'כפפות': false,
  };

  var tmpArray = [];

  String getCheckboxItems() {
    tmpArray.clear();
    values.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
      }
    });
    return tmpArray.toString();
  }

  DateTime _eventDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  List<String> equipmentList = [];
  bool processing;
  String temp = "";
  void stringToList() {
    print(widget.equipment);
    for (int i = 1; i < widget.equipment.length; i++) {
      if (widget.equipment[i] == ',' || widget.equipment[i] == ']') {
        equipmentList.add(temp);
        temp = "";
      } else {
        temp = temp + widget.equipment[i];
      }
    }
    for (int i = 0; i < equipmentList.length; i++) {
      values[equipmentList[i]] = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    stringToList();
    _title = TextEditingController(
        text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(
        text: widget.note != null ? widget.note.description : "");
    _location = TextEditingController(
        text: widget.note != null ? widget.note.location : "");
    processing = false;
    _whatapp = TextEditingController(
        text: widget.note != null ? widget.note.location : "");
    _title = TextEditingController(text: widget.topic);
    _description = TextEditingController(text: widget.text);
    _location = TextEditingController(text: widget.location);
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
                  style: new TextStyle(fontSize: 30),
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      height: 400,
                      width: 300,
                      child: Column(children: <Widget>[
                        Expanded(
                          child: RadioButtonGroup(
                            labels: [
                              "הפגנה",
                              "ניקיון",
                              "הרצאה",
                            ],
                            disabled: [
                              "${widget.type_event}",
                            ],
                            onChange: (String label, int index) {
                              print("label: $label index: $index");
                              //type_event=label;
                            },
                            onSelected: (String label) => print(label),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: new Align(
                            child: new Text(
                              "רשימת ציוד",
                              style: new TextStyle(fontSize: 30),
                            ), //so big text
                            alignment: FractionalOffset.topRight,
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: values.keys.map((String key) {
                              return new CheckboxListTile(
                                title: new Text(key),
                                value: values[key],
                                activeColor: Colors.pink,
                                checkColor: Colors.white,
                                onChanged: (bool value) {
                                  setState(() {
                                    values[key] = value;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),

//           Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                child: TruggleStream(page_call:'new_event'),
//             ),

              const SizedBox(height: 10.0),
              ListTile(
                title: Text(
                  "בחר תאריך",
                  style: new TextStyle(fontSize: 30),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text(
                      "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                ),
                onTap: () async {
                  print(this.data.dropdownValue);
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: _eventDate,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
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
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });

                              await eventDBS.updateData(widget.dataid, {
                                "title": _title.text,
                                "description": _description.text,
                                "event_date": _eventDate,
                                "equipment": getCheckboxItems(),
                                "location": _location.text,
                                "type_event": widget.type_event,
                                "whatapp": _whatapp.text,
                              });

                              setState(() {
                                processing = false;
                              });
                            }
                            successshowAlertDialog(context, currentUser.email,
                                widget.senderId, widget.topic, widget.sender);
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

successshowAlertDialog(BuildContext context, String email, String currentuserId,
    String name_event, String createby) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("אישור"),
    onPressed: () {
      DocumentReference documentReference =
          Firestore.instance.collection("personalMess").document();
      documentReference.setData({
        "text": 'בוצע עדכון על ידי המנהל' + name_event + 'האירוע',
        "sender": email,
        "time": DateTime.now(),
        "url": "",
        "senderID": currentuserId,
      });

      Firestore.instance.collection("users").document(createby).updateData({
        "personalMessId": FieldValue.arrayUnion([documentReference.documentID])
      });

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
    content: Text("נשלח התראה ליוצר האירוע"),
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
