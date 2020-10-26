import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/Component/text_class.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:greenpeace/truggel_page/one_struggle.dart';

final _firestore = Firestore.instance;

class TruggleStream extends StatelessWidget {
  final String page_call;
  Data data;
  TruggleStream({this.page_call, this.data});
  List<TtuggleContainer> TtuggleContainers = [];
  List<All_TtuggleContainer> ALL_TtuggleContainers = [];
  List<String> NameStruggle = [];
  Widget result_stream() {
    if (page_call == 'home') {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(top: 20),
          child: Row(
            children: TtuggleContainers,
          ),
        ),
      );
    }
    if (page_call == 'all_struggle') {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: ALL_TtuggleContainers,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("struggle").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final truggls = snapshot.data.documents;
          for (var truggl in truggls) {
            final trugglNmae = truggl.data["name"];
            final imag_url = truggl.data["url_image"];
            final info = truggl.data["info"];
            final url_money = truggl.data["petition"];
            final share = truggl.data["url_share"];
            final donation = truggl.data["donation"];
            final All_TtuggleContainer_new = All_TtuggleContainer(
                struggle: StruggleModel(
              title: trugglNmae,
              image: imag_url,
              description: info,
              share: share,
              petition: url_money,
              donation: donation,
            ));
            final TtuggleContainer_new = TtuggleContainer(
                struggle: StruggleModel(
              title: trugglNmae,
              image: imag_url,
              description: info,
              share: share,
              petition: url_money,
              donation: donation,
            ));
            if (NameStruggle.contains(trugglNmae) == false) {
              NameStruggle.add(trugglNmae);
            }
            TtuggleContainers.add(TtuggleContainer_new);
            ALL_TtuggleContainers.add(All_TtuggleContainer_new);
          }
          if (page_call == 'new_event') {
            return Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                child: DropDown(
                  NameStruggle: NameStruggle,
                  data: this.data,
                ),
              ),
            );
          }
          return result_stream();
        });
  }
}

class TtuggleContainer extends StatefulWidget {
  final StruggleModel struggle;

  TtuggleContainer({this.struggle});
  @override
  _TtuggleContainerState createState() => _TtuggleContainerState();
}

class _TtuggleContainerState extends State<TtuggleContainer> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      height: MediaQuery.of(context).size.height / (3.5),
      width: MediaQuery.of(context).size.width / (3),
      child: Column(
        children: <Widget>[
          new Expanded(
              flex: 6,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => one_struggle(
                                struggle: widget.struggle,
                              )));
                },
                child: Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: Offset(7, 0), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(const Radius.circular(20)),
                    image: DecorationImage(
                      image: widget.struggle.image != null
                          ? NetworkImage(widget.struggle.image)
                          : AssetImage('image/image_icon.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )),
          new Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width / (1),
                child: Center(child: FittedBox(child: Text(widget.struggle.title))),
              )),
        ],
      ),
    );
  }
}

class All_TtuggleContainer extends StatelessWidget {
  final StruggleModel struggle;
  All_TtuggleContainer({this.struggle});
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => one_struggle(struggle: struggle)));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        constraints: new BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / (5),
          maxHeight: MediaQuery.of(context).size.height / (5),
        ),
        alignment: Alignment.center,
        //padding: new EdgeInsets.only(left: 16.0, bottom: 8.0),
        decoration: new BoxDecoration(
          //borderRadius: BorderRadius.all(const Radius.circular(20)),
          image: new DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
            image: NetworkImage(struggle.image),
            fit: BoxFit.cover,
          ),
        ),
        child: new Text(struggle.title,
            style: new TextStyle(
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.grey[800],
                  offset: Offset(5.0, 5.0),
                ),
              ],
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: 'Assistant',
            )),
      ),
    );
  }

  Container InnerTopWidget() {
    return Container(
        color: Colors.green.shade200,
        child: Text(struggle.title,
            style: TextStyle(
                color: Color(0xFF2e282a),
                fontFamily: 'Assistant',
                fontSize: 20.0,
                fontWeight: FontWeight.w800)));
  }

  Container InnerBottomWidget() {
    return Container(
      color: Colors.green.shade100,
      child: FlatButton(
        onPressed: () => _foldingCellKey?.currentState?.toggleFold(),
        child: Text(
          "Close",
        ),
        textColor: Colors.white,
        color: Colors.green.shade100,
        splashColor: Colors.white.withOpacity(0.5),
      ),
    );
  }

  Container FrontWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: struggle.image != null
                      ? NetworkImage(struggle.image)
                      : AssetImage('image/image_icon.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.shade200,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(struggle.title,
                        style: TextStyle(
                            color: Color(0xFF2e282a),
                            fontFamily: 'Assistant',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800)),
                    Align(
                      child: FlatButton(
                        onPressed: () =>
                            _foldingCellKey?.currentState?.toggleFold(),
                        child: Text(
                          "Open",
                        ),
                        textColor: Colors.white,
                        color: Colors.indigoAccent,
                        splashColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  DropDown({this.NameStruggle, this.data});
  // ignore: non_constant_identifier_names
  Data data;
  List<String> NameStruggle;
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State<DropDown> {
  String dropdownValue = 'sharon';
  @override
  Widget build(BuildContext context) {
    print(widget.NameStruggle);
    return Center(
      child: Column(children: <Widget>[
        DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.red, fontSize: 18),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String data) {
            setState(() {
              widget.data.dropdownValue = data;
              dropdownValue = data;
            });
          },
          items:
              widget.NameStruggle.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Text('Selected Item = ' + '$dropdownValue',
            style: TextStyle(
                fontSize: 22, color: Colors.black, fontFamily: 'Assistant')),
      ]),
    );
  }
}

class Data {
  String dropdownValue;
  Data({this.dropdownValue});
}
