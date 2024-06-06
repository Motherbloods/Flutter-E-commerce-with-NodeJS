import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utils/blade/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllProdukRecomendations extends StatefulWidget {
  final String? token;

  AllProdukRecomendations({required this.token});
  @override
  State<AllProdukRecomendations> createState() =>
      _AllProdukRecomendationsState();
}

class _AllProdukRecomendationsState extends State<AllProdukRecomendations> {
  final List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _page = 1;
  final int _limit = 10;
  @override
  void initState() {
    super.initState();
    _fetchMoreProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _fetchMoreProducts();
      }
    });
  }

  Future<void> _fetchMoreProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Product> newProducts =
          await _getProducts(page: _page, limit: _limit);
      setState(() {
        _page++;
        _products.addAll(newProducts);
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<Product>> _getProducts(
      {required int page, required int limit}) async {
    final api = dotenv.env['URL'] ?? '';

    String url = '${api}/api/home?page=$page&limit=$limit';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + widget.token!,
        'Content-Type': 'application/json',
      },
    );

    var jsonData = json.decode(response.body);
    List<Product> products = [];
    for (var item in jsonData) {
      products.add(Product.fromJson(item));
    }
    return products;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Recommended'),
      ),
      body: _products.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: ProductGrid(
                    products: _products,
                    scrollController: _scrollController,
                    isLoading: _isLoading,
                    recomen: true,
                  ),
                );
              }),
    );
  }
}
