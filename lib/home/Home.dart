import 'package:flutter/material.dart';
import 'package:greenpeace/Component/text_class.dart';

class Home extends StatelessWidget {
  static const String id = 'home_screen';
  Home(this.arguments);
  final ScreenArguments arguments;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //todo check if ok
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Assistant',
        // textTheme: Theme.of(context).textTheme.apply(
        //     fontFamily: 'Assistant',
        //     bodyColor: Colors.white,
        //     displayColor: Colors.white),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              color: _colorFromHex("#92d36e"),
              child: Column(
                children: <Widget>[
                  title(Title: "Feed"),
                  Container(
                    height: MediaQuery.of(context).size.height / (3.3),
                    color: _colorFromHex("#92d36e"),
                  ),
                  title(Title: "מאבקים"),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height / (3),
                            width: MediaQuery.of(context).size.width / (2.5),
                            color: Colors.white,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / (3),
                            width: MediaQuery.of(context).size.width / (2.5),
                            color: Colors.white,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / (3),
                            width: MediaQuery.of(context).size.width / (2.5),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          new Container(
              height: MediaQuery.of(context).size.height / (12),
              color: Colors.red),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final String idname;
  final String role;
  final String name;
  ScreenArguments(this.idname, this.name, this.role);
}
