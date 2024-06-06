import 'package:ecommerce/models/searchHistory.dart';
import 'package:ecommerce/models/searchSuggest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchHelper {
  static Future<List<SearchSuggest>> getSearchSuggest(
      String query, String selectId) async {
    final url = dotenv.env['URL'] ?? '';
    String api = '/api/suggest?q=$query&selectId=$selectId';

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

  static Future<List<SearchHistory>> getSearchHistory(
      String userId, String selectId) async {
    final url = dotenv.env['URL'] ?? '';
    String api = '/api/suggest?userId=$userId&selectId=$selectId';

    final response = await http.get(Uri.parse('$url$api'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<SearchHistory> searchHistory = [];

      for (var item in jsonData) {
        searchHistory.add(SearchHistory.fromJson(item));
      }
      print('ini broo ${searchHistory.runtimeType}');
      return searchHistory;
    } else {
      throw Exception('Failed to load search history');
    }
  }

  static void onSearchChanged(
    String query,
    bool isLoading,
    String userId,
    bool initialSearch,
    String selectId,
    void Function(List<dynamic>, bool, bool) onSearchChangedCallback,
  ) async {
    try {
      if (query.isEmpty) {
        // Muat riwayat pencarian hanya jika query kosong dan ini pencarian awal
        var history = await getSearchHistory(userId, selectId);
        onSearchChangedCallback(history, false, false);
      } else if (query.isNotEmpty) {
        // Muat saran pencarian hanya jika ada query
        var suggestions = await getSearchSuggest(query, selectId);
        onSearchChangedCallback(suggestions, false, false);
      }
    } catch (e) {
      print("Error during search: $e");
      onSearchChangedCallback([], false, true);
    }
  }
}
