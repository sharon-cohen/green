import 'package:flutter/material.dart';
import 'package:greenpeace/evants/add_event.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/GetID_DB/getid.dart';
final _firestore = Firestore.instance;
class mass extends StatefulWidget {
  final String sender;
  final String text;
  final String senderId;
  final String  topic;
  mass({this.sender, this.text,this.senderId,this.topic});
  @override
  _massState createState() => _massState();
}

class _massState extends State<mass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(30),
        child: Column(
          children: <Widget> [
            IconButton(
              icon: Icon(
                  Icons.keyboard_arrow_left,
              ),
              iconSize: 30,
              color: Colors.grey,
              splashColor: Colors.purple,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            new Align (child: new Text("מאת "+widget.sender,
              style: new TextStyle(fontSize: 20),), //so big text
              alignment: FractionalOffset.topRight,),
            Divider(
                thickness: 1,
                color: Colors.black
            ),
            new Align (child: new Text("נושא "+widget.topic,

              style: new TextStyle(fontSize: 20),), //so big text
              alignment: FractionalOffset.topRight,),
            Divider(
                thickness: 1,
                color: Colors.black
            ),

            new Align (child: new Text(widget.text,
              style: new TextStyle(fontSize: 15),), //so big text
              alignment: FractionalOffset.topRight,),

      Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              RaisedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(

                        builder: (context) =>
                            AddEventPage (
                           sender: widget.sender,senderId: widget.senderId, )));},
                child: const Text('השב', style: TextStyle(fontSize: 20)),
                color: Colors.blue,
                textColor: Colors.white,
              ),
              RaisedButton(
                onPressed: ()  async {
                    if(globals.isMeneger){
                      String idevent = await  GetMenagerMess(widget.text, widget.sender);
                      await _firestore
                          .collection("messageMenager")
                          .document(idevent)
                          .delete();
                      Navigator.pop(context);
                    }
                    else{
                      String idevent = await GetPersonalMess(widget.text, widget.sender);
                      await _firestore
                          .collection("personalMess")
                          .document(idevent)
                          .delete();
                      Navigator.pop(context);
                    }
                },
                child: const Text('מחק', style: TextStyle(fontSize: 20)),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
          ],
        ),

      ),

    );
  }
}
