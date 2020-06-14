import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'greenpeace',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(


          body: Messages(),
         // body: WhoWeAre()

        // body: Struggle(),
      ),
    );
  }
}


class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text('הודעות',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Assistant',
                  fontSize: 25.0)),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Chat.dummyData.length,
              itemBuilder: (context, index) {
                Chat _model = Chat.dummyData[index];
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 12.0,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ExpansionTile(
//                    leading: CircleAvatar(
//                      radius: 24.0,
//                      backgroundImage: NetworkImage(_model.avatarUrl),
//                    ),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(_model.name + ' - ' + _model.position,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Assistant',
                                    fontSize: 16.0)),
                            Spacer(),
                            Column(
                              children: <Widget>[
                                Text(_model.date,
                                    style: TextStyle(
                                        fontFamily: 'Assistant',
                                        fontSize: 12.0)),
                                Text(_model.time,
                                    style: TextStyle(
                                        fontFamily: 'Assistant',
                                        fontSize: 12.0)),
                              ],
                            ),
                          ],
                        ),
                        //subtitle: Text(_model.message),
                        children: <Widget>[
                          Text(_model.message,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'Assistant',
                                fontSize: 16.0,
                              )),
                        ],
//                      trailing: Icon(
//                        Icons.arrow_forward_ios,
//                        size: 14.0,
//                      ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}


class Chat {
  final String userId;
  final String name;
  final String position;
  final String message;
  final String time;
  final String date;

  Chat(
      {this.userId,
        this.name,
        this.position,
        this.message,
        this.time,
        this.date});
//  Widget GetInfo(x,y,z){
//    ChatModel
//  }

  static final List<Chat> dummyData = [
    Chat(
        userId: "or@gmail.com",
        name: "sharon",
        position: 'מנהל',
        message: "איך מקימים אירוע?",
        time: '12:20',
        date: '01.06.2020'),
    Chat(
        userId: "or@gmail.com",
        name: "sharon",
        position: 'מנהל',
        message: "איך מקימים אירוע?",
        time: '12:20',
        date: '01.06.2020'),
    Chat(
        userId: "or@gmail.com",
        name: "sharon",
        position: 'מנהל',
        message: "איך מקימים אירוע?",
        time: '12:20',
        date: '01.06.2020'),
  ];
}

// Create a Form widget.
