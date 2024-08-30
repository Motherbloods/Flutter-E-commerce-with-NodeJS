import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getSeller(String sellerId) async {
  final url = dotenv.env['URL'] ?? '';
  var response = await http.get(Uri.parse('$url/api/seller/$sellerId'));
  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);
    return jsonData['data'];
  } else {
    throw Exception('Failed to load seller');
  }
}
