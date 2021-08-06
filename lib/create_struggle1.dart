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
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:greenpeace/currentLocation.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:greenpeace/dialogAlretCreateStruggle.dart';
import 'package:greenpeace/editImageDes.dart';
import  'package:greenpeace/evants/new_event.dart';
final _firestore = Firestore.instance;

class create_struggle1 extends StatefulWidget {
  create_struggle1({Key key, this.arguments,this.gotStruggle}) : super(key: key);
   StruggleModel gotStruggle;
  static const String id = " create_struggle1";
  final ScreenArguments_m arguments;

  @override
  create_struggle1State createState() => create_struggle1State();
}

class create_struggle1State extends State<create_struggle1> {
  bool updateFlag=false;
  TextStyle style = TextStyle(fontFamily: 'Assistant', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  TextEditingController _location;
  TextEditingController _petition;
  TextEditingController _donation;
  String type_event;
  String origenfilename=' ';
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

    _title = TextEditingController(text: widget.gotStruggle.title);
    _location = TextEditingController(text: widget.gotStruggle.share);
    _petition = TextEditingController(text: widget.gotStruggle.petition);
    _donation = TextEditingController(text:widget.gotStruggle.donation);
    if(widget.gotStruggle.image!=" "){
      fileName=widget.gotStruggle.image;
    }
    if(widget.gotStruggle.title!= " "){
      updateFlag=true;
      origenfilename=widget.gotStruggle.image;
    }


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
  String fileName = ' ';

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }
  int counter=0;
  File _imageFile;
  List<File>_imageFiles=[];
  bool boolfile1=false;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,
      imageQuality: 85,
    );

    setState(() {
      fileName = (pickedFile.path);
    });
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {
    fileName = basename(_imageFile.path);

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
      key: _key,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Container(

                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Center(

                            child: updateFlag?Text(
                              'עריכת מאבק',
                              style: TextStyle(
                                fontFamily: 'Assistant',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ):Text(
                              'יצירת מאבק חדש',
                              style: TextStyle(
                                fontFamily: 'Assistant',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        updateFlag!=true?Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: TextFormField(
                            maxLength: 16,
                            controller: _title,
                            validator: (value) =>
                                (value==" ") ? "שדה שם המאבק חובה" : null,
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
                        ):Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Text(
                             widget.gotStruggle.title,
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
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                          child: TextFormField(
                            controller: _location,
                            validator: (value) =>
                                (value==" ") ? "שדה קישור זה חובה" : null,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                          child: TextFormField(
                            controller: _petition,
                            validator: (value) =>
                                (value==" ") ? "שדה קישור זה חובה" : null,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                          child: TextFormField(
                            controller: _donation,
                            validator: (value) =>
                                (value==" ") ? "שדה קישור זה חובה" : null,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                          child: Container(

                            child: FlatButton(
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
                                    "בחר בתמונה ראשית למאבק",
                                    style: new TextStyle(
                                        fontSize: 25, fontFamily: 'Assistant'),
                                  ),
                                ],
                              ),
                              onPressed: ()async{
                                await pickImage();
                                boolfile1=true;
                              } ,

                            ),
                          ),
                        ),
                        fileName!=' ' ? Padding(
                            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                               child: Container(
                                child: updateFlag==false|| origenfilename!=fileName?Image.file(File(fileName )): Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Card(
                                    elevation: 1,
                                    child: Container(
                                      height:  MediaQuery.of(context).size.height/2/3,
                                      child: Container(
                                        height:  MediaQuery.of(context).size.height/2/4,

                                        child: AspectRatio(
                                          aspectRatio: 16/9,
                                          child:
                                          CachedNetworkImage(
                                            imageUrl: fileName,fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                CircularProgressIndicator(value: downloadProgress.progress),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                               )
                        ):Container(),

                      ],
                    ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Color(int.parse("0xff6ed000")),
                elevation: 5.0,
                //borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(

                  onPressed: () async {
                    print("_donation.text");
                    print(_donation.text);
                    if (_formKey.currentState.validate() &&_donation.text!="" && _petition.text!="" && _location.text!=""&&_title.text.length< 17
                    ) {
                      if (fileName != ' ') {
                        bool nameExist = await CheckNameStruggleExist(
                            _title.text);
                        if (nameExist == false || updateFlag==true) {
                          print(fileName);
                          StruggleModel temp= new StruggleModel(
                            title: _title.text,
                            description1: updateFlag==true? widget.gotStruggle.description1:"w",
                            description2: updateFlag==true? widget.gotStruggle.description2:"w",
                            description3: updateFlag==true? widget.gotStruggle.description3:"w",
                            description4: updateFlag==true? widget.gotStruggle.description4:"w",
                            description5: updateFlag==true? widget.gotStruggle.description5:"w",
                            image5: updateFlag==true? widget.gotStruggle.image5:"w",
                            image4: updateFlag==true? widget.gotStruggle.image4:"w",
                            image3: updateFlag==true? widget.gotStruggle.image3:"w",
                            image2: updateFlag==true? widget.gotStruggle.image2:"w",
                            image1: updateFlag==true? widget.gotStruggle.image1:"w",
                            image:  updateFlag==true && origenfilename==fileName? widget.gotStruggle.image:fileName,
                            share:  _location.text,
                            donation:  _donation.text,
                            petition:  _petition.text,
                            place: -1,
                            time:DateTime.now(),

                          );

//                                    MyForm(struggle:temp,updateflag: updateFlag, origenfilename: origenfilename,)
                          if(!updateFlag){
                            Navigator.push(
                              context,
                              MaterialPageRoute(

                                  builder: (context) =>
                                      MyForm(struggle: temp,)),
                            );


                          }

                          else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(

                                  builder: (context) =>
                                      editImageDes(struggle: temp,boolfile0: boolfile1,)),
                            );
                          }
                        }

                        else{
                          NameStruggleExist(context);
                        }
                      }
                      else{
                        missMainImage(context);
                      }
                    }
                    else{
                      AlertDialogCreateEvent(
                          context, "חובה למלא את כל השדות");
                    }
                  },
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "הוסף פסקאות",
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
      if (Mess == "המאבק נוצר בהצלחה") {
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
    title: Mess != "המאבק נוצר בהצלחה"
        ? Text(
            "שגיאה",
          )
        : Text("מאבק חדש נוצר"),
    content: Text(
      Mess,
      style: TextStyle(color: Colors.black, fontFamily: 'Assistant'),
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
