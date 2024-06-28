import 'package:ecommerce/models/searchSuggest.dart';
import 'package:ecommerce/ui/produk&seller/produksearch.dart';
import 'package:ecommerce/utils/blade/search_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _userId = '';
  String _currentQuery = '';
  String _selectId = '';
  late TextEditingController _searchController;
  int _currentIndex = 0; // Index of the current view

  List<dynamic> _searchresults = [];
  bool _isLoading = false;
  bool _initialSearch = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
      _onSearchChanged(''); // Load initial search history when userId is loaded
    });
  }

  void _onSearchChanged(
    String query,
  ) async {
    setState(() {
      _isLoading = true;
    });
    SearchHelper.onSearchChanged(
      query,
      _isLoading,
      _userId,
      _initialSearch,
      _selectId,
      (result, isLoading, initialSearch) {
        setState(() {
          _searchresults = result;
          _isLoading = isLoading;
          _initialSearch = initialSearch;
          _currentIndex = 0; // Back to the search suggestions view
        });
      },
    );
  }

  void _onSuggestionSelected(String suggest, String selectId) {
    setState(() {
      _currentQuery = suggest;
      _selectId = selectId;
      _searchController.text = suggest;
      _currentIndex = 1; // Switch view to ProdukSearch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          autofocus: true,
          controller: _searchController,
          onChanged: _onSearchChanged,
          onTap: () {
            if (_initialSearch) {
              _onSearchChanged('');
            }
          },
          onSubmitted: (query) {
            setState(() {
              _currentQuery = query;
              _currentIndex = 1; // Switch view to ProdukSearch
            });
          },
        ),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.camera_alt),
            ),
            onTap: () {
              // Add camera functionality here
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: [
                ListView.builder(
                  itemCount: _searchresults.length,
                  itemBuilder: (context, index) {
                    var item = _searchresults[index];
                    if (item is SearchSuggest) {
                      return ListTile(
                        title: Text(item.suggest!),
                        onTap: () {
                          _onSuggestionSelected(item.suggest!, item.id!);
                        },
                      );
                    } else {
                      return ListTile(
                        title: Text(item.searchValue!),
                        onTap: () {
                          _onSuggestionSelected(item.searchValue!, item.id!);
                        },
                      );
                    }
                  },
                ),
                ProdukSearch(
                    query: _currentQuery, submit: true, isUser: _userId),
              ],
            ),
    );
  }
}
