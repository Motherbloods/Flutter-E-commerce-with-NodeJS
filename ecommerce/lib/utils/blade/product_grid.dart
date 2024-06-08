import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/seller.dart';
import 'package:ecommerce/ui/produkdetail/produkdetail_page.dart';
import 'package:ecommerce/ui/produk&seller/seller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductGrid extends StatelessWidget {
  final Seller? seller;
  final List<Product> products;
  final ScrollController? scrollController;
  final isLoading;
  final recomen;
  final search;

  const ProductGrid({
    Key? key,
    this.seller,
    this.search,
    this.scrollController,
    this.isLoading,
    this.recomen,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.builder(
        controller: scrollController,
        itemCount: recomen == true
            ? (products.length + (isLoading ? 1 : 0))
            : (search == true ? products.length : 4),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 288,
        ),
        itemBuilder: (context, index) {
          if (recomen == true) {
            if (index == products.length) {
              return Center(child: CircularProgressIndicator());
            }
          }
          final productData = products[index];
          final formattedPrice = NumberFormat.currency(
            locale: 'id_ID',
            decimalDigits: 0,
            symbol: 'Rp ',
          ).format(productData.price);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: productData),
                ),
              );
            },
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 50,
                    spreadRadius: 7,
                    offset: const Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // Gambar
                  Container(
                    height: 180,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Image.network(
                          'http://192.168.43.41:8000${productData.imageUrl}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Failed to load image',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        Positioned(
                          top: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: const Text(
                              '25%',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Detail
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${productData.name}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigasi ke halaman semua produk
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SellerPage(
                                        sellerId:
                                            productData.sellerId.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  seller?.namaToko! ?? productData.sellerName!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 14,
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  formattedPrice,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text('${productData.totalUnitsSold} terjual')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
