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

//  Widget showImage() {
//    return FutureBuilder<File>(
//      future: file,
//      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//        if (snapshot.connectionState == ConnectionState.done &&
//            null != snapshot.data) {
//          tmpFile = snapshot.data;
//          base64Image = base64Encode(snapshot.data.readAsBytesSync());
//          return Flexible(
//            child: Image.file(
//              snapshot.data,
//              fit: BoxFit.fill,
//            ),
//          );
//        } else if (null != snapshot.error) {
//          return const Text(
//            'Error Picking Image',
//            textAlign: TextAlign.center,
//          );
//        } else {
//          return const Text(
//            'No Image Selected',
//            textAlign: TextAlign.center,
//          );
//        }
//      },
//    );
//  }
  bool _isLoading = true;
  int timestamp;
  var imageFile;
  bool choose=false;
  String  fileUrl;
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
                title: Text("בחר בתמונה",style: new TextStyle(fontSize: 30),),

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

              showImage(fileUrl),

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
              SizedBox(
                height: 20.0,
              ),
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


                        _firestore.collection("struggle").add({
                          "info": _title.text,
                          "name":  _description.text,
                          "petition":_petition.text,
                          "url_image": fileUrl,
                          "url_share": _location.text,
                          "donation":_donation.text,
                        });
                        // successshowAlertDialog(context,_title.text,_description.text,_petition.text,fileUrl,_location.text);
//                        }else{
//
//                          await eventDBS.createItem(EventModel(
//                            title: _title.text,
//                            description: _description.text,
//                            eventDate: _eventDate,
//                            approve: false,
//                            equipment: getCheckboxItems(),
//                            sender: _email(),
//                            senderId: currentUser.uid,
//                            type_event: type_event,
//                            location: _location.text,
//                          ));
//                        }

                        setState(() {
                          processing = false;
                        });
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
successshowAlertDialog(BuildContext context,String title,String text,String petition,String img,String share) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("אישור"),
    onPressed: () {


      Navigator.of(context).pop();
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