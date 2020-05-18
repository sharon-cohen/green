import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'footer.dart';
import 'register.dart';
import 'Component/Alret_Dealog.dart';
import 'streem_firestore/MessagesStream.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Home_menager extends StatefulWidget {
  Home_menager({Key key, this.arguments}) : super(key: key);
  static const String id = " home_menager";
  final ScreenArguments_m arguments;

  @override
  Home_menagerState createState() => Home_menagerState();
}

class Home_menagerState extends State<Home_menager> {
  final messageTextContoller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String fileUrl = "";
  String messageText;
  bool ok = false;
  bool showSpinner = false;
  bool try_send=false;
  List<Widget> mass=[];
bool no_reg=false;
  image_sent_pro(BuildContext context, String image_show) {
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
        });

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

      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
      if(user==null){
        no_reg=true;

      }


  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }
  List<Widget> send_botton(){
  print('wiget.reg');
    print(no_reg);
    mass.clear();
    if(try_send==false){
   mass.add(  Align(
     alignment: Alignment.centerLeft,
     child: FlatButton(
       onPressed: (){
         setState(() {
           try_send=true;
          if(no_reg==true){ DialogUtils.showCustomDialog(
            context,
            title: "לא ניתן לעלות הודעה ללא הרשמה רוצה להירשם?",
            okBtnText: "הירשם",
            cancelBtnText: "חזור",
            sender: "",
          );}

         });
       },
       child: Container(
         child: Text('שלח הודעה',textAlign: TextAlign.center,),
       ),
     ),
   ),);
      return mass;
  }
  else{

    if(no_reg==true){
      mass.add(FlatButton(
          onPressed: (){
            Navigator.pushNamed(context, RegistrationScreen.id);

          },
          child: Text('הירשם')),) ;
    return mass;
    }

    else{
      mass.add(Expanded(
        child: TextField(
          controller: messageTextContoller,
          onChanged: (value) {
            messageText = value;
          },
          decoration: kMessageTextFieldDecoration,
        ),
      ),);
      mass.add( FlatButton(
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
      ),);
      mass.add( new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0),
        child: new IconButton(
            icon: new Icon(
              Icons.photo_camera,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () async {

              var image = await ImagePicker.pickImage(
                  source: ImageSource.gallery);
              int timestamp = new DateTime.now()
                  .millisecondsSinceEpoch;
              StorageReference storageReference =
              FirebaseStorage.instance.ref().child(
                  'chats/img_' +
                      timestamp.toString() +
                      '.jpg');
              StorageUploadTask uploadTask =
              storageReference.putFile(image);

              await uploadTask.onComplete;

              try {
                fileUrl = await storageReference
                    .getDownloadURL();
                image_sent_pro(context, fileUrl);

                showSpinner = false;
              } catch (e) {
                print('errordfd');
              }
            }),
      ),);
      return mass;
    }

  }


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              children: ListTile.divideTiles(context: context, tiles: [
            new Container(
              margin: new EdgeInsets.only(left:0, right: 0, top: 0, bottom: 5.0),
              height: MediaQuery.of(context).size.height / (2.5),
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage('image/green.jpeg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            Card(
                margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height /18,
                      color: Colors.green.shade300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          FlatButton(
                            child: Text("מאבקים",style: TextStyle(fontSize: 20,color: Colors.white)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavigationBarController(
                                              widget.arguments, 2, 0,)));
                            },
                          ),
                         FlatButton(
                            child: Text("מאבק חדש",style: TextStyle(fontSize: 20,color: Colors.white)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavigationBarController(
                                              widget.arguments, 4, 0,)));
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(child: TruggleStream('home')),
                    ],
                  ),
                ),
            ),

            Card(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                     Container(
                       height: MediaQuery.of(context).size.height /18,
                     color: Colors.green.shade300,
                       child: Text("feed",style: TextStyle(fontSize: 30,color: Colors.white),),
                     ),
                      Container(child: MessagesStream()),
                      Container(
                        decoration: kMessageContainerDecoration,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                           send_botton(),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
              ]).toList(),
            ),
          ],
        ),
      ),
    );
  }
}


