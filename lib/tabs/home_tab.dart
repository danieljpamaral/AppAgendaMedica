import 'dart:html';

import 'package:flutter/material.dart';
import 'package:plantao/models/locais_model.dart';
import 'package:plantao/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}


class _HomeTabState extends State<HomeTab> {
  @override
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  Key _keyCalendar;
  Color colorEvent;


//  SharedPreferences prefs;

  List<DateTime> list = List<DateTime>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _events = {};
    _eventController = TextEditingController();
    _selectedEvents = [];
    _controller = CalendarController();
    _keyCalendar = Key("teste");
    colorEvent = Colors.yellow;
  }

  Widget build(BuildContext context) {

    return ScopedModelDescendant<UserModel>(
      builder: (build, child, userModel) {
        return ScopedModelDescendant<LocaisModel>(
          builder: (build, child, locaisModel) {

            Widget Calen(Color cor){
              return TableCalendar(
                key: _keyCalendar,
                eventLoader: (day){
                  return _getEventsForDay(day);
                },
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                    markersColor: cor,
                    todayColor: Colors.grey,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                onDaySelected: (date, events) {
                  list.add(date);
                  print(date.toIso8601String());
                },

                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) {



                    return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )
                    );
                  },
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                calendarController: _controller,
                locale: 'pt-BR',
              );
            };



            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Calen(colorEvent),
                    )
                    /* ListView(
              children: <Widget>[
                if(list.isNotEmpty){
                  for(DateTime d in list){
                    ListTile(title: Text(d.toIso8601String()))
                  }
                }
              ],
            )*/
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: _showAddDialog,
              ),
            );
          },
        );
      },
    );
  }

  // Retorna lista de eventos de um determinado dia
  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }




  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _eventController,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty)
                      return Navigator.pop(context);
                    setState(() {
                      if (_events[_controller.selectedDay] != null) {

                        _events[_controller.selectedDay]
                            .add(_eventController.text);
                      } else {
                        _events[_controller.selectedDay] = [
                          _eventController.text
                        ];
                      }
//                  prefs.setString("events", json.encode(encodeMap(_events)));
                      _eventController.clear();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }
}
