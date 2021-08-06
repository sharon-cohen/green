import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:greenpeace/truggel_page/one_struggle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:greenpeace/globalfunc.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class TruggleStreamHome extends StatelessWidget {
  Future<int>getData() async {
    return 3;
  }
  @override
  Widget build(BuildContext context) {
    int sum=0;
    return StreamBuilder<QuerySnapshot>(

      stream: _firestore.collection("struggle").snapshots(),
      // ignore: missing_return

      builder: (context, snapshot) {
        if (!snapshot.hasData ) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          );
        }

        int numberStrugl = 0;
        bool render=true;
        List<TtuggleContainer> MapTtuggleContainers = [];
        final truggls = snapshot.data.documents;
        final d=snapshot.data.documents;
        for (var truggl in truggls) {
          if (truggl.data["sum"] != null) {
            numberStrugl = truggl.data["sum"];
          }
          if (truggl.documentID=="render"){
            if(!truggl.data["ren"]){
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        }
      for (var truggl in truggls) {
        if ( truggl.data["sum"]==null && truggl.documentID!="render" ) {
        final trugglNmae = truggl.data["title"];
        final imag_url = truggl.data["image"];
        final description1 = truggl.data["description1"];
        final description2 = truggl.data["description2"];
        final description3 = truggl.data["description3"];
        final description4 = truggl.data["description4"];
        final description5 = truggl.data["description5"];
        final url_money = truggl.data["petition"];
        final image1 = truggl.data["image1"];
        final image2 = truggl.data["image2"];
        final image3 = truggl.data["image3"];
        final image4 = truggl.data["image4"];
        final image5 = truggl.data["image5"];
        final share = truggl.data["share"];
        final time = truggl.data["time"];
        final donation = truggl.data["donation"];
        final place = truggl.data["place"];
        final TtuggleContainer_new = new TtuggleContainer(
            sum:numberStrugl,
            struggle: StruggleModel(
              title: trugglNmae,
              image: imag_url,
              description1: description1,
              description2: description2,
              description3: description3,
              description4: description4,
              description5: description5,
              share: share,
              image1: image1,
              image2: image2,
              image3: image3,
              image4: image4,
              image5: image5,
              petition: url_money,
              donation: donation,
              time: time.toDate(),
              place: place,
            ));
        MapTtuggleContainers.add(TtuggleContainer_new);
      }

      }


//0493


        MapTtuggleContainers.sort(
            (a, b) => a.struggle.place.compareTo(b.struggle.place));

        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: SingleChildScrollView(

            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Row(

                children: MapTtuggleContainers,
              ),
            ),
          ),
        );
      },
    );
  }
}

class TtuggleContainer extends StatefulWidget {
  final StruggleModel struggle;
  final int sum;
  TtuggleContainer({this.struggle,this.sum});
  @override
  _TtuggleContainerState createState() => _TtuggleContainerState();
}

class _TtuggleContainerState extends State<TtuggleContainer> {
  final _auth = FirebaseAuth.instance;
  Future updateRenderDB(bool enable) async{
   if (enable){
     await Firestore.instance
         .collection("struggle")
         .document("render")
         .updateData({

       'ren': true
     });
   }
   else{
     await Firestore.instance
         .collection("struggle")
         .document("render")
         .updateData({

       'ren': false
     });
   }
  }

  Future getDocs(String newPlace ) async {

    QuerySnapshot querySnapshot = await Firestore.instance.collection("struggle").getDocuments();
    var currentDoc;
    String shiftLeftOrRigth="";
    String currentID="";
    int currPlace;
    await updateRenderDB(false);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.documentID != "sumStruggle" && a.documentID != "render") {
        if (a.data["title"] == widget.struggle.title) {
          currentDoc = a;
          currentID = a.documentID;
          currPlace = a.data["place"];
          if (a.data["place"] < int.parse(newPlace)) {
            shiftLeftOrRigth = "left";
          }
          else {
            shiftLeftOrRigth = "right";
          }
        }
      }
    }

      for (int i = 0; i < querySnapshot.documents.length; i++) {
        var a = querySnapshot.documents[i];
        if (a.documentID != "sumStruggle" && a.documentID != "render") {

          print(a.data["place"]);
          if (shiftLeftOrRigth == "left") {
            if (a.data["place"] > currPlace &&
                a.data["place"] <= int.parse(newPlace)) {
              int placeLessOne = a.data["place"] - 1;
              await updatePlaceStruggleDB(a.documentID, placeLessOne);
            }
          }
          else {
            if (a.data["place"] < currPlace &&
                a.data["place"] >= int.parse(newPlace)) {
              int placeAddOne = a.data["place"] + 1;
              await updatePlaceStruggleDB(a.documentID, a.data["place"] + 1);
            }
          }

      }
      }



    await updatePlaceStruggleDB(currentID, int.parse(newPlace));
    await updateRenderDB(true);
  }
  String dropdownValue="1";
  List<String> spinnerItems = [];
  @override
  void initState() {
    super.initState();
    dropdownValue =widget.struggle.place.toString();
   for(int i=1;i<=widget.sum;i++){
     spinnerItems.add(i.toString());

}

  }



  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / (3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: <Widget>[
          globals.isMeneger?Expanded(
            flex: 1,
            child:   DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.red, fontSize: 18),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String data) async{

                dropdownValue = data;
                await getDocs(data);
              },
              items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ):Expanded(child: Container()),
          new Expanded(
              flex: 4,
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
                          ? NetworkImage(
                              widget.struggle.image,
                            )
                          : AssetImage(
                              'image/image_icon.png',
                            ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
          new Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                   flex:3,
                    child: Container(

                      child: Text(widget.struggle.title),
                    ),
                  ),

                 


                ],
              )),
        ],
      ),
    );
  }
}

class Sort extends StatelessWidget {
  Map<String, TtuggleContainer> TtuggleContainers;
  Sort({this.TtuggleContainers});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("sortInfo").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          );
        }
        List<TtuggleContainer> sortListContainer = [];
        for (var v in TtuggleContainers.values) {
          sortListContainer.add(v);
        }

        final sortdoc = snapshot.data.documents[0];
        var map = sortdoc.data['mapS'];

        for (String key in map.keys) {
          if (map[key] != -1) {
            int par = map[key];

            var temp = sortListContainer[par];
            print(key);
            int index = sortListContainer.indexOf(TtuggleContainers[key]);

            sortListContainer[index] = temp;
            sortListContainer[par] = TtuggleContainers[key];
          }
        }
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: sortListContainer,
            ),
          ),
        );
      },
    );
  }
}
