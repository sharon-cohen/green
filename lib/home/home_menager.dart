import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/globalfunc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenpeace/home/about.dart';
import 'package:greenpeace/streem_firestore/HomeStruggle.dart';
import 'package:greenpeace/home/send_mass_button.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/common/Header.dart';
import 'package:greenpeace/truggel_page/all_truggle.dart';
import 'package:greenpeace/create_struggle1.dart';
import 'package:greenpeace/feed.dart';
import 'package:greenpeace/evants/event_firestore_service.dart';
import 'package:greenpeace/evants/event_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:greenpeace/evants/event_page.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:greenpeace/truggel_page/struggle_model.dart';
import 'package:greenpeace/evants/list_event.dart';
import 'package:greenpeace/welcom.dart';
import 'package:greenpeace/GetID_DB/getid.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Home_menager extends StatefulWidget {
  Home_menager({Key key, this.arguments}) : super(key: key);
  static const String id = " home_menager";
  final ScreenArguments_m arguments;
  @override
  Home_menagerState createState() => Home_menagerState();
}

class Home_menagerState extends State<Home_menager> {
  final _auth = FirebaseAuth.instance;
  TextEditingController aboutController;
  bool ok = false;
  bool showSpinner = false;
  double offset = 0;
  bool no_reg = false;
  bool addUser = true;
  bool addMenagger = true;
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      print(event.title.toString());
      if (event.approve == true) {
        DateTime date = DateTime(event.eventDate.year, event.eventDate.month,
            event.eventDate.day, 12);
        if (data[date] == null) data[date] = [];
        data[date].add(event);
      }
    });
    return data;
  }

  @override
  void initState() {
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];

    super.initState();
    setState(() {
      aboutController = new TextEditingController();
    });
    getCurrentUser();
  }
  void _onDaySelected(DateTime day, List e) {
    setState(() {
                                            setState(() {
                                        _selectedEvents = e;
                                      });
    });
  }
  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
    if (user == null) {
      no_reg = true;
    }
  }

  TextEditingController _c = TextEditingController();
  TextEditingController userBan = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("Corrected size W is ${(MediaQuery.of(context).size.width)}");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            MyHeader(
              image: "image/greenpeace-main-image.png",
              offset: offset,
            ),
            Card(
              margin: new EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 0, bottom: 5.0),
              //margin: new EdgeInsets.only(top: 8.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                "המאבקים שלנו",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Assistant',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Spacer(),
                            globals.isMeneger
                                ? IconButton(
                                    icon: new Icon(
                                      Icons.add,
                                      color: Color(int.parse("0xff6ed000")),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  create_struggle1(
                                                    gotStruggle:
                                                        new StruggleModel(
                                                      title: " ",
                                                      description1: " ",
                                                      description2: " ",
                                                      description3: " ",
                                                      description4: " ",
                                                      description5: " ",
                                                      image5: " ",
                                                      image4: " ",
                                                      image3: " ",
                                                      image2: " ",
                                                      image1: " ",
                                                      image: " ",
                                                      share: " ",
                                                      donation: " ",
                                                      petition: " ",
                                                    ),
                                                  )));
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'הצטרפו ותתמכו בפעילות שלנו',
                            style: TextStyle(
                              fontFamily: 'Assistant',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(

                            child: TruggleStreamHome()),
                      ),
                      Expanded(
                        flex: 2,
                        child: FlatButton(
                          child: Text(
                            "לכל המאבקים",
                            style: TextStyle(
                              fontFamily: 'Assistant',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(int.parse("0xff6ed000")),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, All_truggle.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: new EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 25,
                              child: Text(
                                "עדכונים",
                                style: TextStyle(
                                    fontFamily: 'Assistant',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Spacer(),
                            ImageIcon(
                              AssetImage("image/feed1.png"),
                              color: Colors.black,
                              // color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 25,
                        child: Text(
                          'כאן ניתן לשתף את האהבה והדאגה שלנו לסביבה',
                          style: TextStyle(
                            fontFamily: 'Assistant',
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(child: MessagesStream()),
                      Container(
                        decoration: kMessageContainerDecoration,
                        child: !globals.no_reg?button_send(
                          no_reg: no_reg,
                        ):null,
                      ),
                      FlatButton(
                        child: Text(
                          "לכל העדכונים",
                          style: TextStyle(
                            fontFamily: 'Assistant',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(int.parse("0xff6ed000")),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Feed()));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: new EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "יומן אירועים",
                            style: TextStyle(
                                fontFamily: 'Assistant',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Spacer(),
                          IconButton(
                            icon: new Icon(
                              Icons.add,
                              color: Color(int.parse("0xff6ed000")),
                            ),
                            onPressed: () {
                              if (globals.no_reg == true) {
                                GoregisterAlertDialog(context);
                              } else {
                                Navigator.pushNamed(context, 'new_event');
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        'צפו באירועים הקרובים וצרו אירוע משלכם',
                        style: TextStyle(
                          fontFamily: 'Assistant',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: StreamBuilder<List<EventModel>>(
                            stream: eventDBS.streamList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<EventModel> allEvents = snapshot.data;
                                print("nameeee");
                                print(allEvents[0].title.toString());
                                if (allEvents.isNotEmpty) {
                                  _events = _groupEvents(allEvents);
                                }
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TableCalendar(
                                      locale: 'he_IL',
                                      onDaySelected: (date, events,holidays) {
                                        setState(() {
                                          _selectedEvents = events;

                                        });
                                      },

                                      events: _events,
                                      initialCalendarFormat:
                                          CalendarFormat.month,
                                      startingDayOfWeek:
                                          StartingDayOfWeek.saturday,
                                      calendarStyle: CalendarStyle(
                                        outsideDaysVisible: false,
                                        weekendStyle: TextStyle()
                                            .copyWith(color: Colors.black),
                                        holidayStyle: TextStyle()
                                            .copyWith(color: Colors.black),
                                      ),
                                      daysOfWeekStyle: DaysOfWeekStyle(
                                        weekendStyle: TextStyle()
                                            .copyWith(color: Colors.black),
                                      ),

                                      headerStyle: HeaderStyle(
                                        centerHeaderTitle: true,
                                        formatButtonDecoration: BoxDecoration(
                                          color: Color(int.parse("0xff6ed000")),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        formatButtonTextStyle:
                                            TextStyle(color: Colors.white),
                                        formatButtonShowsNext: false,
                                      ),

//                                    onDaySelected: (date, events) {
//                                      setState(() {
//                                        _selectedEvents = events;
//                                      });
//                                    },

                                      builders: CalendarBuilders(

                                        todayDayBuilder: (context, date,
                                                events) =>
                                            Container(
                                                margin:
                                                    const EdgeInsets.all(4.0),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Color(int.parse(
                                                        "0xff6ed000")),
                                                    // color: Color(int.parse("0xff6ed000")),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                child: Text(
                                                  date.day.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Assistant'),
                                                )),
                                      ),
                                      calendarController: _controller,

                                    ),
                                    ..._selectedEvents.map((event) => Column(
                                      children: [
                                        Divider(),
                                        Container(

                                          child: ListTile(
                                                title: Text(event.title,
                                                    style: new TextStyle(
                                                      fontFamily: 'Assistant',
                                                    )),
                                                onTap: () {
                                                  Navigator.push(

                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              EventDetailsPage(
                                                                event: event,
                                                              )));
                                                },
                                              ),
                                        ),
                                        Divider(),
                                      ],
                                    )),
                                  ],
                                ),
                              );
                            }),
                      ),
                      FlatButton(
                        child: Text(
                          "לכל האירועים",
                          style: TextStyle(
                            fontFamily: 'Assistant',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(int.parse("0xff6ed000")),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, List_event.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: new EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 12,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'אודות גירנפיס',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Assistant',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          globals.isMeneger
                              ? IconButton(
                                  icon: new Icon(
                                    Icons.edit,
                                    color: Color(int.parse("0xff6ed000")),
                                  ),
                                  onPressed: () async {
                                    aboutController.text = await GetAbout();
                                    showDialog(
                                        child: new Dialog(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.3,
                                            child: new Column(
                                              children: <Widget>[
                                                new TextField(
                                                  maxLines:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              60)
                                                          .round(),
                                                  decoration: new InputDecoration(
                                                      hintText:
                                                          "מה תרצה שיהיה כתוב באודות?",
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              10, 10, 10, 0)),
                                                  controller: aboutController,
                                                ),
                                                // Spacer(),
                                                Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Spacer(),
                                                    new FlatButton(
                                                      child: new Text("שמור"),
                                                      onPressed: () async {
                                                        await Firestore.instance
                                                            .collection('about')
                                                            .document(
                                                                'sYFhYhmjY5zyzL3Rowcg')
                                                            .updateData({
                                                          "text":
                                                              aboutController
                                                                  .text,
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    Spacer(),
                                                    new FlatButton(
                                                      child: new Text("בטל"),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                    ),
                                                    Spacer(),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        context: context);
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    About(),
//                  Spacer(),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: ImageIcon(
//                      AssetImage("image/petition1.png"),
//                      color: Colors.black,
//                      size: 50,
//                      // color: Colors.black,
//                    ),
//                  ),
                  ],
                ),
              ),
            ),

            globals.isMeneger
                ? Card(
                    margin: new EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
                    //margin: new EdgeInsets.only(top: 8.0, bottom: 5.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // width: 100,
                        // height: 100,
                        child: new Column(
                          children: <Widget>[
                            Row(
                              children: [
                                addUser
                                    ? Text(
                                        'הוספת מנהל חדש',
                                        style: TextStyle(
                                            fontFamily: 'Assistant',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    : Text(
                                        'מחיקת מנהל',
                                        style: TextStyle(
                                            fontFamily: 'Assistant',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                Spacer(),
                                IconButton(
                                  icon: new Icon(
                                    Icons.autorenew,
                                    color: Color(int.parse("0xff6ed000")),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      addUser = !addUser;
                                    });
                                  },
                                ),
                              ],
                            ),
                            new TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: new InputDecoration(
                                hintText: "דואר אלקטרוני של המנהל ",
                              ),
                              controller: _c,
                            ),
                            new FlatButton(
                              child: new Text("שמור",
                                  style: TextStyle(
                                    fontFamily: 'Assistant',
                                    color: Color(int.parse("0xff6ed000")),
                                  )),
                              onPressed: () async {
                                String IdUser = await GetuserByEmail(_c.text);
                                print(IdUser);
                                if (IdUser == "not exist") {
                                  showAlertDialogManegActive(context,
                                      "כתובת מייל זו לא קיימת במערכת ");
                                }

                                await Firestore.instance
                                    .collection('users')
                                    .document(IdUser)
                                    .updateData({
                                  "role": addUser ? "menager" : "regular",
                                });
                                if (!addUser) {
                                  String mangeId = await mailMenager(_c.text);
                                  await Firestore.instance
                                      .collection('manegar')
                                      .document(mangeId)
                                      .delete();
                                } else {
                                  await _firestore.collection("manegar").add({
                                    "email": _c.text.toString(),
                                  });
                                }
                                showAlertDialogManegActive(
                                    context, "פעולה זו בוצעה בהצלחה");
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            globals.isMeneger
                ? Card(
                    margin: new EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 8.0, bottom: 5.0),
                    //margin: new EdgeInsets.only(top: 8.0, bottom: 5.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // width: 100,
                        // height: 100,
                        child: new Column(
                          children: <Widget>[
                            Row(
                              children: [
                                addMenagger
                                    ? Text(
                                        'חסימת משתמש',
                                        style: TextStyle(
                                            fontFamily: 'Assistant',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    : Text(
                                        'ביטול חסימת משתמש',
                                        style: TextStyle(
                                            fontFamily: 'Assistant',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                Spacer(),
                                IconButton(
                                  icon: new Icon(
                                    Icons.autorenew,
                                    color: Color(int.parse("0xff6ed000")),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      addMenagger = !addMenagger;
                                    });
                                  },
                                ),
                              ],
                            ),
                            new TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: new InputDecoration(
                                hintText: "שם משתמש",
                              ),
                              controller: userBan,
                            ),
                            new FlatButton(
                              child: new Text("שמור",
                                  style: TextStyle(
                                    fontFamily: 'Assistant',
                                    color: Color(int.parse("0xff6ed000")),
                                  )),
                              onPressed: () async {
                                if (addMenagger) {
                                  String IdUser =
                                      await GetuserByName(userBan.text);
                                  print(IdUser);
                                  if (IdUser == "not exist") {
                                    showAlertDialogManegActive(context,
                                        "כתובת מייל זו לא קיימת במערכת ");
                                  }
                                  else {
                                    String userMail= await GetMailuserByName(userBan.text);
                                    String IdBan =
                                        await GetuserBanID(userMail);
                                    if (IdBan == "not exist") {
                                      await _firestore
                                          .collection("banUsers")
                                          .add({
                                        "email": userMail.toLowerCase(),
                                      });
                                      showAlertDialogManegActive(
                                          context, "פעולה זו בוצעה בהצלחה");
                                    } else {
                                      showAlertDialogManegActive(context,
                                          "משתמש זה כבר חסום במערכת");
                                    }
                                  }
                                } else {
                                  String userMail= await GetMailuserByName(userBan.text);
                                  String IdBan =
                                      await GetuserBanID(userMail);
                                  await Firestore.instance
                                      .collection("banUsers")
                                      .document(IdBan)
                                      .delete();
                                  showAlertDialogManegActive(
                                      context, "פעולה זו בוצעה בהצלחה");
                                }


                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            FlatButton(
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser() != null) {
                  await FirebaseAuth.instance.signOut();
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 27,
                color: Color(int.parse("0xff6ed000")),
                child: Center(
                  child: Text(
                    "התנתק",
                  ),
                ),
              ),
            )
          ])),
    );
  }
}

showAlertDialogManegActive(BuildContext context, mess) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("חזור"),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(mess),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
