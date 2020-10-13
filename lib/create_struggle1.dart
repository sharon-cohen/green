import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:greenpeace/Footer/footer.dart';

final _firestore = Firestore.instance;

class create_struggle1 extends StatefulWidget {
  create_struggle1({Key key, this.arguments}) : super(key: key);
  static const String id = " create_struggle1";
  final ScreenArguments_m arguments;

  @override
  create_struggle1State createState() => create_struggle1State();
}

class create_struggle1State extends State<create_struggle1> {
  TextStyle style = TextStyle(fontFamily: 'Assistant', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _location;
  TextEditingController _petition;
  TextEditingController _donation;
  String type_event;
  Data data = Data(
    dropdownValue: '',
  );

  var tmpArray = [];

  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();

    _title = TextEditingController(text: "");
    _description = TextEditingController(text: "");
    _location = TextEditingController(text: "");
    _petition = TextEditingController(text: "");
    _donation = TextEditingController(text: "");
    _eventDate = DateTime.now();
    processing = false;
  }

  static final String uploadEndPoint =
      'http://localhost/flutter_test/upload_image.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  Color imageColorTitle = Colors.green;
  String fileName = '';

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  File _imageFile;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {
    print("fsdfs");
    if (_imageFile.path.isNotEmpty) {
      fileName = basename(_imageFile.path);
    }

    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    fileUrl = await taskSnapshot.ref.getDownloadURL();
  }

  int timestamp;
  var imageFile;
  bool choose = false;
  String fileUrl = "";

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
            // padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
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
                    SizedBox(width: 30),
                    Text(
                      'יצירת מאבק חדש',
                      style: TextStyle(
                          fontFamily: 'Assistant',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה נושא הבעיה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "שם המאבק",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                          fontFamily: 'Assistant', color: Colors.black),
                      focusColor: Colors.lightGreen,
                      border: OutlineInputBorder(
                          //  borderRadius: BorderRadius.circular(10)
                          )),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה תיאור המאבק חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                    labelText: "תיאור המאבק",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle:
                        TextStyle(fontFamily: 'Assistant', color: Colors.black),
                    focusColor: Colors.lightGreen,
                    border: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(10),
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      // borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TextFormField(
                  controller: _location,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                    labelText: "קישור לעמוד המאבק באתר",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle:
                        TextStyle(fontFamily: 'Assistant', color: Colors.black),
                    focusColor: Colors.lightGreen,
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10)
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      // borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TextFormField(
                  controller: _petition,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                    labelText: "קישור לעצומה",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle:
                        TextStyle(fontFamily: 'Assistant', color: Colors.black),
                    border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10)
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      // borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TextFormField(
                  controller: _donation,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                    labelText: "קישור לעמוד התרומה",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle:
                        TextStyle(fontFamily: 'Assistant', color: Colors.black),
                    focusColor: Colors.lightGreen,
                    border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10)
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen),
                      // borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

//           Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                child: TruggleStream(page_call:'new_event'),
//             ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  // margin:
                  //     const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                  child: _imageFile != null
                      ? Image.file(_imageFile)
                      : FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            children: [
                              Image.asset(
                                'image/addimage.png',
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(width: 7),
                              Text(
                                "בחר בתמונה",
                                style: new TextStyle(
                                    fontSize: 25, fontFamily: 'Assistant'),
                              ),
                            ],
                          ),
                          onPressed: pickImage,
                        ),
                ),
              ),

              // SizedBox(height: 10.0),
              //
              // SizedBox(
              //   height: 20.0,
              // ),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),

              //  SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Material(
                      elevation: 5.0,
                      //borderRadius: BorderRadius.circular(30.0),
                      color: Color(int.parse("0xff6ed000")),
                      child: MaterialButton(
                        onPressed: () async {

                         // await uploadImageToFirebase(context);

                          print(fileUrl);
                          if (_formKey.currentState.validate()&&fileUrl!="") {


                            setState(() {
                              processing = true;
                            });
                            await uploadImageToFirebase(context);
                            await _firestore.collection("struggle").add({
                              "info": _title.text,
                              "name": _description.text,
                              "petition": _petition.text,
                              "url_image": fileUrl,
                              "url_share": _location.text,
                              "donation": _donation.text,
                            });

                            setState(() {
                              processing = false;
                            });
                            showAlertDialogStruggle(context);
                          } else {
                            setState(() {
                              imageColorTitle = Colors.red;
                            });
                          }

                          //successshowAlertDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "צור מאבק",
                              style: style.copyWith(
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

showAlertDialogStruggle(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BottomNavigationBarController(2, 1)),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("seccses"),
    content: Text("seccses"),
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
