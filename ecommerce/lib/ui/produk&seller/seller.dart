import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/seller.dart';
import 'package:ecommerce/ui/produk&seller/produkDetail.dart';
import 'package:ecommerce/module/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SellerPage extends StatefulWidget {
  final String sellerId;

  SellerPage({required this.sellerId});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  Future<Map<String, dynamic>> _getSeller() async {
    final url = dotenv.env['URL'] ?? '';
    var response =
        await http.get(Uri.parse('$url/api/seller/${widget.sellerId}'));
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Failed to load seller');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getSeller(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No Seller available'),
            );
          } else {
            Map<String, dynamic> data = snapshot.data!;
            Seller seller = Seller.fromJson(data['seller']);
            List<dynamic> dataProduct = snapshot.data!['product'];
            List<Product> products =
                dataProduct.map((item) => Product.fromJson(item)).toList();

            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${seller.namaToko}',
                        ),
                        subtitle: Text('${seller.kategoriPenjualanBrg}'),
                      ),
                      Padding(
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
                            ProductGrid(seller: seller, products: products)
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
