import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/register.dart';
import 'package:greenpeace/globalfunc.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {@required String title,
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      String text,
      @required String sender,
      String image_u,
      int flage_report}) {
    Future movetoreport(String text) async {
      String mass_id = await GetExistMass(sender, text, image_u);
      if (mass_id == 'not exist') {
        print("not exist");
      } else {}
    }

    Future doesNameAlreadyExist(String text_or_image, bool is_image) async {
      final _firestore = Firestore.instance;
      if (is_image == true) {
        final QuerySnapshot result = await Firestore.instance
            .collection('messages')
            .where('url', isEqualTo: text_or_image)
            .limit(1)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        await Firestore.instance
            .collection('messages')
            .document(documents[0].documentID)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            final image = documentSnapshot.data['url'];
            print(image.toString());
            final text = documentSnapshot.data['text'];

            final sender = documentSnapshot.data['sender'].toString();
            print(sender.toString());
            final time = documentSnapshot.data['time'];
            _firestore.collection('report').add({
              "text": text,
              "sender": sender,
              "time": time,
              "url": image,
            });
          }
        });

        Navigator.pop(context);
      } else {
        final QuerySnapshot result = await Firestore.instance
            .collection('messages')
            .where('text', isEqualTo: text_or_image)
            .limit(1)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        await Firestore.instance
            .collection('messages')
            .document(documents[0].documentID)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            final image = documentSnapshot.data['url'];
            final text = documentSnapshot.data['text'];
            final sender = documentSnapshot.data['sender'].toString();
            final time = documentSnapshot.data['time'];
            _firestore.collection('report').add({
              "text": text,
              "sender": sender,
              "time": time,
              "url": image,
            });
          }
        });
        Navigator.pop(context);
      }
    }

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              children: [
                ImageIcon(
                  AssetImage("image/alert.png"),
                  color: Colors.black,
                  // color: Colors.black,
                ),
                SizedBox(width: 30),
                Text(title),
              ],
            ),
            content:
                //Text("אנא הרשם על מנת לבצע פעולה זו"),
                Container(
              height: 10,
              width: 60,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  okBtnText,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold),
                ),
                color: Colors.white,
                onPressed: () {
                  print(text);
                  if (text == "") {
                    doesNameAlreadyExist(image_u, true);
                  } else {
                    doesNameAlreadyExist(text, false);
                  }
                },
              ),
              FlatButton(
                  child: Text(
                    cancelBtnText,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Assistant',
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }
}

GoregisterAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "לכו להירשם",
      style: new TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Assistant'),
    ),
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegistrationScreen()));
    },
  );
  Widget Later = FlatButton(
    child: Text(
      "אחר כך",
      style: new TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Assistant'),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    //title: FittedBox(child: Text("בשביל לבצע פעולה זאת עלייך להירשם")),
    title: Container(

      height: MediaQuery.of(context).size.height / 10,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ImageIcon(
                AssetImage("image/alert.png"),
                color: Colors.black,

                // color: Colors.black,
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  "בשביל לבצע פעולה זאת עליכם להירשם",
                  style: new TextStyle(
                      color: Colors.black,
                      fontFamily: 'Assistant',
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      okButton,
      Later,
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
