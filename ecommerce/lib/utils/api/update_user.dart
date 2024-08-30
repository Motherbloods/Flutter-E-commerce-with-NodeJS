import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> patchUser({
  String? username,
  required String fullName,
  required String id,
  required List<Map<String, String>> alamat,
  List<dynamic>? recommendations,
}) async {
  try {
    final api = dotenv.env['URL'] ?? '';
    String url = '$api/api/update-profile';

    // Membuat peta data untuk permintaan JSON
    final Map<String, dynamic> data = {
      'fullname': fullName,
      'id': id,
      'alamat': alamat,
    };

    // Menambahkan data tambahan hanya jika tidak null
    if (username != null) data['username'] = username;
    if (recommendations != null) data['recommendations'] = recommendations;

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Failed to patch user: ${response.body}');
      return 'Failed to patch user: ${response.statusCode}';
    }
  } catch (e) {
    print('Error: $e');
    return 'An error occurred during patching user.';
  }
}
