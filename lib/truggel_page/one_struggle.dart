import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:greenpeace/common/Header.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:screenshot/screenshot.dart';
final databaseReference = Firestore.instance;


class one_struggle extends StatefulWidget {
  final StruggleModel struggle;
  one_struggle({this.struggle});
  @override
  _one_struggle createState() => _one_struggle();
}

class _one_struggle extends State<one_struggle> {
  FirebaseUser currentUser;
  ScreenshotController screenshotController = ScreenshotController();
  double offset=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


       body:SingleChildScrollView(
         child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              MyHeader(
                image: widget.struggle.image,
                page:"struggle",
                offset: offset,
              ),

            
              new Align(
                child: new Text(
               widget.struggle.title,
                  style: new TextStyle(fontSize: 30),
                ), //so big text
                alignment: FractionalOffset.topRight,
              ),
               Expanded(

                 child: Align(
                  child: new Text(
                    widget.struggle.description,
                    style: new TextStyle(fontSize: 20),
                  ), //so big text
                  alignment: FractionalOffset.topRight,
              ),
               ),

            ],
          ),
      ),
       ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            
            Expanded(
              child: IconButton(icon: Icon(Icons.share), onPressed:() {
                FlutterShareMe().shareToFacebook(
                    url: widget.struggle.share, msg: "הצטרפו למאבק!");



              },),
            ),

            Expanded(
              child: IconButton(
                  icon: Icon(
                    Icons.border_color,
                  ),
                  iconSize: 30,
                  color: Colors.grey,
                  splashColor: Colors.purple,
                  onPressed:(){ _launchURL(widget.struggle.petition);}
              ),
            ),

            Expanded(
              child: IconButton(
                  icon: Icon(
                    Icons.all_inclusive,
                  ),
                  iconSize: 30,
                  color: Colors.grey,
                  splashColor: Colors.purple,
                  onPressed:(){ _launchURL(widget.struggle.donation);}
              ),
            ),

          ],
        ),
      ),
    );
  }
}


_launchURL(String url) async {

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
