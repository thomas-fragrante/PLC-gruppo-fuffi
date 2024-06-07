import 'package:shared_preferences/shared_preferences.dart';
import 'calendarpage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});
  
  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  List<String> dispositivi = [];
  List<Map<String, String>> personale = [];
  List<Map<String, dynamic>> eventi = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dispositivi = (prefs.getStringList('dispositivi') ?? []);
      personale = (jsonDecode(prefs.getString('personale') ?? '[]') as List).map((e) => Map<String, String>.from(e)).toList();
      eventi = (jsonDecode(prefs.getString('eventi') ?? '[]') as List).map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dispositivi', dispositivi);
    await prefs.setString('personale', jsonEncode(personale));
    await prefs.setString('eventi', jsonEncode(eventi));
  }

  void _addEvent(DateTime startDate, TimeOfDay startTime, DateTime endDate, TimeOfDay endTime, String title, List<String> selectedDispositivi, List<String> selectedPersonale) {
    setState(() {
      eventi.add({
        'startDate': startDate.toIso8601String(),
        'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
        'endDate': endDate.toIso8601String(),
        'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
        'title': title,
        'dispositivi': selectedDispositivi,
        'personale': selectedPersonale,
      });
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      // Home Page
      Scaffold(
        body: MyCalendar(
          
          eventi: eventi,
          dispositivi: dispositivi,
          personale: personale,
          onCreateEvent: _addEvent,
        ),
      ),
      // Devices Page
      Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 132, 169, 140),
        ),
        body: dispositivi.isEmpty
            ? Center(
                child: Text(
                  'Nessun dispositivo aggiunto',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              )
            : ListView.builder(
                itemCount: dispositivi.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            dispositivi[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Iconsax.box_remove, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              dispositivi.removeAt(index);
                              _saveData();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      // Personnel Page
      Scaffold(
        appBar: AppBar(
          title: Text('Personale'),
          backgroundColor: const Color.fromARGB(255, 132, 169, 140),
        ),
        body: personale.isEmpty
            ? Center(
                child: Text(
                  'Nessun personale aggiunto',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              )
            : ListView.builder(
                itemCount: personale.length,
                itemBuilder: (context, index) {
                  final person = personale[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome: ${person['nome']!}',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Professione: ${person['professione']!}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                'Età: ${person['eta']!}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          splashColor: Color.fromARGB(255, 132, 169, 140),
                          icon: Icon(Iconsax.profile_delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              personale.removeAt(index);
                              _saveData();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      // Settings Page
      
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 90,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 132, 169, 140),
        indicatorColor: const Color.fromARGB(255, 82, 121, 111),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Iconsax.home_2),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.box),
            label: 'Dispositivi',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.personalcard),
            label: 'Personale',
          ),
          
        ],
      ),
      body: pages[currentPageIndex],
      floatingActionButton: currentPageIndex == 1 || currentPageIndex == 2
          ? FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 132, 169, 140),
              splashColor: Color.fromARGB(255, 132, 169, 140),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    if (currentPageIndex == 1) {
                      // Dialog for adding a device
                      String newDevice = '';
                      return AlertDialog(
                        title: Text('Aggiungi Dispositivo'),
                        content: TextField(
                          onChanged: (valore) {
                            newDevice = valore;
                          },
                          decoration: InputDecoration(
                            hintText: 'Nome del dispositivo',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Annulla'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Aggiungi'),
                            onPressed: () async {
                              setState(() {
                                dispositivi.add(newDevice);
                                _saveData();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    } else if (currentPageIndex == 2) {
                      // Dialog for adding personnel
                      String nome = '';
                      String professione = '';
                      String eta = '';
                      return AlertDialog(
                        title: Text('Aggiungi Personale'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (valore) {
                                nome = valore;
                              },
                              decoration: InputDecoration(
                                hintText: 'Nome',
                              ),
                            ),
                            TextField(
                              onChanged: (valore) {
                                professione = valore;
                              },
                              decoration: InputDecoration(
                                hintText: 'Professione',
                              ),
                            ),
                            TextField(
                              onChanged: (valore) {
                                eta = valore;
                              },
                              decoration: InputDecoration(
                                hintText: 'Età',
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Annulla'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Aggiungi'),
                            onPressed: () {
                              setState(() {
                                personale.add({
                                  'nome': nome,
                                  'professione': professione,
                                  'eta': eta,
                                });
                                _saveData();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
