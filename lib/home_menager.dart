
import 'package:greenpeace/test.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'globalfunc.dart';
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Home_menager extends StatefulWidget {
  Home_menager ({Key key,this.arguments}) : super(key: key);
  static const String id = " home_menager";
  final ScreenArguments_m arguments;

  @override
  Home_menagerState createState() => Home_menagerState();
}

class Home_menagerState extends State<Home_menager> {
  final messageTextContoller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String fileUrl="";
  String messageText;
  bool ok=false;
  bool showSpinner = false;
  image_sent_pro(BuildContext context,String image_show) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = FlatButton(
      child: Text("send"),
      onPressed: () {

        fileUrl = image_show;
        messageTextContoller.clear();
        _firestore.collection("messages").add({
          "text": "",
          "sender": loggedInUser.email,
          "time": DateTime.now(),
          "url": fileUrl,
        });

        Navigator.of(context).pop();
      }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Image.network(image_show),
      actions: [
      cancelButton,
      continueButton,
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
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('My App Title'),
        elevation: 0.0,
      ),
      body:  ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(

          alignment: Alignment.bottomCenter,
          children : <Widget> [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / (18),
                    color: Colors.green,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(child: MessagesStream()),
                        Container(
                          decoration: kMessageContainerDecoration,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: messageTextContoller,
                                  onChanged: (value) {
                                    messageText = value;
                                  },
                                  decoration: kMessageTextFieldDecoration,
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  messageTextContoller.clear();
                                  _firestore.collection("messages").add({
                                    "text": messageText,
                                    "sender": loggedInUser.email,
                                    "time": DateTime.now(),
                                    "url": fileUrl,
                                  });
                                },
                                child: Text(
                                  'Send',
                                  style: kSendButtonTextStyle,
                                ),
                              ),
                              new Container(
                                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                                child: new IconButton(
                                    icon: new Icon(
                                      Icons.photo_camera,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: () async {
                                      var image = await ImagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                                      StorageReference storageReference = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('chats/img_' + timestamp.toString() + '.jpg');
                                      StorageUploadTask uploadTask =
                                      storageReference.putFile(image);

                                      await uploadTask.onComplete;

                                     try {
                                       fileUrl =
                                       await storageReference.getDownloadURL();
                                       image_sent_pro(context, fileUrl);

                                         showSpinner = false;

                                     }
                                     catch (e) {
                                       print('error');
                                     }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / (18),
                    color: Colors.green,
                  ),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                            height: MediaQuery.of(context).size.height / (3),
                            width: MediaQuery.of(context).size.width / (2.5),
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                            height: MediaQuery.of(context).size.height / (3),
                            width: MediaQuery.of(context).size.width / (2.5),
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                            height: MediaQuery.of(context).size.height / (3),
                            width: MediaQuery.of(context).size.width / (2.5),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data["sender"];
          final messageTime = message.data["time"];
          final currentUsser = loggedInUser.email;
          final imag_url= message.data["url"];
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            time: messageTime,
            isMe: currentUsser == messageSender,
            image_u: imag_url,
          );
          messageBubbles.add(messageBubble);
          messageBubbles.sort((a, b) => b.time.compareTo(a.time));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp time;
  final bool isMe;
  final String image_u;
  MessageBubble({this.sender, this.text, this.isMe, this.time,this.image_u});


  Widget nassege(){

   if(image_u=="")
     {
       return Material(
         borderRadius: isMe
             ? BorderRadius.only(
           topLeft: Radius.circular(30),
           bottomLeft: Radius.circular(30),
           bottomRight: Radius.circular(30),
         )
             : BorderRadius.only(
           topRight: Radius.circular(30),
           bottomLeft: Radius.circular(30),
           bottomRight: Radius.circular(30),
         ),
         elevation: 5.0,
         color: isMe ? Colors.lightBlueAccent : Colors.purpleAccent,
         child: Padding(
           padding: EdgeInsets.symmetric(
             vertical: 10,
             horizontal: 20,
           ),
           child: Column(
             children:<Widget>[
               Text(
                 text,
                 style: TextStyle(
                   fontSize: 15,
                   color: Colors.white,
                 ),
               ),

             ],
           ),
         ),
       );

     }
   else
     return Container(
         height:100,
         width: 100,
         decoration: new BoxDecoration(
             image: new DecorationImage(
               image: new NetworkImage(image_u),
               fit: BoxFit.fill,
             )
         )
     );
 }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children :<Widget>[
              Text(
              "$sender ${time.toDate()}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
           Container(
             child: GestureDetector(
               onTap: () =>
                   DialogUtils.showCustomDialog(context,
                       title: "אתה בטוח רוצה לדווח על הודעה זו למנהל?",
                       okBtnText: "דווח",
                       cancelBtnText: "ביטול",
                      text:text,
                      sender:sender,
                       image_u:image_u,
    ),
               child:  Container(
                   height:25,
                   width: 25,
                   decoration: new BoxDecoration(
                       image: new DecorationImage(
                         image: new AssetImage('image/report.png'),
                         fit: BoxFit.fill,
                       )
                   )
               ),
             ),

           ),
            ],
    ),
         nassege()
        ],
      ),
    );
  }
}



class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {@required String title,
        String okBtnText = "Ok",
        String cancelBtnText = "Cancel",
 String text,@required String sender,String image_u}) {

    Future movetoreport()async{
      String mass_id=await GetExistMass(sender,text,image_u);
      if(mass_id=='not exist'){
        print("not exist");

      }
    else{

        await movedoc(uid: mass_id).updateUserData(sender,text,image_u);
        Navigator.pop(context);
    }

    }

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content:Container(),
            actions: <Widget>[
              FlatButton(
                child: Text(okBtnText),
             onPressed: () {
                  movetoreport();
             },
              ),
              FlatButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }
}