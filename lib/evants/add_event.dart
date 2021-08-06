import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:greenpeace/global.dart' as globals;
import 'event_model.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
final _firestore = Firestore.instance;

class AddEventPage extends StatefulWidget {
  final String sender;
  final String senderId;
  const AddEventPage({Key key, this.sender, this.senderId}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _controller = new TextEditingController();
  FirebaseUser currentUser;
  bool isLoading=false;
  String fileUrl="";
  String str = "";
  String submitStr = "";
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  Widget text_field() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: "תוכן ההודעה",
        ),
        onChanged: (String value) {
          submitStr = value;
        },
        controller: _controller,
        onSubmitted: (String submittedStr) {
          _controller.text = submittedStr;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          automaticallyImplyLeading: false),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 16,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.clear),
                        iconSize: 30,
                        color: Colors.grey,
                        splashColor: Colors.purple,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      Spacer(),
                      globals.isMeneger
                          ? Text(
                              'תשובה',
                              style: new TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Assistant'),
                            )
                          : Text(
                              'הודעה למנהלים',
                              style: new TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Assistant'),
                            ),

                      Spacer(), // use Spacer
                      IconButton(
                        icon: Icon(
                          Icons.send,
                        ),
                        iconSize: 30,
                        color: Colors.grey,
                        splashColor: Colors.purple,
                        onPressed: () {
                          if (globals.isMeneger == false) {
                            _firestore.collection("messageMenager").add({
                              "text": '$submitStr',
                              "sender": globals.name,
                              "time": DateTime.now(),
                              "senderID": currentUser.uid,
                            });
                          } else {
                            DocumentReference documentReference = Firestore
                                .instance
                                .collection("personalMess")
                                .document();
                            documentReference.setData({
                              "text": '$submitStr',
                              "sender": globals.name,
                              "time": DateTime.now(),
                              "senderID": currentUser.uid,
                            });

                            print('widget.senderId');
                            print(widget.senderId);
                            Firestore.instance
                                .collection("users")
                                .document(widget.senderId)
                                .updateData({
                              "personalMessId": FieldValue.arrayUnion(
                                  [documentReference.documentID])
                            });
                          }

                          showAlertDialog_mess_send(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: globals.isMeneger
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Text('אל: ' + widget.sender,
                                      style: new TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Text(
                                    'אל: מנהלים',
                                    style: new TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ),
                      Divider(thickness: 1, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: globals.isMeneger
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text('מאת: מנהלים',
                                    style: new TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'מאת: ' + globals.name,
                                  style: new TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider(thickness: 1, color: Colors.black),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    new IconButton(
                        padding:  EdgeInsets.only(top:10,bottom: 10,left: 10),
                        constraints: BoxConstraints(),
                        icon: new Icon(
                          Icons.photo_camera,
                          color: Color(int.parse("0xff6ed000")),
                        ),
                        onPressed: () async {
                          if(globals.no_reg==true){
                            GoregisterAlertDialog(context);
                          }
                          else{

                            var image =
                            await ImagePicker.pickImage(source: ImageSource.camera);
                            int timestamp = new DateTime.now().millisecondsSinceEpoch;
                            StorageReference storageReference = FirebaseStorage.instance
                                .ref()
                                .child('chats/img_' + timestamp.toString() + '.jpg');
                            StorageUploadTask uploadTask = storageReference.putFile(image);
                            setState(() {
                              isLoading = true;
                            });
                            await uploadTask.onComplete;

                            try {
                              fileUrl = await storageReference.getDownloadURL();

                              setState(() {
                                isLoading = false;

                                _firestore.collection("messages").add({
                                  "text": "",
                                  "sender": globals.name,
                                  "time": DateTime.now(),
                                  "url": fileUrl,
                                });
                                setState(() {
                                  fileUrl = "";

                                });
                              });
                            } catch (e) {
                              print('errordfd');
                            }

                          }

                        }),

                    new IconButton(
                        padding:  EdgeInsets.only(top:10,bottom: 10,left: 2),
                        constraints: BoxConstraints(),
                        icon: new Icon(

                          Icons.upload_file,
                          color: Color(int.parse("0xff6ed000")),
                        ),
                        onPressed: () async {
                          if(globals.no_reg==true){
                            GoregisterAlertDialog(context);
                          }
                          else{

                            var image =
                            await ImagePicker.pickImage(source: ImageSource.gallery);
                            int timestamp = new DateTime.now().millisecondsSinceEpoch;
                            StorageReference storageReference = FirebaseStorage.instance
                                .ref()
                                .child('chats/img_' + timestamp.toString() + '.jpg');
                            StorageUploadTask uploadTask = storageReference.putFile(image);
                            setState(() {
                              isLoading = true;
                            });
                            await uploadTask.onComplete;

                            try {
                              fileUrl = await storageReference.getDownloadURL();

                              setState(() {
                                isLoading = false;

                                _firestore.collection("messages").add({
                                  "text": "",
                                  "sender": globals.name,
                                  "time": DateTime.now(),
                                  "url": fileUrl,
                                });
                                setState(() {
                                  fileUrl = "";

                                });
                              });
                            } catch (e) {
                              print('errordfd');
                            }
                          }

                        }),

                  ],
                ),
              ),
              Padding(
                //padding: const EdgeInsets.all(8.0),
                padding: EdgeInsets.fromLTRB(8, 1, 8, 8),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.87,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                    child: text_field(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

showAlertDialog_mess_send(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "אישור",
      style: TextStyle(
        fontFamily: 'Assistant',
        color: Colors.black,
      ),
    ),
    onPressed: () {
      Navigator.pop(context, true);
      Navigator.pop(context, true);

    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("נשלח"),
    content: Text("ההודעה נשלחה בהצלחה"),
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
