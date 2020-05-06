import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

var kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: OutlineInputBorder(borderSide:
  BorderSide(color: Colors.green),
  borderRadius: BorderRadius.circular(10),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    //top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
class ScreenArguments_m {
  final String idname;
  final String role;
  final String name;
  ScreenArguments_m(this.idname, this.name, this.role);
}
Future<String> GetExistMass(String email,String text,String image) async {
  if(text==""){
    final QuerySnapshot result = await Firestore.instance
        .collection('masseges')
        .where('sender', isEqualTo: email)
        .where('url', isEqualTo: image)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 1)
      return documents[0].documentID;
    else
      return "not exist";

  }
else {
    final QuerySnapshot result = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: email)
        .where('text', isEqualTo: text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length == 1)
      return documents[0].documentID;
    else
      return "not exist";
  }
}
class movedoc {
  final String uid;

  movedoc({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection(
      'report');

  Future updateUserData(String sender, String text, String url) async {
    return await userCollection.document(uid).setData({
      'sender': sender,
      'text': text,
      'url': url,
    });
  }
}


class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.colour, @required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


final _firestore = Firestore.instance;
class TruggleStream extends StatelessWidget {
  final  String page_call;
  TruggleStream(this.page_call);
  List<TtuggleContainer> TtuggleContainers = [];
  List<All_TtuggleContainer> ALL_TtuggleContainers = [];
  Widget result_stream(){
  if(page_call=='home'){
    return   Align(
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
  if(page_call=='all_struggle'){
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
          final info=truggl.data["info"];
          final sign_target = truggl.data["name"];
          final url_money = truggl.data["url_money"];
          final sign_num=truggl.data["sign_num"];
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
          );
          TtuggleContainers.add(TtuggleContainer_new);
          ALL_TtuggleContainers.add(All_TtuggleContainer_new);
          // messageBubbles.sort((a, b) => b.time.compareTo(a.time));
        }

       return result_stream();

      },
    );
  }
}
class TtuggleContainer extends StatelessWidget {
  final String name;
  final String image_u;
  TtuggleContainer({this.name, this.image_u});

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
                    image: new NetworkImage(image_u),
                    fit: BoxFit.fill,
                  ),

                ),
              )
          ),
          new Expanded(
              flex: 1,
              child: Container(
                color: Colors.green.shade200,
                width: MediaQuery.of(context).size.width / (2.5),
                child: Text(name),
              )
          ),
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
  All_TtuggleContainer({this.name, this.image_u,this.info,this.sign_target,this.url_money,this.sign_num});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 3, 0, 5),
      height: MediaQuery.of(context).size.height / (5),
      width: MediaQuery.of(context).size.width ,
      child: Row(
        children: <Widget>[
          new Expanded(

              child: Container(
               height: 100,
                width: 100,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new NetworkImage(image_u),
                    fit: BoxFit.fill,
                  ),

                ),
              )
          ),
          new Expanded(

              child: Container(
                height: MediaQuery.of(context).size.height / (5),
                color: Colors.green.shade200,
                child: Text(name),
              )
          ),
        ],
      ),
    );
  }
}