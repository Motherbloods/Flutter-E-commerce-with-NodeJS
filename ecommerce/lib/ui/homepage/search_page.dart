import 'package:ecommerce/models/searchSuggest.dart';
import 'package:ecommerce/ui/produk&seller/produksearch.dart';
import 'package:ecommerce/module/search_helper.dart';
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
  bool _isSubmitted = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Pastikan untuk dispose controller saat widget dihapus
    super.dispose();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  List<SearchSuggest> _searchSuggestions = [];
  bool _isLoading = false;
  bool _initialSearch = true;

  void _onSearchChanged(String query) async {
    SearchHelper.onSearchChanged(
      query,
      _searchSuggestions,
      _isLoading,
      _userId,
      _initialSearch,
      (suggestions, isLoading, initialSearch) {
        setState(() {
          _searchSuggestions = suggestions;
          _isLoading = isLoading;
          _initialSearch = initialSearch;
        });
      },
    );
  }

  void _onSuggestionSelected(String suggest) {
    setState(() {
      _currentQuery = suggest;
      _searchController.text = suggest;
    });
  }

  void _onSubmitted(String query, bool isSubmitted) {
    print(query);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProdukSearch(query: query, submit: isSubmitted),
        ));
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
            _onSubmitted(_searchController.text, _isSubmitted);
          },
        ),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.camera_alt),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _searchSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchSuggestions[index]
                      .suggest!), // Asumsikan `SearchSuggest` memiliki field `name`
                  onTap: () {
                    _onSuggestionSelected(_searchSuggestions[index].suggest!);
                    _onSubmitted(_searchSuggestions[index].suggest!, true);
                  },
                );
              },
            ),
    );
  }
}
