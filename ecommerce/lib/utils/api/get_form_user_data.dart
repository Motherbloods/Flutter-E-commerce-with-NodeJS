// api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, String>>> fetchProvinsi() async {
  final String? key = dotenv.env['API_KEY'];
  final String? apiURL = dotenv.env['API_URL'];

  if (key == null || apiURL == null) {
    print('API key or URL is missing in environment variables.');
    return [];
  }

  final String url = '${apiURL}provinsi?api_key=$key';

  try {
    final response = await Dio().get(url);
    final data = response.data['value'] as List;

    if (response.statusCode == 200) {
      return List<Map<String, String>>.from(
        data.map((item) {
          return {
            'id': item['id'].toString(),
            'name': item['name'].toString(),
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

Future<List<Map<String, String>>> fetchKabupaten(String provinceId) async {
  final String? key = dotenv.env['API_KEY'];
  final String? apiURL = dotenv.env['API_URL'];

  if (key == null || apiURL == null) {
    print('API key or URL is missing in environment variables.');
    return [];
  }

  final String url = '${apiURL}kabupaten?api_key=$key&id_provinsi=$provinceId';

  try {
    final response = await Dio().get(url);
    final data = response.data['value'] as List;
    if (response.statusCode == 200) {
      return List<Map<String, String>>.from(
        data.map((item) {
          return {
            'id': item['id'].toString(),
            'name': item['name'].toString(),
          };
        }),
      );
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching kabupaten: $e');
    return [];
  }
}

Future<List<Map<String, String>>> fetchKecamatan(String kabupatenId) async {
  final String? key = dotenv.env['API_KEY'];
  final String? apiURL = dotenv.env['API_URL'];

  if (key == null || apiURL == null) {
    print('API key or URL is missing in environment variables.');
    return [];
  }

  final String url =
      '${apiURL}kecamatan?api_key=$key&id_kabupaten=$kabupatenId';

  try {
    final response = await Dio().get(url);
    final data = response.data['value'] as List;
    if (response.statusCode == 200) {
      return List<Map<String, String>>.from(
        data.map((item) {
          return {
            'id': item['id'].toString(),
            'name': item['name'].toString(),
          };
        }),
      );
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching kecamatan: $e');
    return [];
  }
}

Future<List<Map<String, String>>> fetchDesa(String kecamatanId) async {
  final String? key = dotenv.env['API_KEY'];
  final String? apiURL = dotenv.env['API_URL'];

  if (key == null || apiURL == null) {
    print('API key or URL is missing in environment variables.');
    return [];
  }

  final String url =
      '${apiURL}kelurahan?api_key=$key&id_kecamatan=$kecamatanId';

  try {
    final response = await Dio().get(url);
    final data = response.data['value'] as List;
    if (response.statusCode == 200) {
      return List<Map<String, String>>.from(
        data.map((item) {
          return {
            'id': item['id'].toString(),
            'name': item['name'].toString(),
          };
        }),
      );
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching desa: $e');
    return [];
  }
}
