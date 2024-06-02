import 'package:ecommerce/models/searchSuggest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchHelper {
  static Future<List<SearchSuggest>> getSearchSuggest(
      String query, String userId) async {
    final url = dotenv.env['URL'] ?? '';
    String api = '/api/suggest?q=$query';

    // if (query.isNotEmpty) {
    //   api = '/api/suggest?q=$query';
    // } else {
    //   api = '/api/suggest?user=$userId';
    // }

    final response = await http.get(Uri.parse('$url$api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<SearchSuggest> searchSuggests = [];

      for (var item in jsonData) {
        searchSuggests.add(SearchSuggest.fromJson(item));
      }
      return searchSuggests;
    } else {
      throw Exception('Failed to load search suggestions');
    }
  }

  static void onSearchChanged(
    String query,
    List<SearchSuggest> searchSuggestions,
    bool isLoading,
    String userId,
    bool initialSearch,
    void Function(List<SearchSuggest>, bool, bool) onSearchChangedCallback,
  ) async {
    if (query.isEmpty) {
      onSearchChangedCallback([], false, false);
      return;
    }

    onSearchChangedCallback([], true, false);

    var suggestions = await getSearchSuggest(query, userId);
    onSearchChangedCallback(suggestions, false, false);
  }
}
