import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  final List<String> devices;
  final ValueChanged<String> addDevice;

  const DevicePage({
    Key? key,
    required this.devices,
    required this.addDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispositivi'),
        backgroundColor: const Color.fromARGB(255, 82, 121, 111),
      ),
      body: devices.isEmpty
          ? Center(
              child: Text(
                'Nessun dispositivo aggiunto',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
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
                  child: Text(
                    devices[index],
                    style: TextStyle(
                      color: index % 2 == 0 ? Colors.blue : Colors.green,
                      fontSize: 18.0,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
