import 'package:flutter/material.dart';

missMainImage(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("חזור"),
    onPressed: () => Navigator.of(context).pop(null),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("שגיאה"),
    content: Text("חובה לצרף תמונה ראשית למאבק"),
    actions: [
      okButton,
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
NameStruggleExist(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("חזור"),
    onPressed: () => Navigator.of(context).pop(null),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("שגיאה"),
    content: Text("שם מאבק זה קיים במערכת יש צורך לשנות את שם המאבק"),
    actions: [
      okButton,
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