import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("about").snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              ' ',
            );
          } else {
            final text = snapshot.data.documents;
            final String about = text[0].data["text"];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                about,
                style: TextStyle(
                  fontFamily: 'Assistant',
                  color: Colors.black,
                ),
              ),
            );
          }
        });
  }
}
