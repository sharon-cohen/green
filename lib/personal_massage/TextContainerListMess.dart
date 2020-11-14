import 'package:flutter/material.dart';


class TextStyleMess extends StatelessWidget {
  final String text;
  final double size;
  final double  sizeHeight;
  final double  sizeWidth;
  TextStyleMess({this.text,this.size,this.sizeHeight,this.sizeWidth});
  @override
  Widget build(BuildContext context) {
    return Container(
      width:   sizeWidth,
      height: sizeHeight ,
      alignment: Alignment.bottomRight,

      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: size,
              fontFamily: 'Assistant'),
        ),
      ),
    );
  }
}
