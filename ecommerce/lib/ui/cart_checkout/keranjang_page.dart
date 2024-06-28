import 'package:ecommerce/models/variants.dart';
import 'package:ecommerce/ui/cart_checkout/checkout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List<Map<String, dynamic>> _cart = [];
  List<bool> isSelectedList = [];
  List<String> _checkout = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cart');

    if (cartItems != null) {
      _cart = cartItems
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
      isSelectedList = List.filled(_cart.length, false);
    }
    setState(() {});
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = _cart.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('cart', cartItems);
  }

  Future<void> _deleteCart(int index) async {
    if (_cart.isNotEmpty && index >= 0 && index < _cart.length) {
      setState(() {
        _cart = _cart.toList()..removeAt(index);
        isSelectedList = isSelectedList.toList()..removeAt(index);
      });
      await _saveCart();
    }
  }

  double _calculateTotal() {
    double total = 0.0;
    for (int i = 0; i < _cart.length; i++) {
      if (isSelectedList[i]) {
        final item = _cart[i];
        final price = item['price'] as double;
        final quantity = item['jumlah'] as int;
        total += price * quantity;
      }
    }
    return total;
  }

  void _checkoutPage() {
    List<Map<String, dynamic>> selectedItems = [];
    for (int i = 0; i < _cart.length; i++) {
      if (isSelectedList[i]) {
        final item = _cart[i];
        final selectedVariant = item['variant']
            .firstWhere((variant) => variant['_id'] == item['variantId']);
        final selectedItem = {
          ...item,
          'variant': [
            {
              '_id': selectedVariant['_id'],
              'name': selectedVariant['name'],
              'price': selectedVariant['price'],
              'stock': selectedVariant['stock'],
              'imageUrl': selectedVariant['imageUrl']
            }
          ]
        };
        selectedItems.add(selectedItem);
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(product: selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: _cart.isNotEmpty
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _cart.length,
                      itemBuilder: (context, index) {
                        final item = _cart[index];
                        List<Map<String, dynamic>> variants =
                            List<Map<String, dynamic>>.from(item['variant']);
                        Map<String, dynamic>? selectedVariant;
                        selectedVariant = variants.firstWhere(
                          (variant) {
                            // print(
                            //     '${variant['_id']} == ${item['variantId']}: ${variant['_id'] == item['variantId']}');

                            return variant['_id'] == item['variantId'];
                          },
                          orElse: () => <String, dynamic>{},
                        );

                        List<DropdownMenuItem<Map<String, dynamic>>>
                            dropdownItems = variants.map((variant) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: variant,
                            child: Text(
                                '${variant['name']} - Rp ${variant['price']}'),
                          );
                        }).toList();
                        return Stack(
                          children: [
                            //produk
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelectedList[index],
                                      onChanged: (value) {
                                        setState(() {
                                          isSelectedList[index] = value!;
                                        });
                                        // Lakukan operasi lain jika diperlukan
                                      },
                                    ),
                                    Container(
                                      height: 100,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.network(item['imageUrl']),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        DropdownButton<Map<String, dynamic>>(
                                            value: selectedVariant,
                                            items: dropdownItems,
                                            onChanged: (Map<String, dynamic>?
                                                newValue) {
                                              setState(() {
                                                selectedVariant = newValue;
                                                item['variantId'] =
                                                    newValue!['_id'];
                                                item['price'] =
                                                    newValue['price'];
                                                item['imageUrl'] =
                                                    newValue['imageUrl'];
                                                // Lakukan operasi lain jika diperlukan
                                              });
                                            },
                                            hint: Text('halo')),
                                        Text(
                                          item['sellerName'] ??
                                              'Seller Name', // Ganti dengan sellerName dari item
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Rp. ${item['price']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              right: 35,
                              bottom: 35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () => _deleteCart(index),
                                      child: Text('Hapus'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              item['jumlah'] =
                                                  (item['jumlah'] ?? 0) + 1;
                                            });
                                            // Simpan perubahan ke SharedPreferences
                                            _saveCart();
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${item['jumlah']}', // Ganti dengan jumlah item dari item
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: (item['jumlah'] ?? 0) <= 1
                                              ? Icon(Icons.delete)
                                              : Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (item['jumlah'] == 1) {
                                                _cart.removeAt(index);
                                              } else {
                                                item['jumlah'] =
                                                    (item['jumlah'] ?? 0) - 1;
                                              }
                                            });
                                            // Simpan perubahan ke SharedPreferences
                                            _saveCart();
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: Text('Keranjang Kosong'),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total : ', style: TextStyle(color: Colors.black)),
                Text(
                  'Rp ${_calculateTotal().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: _checkoutPage,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 16)),
                child: Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
