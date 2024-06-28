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
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';
  String kabupaten = '';
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

  Future<void> getUser() async {
    final url = dotenv.env['URL'] ?? '';
    String api = '$url/api/user?id=${widget.isUser}';

    try {
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
          isLoading = false;
          kabupaten = userData?['alamat'][1]['kabupatenId'];
        });

        if (kabupaten != null) {
          var api_key = dotenv.env['API_KEY'] ?? '';
          var url2 =
              'https://api.binderbyte.com/v1/cost?api_key=$api_key&courier=jne,sicepat,anteraja,lion,sap,pos,ide&origin=$kabupaten&destination=jakarta&weight=1&volume=100x100x100';
          final response2 = await http.get(Uri.parse(url2));

          if (response2.statusCode == 200) {
          } else {
            print('Failed to fetch cost data: ${response2.reasonPhrase}');
          }
        } else {
          print('kabupaten is null');
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load user data: ${response.reasonPhrase}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
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
