// main_screen.dart
import 'package:ecommerce/home_page%20copy.dart';
import 'package:ecommerce/ui/chat/list_chat.dart';
import 'package:ecommerce/ui/profil.dart';
import 'package:ecommerce/utils/blade/navbar_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String? token;

  MainScreen({required this.token});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomePage(token: widget.token),
      ListConversationsPage(),
      ProfilPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: NavbarPage(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
