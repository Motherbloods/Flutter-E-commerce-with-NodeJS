// navbar_page.dart
import 'package:flutter/material.dart';

class NavbarPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  NavbarPage({required this.selectedIndex, required this.onItemTapped});

  @override
  _NavbarPageState createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 60,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onItemTapped,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.message), label: 'Chat'),
        NavigationDestination(
            icon: Icon(Icons.account_circle), label: 'Profil'),
      ],
    );
  }
}
