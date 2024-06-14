import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/seller.dart';
import 'package:ecommerce/ui/produkdetail/deskripsi.dart';
import 'package:ecommerce/ui/produkdetail/modal_varian.dart';
import 'package:ecommerce/ui/produkdetail/reviews.dart';
import 'package:ecommerce/utils/api/get_seller.dart';
import 'package:ecommerce/utils/blade/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentImage = 0;
  int _selectedTabIndex = 0;
  int _selectedColorIndex = 0;

  final List<String> images = [
    'https://picsum.photos/id/21/1280/853',
    'https://picsum.photos/id/22/1280/853',
    'https://picsum.photos/id/23/1280/853',
  ];
  final List<String> colorOptions = ['Red'];

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID',
      decimalDigits: 0,
      symbol: 'Rp ',
    ).format(widget.product.price);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.share_outlined,
                color: Colors.black,
              ),
            ),
            onTap: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // detail image slider
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: 1,
                  onPageChanged: (int index) {
                    setState(() {
                      currentImage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    var url = dotenv.env['URL'];
                    return Hero(
                      tag: images[index],
                      child: Image.network('$url${widget.product.imageUrl}'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: currentImage == index ? 15 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentImage == index
                          ? Colors.black
                          : Colors.transparent,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //nama produk, harga rating dan toko
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.product.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 25,
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${formattedPrice}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                //rating
                                Row(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.orangeAccent,
                                      ),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '4.9',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '500 Review',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const Spacer(),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Seller: ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  TextSpan(
                                    text: '${widget.product.sellerName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // ---
                    const SizedBox(height: 25),
                    // Deskripsi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTabIndex = 0;
                                });
                              },
                              child: Container(
                                width: 160,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _selectedTabIndex == 0
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Deskripsi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTabIndex == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTabIndex = 1;
                                });
                              },
                              child: Container(
                                width: 160,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _selectedTabIndex == 1
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Ulasan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTabIndex == 1
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _selectedTabIndex == 0
                            ? Deskripsi()
                            : Reviews(
                                reviews: widget.product.reviews,
                              )
                      ],
                    ),
                    //produk lain
                    Text('Produk Lain Dari Toko Ini'),
                    FutureBuilder<Map<String, dynamic>>(
                      future: getSeller(widget.product.sellerId!),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          List<Product> products = dataProduct
                              .map((item) => Product.fromJson(item))
                              .toList();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Produk',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                ProductGrid(seller: seller, products: products)
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (widget.product.variants!.isNotEmpty) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return VariantModal(
                        selectedColorIndex: _selectedColorIndex,
                        onColorSelected: (int selectedIndex) {
                          setState(() {
                            _selectedColorIndex = selectedIndex;
                          });
                        },
                        variants: widget.product.variants!,
                      );
                    },
                  );
                } else {
                  print('Beli');
                }
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32)),
              child: Text(
                'Beli',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (widget.product.variants!.isNotEmpty) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return VariantModal(
                          selectedColorIndex: _selectedColorIndex,
                          onColorSelected: (int selectedIndex) {
                            setState(() {
                              _selectedColorIndex = selectedIndex;
                            });
                          },
                          variants: widget.product.variants!,
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Berhasil dimasukkan ke keranjang"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 16)),
                child: Text(
                  '+Keranjang',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
