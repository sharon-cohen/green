import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:greenpeace/streem_firestore/StruggleStream.dart';

class All_truggle extends StatefulWidget {
  All_truggle({Key key, this.arguments}) : super(key: key);
  static const String id = " All_truggle";
  final ScreenArguments_m arguments;
  @override
  _All_truggleState createState() => _All_truggleState();
}

class _All_truggleState extends State<All_truggle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
            automaticallyImplyLeading: false),
        body: ListView(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Text(
                  'מאבקים        ',
                  style: TextStyle(
                      fontFamily: 'Assistant',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                Spacer(),
              ],
            ),
            Container(
                padding: EdgeInsets.all(0),
                child: TruggleStream(page_call: 'all_struggle')),
          ],
        ));
  }
}
