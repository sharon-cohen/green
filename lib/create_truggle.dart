import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _firestore = Firestore.instance;

class create_struggle extends StatefulWidget {
  create_struggle({Key key, this.arguments}) : super(key: key);
  static const String id = "create_struggle";
  final ScreenArguments_m arguments;

  @override
  create_struggleState createState() => create_struggleState();
}

class create_struggleState extends State<create_struggle> {
  String link;
  final FocusNode _FocusNode1 = new FocusNode();
  final FocusNode _FocusNode2  = new FocusNode();
  final FocusNode _FocusNode3 = new FocusNode();
  final FocusNode _FocusNode4  = new FocusNode();
  final FocusNode _FocusNode5  = new FocusNode();
  Widget text_field(String  title,final FocusNode focus){
    return TextField(
      focusNode: focus,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.right,
      decoration: InputDecoration(hintText:  title),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus( focus),
      onChanged: (value) {
        link = value;
      },
    );



  }
  String dropdownValue = 'בחר מאבק';

  List <String> spinnerItems = [
    'בחר מאבק',
    'Two',
    'Three',
    'Four',
    'Five'
  ] ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          text_field("שם אירוע ",_FocusNode1),
          text_field("סוג האירוע",_FocusNode2),
          text_field("מספר משתתפים רצוי",_FocusNode3),
          text_field("צרכים לוגיסטיים",_FocusNode4),
          text_field("קישור לקבוצת WhatsAp",_FocusNode5),
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.red, fontSize: 18),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String data) {
              setState(() {
                dropdownValue = data;
              });
            },
            items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

        ],
      ),
    );

  }


}

//_launchURL(String link) async {
//  const url = 'link';
//  if (await canLaunch(url)) {
//    await launch(url);
//  } else {
//    throw 'Could not launch $url';
//  }
//}
class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Apple'),
      Company(2, 'Google'),
      Company(3, 'Samsung'),
      Company(4, 'Sony'),
      Company(5, 'LG'),
    ];
  }
}