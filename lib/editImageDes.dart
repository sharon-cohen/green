import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:greenpeace/GetID_DB/getid.dart';
final navigatorKey = GlobalKey<NavigatorState>();
final _firestore = Firestore.instance;
class editImageDes extends StatefulWidget {
  StruggleModel struggle;
  bool boolfile0;
  editImageDes  ({this.struggle,this.boolfile0});
  @override
  _editImageDesState createState() => _editImageDesState();
}

class _editImageDesState extends State<editImageDes> {
  TextEditingController _des1;
  TextEditingController _des2;
  TextEditingController _des3;
  TextEditingController _des4;
  TextEditingController _des5;
  bool boolfile1=false;
  bool boolfile2=false;
  bool boolfile3=false;
  bool boolfile4=false;
  bool boolfile5=false;
  String file1;
  String file2;
  String file3;
  String file4;
  String file5;
  TextStyle style = TextStyle(fontFamily: 'Assistant', fontSize: 20.0);
  bool  processing=false;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();


    file1='${widget.struggle.image1}';

    file2='${widget.struggle.image2}';

    file3='${widget.struggle.image3}';

    file4='${widget.struggle.image4}';

    file5='${widget.struggle.image5}';

    _des1 = TextEditingController(text: widget.struggle.description1);
    _des2 = TextEditingController(text:  widget.struggle.description2);
    _des3 = TextEditingController(text:  widget.struggle.description3);
    _des4 = TextEditingController(text:  widget.struggle.description4);
    _des5 = TextEditingController(text:  widget.struggle.description5);


  }
  Future<String> uploadImageToFirebase( File fileImage) async {
    if (fileImage.path!=" ") {

      String fileName = basename(fileImage.path);

      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('uploads/$fileName');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(fileImage);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;


      return await taskSnapshot.ref.getDownloadURL();


    }
    else{return " ";}
  }
  Future<String> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return pickedFile.path;

  }
  @override
  Widget build(BuildContext context) {
    print("fdfsdfsdfsdf");
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Container(

              child: Image.asset('image/logo_greem.png', scale: 2)),
          leading:
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new TextFormField(
              controller: _des1,
              decoration: InputDecoration(
                labelText: "פסקה מספר 1 ",
                filled: true,
                fillColor: Colors.white,
                labelStyle:
                TextStyle(fontFamily: 'Assistant', color: Colors.black),
                focusColor: Colors.lightGreen,
                border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                  // borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            new FlatButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Image.asset(
                    'image/addimage.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    "בחר בתמונה",
                    style: new TextStyle(fontSize: 25, fontFamily: 'Assistant'),
                  ),
                ],
              ),
              onPressed: () async {
                String filePath = await pickImage();
                setState(() {
                  file1 = filePath;
                  boolfile1=true;
                });
              },
            ),
            file1 != " " ? new Row(
              children: [
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          file1 = " ";
                        widget.struggle.image1=" ";
                        });
                      },
                      child: Icon(
                        Icons.clear,
                      )),
                ),
                Expanded(child: imageChoose(image: file1,change:boolfile1)),
              ],
            ) : Container(),
            new TextFormField(
              controller: _des2,
              decoration: InputDecoration(
                labelText: "פסקה מספר 2",
                filled: true,
                fillColor: Colors.white,
                labelStyle:
                TextStyle(fontFamily: 'Assistant', color: Colors.black),
                focusColor: Colors.lightGreen,
                border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                  // borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            new FlatButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Image.asset(
                    'image/addimage.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    "בחר בתמונה",
                    style: new TextStyle(fontSize: 25, fontFamily: 'Assistant'),
                  ),
                ],
              ),
              onPressed: () async {
                String filePath = await pickImage();
                setState(() {
                  file2 = filePath;
                  boolfile2=true;

                });
              },
            ),
            file2 != " " ? new Row(
              children: [
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          file2 = " ";
                          widget.struggle.image2=" ";
                        });
                      },
                      child: Icon(
                        Icons.clear,
                      )),
                ),
                Expanded(child: imageChoose(image: file2,change: boolfile2,)),
              ],
            ) : Container(),
            new TextFormField(
              controller: _des3,
              decoration: InputDecoration(
                labelText: "פסקה מספר 3",
                filled: true,
                fillColor: Colors.white,
                labelStyle:
                TextStyle(fontFamily: 'Assistant', color: Colors.black),
                focusColor: Colors.lightGreen,
                border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                  // borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            new FlatButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Image.asset(
                    'image/addimage.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    "בחר בתמונה",
                    style: new TextStyle(fontSize: 25, fontFamily: 'Assistant'),
                  ),
                ],
              ),
              onPressed: () async {
                String filePath = await pickImage();
                setState(() {
                  file3 = filePath;
                  boolfile3=true;

                });
              },
            ),
            file3 != " " ? new Row(
              children: [
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          file3 = " ";
                          widget.struggle.image3=" ";
                        });
                      },
                      child: Icon(
                        Icons.clear,
                      )),
                ),
                Expanded(child: imageChoose(image: file3,change: boolfile3,)),
              ],
            ) : Container(),
            new TextFormField(
              controller: _des4,
              decoration: InputDecoration(
                labelText: "פסקה מספר 4",
                filled: true,
                fillColor: Colors.white,
                labelStyle:
                TextStyle(fontFamily: 'Assistant', color: Colors.black),
                focusColor: Colors.lightGreen,
                border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                  // borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            new FlatButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Image.asset(
                    'image/addimage.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    "בחר בתמונה",
                    style: new TextStyle(fontSize: 25, fontFamily: 'Assistant'),
                  ),
                ],
              ),
              onPressed: () async {
                String filePath = await pickImage();
                setState(() {
                  file4=filePath;
                  boolfile4=true;


                });
              },
            ),
            file4 != " " ? new Row(
              children: [
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          file4 = " ";
                          widget.struggle.image4=" ";
                        });
                      },
                      child: Icon(
                        Icons.clear,
                      )),
                ),
                Expanded(child: imageChoose(image: file4,change: boolfile4,)),
              ],
            ) : Container(),
            new TextFormField(
              controller: _des5,
              decoration: InputDecoration(
                labelText: "פסקה מספר5",
                filled: true,
                fillColor: Colors.white,
                labelStyle:
                TextStyle(fontFamily: 'Assistant', color: Colors.black),
                focusColor: Colors.lightGreen,
                border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                  // borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            new FlatButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Image.asset(
                    'image/addimage.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    "בחר בתמונה",
                    style: new TextStyle(fontSize: 25, fontFamily: 'Assistant'),
                  ),
                ],
              ),
              onPressed: () async {
                String filePath = await pickImage();
                setState(() {
                  file5 = filePath;
                  boolfile5=true;

                });
              },
            ),
            file5 != " " ? new Row(
              children: [
                Expanded(
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          file5 = " ";
                          widget.struggle.image5=" ";
                        });
                      },
                      child: Icon(
                        Icons.clear,
                      )),
                ),
                Expanded(child: imageChoose(image: file5,change: boolfile5,)),
              ],
            ) : Container(),
            processing
                ? Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Material(
                color: Color(int.parse("0xff6ed000")),
                elevation: 5.0,
                //borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                      processing = true;
                    });

                    print("widget.struggle.image");
                    print(widget.struggle.image);
                    if(widget.boolfile0)
                    widget.struggle.image = await uploadImageToFirebase(
                        new File(widget.struggle.image));
                    if(boolfile1)
                      widget.struggle.image1 = await uploadImageToFirebase(new File(file1));
                    if(boolfile2)
                      widget.struggle.image2 = await uploadImageToFirebase(new File(file2));
                    if(boolfile3)
                      widget.struggle.image3 = await uploadImageToFirebase(new File(file3));
                    if(boolfile4){

                      widget.struggle.image4 = await uploadImageToFirebase(new File(file4));
                    }

                    if(boolfile5){

                      widget.struggle.image5 = await uploadImageToFirebase(new File(file5));
                    }

                    String IdStruggle =
                    await GetStrugle(widget.struggle.title);
                    await Firestore.instance.collection("struggle")
                        .document(IdStruggle)
                        .updateData({
                      "image": widget.struggle.image,
                      "image1": widget.struggle.image1,
                      "image2": widget.struggle.image2,
                      "image3": widget.struggle.image3,
                      "image4": widget.struggle.image4,
                      "image5": widget.struggle.image5,
                      "description1": _des1.text,
                      "description2": _des2.text,
                      "description3": _des3.text,
                      "description4": _des4.text,
                      "description5": _des5.text,
                      "title": widget.struggle.title,
                      "share": widget.struggle.share,
                      "petition": widget.struggle.petition,
                      "donation": widget.struggle.donation,


                    });
                    setState(() {
                      processing = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BottomNavigationBarController(2, 1)),
                      );
                    });
                  },
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "סיום עריכה",
                        style: style.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      // SizedBox(width: 270),
                      Image.asset(
                        'image/whitearrow.png',
                        width: 30,
                        height: 30,
                      ),
                      //   Icons.play_circle_outline,
                      //   color: Colors.white,
                      //   size: 36.0,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }

class imageChoose extends StatelessWidget {
  String image;
  bool change;
  imageChoose({this.image,this.change});
  @override
  Widget build(BuildContext context) {
    return change? AspectRatio(
      aspectRatio: 4 / 3,
      child:Image.file(new File(image) ),

    ):image!=null?AspectRatio(
      aspectRatio: 16/9,
      child:
      CachedNetworkImage(
        imageUrl: image,fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    ):Container();
  }
}