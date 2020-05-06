import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
final _firestore = Firestore.instance;

class create_struggle1 extends StatefulWidget {
  create_struggle1({Key key, this.arguments}) : super(key: key);
  static const String id = " create_struggle1";
  final ScreenArguments_m arguments;

  @override
  create_struggle1State createState() => create_struggle1State();
}

class create_struggle1State extends State<create_struggle1> {
 var ref;
  String name;
  String info;
  String target_saign_num;
  String target_saign;
  String name_event;
  String event_type;
  String event_parti;
  String _event_logist;
  String _event_whatsap;
  String money;
  String imagePath;
  Image image;
  int _selectedIndex = 0;
  final FocusNode _FocusNode1 = new FocusNode();
  final FocusNode _FocusNode2  = new FocusNode();
  final FocusNode _FocusNode3 = new FocusNode();
  final FocusNode _FocusNode4  = new FocusNode();
  final FocusNode _FocusNode5  = new FocusNode();
  final FocusNode _FocusNode6 = new FocusNode();
  final FocusNode _FocusNode7  = new FocusNode();
  final FocusNode _FocusNode8 = new FocusNode();
  final FocusNode _FocusNode9  = new FocusNode();
  final FocusNode _FocusNode10  = new FocusNode();
  Widget text_field(String  title,final FocusNode focus){
    return TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1,//Normal textInputField will be displayed
      maxLines: 5,// when user presses enter it will adapt to it
      focusNode: focus,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.right,
      decoration: InputDecoration(hintText:  title),
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus( focus),
      onChanged: (value) {
       if(title=="שם מאבק"){
         name=value;
       }
       if(title=="מידע כללי"){
         info=value;
       }
       if(title=="יעד לחתימות"){
        target_saign_num=value;
       }
       if(title=="יעד הפעלת הלחץ"){
        target_saign=value;
       }
       if(title=="שם האירוע"){
       name_event=value;
       }

       if(title=="סוג האירוע"){
        event_type=value;
       }
       if(title=="מספר משתתפים רצוי"){
         event_parti=value;
       }
        if(title=="צרכים לוגיסטיים"){
          _event_logist=value;
        }
       if(title=="קישור לקבוצת WhatsAp"){
         _event_whatsap=value;
       }
        if(title=="קישור לתרומה"){
           money=value;
        }

        },
    );



  }
  int currStep = 0;




  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Log Out '),
              ),
              new Stepper(
                type: StepperType.vertical,
                currentStep: this.currStep,
                onStepContinue: () {
                  setState(() {
                    if (currStep < 2 - 1) {
                      currStep = currStep + 1;
                    } else {
                      currStep = 0;
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (currStep > 0) {
                      currStep = currStep - 1;
                    } else {
                      currStep = 0;
                    }
                  });
                },
                onStepTapped: (step) {
                  setState(() {
                    currStep = step;
                  });
                },
                steps: [
                  Step(
                    title: const Text('מידע כללי'),
                    isActive: true,
                    state: StepState.editing,
                    content:Column(
                      children: <Widget>[
                        text_field("שם מאבק",_FocusNode1),
                        text_field("מידע כללי",_FocusNode2),
                      ],
                    ),


                  ),
                  Step(
                    title: const Text('עצומה'),
                    isActive: true,
                    state: StepState.editing,
                    content:Column(
                      children: <Widget>[
                        text_field("יעד לחתימות",_FocusNode3),
                        text_field("יעד הפעלת הלחץ",_FocusNode4),
                      ],
                    ),


                  ),
                  Step(
                    title: const Text('יצירת אירוע'),
                    isActive: true,
                    state: StepState.editing,
                    content:Column(
                      children: <Widget>[
                        text_field("שם אירוע ",_FocusNode5),
                        text_field("סוג האירוע",_FocusNode6),
                        text_field("מספר משתתפים רצוי",_FocusNode7),
                        text_field("צרכים לוגיסטיים",_FocusNode8),
                        text_field("קישור לקבוצת WhatsAp",_FocusNode9),
                      ],
                    ),


                  ),
                  Step(
                    title: const Text('תרומה'),
                    isActive: true,
                    state: StepState.editing,
                    content:Column(
                      children: <Widget>[

                        text_field("קישור לתרומות",_FocusNode10),
                      ],
                    ),


                  ),
                ],
              ),
              new RaisedButton(
                child: new Text(
                  'שמור',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () async{
                  DocumentReference docRef = await
                  Firestore.instance.collection("struggle").add({
                    "name": name,
                    "info": info,
                    "sign_num": target_saign_num,
                    "sign_target": target_saign,
                    "url_money": money,

                  });
                 ref= docRef.documentID;
                 print("id");
                 print(ref);
                  await _dialogCall(context,ref);
                },
                color: Colors.blue,

              ),

            ],
          ),
        ),
      ),

    );
  }
  Future<void> _dialogCall(BuildContext context,String ref_id) {
    return showDialog(
        context: context,
        builder: (BuildContext context,) {
          return MyDialog(ref_id: ref_id,);
        });
  }
}

class MyDialog extends StatefulWidget {
  MyDialog({@required this.ref_id});
  final  ref_id;
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool _isLoading = true;
  int timestamp;
  var imageFile;
  bool choose=false;
  String  fileUrl;
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile =  ImagePicker.pickImage(
          source: ImageSource.gallery);
       timestamp = new DateTime.now().millisecondsSinceEpoch;
    });
  }

 Widget viwe(){
    if(choose==false){
      return  new SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              RaisedButton(
                child: Text("Select Image from Gallery"),
                onPressed: () async{
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

                },
              ),


              RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  print("id2");
                  print(widget.ref_id);
                  Firestore.instance
                      .collection("struggle")
                      .document(widget.ref_id)
                      .updateData({
                    "url_image":fileUrl,
                  });
                setState(() {

                  choose=true;
                });
                  },
              ),
            ],
          ),
        ),
      );

    }
    else return Container(
      child: Column(children: <Widget>[
        Image.asset("image/approv.png"),
        Text("מאבק נוצר בהצלחה"),

      ],),

    );

 }

  Widget showImage(String image) {

   if(image==null){
     return Container();
   }
   else{ return Image.network(image);}


  }


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Column(
        children: <Widget>[
          viwe(),

          showImage(fileUrl),
        ],

      ),


      actions: <Widget>[
        FlatButton(
            child: Text('Switch'),
            onPressed: () => setState(() {

            }))
      ],

    );
  }




}