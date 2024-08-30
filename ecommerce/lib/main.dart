import 'package:ecommerce/ui/conversation_provider.dart';
import 'package:ecommerce/ui/homepage/isipulsa_page.dart';
import 'package:ecommerce/ui/cart_checkout/keranjang_page.dart';
import 'package:ecommerce/ui/authpage/register.dart';
import 'package:ecommerce/ui/authpage/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Tambahkan ini
  await dotenv.load(fileName: 'assets/.env');
  runApp(
    ChangeNotifierProvider(
      create: (context) => ConversationProvider(),
      child: MyApp(),
    ),
  );
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
