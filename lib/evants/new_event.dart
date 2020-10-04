import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenpeace/streem_firestore/StruggleStream.dart';
import 'package:intl/intl.dart';
import 'event_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _location;
  TextEditingController _whatapp;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final initialValue = DateTime.now();
  final createDateEvent = DateTime.now();
  DateTime value = DateTime.now();
  int savedCount = 0;
  int changedCount = 0;
  String type_event;
  Data data=Data(
    dropdownValue:'',
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
  Map<String, bool> values_type = {
    'foo': true,
    'bar': false,
  };
  var tmpArray = [];

  String getCheckboxItems(){
    tmpArray.clear();
    values.forEach((key, value) {
      if(value == true)
      {
        tmpArray.add(key);

      }
    });
      return tmpArray.toString();

  }
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
  bool autoValidate = false;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _title = TextEditingController(text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(text:  widget.note != null ? widget.note.description : "");
    _location = TextEditingController(text:  widget.note != null ? widget.note.location : "");
    _whatapp = TextEditingController(text:  widget.note != null ? widget.note.location : "");
    _eventDate = DateTime.now();
    processing = false;
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
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

      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                  (value.isEmpty) ? "שדה נושא הבעיה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "נושא המחאה",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                  (value.isEmpty) ? "שדה תיאור הבעיה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "תיאור הבעיה",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _whatapp,
                  minLines: 3,
                  maxLines: 5,

                  style: style,
                  decoration: InputDecoration(
                      labelText: "צרף קישור לקבוצת Whatapp",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _location,
                  validator: (value) =>
                  (value.isEmpty) ? "שדה המיקום חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "מיקום",

                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Date'),
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
                            initialTime:
                            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
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
              new Align(
                child: new Text(
                  "סוג האירוע",
                  style: new TextStyle(fontSize: 30),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
        Flex(
          direction: Axis.horizontal,

              children: [
                Expanded(
                  child: Container(
                    height: 400,
                    width: 300,
                    child: Column (children: <Widget>[
                      Expanded(
                        child:  RadioButtonGroup(
                          labels: [
                            "הפגנה",
                            "נקיון",
                            "הרצאה",
                          ],

                          onChange: (String label, int index) {print("label: $label index: $index");
                         type_event=label;
                          } ,
                          onSelected: (String label) => print(label),
                        ),
                      ),
                      new Align(
                        child: new Text(
                          "רשימת ציוד",
                          style: new TextStyle(fontSize: 30),
                        ), //so big text
                        alignment: FractionalOffset.topRight,
                      ),

                      Expanded(
                        child :
                        ListView(
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
                      ),]),
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
                title: Text("בחר תאריך",style: new TextStyle(fontSize: 30),),
                subtitle: Text("${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                onTap: ()async{
                  print(this.data.dropdownValue);
                  DateTime picked = await showDatePicker(context: context, initialDate: _eventDate, firstDate: DateTime(_eventDate.year-5), lastDate: DateTime(_eventDate.year+5));
                  if(picked != null) {
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    onPressed: () async {

                      if (_formKey.currentState.validate()) {
                        setState(() {
                          processing = true;
                        });
                        if(widget.note != null) {
                          await eventDBS.updateData(widget.note.id,{
                            "title": _title.text,
                            "description": _description.text,
                            "event_date": widget.note.eventDate,
                            "equipment":tmpArray.toString(),
                            "sender":globals.name,
                            "senderId":currentUser.uid,
                            "location":_location.text,
                            "type_event":type_event,
                            "whatapp":_whatapp.text,
                          });
                        }else{

                          await eventDBS.createItem(EventModel(
                            title: _title.text,
                            description: _description.text,
                            eventDate: value,
                            createDateEvent:createDateEvent,
                            approve: false,
                            equipment: getCheckboxItems(),
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
                      }
                      successshowAlertDialog(context);

                    },

                    child: Text(
                      "Save",
                      style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
class Data{
  String dropdownValue;
  Data({this.dropdownValue});
}
successshowAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("אישור"),
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BottomNavigationBarController(
                    3, 3,)));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("האירוע נוצר בהצלחה"),
    content: Text("נשלח למנהלים לאישור תקבל עדכון בקרוב"),
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
