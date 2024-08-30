import 'package:flutter/material.dart';
import 'package:ecommerce/irfan/service/api_service.dart';
import 'package:ecommerce/irfan/service/shared_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              SharedService.logout(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: UserProfile(),
    );
  }

  Widget UserProfile() {
    return FutureBuilder<String?>(
      future: ApiService.getUserProfile(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return Center(
            child: Text(snapshot.data!),
          );
        } else {
          return const Center(
            child: Text('No data found'),
          );
        }
      },
    );
  }
}
