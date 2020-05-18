import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'movedoc.dart';
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
      if (is_image == true) {
        final QuerySnapshot result = await Firestore.instance
            .collection('messages')
            .where('url', isEqualTo: text_or_image)
            .limit(1)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        print(documents[0].documentID.toString());
        await movedoc(uid: documents[0].documentID)
            .updateUserData(sender, text, image_u);
        Navigator.pop(context);
      } else {
        final QuerySnapshot result = await Firestore.instance
            .collection('messages')
            .where('text', isEqualTo: text_or_image)
            .limit(1)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        print(documents[0].documentID.toString());
        await movedoc(uid: documents[0].documentID)
            .updateUserData(sender, text, image_u);
        Navigator.pop(context);
      }
    }

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Container(),
            actions: <Widget>[
              FlatButton(
                child: Text(okBtnText),
                onPressed: () {
                  print(text);
                  if (text == null) {
                    doesNameAlreadyExist(image_u, true);
                  } else {
                    doesNameAlreadyExist(text, false);
                  }
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
