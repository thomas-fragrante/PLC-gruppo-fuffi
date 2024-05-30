import 'package:flutter/material.dart';

class PersonnelPage extends StatelessWidget {
  final List<Map<String, String>> personnel;
  final ValueChanged<Map<String, String>> addPersonnel;

  const PersonnelPage({
    Key? key,
    required this.personnel,
    required this.addPersonnel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personale'),
        backgroundColor: const Color.fromARGB(255, 82, 121, 111),
      ),
      body: personnel.isEmpty
          ? Center(
              child: Text(
                'Nessun personale aggiunto',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: personnel.length,
              itemBuilder: (context, index) {
                final person = personnel[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome: ${person['name']!}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        'Professione: ${person['profession']!}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        'Età: ${person['age']!}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
