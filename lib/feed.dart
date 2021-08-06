  import 'package:flutter/material.dart';
import 'package:greenpeace/streem_firestore/MessagesStream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/home/send_mass_button.dart';
import 'package:greenpeace/globalfunc.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
      body: Card(
        margin:
            new EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Container(
                  //  height: MediaQuery.of(context).size.height / 18,
                  child: Row(
                    children: [
                      Text(
                        "עדכונים",
                        style: TextStyle(
                            fontFamily: 'Assistant',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Spacer(),
                      ImageIcon(
                        AssetImage("image/feed1.png"),
                        color: Colors.black,
                        // color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Text(
                  'כאן ניתן לשתף את האהבה והדאגה שלנו לסביבה',
                  style: TextStyle(
                    fontFamily: 'Assistant',
                  ),
                ),
                SizedBox(height: 15),
                Container(child: MessagesStream()),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: !globals.no_reg?button_send(
                    no_reg: globals.no_reg,
                  ):null,
                ),
              ],
            ),
          ),
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
