import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/evants/add_event.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/GetID_DB/getid.dart';

final _firestore = Firestore.instance;

class userStream extends StatefulWidget {
  userStream({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _userStream createState() => new _userStream();
}

class _userStream extends State<userStream> {
  TextEditingController editingController = TextEditingController();

  var duplicateItems = List<String>();
  var items = List<String>();
  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i].data["name"];
      String role = querySnapshot.documents[i].data["role"];
      if (role != "menager") {
        duplicateItems.add(a.toString());
      }
      print(a);
    }
    items.addAll(duplicateItems);
  }

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDocs().then((value) {
        setState(() {
          isLoading = true;
        });
      });
    });
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          automaticallyImplyLeading: false),
      body: !isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'בחר משתמש         ',
                        style: TextStyle(
                            fontFamily: 'Assistant',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Spacer(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "חפש",
                          hintText: "חפש",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${items[index]}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 20.0,
                                  color: Colors.brown[900],
                                ),
                                onPressed: () async {
                                  String id = await Getuser(items[index]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddEventPage(
                                                senderId: id,
                                                sender: items[index],
                                              )));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
