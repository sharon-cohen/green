import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/Footer/footer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

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
  String fileUrl = "";
  Position _currentPosition;
  String _currentAddress = "";
  TextEditingController _description;
  TextEditingController _location;
  TextStyle style = TextStyle(fontFamily: 'Assistant', fontSize: 20.0);
  File _imageFile;
  String fileName = '';
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {
    if (_imageFile.path.isNotEmpty) {
      fileName = basename(_imageFile.path);
    }
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    fileUrl = await taskSnapshot.ref.getDownloadURL();
  }

  bool processing;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    processing = false;
    _description = TextEditingController(text: "");
    _location = TextEditingController(text: "");
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
              // Align(
              //   child: IconButton(
              //     icon: Icon(Icons.clear),
              //     iconSize: 30,
              //     color: Colors.grey,
              //     splashColor: Colors.purple,
              //     onPressed: () {
              //       Navigator.pop(context, true);
              //     },
              //   ),
              //   alignment: FractionalOffset.topRight,
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: Row(
                  children: [
                    Align(
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        iconSize: 30,
                        color: Colors.grey,
                        splashColor: Colors.purple,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      alignment: FractionalOffset.topRight,
                    ),
                    SizedBox(width: 60),
                    new Text(
                      "דיווח סביבתי",
                      style: new TextStyle(
                          fontFamily: 'Assistant',
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // child: new Align(
                //   child: new Text(
                //     "דיווח חם",
                //     style: new TextStyle(fontSize: 35, color: Colors.red),
                //   ), //so big text
                //   alignment: FractionalOffset.topRight,
                // ),
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
                  decoration: InputDecoration(
                    labelText: "תיאור הבעיה",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10),
                        ),
                  ),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              //   child: new Align(
              //     child: new Text(
              //       "מיקום",
              //       style: new TextStyle(
              //           fontSize: 35,
              //           color: Colors.black,
              //           fontFamily: 'Assistant'),
              //     ), //so big text
              //     alignment: FractionalOffset.topRight,
              //   ),
              // ),
              Padding(
                // padding: EdgeInsets.symmetric(
                //     horizontal: 5,
                //     vertical: MediaQuery.of(context).size.height / 10),

                padding: EdgeInsets.fromLTRB(
                    5, MediaQuery.of(context).size.height / 15, 5, 0),
                child: Align(
                  child: FlatButton(
                    child: Row(
                      children: [
                        Image.asset(
                          'image/google-maps.png',
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 7),
                        Text(
                          "צירוף המיקום הנוכחי שלך",
                          style: new TextStyle(
                              fontFamily: 'Assistant',
                              fontSize: 25,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _getCurrentLocation();
                    },
                  ),
                  alignment: FractionalOffset.topRight,
                ),
              ),
              if (_currentPosition != "")
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 0.0),
                  child: Text(
                    _currentAddress,
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Assistant'),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: new Align(
                  child: new Text(
                    "או הוספת כתובת",
                    style: new TextStyle(
                        fontFamily: 'Assistant',
                        fontSize: 25,
                        color: Colors.black),
                  ), //so big text
                  alignment: FractionalOffset.topRight,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _location,
                  validator: (value) =>
                      (_location.text == "") ? "שדה המיקום חובה" : null,
                  decoration: InputDecoration(
                    labelText: "הוספת כתובת",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(10),
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    5, MediaQuery.of(context).size.height / 15, 5, 0),
                child: Container(
                  child: _imageFile != null
                      ? Image.file(_imageFile)
                      : FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Row(
                            children: [
                              Image.asset(
                                'image/addimage.png',
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(width: 7),
                              Text(
                                "הוספת תמונה",
                                style: new TextStyle(
                                    fontSize: 25, fontFamily: 'Assistant'),
                              ),
                            ],
                          ),
                          onPressed: pickImage,
                        ),
                ),
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      //  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.height / 15, 0, 0),
                      child: Material(
                        color: Color(int.parse("0xff6ed000")),
                        elevation: 5.0,
                        //borderRadius: BorderRadius.circular(30.0),
                        //color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              await uploadImageToFirebase(context);
                              _firestore.collection("hotReport").add({
                                "text": _description.text,
                                "sender": globals.name,
                                "time": DateTime.now(),
                                "location": _location.text,
                                "url_image": fileUrl,
                                "senderId": globals.UserId,
                              });

                              setState(() {
                                processing = false;
                              });
                            }
                            if (_description.text != "" && _location.text != "")
                              successshowAlertDialog(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "שלח דיווח",
                                style: style.copyWith(
                                    fontFamily: 'Assistant',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              //SizedBox(width: 270),
                              Image.asset(
                                'image/whitearrow.png',
                                width: 30,
                                height: 30,
                              ),
                            ],
                          ),
                          // child: Text(
                          //   "שלח",
                          //   style: style.copyWith(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() async {
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
        _location.text = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }
}

class Data {
  String dropdownValue;
  Data({this.dropdownValue});
}

successshowAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "אישור",
      style: TextStyle(color: Colors.white, fontFamily: 'Assistant'),
    ),
    onPressed: () {
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
    title: Text(
      "האירוע נוצר בהצלחה",
      style: TextStyle(color: Colors.white, fontFamily: 'Assistant'),
    ),
    content: Text(
      "נשלח למנהלים לאישור תקבל עדכון בקרוב",
      style: TextStyle(color: Colors.white, fontFamily: 'Assistant'),
    ),
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
