import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentPageIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationBar({
    Key? key,
    required this.currentPageIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 80,
      onDestinationSelected: onDestinationSelected,
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
        NavigationDestination(
          icon: Icon(Iconsax.setting_24),
          label: 'Impostazioni',
        ),
      ],
    );
  }
}
