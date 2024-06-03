import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'main.dart';
// ignore: unused_import
import 'device_page.dart';

class CalendarPage extends StatefulWidget {
  final List<String> devices;
  final Map<DateTime, List<Event>> events;
  final Function(DateTime date, Event event) onEventAdded;
  final Function(DateTime date, Event event) onEventSelected;

  CalendarPage({
    required this.devices,
    required this.events,
    required this.onEventAdded,
    required this.onEventSelected,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<Event>> _events;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _eventPersonnelController =
      TextEditingController();
  List<String> _selectedDevices = [];

  @override
  void initState() {
    super.initState();
    _events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: _getEventsForDay,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _showAddEventDialog(context);
          },
          child: Text('Aggiungi Evento'),
        ),
        SizedBox(height: 20),
        if (_selectedDay != null && _events[_selectedDay!] != null)
          Expanded(
            child: ListView.builder(
              itemCount: _events[_selectedDay!]!.length,
              itemBuilder: (context, index) {
                Event event = _events[_selectedDay!]![index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fascia Oraria: ${event.time}'),
                      Text('Materiale Necessario: ${event.material}'),
                      Text('Luogo: ${event.location}'),
                      Text('Personale: ${event.personnel}'),
                    ],
                  ),
                  onTap: () {
                    widget.onEventSelected(_selectedDay!, event);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aggiungi Evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _eventNameController,
                  decoration: InputDecoration(labelText: 'Nome Evento'),
                ),
                TextField(
                  controller: _eventTimeController,
                  decoration: InputDecoration(labelText: 'Fascia Oraria'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showDeviceSelectionDialog();
                  },
                  child: Text('Seleziona Dispositivi'),
                ),
                TextField(
                  controller: _eventLocationController,
                  decoration: InputDecoration(labelText: 'Luogo'),
                ),
                TextField(
                  controller: _eventPersonnelController,
                  decoration: InputDecoration(labelText: 'Personale'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                _addEvent();
                Navigator.of(context).pop();
              },
              child: Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  void _showDeviceSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelectedDevices = List.from(_selectedDevices);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Seleziona Dispositivi'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.devices.map((device) {
                    return CheckboxListTile(
                      title: Text(device),
                      value: tempSelectedDevices.contains(device),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedDevices.add(device);
                          } else {
                            tempSelectedDevices.remove(device);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annulla'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDevices = tempSelectedDevices;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Seleziona'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addEvent() {
    if (_selectedDay != null) {
      final newEvent = Event(
        name: _eventNameController.text,
        time: _eventTimeController.text,
        material: '',
        devices: _selectedDevices,
        location: _eventLocationController.text,
        personnel: _eventPersonnelController.text,
        numberOfDevices: _selectedDevices.length,
      );

      setState(() {
        if (_events[_selectedDay!] != null) {
          if (!_events[_selectedDay!]!.contains(newEvent)) {
            _events[_selectedDay!]!.add(newEvent);
          }
        } else {
          _events[_selectedDay!] = [newEvent];
        }
      });

      widget.onEventAdded(_selectedDay!, newEvent);

      _eventNameController.clear();
      _eventTimeController.clear();
      _eventLocationController.clear();
      _eventPersonnelController.clear();
      _selectedDevices.clear();
    }
  }
}
