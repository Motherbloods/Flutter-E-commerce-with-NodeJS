import 'package:ecommerce/ui/homepage/isipulsa_page.dart';
import 'package:ecommerce/ui/keranjang/keranjang_page.dart';
import 'package:ecommerce/ui/produk&seller/search_page.dart';
import 'package:ecommerce/ui/authpage/register.dart';
import 'package:ecommerce/ui/authpage/login.dart';
import 'package:ecommerce/ui/produkdetail/produkdetail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Tambahkan ini
  await dotenv.load(fileName: 'assets/.env');
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
        '/Isi_Pulsa': (context) => IsipulsaPage(),
        // '/produkdetail': (context) => ProdukDetail(),
        '/keranjang': (context) => KeranjangPage(),
      },
    );
  }
}
