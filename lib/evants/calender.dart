import 'package:flutter/material.dart';
import 'package:greenpeace/evants/event_firestore_service.dart';
import 'event_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:greenpeace/evants/event_page.dart';
class Calender extends StatefulWidget {
  Calender({Key key}) : super(key: key);
  static const String id = 'Calender';
  @override
  CalenderState createState() => CalenderState();
}

class CalenderState extends State<Calender>{
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  Map<DateTime,List<dynamic>>_groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data={};
    events.forEach((event) {
      if(event.approve==true) {
        DateTime date = DateTime(
            event.eventDate.year, event.eventDate.month, event.eventDate.day,
            12);
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
      body: Container(
        margin: const EdgeInsets.all(30),
        child: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context, snapshot) {
           if(snapshot.hasData){
             List<EventModel> allEvents=snapshot.data;
            if(allEvents.isNotEmpty){
                _events=_groupEvents(allEvents);
            }
           }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  TableCalendar(
                    events: _events,
                    initialCalendarFormat: CalendarFormat.week,
                    calendarStyle: CalendarStyle(
                        canEventMarkersOverflow: true,
                        todayColor: Colors.green,
                        selectedColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (date, events) {
                      setState(() {
                        _selectedEvents = events;
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    calendarController: _controller,
                  ),
                  ..._selectedEvents.map((event) => ListTile(
                    title: Text(event.title),
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
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'new_event'),
      ),
    );
  }
}




