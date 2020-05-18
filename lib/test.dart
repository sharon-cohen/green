import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
class report extends StatefulWidget {
  report({Key key,this.arguments}) : super(key: key);
  static const String id = " report";
  final ScreenArguments_m arguments;

  @override
  reportState createState() => reportState();
}

class reportState extends State<report> {
  var height_page;
  var width_page;
  height_width(){
     height_page=MediaQuery.of(context).size.height;
  width_page= MediaQuery.of(context).size.width;
  }
  @override
  Widget build(BuildContext context) {
    height_width();
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: new AppBar(
        title: new Text('My App Title'),
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            SingleChildScrollView(
              child: reportStream(),


//              child: Column(
//                children: <Widget>[
//                  Container(
//                    height: MediaQuery.of(context).size.height / (18),
//                    color: Colors.green,
//                  ),
//                  Container(
//                    height: MediaQuery.of(context).size.height ,
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//                        Container(child: reportStream(height_page: height_page,width_page: width_page,)),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
            ),
          ],
        ),
      ),
    );
  }
}
class reportStream extends StatelessWidget {
  reportStream({this.width_page,this.height_page});
final height_page;
final width_page;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("report").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final reports = snapshot.data.documents;
        List<ReportsContainer> reportsContainers = [];
        for (var report in reports) {
          final messageText = report.data["text"];
          final messageSender = report.data["sender"];
          final messageImage = report.data["url"];
          final reportsContainer =ReportsContainer(
            sender: messageSender,
            text: messageText,
            image_u: messageImage,
            height_page: height_page,
            width_page: width_page,
          );
          reportsContainers.add( reportsContainer);
        //  reports.sort((a, b) => b.time.compareTo(a.time));
        }
        return ListView(
          shrinkWrap: true,

          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          children: reportsContainers,
        );
      },
    );
  }
}
class ReportsContainer extends StatelessWidget {
  final String sender;
  final String text;
  final String image_u;
  var height_page;
  var width_page;
  ReportsContainer({this.sender, this.text, this.image_u,this.height_page,this.width_page});
  Widget thereport(){
    if(image_u!=''){
      return Container(
        height:100,
          width: 100,
          decoration: new BoxDecoration(image: new DecorationImage(
               image: new NetworkImage(image_u),
               fit: BoxFit.fill,
             )
          )
     );
    }
    else{
      return Text(text,style: TextStyle(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(

        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.receipt, color: Colors.white),
        ),
        title: Text(
         sender,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Text('message:  ',style: TextStyle(color: Colors.white30)),
            thereport(),
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
  }
}
