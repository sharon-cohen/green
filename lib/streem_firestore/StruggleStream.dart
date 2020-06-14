import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/evants/add_event.dart';
import 'package:greenpeace/home/haert_button.dart';
final _firestore = Firestore.instance;

class TruggleStream extends StatelessWidget {
  final String page_call;
  Data data;
  TruggleStream({this.page_call,this.data});
  List<TtuggleContainer> TtuggleContainers = [];
  List<All_TtuggleContainer> ALL_TtuggleContainers = [];
  List<String>NameStruggle=[];
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
          final messageTime = truggl.data["time"];
          final sign_target = truggl.data["name"];
          final url_money = truggl.data["url_money"];
          final sign_num = truggl.data["sign_num"];
          final All_TtuggleContainer_new = All_TtuggleContainer(
            name: trugglNmae,
            image_u: imag_url,
            info: info,
            sign_num: sign_num,
            url_money: url_money,
            sign_target: sign_target,
          );
          final TtuggleContainer_new = TtuggleContainer(
            name: trugglNmae,
            image_u: imag_url,
            time: messageTime,
          );
          if(NameStruggle.contains(trugglNmae)==false) {
            NameStruggle.add(trugglNmae);
          }
          TtuggleContainers.add(TtuggleContainer_new);
          ALL_TtuggleContainers.add(All_TtuggleContainer_new);
          TtuggleContainers.sort((a, b) => b.time.compareTo(a.time));
        }
        if(page_call=='add_event'){
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              child: DropDown(NameStruggle: NameStruggle,data: this.data,),
            ),

          );

        }
        return result_stream();
      },
    );
  }
}

class TtuggleContainer extends StatefulWidget {
  final Timestamp time;
  final String name;
  final String image_u;
  TtuggleContainer({this.name, this.image_u,this.time});
  @override
  _TtuggleContainerState createState() => _TtuggleContainerState();
}
class _TtuggleContainerState extends State<TtuggleContainer> {
  final _auth = FirebaseAuth.instance;
  bool love=false;
  Future<void> readlike(String name)async{
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    final document = await Firestore.instance.collection('users').document(uid
    ).get();
    List<String> likes=List.from(document['likes']);
    if(likes.contains(widget.name)){
      setState(() => love = true);
    }
  }
  @override
  Widget build(BuildContext context) {
    readlike(widget.name);
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
      height: MediaQuery.of(context).size.height / (3.5),
      width: MediaQuery.of(context).size.width / (2.5),
      child: Column(
        children: <Widget>[
          new Expanded(
              flex: 4,
              child: Container(
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image:widget.image_u != null
                        ? NetworkImage(widget.image_u)
                        : AssetImage('image/image_icon.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              )),
          new Expanded(
              flex: 1,
              child: Container(
                color: Colors.green.shade200,
                width: MediaQuery.of(context).size.width / (2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.name),
                    heart_button(name: widget.name, like_or_not: love,),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
class All_TtuggleContainer extends StatelessWidget {
  final String name;
  final String image_u;
  final String info;
  final String sign_target;
  final String url_money;
  final String sign_num;
  All_TtuggleContainer(
      {this.name,
        this.image_u,
        this.info,
        this.sign_target,
        this.url_money,
        this.sign_num});
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      child: Container(
        child: SimpleFoldingCell(
          key: _foldingCellKey,
          frontWidget: FrontWidget(),
          innerTopWidget: InnerTopWidget(),
          innerBottomWidget: InnerBottomWidget(),
          cellSize: Size(MediaQuery.of(context).size.width, 160),
          padding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Container InnerTopWidget() {
    return Container(
        color: Colors.green.shade200,
        child: Text(name,
            style: TextStyle(
                color: Color(0xFF2e282a),
                fontFamily: 'OpenSans',
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
                  image: image_u != null
                      ? NetworkImage(image_u)
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
                    Text(name,
                        style: TextStyle(
                            color: Color(0xFF2e282a),
                            fontFamily: 'OpenSans',
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
 DropDown({this.NameStruggle,this.data});
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
        child :
        Column(children: <Widget>[

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
            items: widget.NameStruggle.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          Text('Selected Item = ' + '$dropdownValue',
              style: TextStyle
                (fontSize: 22,
                  color: Colors.black)),
        ]),
      );

  }
}
