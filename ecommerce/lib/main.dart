import 'package:ecommerce/ui/home_page.dart';
import 'package:ecommerce/ui/isipulsa_page.dart';
import 'package:ecommerce/ui/search_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/searchpage': (context) => SearchPage(),
        '/Isi_Pulsa': (context) => IsipulsaPage()
      },
    );
  }
}
