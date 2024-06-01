import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AllProdukRecomendations extends StatefulWidget {
  final String? token;

  AllProdukRecomendations({required this.token});
  @override
  State<AllProdukRecomendations> createState() =>
      _AllProdukRecomendationsState();
}

class _AllProdukRecomendationsState extends State<AllProdukRecomendations> {
  List<IconData> myIcons = [
    Icons.phone_android,
    Icons.power,
    Icons.local_drink,
    Icons.menu,
  ];

  Future<List<Product>> _getProducts() async {
    String url = 'http://192.168.128.30:8000/api/home';

    var data = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ' + widget.token!,
        'Content-Type': 'application/json',
      },
    );
    var jsonData = json.decode(data.body);
    List<Product> products = [];
    for (var item in jsonData) {
      products.add(Product.fromJson(item));
    }
    return products;
  }

  List<String> myIconNames = [
    'Isi Pulsa',
    'Isi Token Listrik',
    'Bayar PDAM',
    'Lainnya',
  ];

  void navigateToPage(BuildContext context, String pageName) {
    String routeName = pageName.replaceAll(' ', '_');
    Navigator.pushNamed(context, '/$routeName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk Recommended'),
      ),
      body: FutureBuilder(
        future: _getProducts(),
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
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GridView.builder(
                                    itemCount: products.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      mainAxisExtent: 288,
                                    ),
                                    itemBuilder: (context, index) {
                                      Product product = products[index];
                                      String formatedPrice =
                                          NumberFormat.currency(
                                                  locale: 'id_ID',
                                                  decimalDigits: 0,
                                                  symbol: 'Rp ')
                                              .format(product.price);
                                      return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 180,
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  blurRadius: 50,
                                                  spreadRadius: 7,
                                                  offset: const Offset(0, 2),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              //gambar
                                              Container(
                                                height: 180,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                color: Colors.white,
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      'http://192.168.128.30:8000${product.imageUrl}',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Center(
                                                          child: Text(
                                                            'Failed to load image',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        );
                                                      },
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                    ),
                                                    Positioned(
                                                      top: 8,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color:
                                                                Colors.amber),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 4),
                                                        child: const Text(
                                                          '25%',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //detail
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${product.name}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${product.sellerName}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Icon(
                                                          Icons.verified,
                                                          color: Colors.blue,
                                                          size: 14,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '${formatedPrice}',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                            '${product.totalUnitsSold} terjual')
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
