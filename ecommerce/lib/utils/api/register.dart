import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> registerUser(String email, String password,
    String confirmPassword, bool? seller, String? namaToko) async {
  try {
    var url = '';
    final api = dotenv.env['URL'] ?? '';
    if (seller != null && !seller) {
      url = '$api/api/register/';
    } else {
      url = '$api/api/register/seller';
    }
    final Map<String, String> payload = {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
    if (seller == true) {
      payload['namaToko'] = namaToko!;
    }
    final response = await http.post(
      (Uri.parse(url)),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      return response.body;
    } else {
      return response.body;
    }
  } catch (e) {
    print('Error: $e');
    return 'An error occurred during registration.';
  }
}
