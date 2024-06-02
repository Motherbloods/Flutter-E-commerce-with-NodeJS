import 'package:ecommerce/ui/produkdetail/deskripsi.dart';
import 'package:ecommerce/ui/produkdetail/reviews.dart';
import 'package:flutter/material.dart';

class ProdukDetail extends StatefulWidget {
  const ProdukDetail({Key? key}) : super(key: key);

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  int currentImage = 0;
  int _selectedTabIndex = 0;
  final List<String> images = [
    'https://picsum.photos/id/21/1280/853',
    'https://picsum.photos/id/22/1280/853',
    'https://picsum.photos/id/23/1280/853',
  ];

  @override
  Widget build(BuildContext context) {
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
                  itemCount: images.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentImage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: images[index],
                      child: Image.network(images[index]),
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
                        const Text(
                          'Nama produk',
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
                                const Text(
                                  'Rp 350.000',
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
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Seller: ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  TextSpan(
                                    text: 'Toko',
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
                        const SizedBox(height: 20),
                        _selectedTabIndex == 0 ? Deskripsi() : Reviews()
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
