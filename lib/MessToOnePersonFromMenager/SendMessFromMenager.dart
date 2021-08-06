import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


final _firestore = Firestore.instance;

class SendOneUser extends StatefulWidget {
  final globals.user User;
  const SendOneUser({Key key, this.User}) : super(key: key);

  @override
  _SendOneUser createState() => _SendOneUser();
}

class _SendOneUser extends State<SendOneUser> {
  final TextEditingController _controller = new TextEditingController();
  FirebaseUser currentUser;
  String fileUrl='';
  bool isLoading=false;
  String str = "";
  String submitStr = "";
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }
  image_sent_pro(BuildContext context, String image_show) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("בטל"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("אישור"),
        onPressed: () {
          fileUrl = image_show;

          setState(() {
            fileUrl = "";

          });
          Navigator.pop(context, true);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("האם לפרסם תמונה זו?"),
      content: CachedNetworkImage(
        imageUrl: image_show,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      actions: [
        continueButton,
        cancelButton,
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
  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  Widget text_field() {
    return TextField(
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
        _controller.text = "";
      },
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

                      Spacer(), // use Spacer
                      IconButton(
                        icon: Icon(
                          Icons.send,
                        ),
                        iconSize: 30,
                        color: Colors.grey,
                        splashColor: Colors.purple,
                        onPressed: () {
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
                          print(widget.User.id);
                          Firestore.instance
                              .collection("users")
                              .document(widget.User.id)
                              .updateData({
                            "personalMessId": FieldValue.arrayUnion(
                                [documentReference.documentID])
                          });

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
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'אל: ' + widget.User.name,
                      ),
                      Divider(thickness: 1, color: Colors.grey[400]),
                      Row(
                        children: [
                          Text('מאת: ',
                              style: new TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(globals.name,
                              style: new TextStyle(
                                fontSize: 20,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                                image_sent_pro(context, fileUrl);
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
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigationBarController(
                    2,
                    2,
                  )));
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
