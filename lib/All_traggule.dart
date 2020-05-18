import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalfunc.dart';
import 'streem_firestore/StruggleStream.dart';
import 'home_menager.dart';
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
    return  Container(child: TruggleStream('all_struggle'));
  }
}
