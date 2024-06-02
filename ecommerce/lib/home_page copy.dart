import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/ui/homepage/product_recomen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String? token;

  HomePage({required this.token});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IconData> myIcons = [
    Icons.phone_android,
    Icons.power,
    Icons.local_drink,
    Icons.menu,
  ];

  Future<List<Product>> _getProducts() async {
    String url = 'http://192.168.43.41:8000/api/home';

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/searchpage');
          },
          child: Container(
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1.4),
                borderRadius: BorderRadius.circular(10)),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Search Product . . .',
                  style: TextStyle(color: Colors.grey),
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
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.notifications), label: 'Notifikasi'),
          NavigationDestination(
              icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
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
            // List<Product> products = snapshot.data!;
            // print(products);
            // return ListView.builder(
            //   itemCount: products.length,
            //   itemBuilder: (context, index) {
            //     Product product = products[index];
            //     String categories =
            //         product.category?.join(', ') ?? 'No categories';
            //     return ListTile(
            //       title: Text('Product: ${categories}'),
            //       subtitle: Text('ID: ${product.id}, Price: ${product.price}'),
            //     );
            //   },
            // );
            List<Product> products = snapshot.data!;
            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          //Layanan
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: SizedBox(
                              height: 100.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children:
                                    List.generate(myIcons.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      navigateToPage(
                                          context, myIconNames[index]);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              myIcons[index],
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              60, // Set a width to constrain the text
                                          child: Text(
                                            myIconNames[index],
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign
                                                .center, // Center align the text
                                            maxLines:
                                                2, // Allow text to wrap to 2 lines
                                            overflow: TextOverflow
                                                .ellipsis, // Handle overflow
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          //Rekomendasi
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment
                                          .centerLeft, // Align text to the left
                                      child: Text(
                                        'Recommendations',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigasi ke halaman semua produk
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllProdukRecomendations(
                                                      token: widget.token)),
                                        );
                                      },
                                      child: Text(
                                        'Lihat Semua Produk',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 21,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GridView.builder(
                                    itemCount: 4,
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
                                                        'https://picsum.photos/id/1/600/700'),
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
                                                    Text(
                                                      '${formatedPrice}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
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
