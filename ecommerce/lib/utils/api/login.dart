import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> loginUser(
    String email, String password, bool? seller) async {
  try {
    var url = '';
    final api = dotenv.env['URL'] ?? '';
    if (seller != null && !seller) {
      url = '$api/api/login';
    } else {
      url = '$api/api/login/seller';
    }

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'token': responseData['token'],
        'userId': responseData['id'],
      };
    } else {
      return {
        'success': false,
        'message': 'Login failed',
      };
    }
  } catch (e) {
    print('Error: $e');
    return {
      'success': false,
      'message': 'An error occurred. Please check your internet connection.',
    };
  }
}
