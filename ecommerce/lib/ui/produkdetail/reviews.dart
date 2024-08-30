import 'package:ecommerce/models/ulasan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class Reviews extends StatefulWidget {
  final List<Ulasan>? reviews;

  Reviews({this.reviews});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return widget.reviews!.isEmpty || widget.reviews == null
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
                final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
                final String formattedDate = formatter.format(review.date!);
                // return Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Row(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Expanded(
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Text(review.review!),
                //                     Text(review.userId!)
                //                   ],
                //                 ),
                //               ),
                //               SizedBox(
                //                   width: 10), // Spasi antara teks dan gambar
                //               // Menampilkan gambar untuk setiap URL dalam daftar 'picture'
                //               for (String pictureUrl in review.picture!)
                //                 Image.network(
                //                   '$url$pictureUrl',
                //                   width: 50,
                //                   height: 50,
                //                 ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // );
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //info User, date
                        Row(
                          children: [
                            for (String pictureUrl in review.picture!)
                              ClipOval(
                                child: Image.network(
                                  pictureUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userId!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                        //Rating
                        SizedBox(height: 10),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(Icons.star, color: Colors.yellow),
                          ),
                        ),
                        //Review
                        SizedBox(height: 10),
                        Text(review.review!)
                      ],
                    ),
                  ),
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
