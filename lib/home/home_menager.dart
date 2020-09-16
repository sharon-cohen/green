import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:greenpeace/streem_firestore/MessagesStream.dart';
import 'package:greenpeace/home/send_mass_button.dart';
import 'package:greenpeace/streem_firestore/StruggleStream.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/common/Header.dart';
import 'package:greenpeace/create_struggle1.dart';
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
  final _auth = FirebaseAuth.instance;
  bool ok = false;
  bool showSpinner = false;
  double offset = 0;
  bool no_reg=false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<Widget> listOfMass() async {

      return Container(

        child: SingleChildScrollView(

          child:TruggleStream(page_call:'home')
        ),
      );


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

                MyHeader(
                  image: "image/green.jpeg",

                  offset: offset,
                ),


                Card(
                  margin: new EdgeInsets.only( top: 8.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height /18,

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              FlatButton(
                                child: Text("מאבקים",style: TextStyle(fontSize: 20,color: Colors.green.shade900)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BottomNavigationBarController(
                                                3, 0,)));
                                },
                              ),
                              globals.isMeneger?
                              FlatButton(
                                child: Text("מאבק חדש",style: TextStyle(fontSize: 20,color: Colors.green.shade900)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>create_struggle1() ));
                                },
                              ):Container(),
                            ],
                          ),
                        ),
                         new FutureBuilder<Widget>(
                            future: listOfMass(),
                            builder: (BuildContext context, AsyncSnapshot<Widget> text) {
                              return new SingleChildScrollView(
                                padding: new EdgeInsets.all(8.0),
                                child: text.data,
                              );
                            }),

                      ],
                    ),
                  ),
                ),
                Card(
                  margin: new EdgeInsets.only( top: 8.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height /18,

                            child: Text("עידכונים",style: TextStyle(fontSize: 20,color: Colors.green.shade900),),
                          ),
                          Container(child: MessagesStream()),
                          Container(
                            decoration: kMessageContainerDecoration,
                            child: button_send(no_reg: no_reg,),
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
          //final currentUsser = loggedInUser.email;
          final imag_url = message.data["url"];
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            time: messageTime,
            isMe: globals.name == messageSender,
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


