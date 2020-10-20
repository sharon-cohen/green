import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/evants/add_event.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
import 'package:greenpeace/personal_massage/manage_massage.dart';

final _firestore = Firestore.instance;

class mass extends StatefulWidget {
  final String sender;
  final String text;
  final String senderId;
  final String topic;
  final bool MessForAll;
  mass({this.sender, this.text, this.senderId, this.topic,this.MessForAll});
  @override
  _massState createState() => _massState();
}

class _massState extends State<mass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              //todo
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Text(
                        "פניות",
                        style: new TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Assistant',
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                        ),
                        iconSize: 30,
                        color: Colors.black,
                        splashColor: Colors.purple,
                        onPressed: () {
                          Navigator.pop(context, true);
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
                        child: Row(
                          children: [
                            new Text(
                              "מאת: ",
                              style: new TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Assistant',
                              ),
                            ),
                            new Text(widget.sender,
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Assistant',
                                )),
                          ],
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Row(
                          children: [
                            new Text("נושא: ",
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Assistant',
                                )),
                            new Text(widget.topic,
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Assistant',
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                    child: new Text(
                      widget.text,
                      style: new TextStyle(
                        fontSize: 20,
                        fontFamily: 'Assistant',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              //color: Color(int.parse("0xff6ed000")),
                              decoration: BoxDecoration(
                                color: Color(int.parse("0xff6ed000")),
                                //border: Border.all(color: Colors.grey[600])
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'image/reply.png',
                                          color: Colors.white,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text('השב ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontFamily: 'Assistant',
                                            )),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddEventPage(
                                                sender: widget.sender,
                                                senderId: widget.senderId,
                                              )));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(

                              decoration: BoxDecoration(
                                //border: Border.all(color: Colors.grey[600]),
                                color: Colors.black87,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'image/delete.png',
                                          color: Colors.white,
                                          width: 30,
                                          height: 30,
                                        ),
                                        Text('מחק',
                                            style: TextStyle(
                                              fontFamily: 'Assistant',
                                              fontSize: 20,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                    onPressed: () async{
                                      await showDialog(
                                          child: new Dialog(
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              child: new Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.fromLTRB(
                                                              5, 0, 5, 0),
                                                          child:
                                                          Icon(Icons.delete_forever),
                                                        ),
                                                        Text('האם למחוק הודעה זו?',
                                                            style: TextStyle(
                                                              fontFamily: 'Assistant',
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Row(
                                                    children: [
                                                      Spacer(),
                                                      new FlatButton(
                                                        child: new Text("מחק",
                                                            style: TextStyle(
                                                              fontFamily: 'Assistant',
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                            )),
                                                        onPressed: () async {
                                                          if (globals.isMeneger) {
                                                            String idevent =
                                                            await GetMenagerMess(
                                                                widget.text,
                                                                widget.sender);
                                                            await _firestore
                                                                .collection(
                                                                "messageMenager")
                                                                .document(idevent)
                                                                .delete();
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          } else {
                                                           if(widget.MessForAll==false) {
                                                             String idevent =
                                                             await GetPersonalMess(
                                                                 widget.text,
                                                                 widget.sender);
                                                             await _firestore
                                                                 .collection(
                                                                 "personalMess")
                                                                 .document(
                                                                 idevent)
                                                                 .delete();

                                                           }
                                                            else{
                                                            print("here");
                                                             String idMessForAll =
                                                             await GetMessToAll(
                                                                 widget.text,
                                                                 widget.sender);
                                                             Firestore.instance
                                                                 .collection("users")
                                                                 .document(globals.UserId)
                                                                 .updateData({
                                                               "personalMessIdDeleted": FieldValue.arrayUnion(
                                                                   [idMessForAll]),
                                                             });
                                                           }
                                                           Navigator.pushNamed(
                                                               context, Allmess.id
                                                               );

                                                          }
                                                        },
                                                      ),
                                                      new FlatButton(
                                                        child: new Text("בטל",
                                                            style: TextStyle(
                                                              fontFamily: 'Assistant',
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                            )),
                                                        onPressed: () {
                                                          Navigator.pop(context, true);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          context: context);
                                    },
                                  ),
                                  // SizedBox(width: 200),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
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
