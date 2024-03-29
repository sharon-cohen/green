import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:path/path.dart';
import 'package:greenpeace/Footer/footer.dart';

final _firestore = Firestore.instance;

class updatestrugle extends StatefulWidget {
  updatestrugle({Key key, this.arguments, this.strugle}) : super(key: key);
  static const String id = " create_struggle1";
  final StruggleModel strugle;
  final ScreenArguments_m arguments;

  @override
  updatestrugleState createState() => updatestrugleState();
}

class updatestrugleState extends State<updatestrugle> {
  TextStyle style = TextStyle(fontFamily: 'Assistant', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _share;
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

    _title = TextEditingController(text: widget.strugle.title);
    _description = TextEditingController(text: widget.strugle.description1);
    _share = TextEditingController(text: widget.strugle.share);
    _petition = TextEditingController(text: widget.strugle.petition);
    _donation = TextEditingController(text: widget.strugle.donation);
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
    print("pth of image");
    print(_imageFile.path.toString());
    if (_imageFile.path.isEmpty) {
      throw GradeException();
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
          centerTitle: true,
          title: Container(

              child: Image.asset('image/logo_greem.png', scale: 2)),
          leading:
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )

      ),
      backgroundColor: Colors.grey[200],
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Text(
                    'עריכת מאבק',
                    style: TextStyle(
                        fontFamily: 'Assistant',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  maxLength: 16,
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "שם המאבק הוא שדה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "שם המאבק",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _share,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "קישור לעמוד המאבק באתר",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _petition,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "קישור לעצומה",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _donation,
                  validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "קישור לעמוד התרומה",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),

//           Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                child: TruggleStream(page_call:'new_event'),
//             ),

              Container(
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: _imageFile != null
                      ? Image.file(_imageFile)
                      : FlatButton(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50,
                          ),
                          onPressed: pickImage,
                        ),
                ),
              ),

              SizedBox(height: 10.0),

              SizedBox(
                height: 20.0,
              ),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Assistant',
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),

              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Material(
                      elevation: 5.0,
                      //borderRadius: BorderRadius.circular(30.0),
                      color: Color(int.parse("0xff6ed000")),
                      child: MaterialButton(
                        onPressed: () async {
                          try {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              if (_imageFile != null) {
                                await uploadImageToFirebase(context);
                              }

                              String idevent =
                                  await GetStrugle(widget.strugle.title);
                              if (fileUrl == "") {
                                await Firestore.instance
                                    .collection('struggle')
                                    .document(idevent)
                                    .updateData({
                                  "info": _description.text,
                                  "name": _title.text,
                                  "petition": _petition.text,
                                  "url_share": _share.text,
                                  "donation": _donation.text,
                                });
                              } else {
                                await Firestore.instance
                                    .collection('struggle')
                                    .document(idevent)
                                    .updateData({
                                  "info": _description.text,
                                  "name": _title.text,
                                  "petition": _petition.text,
                                  "url_image": fileUrl,
                                  "url_share": _share.text,
                                  "donation": _donation.text,
                                });
                              }

                              setState(() {
                                processing = false;
                              });
                              showAlertDialogStruggle(
                                  context, "המאבק עודכן בהצלחה");
                            } else {}
                          } //successshowAlertDialog(context);
                          catch (e) {
                            print("error");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
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

showAlertDialogStruggle(BuildContext context, String Mess) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "אישור",
      style: TextStyle(color: Colors.black, fontFamily: 'Assistant'),
    ),
    onPressed: () {
      if (Mess == "המאבק עודכן בהצלחה") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigationBarController(2, 1)),
        );
      } else {
        Navigator.pop(context, true);
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Mess != "המאבק עודכן בהצלחה"
        ? Text(
            "שגיאה",
          )
        : Text("המאבק עודכן בהצלחה"),
    content: Mess != "המאבק עודכן בהצלחה"
        ? Text(
            Mess,
            style: TextStyle(color: Colors.black, fontFamily: 'Assistant'),
          )
        : Text(""),
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

class GradeException implements Exception {
  String errorMessage() {
    return 'Marks cannot be -ve values';
  }
}
