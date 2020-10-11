import 'package:flutter/material.dart';

class title extends StatefulWidget {
  final String Title;
  title({this.Title});
  @override
  _titleState createState() => _titleState();
}

class _titleState extends State<title> {
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 18,
      color: _colorFromHex("#49a078"),
      child: Center(
        child: Text(
          widget.Title,
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: 'Assistant',
          ),
        ),
      ),
    );
  }
}
