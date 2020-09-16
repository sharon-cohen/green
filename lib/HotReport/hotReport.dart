import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/Footer/footer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
final _firestore = Firestore.instance;

class HotReport extends StatefulWidget {


  const HotReport({Key key}) : super(key: key);

  @override
  _HotReport createState() => _HotReport();
}

class _HotReport extends State<HotReport> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  File _image;
  var imageFile;
  String  fileUrl="";
  Position _currentPosition;
  String _currentAddress="";
  TextEditingController _description;
  TextEditingController _location;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);


  bool processing;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();

    processing = false;
    _description = TextEditingController(text:"");
    _location = TextEditingController(text:  "");

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
              Align(
                child: IconButton(
                  icon: Icon(
                      Icons.clear
                  ),
                  iconSize: 30,
                  color: Colors.grey,
                  splashColor: Colors.purple,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                alignment: FractionalOffset.topRight,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: new Align(
                  child: new Text(
                    "דיווח חם",
                    style: new TextStyle(fontSize: 35, color: Colors.red),
                  ), //so big text
                  alignment: FractionalOffset.topRight,
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

                  decoration: InputDecoration(
                      labelText: "תיאור הבעיה",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: new Align(
                  child: new Text(
                    "מיקום",
                    style: new TextStyle(fontSize: 35, color: Colors.black),
                  ), //so big text
                  alignment: FractionalOffset.topRight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
                child: Align(
                  child: FlatButton(
                    child: Text("קבל מיקום הנוכחי שלך",style: new TextStyle(fontSize: 25, color: Colors.black),),
                    onPressed: () {
                      _getCurrentLocation();

                    },
                  ),
                  alignment: FractionalOffset.topRight,
                ),
              ),
              if (_currentPosition != "") Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(_currentAddress),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: new Align(
                  child: new Text(
                    "או הקלד כתובת",
                    style: new TextStyle(fontSize: 25, color: Colors.black),
                  ), //so big text
                  alignment: FractionalOffset.topRight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _location,
                  validator: (value) =>
                  (_location.text=="") ? "שדה המיקום חובה" : null,

                  decoration: InputDecoration(
                      labelText: "הקלד כתובת",

                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),

              ListTile(
                  title: Text("בחר בתמונה",style: new TextStyle(fontSize: 30),),

                  onTap: () async{
                    imageFile = await ImagePicker.pickImage(
                        source: ImageSource.gallery);

                    int timestamp = new DateTime.now().microsecondsSinceEpoch;
                    StorageReference storageReference = FirebaseStorage
                        .instance
                        .ref()
                        .child('chats/img_' + timestamp.toString() + '.jpg');
                    StorageUploadTask uploadTask =
                    storageReference.putFile(imageFile);
                    await uploadTask.onComplete;
                    fileUrl =
                    await storageReference.getDownloadURL();

                    setState(() {
                      _image = File(imageFile.path);
                    });
                  }

              ),

              SizedBox(height: 10.0),
              SizedBox(
                height: 20.0,
              ),

              if (fileUrl != "") Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),


              ),

              SizedBox(
                height: 20.0,
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


                        _firestore.collection("hotReport").add({
                          "text": _description.text,
                          "sender": globals.name,
                          "time": DateTime.now(),
                           "location":_location.text,
                          "url_image": fileUrl,
                          "senderId":globals.UserId,
                        });


                        setState(() {
                          processing = false;
                        });
                      }
                     if(_description.text!=""&& _location.text!="")
                      successshowAlertDialog(context);

                    },

                    child: Text(
                      "שלח",
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
  _getCurrentLocation() async{
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
          _location.text=_currentAddress;
      });
    } catch (e) {
      print(e);
    }
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
