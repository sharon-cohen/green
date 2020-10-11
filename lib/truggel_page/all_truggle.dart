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
        body: Container(child: TruggleStream(page_call: 'all_struggle')));
  }
}
