import 'package:ecommerce/models/ulasan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Reviews extends StatefulWidget {
  final List<Ulasan>? reviews;

  Reviews({this.reviews});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return widget.reviews!.isEmpty
        ? Center(child: Text('Belum ada Ulasan untuk produk ini!'))
        : Column(children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: false,
              itemCount: widget.reviews!.length,
              itemBuilder: (context, index) {
                final review = widget.reviews![index];
                final url = dotenv.env['URL'] ?? '';
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review.review!),
                                    Text(review.userId!)
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: 10), // Spasi antara teks dan gambar
                              // Menampilkan gambar untuk setiap URL dalam daftar 'picture'
                              for (String pictureUrl in review.picture!)
                                Image.network(
                                  '$url$pictureUrl',
                                  width: 50,
                                  height: 50,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Center(
              child: ElevatedButton(
                child: Text('Lihat Ulasan Lengkap'),
                onPressed: () {},
              ),
            )
          ]);
  }
}
