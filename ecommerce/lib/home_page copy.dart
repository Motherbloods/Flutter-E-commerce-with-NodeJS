import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utils/blade/navbar_page.dart';
import 'package:ecommerce/utils/api/get_recomen.dart';
import 'package:ecommerce/utils/blade/product_grid.dart';
import 'package:ecommerce/ui/homepage/product_recomen.dart';
import 'package:ecommerce/ui/produk&seller/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      bottomNavigationBar: NavbarPage(selectedIndex: _selectedIndex),
      body: FutureBuilder(
        future: getProducts(widget.token!),
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
                                                    token: widget.token,
                                                  )),
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
                                ProductGrid(products: products)
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
