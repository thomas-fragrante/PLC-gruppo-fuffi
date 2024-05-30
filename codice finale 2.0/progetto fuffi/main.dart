import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'calendar_page.dart';
import 'navigation_bar.dart';
import 'device_page.dart';
import 'personnel_page.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  List<String> devices = [];
  List<Map<String, String>> personnel = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      // Home Page with Calendar
      Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedle',
            style: TextStyle(
              fontSize: 24, // Dimensione del testo
              fontWeight: FontWeight.bold, // Grassetto
            ),
            textAlign: TextAlign.center, // Centra il testo
          ),
          backgroundColor: const Color.fromARGB(255, 82, 121, 111),
        ),
        body: CalendarPage(),
      ),
      DevicePage(devices: devices, addDevice: (String device) {
        setState(() {
          devices.add(device);
        });
      }),
      PersonnelPage(personnel: personnel, addPersonnel: (Map<String, String> person) {
        setState(() {
          personnel.add(person);
        });
      }),
      Container(
        child: Center(
          child: Text('Impostazioni'),
        ),
      ),
    ];

    return Scaffold(
      bottomNavigationBar: AppNavigationBar(
        currentPageIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: pages[currentPageIndex],
      floatingActionButton: currentPageIndex == 1 || currentPageIndex == 2
          ? FloatingActionButton(
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
                          onChanged: (value) {
                            newDevice = value;
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
                            onPressed: () {
                              setState(() {
                                devices.add(newDevice);
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    } else if (currentPageIndex == 2) {
                      // Dialog for adding personnel
                      String name = '';
                      String profession = '';
                      String age = '';
                      return AlertDialog(
                        title: Text('Aggiungi Personale'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                name = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Nome',
                              ),
                            ),
                            TextField(
                              onChanged: (value) {
                                profession = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Professione',
                              ),
                            ),
                            TextField(
                              onChanged: (value) {
                                age = value;
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
                                personnel.add({
                                  'name': name,
                                  'profession': profession,
                                  'age': age,
                                });
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
