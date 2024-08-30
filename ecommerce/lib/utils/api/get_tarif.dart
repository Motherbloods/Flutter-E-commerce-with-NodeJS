import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, dynamic>>> getTarif(String origin, String destination,
    String courier, int weight, String volume) async {
  final String? key = dotenv.env['API_KEY'];
  // final String? apiURL = dotenv.env['API_URL_TARIF'];

  if (key == null) {
    print('API key or URL is missing in environment variables.');
    return [];
  }
  final String url =
      'https://api.binderbyte.com/v1/cost?api_key=$key&courier=$courier&origin=$origin&destination=$destination&weight=$weight&volume=$volume';

  try {
    final response = await Dio().get(url);
    final data = response.data['data']['costs'] as List;
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        data.map((item) {
          return {
            'code': item['code'],
            'name': item['name'],
            'service': item['service'],
            'type': item['type'],
            'price': item['price'],
            'estimated': item['estimated'],
          };
        }),
      );
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('An error occurred: $e');
    return [];
  }
}
