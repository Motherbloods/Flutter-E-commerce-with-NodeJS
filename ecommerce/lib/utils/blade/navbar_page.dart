import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavbarPage extends StatelessWidget {
  final selectedIndex;
  NavbarPage({required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 60,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      selectedIndex: 0,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.notifications), label: 'Notifikasi'),
        NavigationDestination(
            icon: Icon(Icons.account_circle), label: 'Profil'),
      ],
    );
  }
}
