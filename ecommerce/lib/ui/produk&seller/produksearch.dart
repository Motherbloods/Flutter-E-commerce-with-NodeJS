import 'package:ecommerce/utils/blade/product_grid.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdukSearch extends StatefulWidget {
  final String query;
  final bool submit;
  final String isUser;

  ProdukSearch(
      {required this.query, required this.submit, required this.isUser});
  @override
  State<ProdukSearch> createState() => _ProdukSearchState();
}

class _ProdukSearchState extends State<ProdukSearch> {
  Future<List<Product>> _getProductsSearch() async {
    final url = dotenv.env['URL'] ?? '';
    String api =
        '/api/search-products?q=${widget.query}&userId=${widget.isUser}';

    final response = await http.get(Uri.parse('$url$api'));
    var jsonData = json.decode(response.body);
    List<Product> products = [];
    for (var item in jsonData) {
      products.add(Product.fromJson(item));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _getProductsSearch(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No Products available'),
          );
        } else {
          List<Product> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: const [
                          Align(
                            alignment:
                                Alignment.centerLeft, // Align text to the left
                            child: Text(
                              'Produk',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProductGrid(products: products, search: true)
                  ],
                ),
              ));
            },
          );
        }
      },
    ));
  }
}
