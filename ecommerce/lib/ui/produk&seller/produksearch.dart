import 'package:ecommerce/module/product_grid.dart';
import 'package:ecommerce/ui/homepage/search_page.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdukSearch extends StatefulWidget {
  final String query;
  final bool submit;

  ProdukSearch({required this.query, required this.submit});
  @override
  State<ProdukSearch> createState() => _ProdukSearchState();
}

class _ProdukSearchState extends State<ProdukSearch> {
  Future<List<Product>> _getProductsSearch() async {
    String url = dotenv.env['URL'] ?? '';
    print('ini widget query ${widget.query}');
    var data = await http.get(Uri.parse(
        '${url}/api/suggest?q=${widget.query}&submit=${widget.submit}'));

    var jsonData = json.decode(data.body);
    print(jsonData);
    List<Product> products = [];
    for (var item in jsonData) {
      products.add(Product.fromJson(item));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 1.4),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${widget.query}',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          actions: [
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {},
            )
          ],
        ),
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
                itemCount: 1,
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
                                alignment: Alignment
                                    .centerLeft, // Align text to the left
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
                        ProductGrid(products: products)
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
