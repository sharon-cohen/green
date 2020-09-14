import 'package:flutter/material.dart';

import 'package:greenpeace/common/Header_svg.dart';
class connect extends StatefulWidget {
  connect({Key key}) : super(key: key);
  static const String id = "connect";
  @override
  _connectState createState() => _connectState();
}

class _connectState extends State<connect> {

  double offset = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        child: Column(
          children: <Widget>[
            MyHeader_svg(
              image: "assets/icons/Drcorona.svg",
              textTop: "הצטרף אלינו",
              textBottom: "כדור הארץ צריך אותנו.",
              offset: offset,
            ),

            SizedBox(height: 20),
            Text('להשלים מה שגריין פיס רוצים'),
            FlatButton(
             color:   Color(0xFF3382CC).withOpacity(.8),
              onPressed: (){},
              child: Text('לתרומה',
                  style: TextStyle(fontSize: 20)),

              textColor: Colors.white,
              ),

          ],
        ),
      ),
    );
  }
}
