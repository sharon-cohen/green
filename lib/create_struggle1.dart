import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
final _firestore = Firestore.instance;
class create_struggle1 extends StatefulWidget {
  create_struggle1({Key key, this.arguments}) : super(key: key);
  static const String id = " create_struggle1";
  final ScreenArguments_m arguments;

  @override
  create_struggle1State createState() => create_struggle1State();
}

class create_struggle1State extends State<create_struggle1> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _location;
  TextEditingController _petition;
  TextEditingController _donation;
  String type_event;
  Data data=Data(
    dropdownValue:'',
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
   _description = TextEditingController(text:  "");
    _location = TextEditingController(text:  "");
    _petition = TextEditingController(text:  "");
    _donation=TextEditingController(text:  "");
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
  Color imageColorTitle=Colors.green;
  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }


  bool _isLoading = true;
  int timestamp;
  var imageFile;
  bool choose=false;
  String  fileUrl="";
  Widget showImage(String image) {
    if(image==null){
      return Container();
    }
    else{

      return Image.network(image,fit: BoxFit.cover,
        loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ?
              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },);}
  }

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile =  ImagePicker.pickImage(
          source: ImageSource.gallery);
      timestamp = new DateTime.now().millisecondsSinceEpoch;
    });
  }
  Widget setUserForm() {
    return Stack(children: <Widget>[
      // Background with gradient
      Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red[900], Colors.blue[700]])),
          height: MediaQuery.of(context).size.height * 0.3
      ),
      //Above card
      Card(
          elevation: 20.0,
          margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 100.0),
          child: ListView(
              padding:
              EdgeInsets.only(top: 20.0, left: 20.0, right: 18.0, bottom: 5.0),
              children: <Widget>[
                TextField(),
                TextField()
              ]

          )),
      // Positioned to take only AppBar size
      Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: AppBar(        // Add AppBar here only
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Doctor Form"),
        ),
      ),

    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _key,
      body: Stack   (
        children: [
          Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 30,

                    ),
                    child: Align(alignment: Alignment.topRight,
                        child: IconButton(onPressed: () {
                          Navigator.pop(context, true);
                        }, icon: Icon(Icons.clear,
                          color: Colors.black,
                        ),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _title,
                      validator: (value) =>
                      (value.isEmpty) ? "שדה נושא הבעיה חובה" : null,
                      style: style,
                      decoration: InputDecoration(
                          labelText: "שם המאבק",
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
                      (value.isEmpty) ? "שדה תיאור המאבק חובה" : null,
                      style: style,
                      decoration: InputDecoration(
                          labelText: "תיאור המאבק",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _location,
                      validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                      style: style,
                      decoration: InputDecoration(
                          labelText: "קישור לעמוד המאבק באתר",

                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _petition,
                      validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                      style: style,
                      decoration: InputDecoration(
                          labelText: "קישור לעצומה",

                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _donation,
                      validator: (value) =>
                      (value.isEmpty) ? "שדה קישור זה חובה" : null,
                      style: style,
                      decoration: InputDecoration(
                          labelText: "קישור לעמוד התרומה",

                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),

//           Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                child: TruggleStream(page_call:'new_event'),
//             ),

                  const SizedBox(height: 10.0),
                  ListTile(
                    title: Text("בחר בתמונה",style: new TextStyle(fontSize: 30,color: imageColorTitle),),

                    onTap: () async{
                      imageFile = await ImagePicker.pickImage(
                          source: ImageSource.gallery);

                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
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

                        });
                      }

                  ),

                  SizedBox(height: 10.0),
                  SizedBox(
                    height: 20.0,
                  ),

                  if(fileUrl!="")showImage(fileUrl),

                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
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

                          if (_formKey.currentState.validate()&& fileUrl!="") {
                            setState(() {

                              processing = true;
                            });

                            _firestore.collection("struggle").add({
                              "info": _title.text,
                              "name":  _description.text,
                              "petition":_petition.text,
                              "url_image": fileUrl,
                              "url_share": _location.text,
                              "donation":_donation.text,
                            });



                            setState(() {

                              processing = false;
                            });
                          }
                         else{
                            setState(() {

                              imageColorTitle=Colors.red;
                            });
                          }

                          //successshowAlertDialog(context);

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
        ],
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
