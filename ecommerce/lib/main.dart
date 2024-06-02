import 'package:ecommerce/ui/homepage/home_page.dart';
import 'package:ecommerce/ui/homepage/isipulsa_page.dart';
import 'package:ecommerce/ui/homepage/search_page.dart';
// import 'package:ecommerce/login_page.dart';
import 'package:ecommerce/ui/authpage/register.dart';
import 'package:ecommerce/ui/authpage/login.dart';
import 'package:ecommerce/ui/produkdetail/produkdetail_page.dart';
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
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/searchpage': (context) => SearchPage(),
        '/Isi_Pulsa': (context) => IsipulsaPage(),
        '/produkdetail': (context) => ProdukDetail()
      },
    );
  }
}
