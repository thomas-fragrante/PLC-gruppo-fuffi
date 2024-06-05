import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  final List<Map<String, dynamic>> eventi;
  final List<String> dispositivi;
  final List<Map<String, String>> personale;
  final Function(DateTime, TimeOfDay, DateTime, TimeOfDay, String, List<String>, List<String>) onCreateEvent;

  MyCalendar({
    required this.eventi,
    required this.dispositivi,
    required this.personale,
    required this.onCreateEvent,
  });

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime today = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
    _showEventsDialog(selectedDay);
  }

  void _showEventsDialog(DateTime day) {
    showDialog(
      context: context,
      builder: (context) {
        final events = widget.eventi.where((event) {
          final startDate = DateTime.parse(event['startDate']);
          final endDate = DateTime.parse(event['endDate']);
          return isSameDay(startDate, day) ||
              isSameDay(endDate, day) ||
              (startDate.isBefore(day) && endDate.isAfter(day));
        }).toList();
        return AlertDialog(
          title: Text("Eventi del giorno"),
          content: events.isEmpty
              ? Text("Nessun evento")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: events.map((event) {
                    return ListTile(
                      title: Text(event['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Inizio: ${event['startTime']}"),
                          Text("Fine: ${event['endTime']}"),
                          Text("Dispositivi usati: ${event['dispositivi'].join(', ')}"),
                          Text("Personale coinvolto: ${event['personale'].join(', ')}"),
                        ],
                      ),
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              child: Text("Chiudi"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        child: calendario(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddEventDialog();
        },
      ),
    );
  }

  void _showAddEventDialog() {
    DateTime startDate = today;
    DateTime endDate = today;
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now();
    String title = '';
    List<String> selectedDispositivi = [];
    List<String> selectedPersonale = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Crea Evento"),
              content: Container(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(
                      onChanged: (valore) {
                        title = valore;
                      },
                      decoration: InputDecoration(hintText: 'Titolo'),
                    ),
                    SizedBox(height: 16),
                    Text("Data di Inizio:"),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != startDate) {
                          setState(() {
                            startDate = picked;
                          });
                        }
                      },
                      child: Text("${startDate.toLocal()}".split(' ')[0]),
                    ),
                    SizedBox(height: 16),
                    Text("Ora di Inizio:"),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (picked != null && picked != startTime) {
                          setState(() {
                            startTime = picked;
                          });
                        }
                      },
                      child: Text("${startTime.format(context)}"),
                    ),
                    SizedBox(height: 16),
                    Text("Data di Fine:"),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != endDate) {
                          setState(() {
                            endDate = picked;
                          });
                        }
                      },
                      child: Text("${endDate.toLocal()}".split(' ')[0]),
                    ),
                    SizedBox(height: 16),
                    Text("Ora di Fine:"),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (picked != null && picked != endTime) {
                          setState(() {
                            endTime = picked;
                          });
                        }
                      },
                      child: Text("${endTime.format(context)}"),
                    ),
                    SizedBox(height: 16),
                    Text("Dispositivi:"),
                    Container(
                      height: 100,
                      child: ListView(
                        children: widget.dispositivi.map((dispositivo) {
                          return CheckboxListTile(
                            title: Text(dispositivo),
                            value: selectedDispositivi.contains(dispositivo),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedDispositivi.add(dispositivo);
                                } else {

                                  selectedDispositivi.remove(dispositivo);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("Personale:"),
                    Container(
                      height: 100,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: widget.personale.map((person) {
                          return CheckboxListTile(
                            title: Text(person['nome']!),
                            value: selectedPersonale.contains(person['nome']!),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedPersonale.add(person['nome']!);
                                } else {
                                  selectedPersonale.remove(person['nome']!);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Annulla"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Crea"),
                  onPressed: () {
                    widget.onCreateEvent(startDate, startTime, endDate, endTime, title, selectedDispositivi, selectedPersonale);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget calendario() {
    return Column(
      children: [
        Spacer(flex: 1),
        Container(
          child: TableCalendar(
            focusedDay: today,
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            selectedDayPredicate: (day) => isSameDay(day, today),
            onDaySelected: _onDaySelected,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              return widget.eventi.where((event) {
                final startDate = DateTime.parse(event['startDate']);
                final endDate = DateTime.parse(event['endDate']);
                return isSameDay(startDate, day) ||
                    isSameDay(endDate, day) ||
                    (startDate.isBefore(day) && endDate.isAfter(day));
              }).toList();
            },
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }
}
