import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
final _firestore = Firestore.instance;
class MyForm extends StatefulWidget {
  StruggleModel struggle;
  MyForm({this.struggle});
  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  TextEditingController _des1;
  TextEditingController _des2;
  TextEditingController _des3;
  TextEditingController _des4;
  TextEditingController _des5;
  File file1=new File(" ");
  File file2=new File(" ");
  File file3=new File(" ");
  File file4=new File(" ");
  File file5=new File(" ");
  bool  processing=false;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _des1 = TextEditingController(text: " ");
    _des2 = TextEditingController(text: " ");
    _des3 = TextEditingController(text: " ");
    _des4 = TextEditingController(text: " ");
    _des5 = TextEditingController(text: " ");


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
      body: Container(
       height: MediaQuery.of(context).size.height,

        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      'יצירת מאבק חדש',
                      style: TextStyle(
                        fontFamily: 'Assistant',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
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
                        String filePath= await pickImage();
                        setState(() {
                          file1=new File(filePath);
                          print(filePath);
                      });

                      },
                    ),
                    file1.path!=" "? new Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  file1=new File(" ");
                                });

                              },
                              child: Icon(
                                Icons.clear,
                              )),
                        ),
                        Expanded(child: imageChoose(image:file1)),
                      ],
                    ):Container(),
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
                        String filePath= await pickImage();
                        setState(() {
                          file2=new File(filePath);
                          print(filePath);
                        });

                      },
                    ),
                    file2.path!=" "?new Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  file2=new File(" ");
                                });

                              },
                              child: Icon(
                                Icons.clear,
                              )),
                        ),
                        Expanded(child: imageChoose(image:file2)),
                      ],
                    ):Container(),
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
                        String filePath= await pickImage();
                        setState(() {
                          file3=new File(filePath);
                          print(filePath);
                        });

                      },
                    ),
                    file3.path!=" "?new Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  file3=new File(" ");
                                });

                              },
                              child: Icon(
                                Icons.clear,
                              )),
                        ),
                        Expanded(child: imageChoose(image:file3)),
                      ],
                    ):Container(),
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
                        String filePath= await pickImage();
                        setState(() {
                          file4=new File(filePath);
                          print(filePath);
                        });

                      },
                    ),
                    file4.path!=" "?new Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  file4=new File(" ");
                                });

                              },
                              child: Icon(
                                Icons.clear,
                              )),
                        ),
                        Expanded(child: imageChoose(image:file4)),
                      ],
                    ):Container(),
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
                        String filePath= await pickImage();
                        setState(() {
                          file5=new File(filePath);
                          print(filePath);
                        });

                      },
                    ),
                    file5.path!=" "?new Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  file5=new File(" ");
                                });

                              },
                              child: Icon(
                                Icons.clear,
                              )),
                        ),
                        Expanded(child: imageChoose(image:file5)),
                      ],
                    ):Container(),
                   
                  ],
                ),
              ),
            ),
            processing
                ? Center(child: CircularProgressIndicator())
                :Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Color(int.parse("0xff6ed000")),
                elevation: 5.0,
                //borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                      processing = true;
                    });

                    widget.struggle.image=await uploadImageToFirebase(new File(widget.struggle.image));
                    widget.struggle.image1=await uploadImageToFirebase(file1);
                    widget.struggle.image2=await uploadImageToFirebase(file2);
                    widget.struggle.image3=await uploadImageToFirebase(file3);
                    widget.struggle.image4=await uploadImageToFirebase(file4);
                    widget.struggle.image5=await uploadImageToFirebase(file5);
                    int numStruggle=0;
                    await Firestore.instance.collection("struggle").document('sumStruggle')
                        .get().then((DocumentSnapshot) =>
                        numStruggle=DocumentSnapshot.data['sum']
                    );
                    await _firestore.collection("struggle").add({
                      "image": widget.struggle.image,
                      "image1": widget.struggle.image1,
                      "image2": widget.struggle.image2,
                      "image3": widget.struggle.image3,
                      "image4": widget.struggle.image4,
                      "image5": widget.struggle.image5,
                      "description1": _des1.text,
                      "description2":_des2.text,
                      "description3": _des3.text,
                      "description4": _des4.text,
                      "description5": _des5.text,
                      "title": widget.struggle.title,
                      "share": widget.struggle.share,
                      "petition": widget.struggle.petition,
                      "donation": widget.struggle.donation,
                      "time":widget.struggle.time,
                      "place":numStruggle+1,

                    });
                    await _firestore.collection("struggle").document('sumStruggle').updateData({
                     'sum':numStruggle+1,
                    });

                    setState(() {
                      processing = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomNavigationBarController(2, 1)),
                    );
                  },
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "צור מאבק",
                        style: TextStyle(
                          color:Colors.white,
                        ),
                      ),
                      // SizedBox(width: 270),
                      Image.asset(
                        'image/whitearrow.png',
                        width: 30,
                        height: 30,
                      ),
                      // Icon(
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
  File image;
  imageChoose({this.image});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child:Image.file(image ),

    );
  }
}