class TruggleStream extends StatelessWidget {
  final String page_call;
  TruggleStream(this.page_call);
  List<TtuggleContainer> TtuggleContainers = [];
  List<All_TtuggleContainer> ALL_TtuggleContainers = [];
  Widget result_stream() {
    if (page_call == 'home') {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(top: 20),
          child: Row(
            children: TtuggleContainers,
          ),
        ),
      );
    }
    if (page_call == 'all_struggle') {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: ALL_TtuggleContainers,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("struggle").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final truggls = snapshot.data.documents;
        for (var truggl in truggls) {
          final trugglNmae = truggl.data["name"];
          final imag_url = truggl.data["url_image"];
          final info = truggl.data["info"];
          final messageTime = truggl.data["time"];
          final sign_target = truggl.data["name"];
          final url_money = truggl.data["url_money"];
          final sign_num = truggl.data["sign_num"];
          final All_TtuggleContainer_new = All_TtuggleContainer(
            name: trugglNmae,
            image_u: imag_url,
            info: info,
            sign_num: sign_num,
            url_money: url_money,
            sign_target: sign_target,
          );
          final TtuggleContainer_new = TtuggleContainer(
            name: trugglNmae,
            image_u: imag_url,
            time: messageTime,
          );
          TtuggleContainers.add(TtuggleContainer_new);
          ALL_TtuggleContainers.add(All_TtuggleContainer_new);
          TtuggleContainers.sort((a, b) => b.time.compareTo(a.time));
        }

        return result_stream();
      },
    );
  }
}

class TtuggleContainer extends StatefulWidget {
  final Timestamp time;
  final String name;
  final String image_u;
  TtuggleContainer({this.name, this.image_u,this.time});
  @override
  _TtuggleContainerState createState() => _TtuggleContainerState();
}

class _TtuggleContainerState extends State<TtuggleContainer> {
  final _auth = FirebaseAuth.instance;
  String  button_heart='image/heart.png';
  void inputlike() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    Firestore.instance.collection("users").document(uid).updateData({"likes": FieldValue.arrayUnion([widget.name])});

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
      height: MediaQuery.of(context).size.height / (3.5),
      width: MediaQuery.of(context).size.width / (2.5),
      child: Column(
        children: <Widget>[
          new Expanded(
              flex: 4,
              child: Container(
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image:widget.image_u != null
                        ? NetworkImage(widget.image_u)
                        : AssetImage('image/image_icon.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              )),
          new Expanded(
              flex: 1,
              child: Container(
                color: Colors.green.shade200,
                width: MediaQuery.of(context).size.width / (2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.name),
                    FlatButton(
                      onPressed: () async {
                       setState(() {
                         button_heart='image/heart_red.png';
                       });
                        inputlike();
                      },
                      child: Image.asset(button_heart),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}




class All_TtuggleContainer extends StatelessWidget {
  final String name;
  final String image_u;
  final String info;
  final String sign_target;
  final String url_money;
  final String sign_num;
  All_TtuggleContainer(
      {this.name,
        this.image_u,
        this.info,
        this.sign_target,
        this.url_money,
        this.sign_num});
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      child: Container(
        child: SimpleFoldingCell(
          key: _foldingCellKey,
          frontWidget: FrontWidget(),
          innerTopWidget: InnerTopWidget(),
          innerBottomWidget: InnerBottomWidget(),
          cellSize: Size(MediaQuery.of(context).size.width, 160),
          padding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Container InnerTopWidget() {
    return Container(
        color: Colors.green.shade200,
        child: Text(name,
            style: TextStyle(
                color: Color(0xFF2e282a),
                fontFamily: 'OpenSans',
                fontSize: 20.0,
                fontWeight: FontWeight.w800)));
  }

  Container InnerBottomWidget() {
    return Container(
      color: Colors.green.shade100,
      child: FlatButton(
        onPressed: () => _foldingCellKey?.currentState?.toggleFold(),
        child: Text(
          "Close",
        ),
        textColor: Colors.white,
        color: Colors.green.shade100,
        splashColor: Colors.white.withOpacity(0.5),
      ),
    );
  }

  Container FrontWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image_u != null
                      ? NetworkImage(image_u)
                      : AssetImage('image/image_icon.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.shade200,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(name,
                        style: TextStyle(
                            color: Color(0xFF2e282a),
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800)),
                    Align(
                      child: FlatButton(
                        onPressed: () =>
                            _foldingCellKey?.currentState?.toggleFold(),
                        child: Text(
                          "Open",
                        ),
                        textColor: Colors.white,
                        color: Colors.indigoAccent,
                        splashColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                )),
          ),
        ],
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
              backgroundColor: Colors.green,
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
          final imag_url = message.data["url"];
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