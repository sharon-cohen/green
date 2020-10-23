import 'package:flutter/material.dart';
import 'package:greenpeace/evants/event_firestore_service.dart';
import 'event_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:greenpeace/evants/event_page.dart';
import 'package:greenpeace/Component/Alret_Dealog.dart';
import 'package:greenpeace/global.dart' as globals;

class Calender extends StatefulWidget {
  Calender({Key key}) : super(key: key);
  static const String id = 'Calender';
  @override
  CalenderState createState() => CalenderState();
}

class CalenderState extends State<Calender> {
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
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Image.asset('image/logo_greem.png', scale: 2)),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(
          //       Icons.arrow_back_outlined,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {
          //       Navigator.pop(context, true);
          //     },
          //   )
          // ],
          automaticallyImplyLeading: false),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
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
                          events: _events,
                          initialCalendarFormat: CalendarFormat.month,
                          calendarStyle: CalendarStyle(
                              canEventMarkersOverflow: true,
                              todayColor: Color(int.parse("0xff6ed000")),
                              selectedColor: Color(int.parse("0xff6ed000")),
                              todayStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white)),
                          headerStyle: HeaderStyle(
                            centerHeaderTitle: true,
                            formatButtonDecoration: BoxDecoration(
                              color: Color(int.parse("0xff6ed000")),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            formatButtonTextStyle:
                                TextStyle(color: Colors.white),
                            formatButtonShowsNext: false,
                          ),
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          onDaySelected: (date, events) {
                            setState(() {
                              _selectedEvents = events;
                            });
                          },
                          builders: CalendarBuilders(
                            selectedDayBuilder: (context, date, events) =>
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color(int.parse("0xff6ed000")),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Assistant'),
                                    )),
                            todayDayBuilder: (context, date, events) =>
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        // color: Color(int.parse("0xff6ed000")),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Assistant'),
                                    )),
                          ),
                          calendarController: _controller,
                        ),
                        ..._selectedEvents.map((event) => ListTile(
                              title: Text(event.title,
                                  style: new TextStyle(
                                    fontFamily: 'Assistant',
                                  )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => EventDetailsPage(
                                              event: event,
                                            )));
                              },
                            )),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(int.parse("0xff6ed000")),
          child: Icon(Icons.add),
          onPressed: () {
            if (globals.no_reg == true) {
              GoregisterAlertDialog(context);
            } else {
              Navigator.pushNamed(context, 'new_event');
            }
          }),
    );
  }
}
