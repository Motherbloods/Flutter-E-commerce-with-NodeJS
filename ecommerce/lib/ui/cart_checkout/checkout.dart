import 'package:ecommerce/models/diskon.dart';
import 'package:ecommerce/utils/api/get_tarif.dart';
import 'package:ecommerce/utils/api/get_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> product;

  CheckoutPage({required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Future<Map<String, dynamic>> userFuture;

  List<Discount> discounts = [
    Discount(name: 'Diskon Potongan 10ribu', price: '10', minTotal: 100),
    Discount(name: 'Diskon 100k', price: '25%', minTotal: 10000),
  ];
  Discount? selectedDiscount;
  List<Map<String, dynamic>> data = [
    {
      'code': 'jne',
      'name': 'JNE Express',
      'service': 'REG',
      'type': 'Document/Paket',
      'price': '11000',
      'estimated': '1-2 hari'
    },
    {
      'code': 'sicepat',
      'name': 'SiCepat',
      'service': 'GOKIL',
      'type': 'Cargo (minimal 10Kg)',
      'price': '50000',
      'estimated': '2 - 3 hari'
    },
    {
      'code': 'jne',
      'name': 'JNE Express',
      'service': 'OKE',
      'type': 'Document/Paket',
      'price': '10000',
      'estimated': '2-3 hari'
    }
  ];
  String? selectedValue;
  String? selectedPrice;
  String? estimatedDelivery;

  @override
  void initState() {
    super.initState();
    userFuture = _loadUser();
  }

  Future<Map<String, dynamic>> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId')!;
    selectedValue =
        '${data[0]['name']} - ${data[0]['price']} - ${data[0]['estimated']}';
    selectedPrice = data[0]['price'];
    estimatedDelivery = calculateEstimatedDelivery(data[0]['estimated']);
    return await getUser(userId);
  }

  String calculateEstimatedDelivery(String estimated) {
    // Parsing estimated delivery days
    final range = estimated
        .split('-')
        .map((e) => int.tryParse(e.trim().split(' ')[0]) ?? 0)
        .toList();
    final now = DateTime.now();
    final format = DateFormat('dd MMM');

    if (range.length == 2) {
      final start = now.add(Duration(days: range[0]));
      final end = now.add(Duration(days: range[1]));
      return '${format.format(start)} - ${format.format(end)}';
    } else if (range.length == 1) {
      final start = now.add(Duration(days: range[0]));
      return format.format(start);
    }
    return estimated; // default if parsing fails
  }

  double _calculateTotal() {
    double total = 0.0;
    for (int i = 0; i < widget.product.length; i++) {
      final item = widget.product[i];
      final price = item['price'] as double;
      final quantity = item['jumlah'] as int;
      total += price * quantity;
    }
    return total;
  }

  // double _calculateTotalWithDiscount() {
  //   double total = _calculateTotal();
  //   if (selectedDiscount != null) {
  //     if (selectedDiscount!.price.endsWith('%')) {
  //       double discountPercentage = double.parse(selectedDiscount!.price
  //               .substring(0, selectedDiscount!.price.length - 1)) /
  //           100;
  //       total = total - (total * discountPercentage);
  //     } else {
  //       double discountAmount = double.parse(selectedDiscount!.price);
  //       total = total - discountAmount;
  //     }
  //   }
  //   return total;
  // }
  // double _calculateTotalWithDiscount() {
  //   double total = _calculateTotal();

  //   if (selectedDiscount != null) {
  //     if (total >= selectedDiscount!.minTotal) {
  //       if (selectedDiscount!.price.endsWith('%')) {
  //         double discountPercentage = double.parse(selectedDiscount!.price
  //                 .substring(0, selectedDiscount!.price.length - 1)) /
  //             100;
  //         total = total - (total * discountPercentage);
  //       } else {
  //         double discountAmount = double.parse(selectedDiscount!.price);
  //         total = total - discountAmount;
  //       }
  //     }
  //   }
  //   return total;
  // }
  double _calculateTotalWithDiscount() {
    double total = _calculateTotal();
    int productCount = widget.product.length;

    if (selectedDiscount != null) {
      if (total >= selectedDiscount!.minTotal) {
        if (selectedDiscount!.price.endsWith('%')) {
          double discountPercentage = double.parse(selectedDiscount!.price
                  .substring(0, selectedDiscount!.price.length - 1)) /
              100;
          total = total - (total * discountPercentage);
        } else {
          double discountAmount = double.parse(selectedDiscount!.price);
          total = total - (discountAmount * productCount);
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final user = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.product.length,
                        itemBuilder: (context, index) {
                          final item = widget.product[index];
                          final variant = item['variant'][0];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index ==
                                  0) // Menambahkan informasi alamat pengiriman hanya sekali di awal
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Alamat Pengiriman',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(
                                        '${user['fullName'] ?? user['username']} | ${user['noHP'] ?? ''}'),
                                    Text(
                                        '${user['alamat'][0]['alamat'].toUpperCase() ?? ''}'),
                                    Text(
                                        'KEC. ${user['alamat'][1]['kecamatanId'].toUpperCase()} - KAB. ${user['alamat'][1]['kabupatenId'].toUpperCase()}, ${user['alamat'][1]['provinsiId']}, ID 60124'),
                                  ],
                                ),
                              Row(
                                children: <Widget>[
                                  Image.network(
                                    item[
                                        'imageUrl'], // Replace with your product image URL
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(item['name']),
                                        Text(variant['name']),
                                        SizedBox(height: 5),
                                        Text('Rp. ${item['price'].toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Opsi Pengiriman',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              DropdownButton<String>(
                                hint: Text('Pilih Tarif'),
                                value: selectedValue,
                                items: data.map((tarif) {
                                  String dropdownValue =
                                      '${tarif['name']} - ${tarif['price']} - ${tarif['estimated']}';
                                  return DropdownMenuItem<String>(
                                    value: dropdownValue,
                                    child: Text(dropdownValue),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value!;
                                    selectedPrice = data.firstWhere((tarif) =>
                                        '${tarif['name']} - ${tarif['price']} - ${tarif['estimated']}' ==
                                        value)['price'];
                                    estimatedDelivery = calculateEstimatedDelivery(
                                        data.firstWhere((tarif) =>
                                            '${tarif['name']} - ${tarif['price']} - ${tarif['estimated']}' ==
                                            value)['estimated']);
                                  });
                                },
                              ),
                              Text('Rp$selectedPrice'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Akan diterima pada tanggal $estimatedDelivery',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Pesan',
                                hintText: 'Silakan tinggalkan pesan...',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              'Total Pesanan (${widget.product.length} Produk):'),
                          Text(
                              'Rp ${_calculateTotalWithDiscount().toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          // DropdownButton<Discount>(
                          //   hint: Text('Pilih Diskon'),
                          //   value: selectedDiscount,
                          //   onChanged: (Discount? newValue) {
                          //     setState(() {
                          //       selectedDiscount = newValue!;
                          //     });
                          //   },
                          //   items: discounts
                          //       .map<DropdownMenuItem<Discount>>(
                          //           (Discount discount) {
                          //     return DropdownMenuItem<Discount>(
                          //       value: discount,
                          //       child: Text(
                          //           '${discount.name} (${discount.price})'),
                          //     );
                          //   }).toList(),
                          // ),
                          DropdownButton<Discount>(
                            hint: Text('Pilih Diskon'),
                            value: selectedDiscount,
                            onChanged: (Discount? newValue) {
                              setState(() {
                                selectedDiscount = newValue;
                              });
                            },
                            items: discounts.map<DropdownMenuItem<Discount>>(
                                (Discount discount) {
                              bool meetMinTotal =
                                  _calculateTotal() >= discount.minTotal;
                              return DropdownMenuItem<Discount>(
                                value: discount,
                                child: Text(
                                    '${discount.name} (${discount.price})'),
                                enabled: meetMinTotal,
                              );
                            }).toList(),
                            isExpanded: true,
                            disabledHint:
                                Text('Total pesanan tidak memenuhi minimal'),
                          ),
                          // TextField(
                          //   decoration: InputDecoration(
                          //     labelText: 'Voucher',
                          //     hintText: 'Gunakan/ masukkan kode',
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Pilih Metode Pembayaran'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                            'Pakai ShopeePay & nikmati checkout lebih cepat!',
                            style: TextStyle(color: Colors.orange)),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
