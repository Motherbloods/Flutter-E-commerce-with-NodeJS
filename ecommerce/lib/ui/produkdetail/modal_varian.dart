import 'dart:convert';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/variants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VariantModal extends StatefulWidget {
  final int selectedColorIndex;
  final Function(int) onColorSelected;
  final List<Variants> variants;
  final Product products;

  const VariantModal(
      {required this.selectedColorIndex,
      required this.onColorSelected,
      required this.variants,
      required this.products});

  @override
  _VariantModalState createState() => _VariantModalState();
}

Future<void> _addToCart(
    BuildContext context, Variants variant, int jumlah, Product product) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cartItems = prefs.getStringList('cart') ?? [];

  // Cek apakah produk dengan ID yang sama sudah ada di keranjang
  int existingIndex = cartItems.indexWhere((item) {
    Map<String, dynamic> itemMap = jsonDecode(item);
    return itemMap['id'] == variant.id;
  });

  if (existingIndex != -1) {
    Map<String, dynamic> itemMap = jsonDecode(cartItems[existingIndex]);
    if (itemMap['jumlah'] == jumlah) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Produk sudah ada di keranjang'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      itemMap['jumlah'] = jumlah;
      cartItems[existingIndex] = jsonEncode(itemMap);
      await prefs.setStringList('cart', cartItems);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Berhasil'),
            content: Text('Jumlah produk di keranjang berhasil diperbarui'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } else {
    // Jika produk dengan ID yang sama belum ada di keranjang, tambahkan ke keranjang
    Map<String, dynamic> variantMap = {
      'productId': product.id,
      'variantId': variant.id,
      'name': product.name,
      'price': variant.price,
      'imageUrl': variant.imageUrl,
      'jumlah': jumlah,
      'sellerName': product.sellerName, // Menambahkan sellerName
      'sellerId': product.sellerId,
      'variant': product.variants?.map((v) => v.toJson()).toList()
    };

    cartItems.add(jsonEncode(variantMap));
    await prefs.setStringList('cart', cartItems);
    // Tampilkan dialog sukses dan tutup halaman modal_variant
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil'),
          content: Text('Produk berhasil dimasukkan ke keranjang'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                Navigator.of(context).pop(); // Menutup halaman modal_variant
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _VariantModalState extends State<VariantModal> {
  late int _selectedColorIndex;
  List<Variants>? variants; // No need for late
  String? sellerName;
  String? sellerId;

  int _counter = 1; // Mulai dari 1

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementOrDelete() {
    setState(() {
      if (_counter == 1) {
        _counter = 0; // Menghapus (mengatur ke 0)
      } else if (_counter > 1) {
        _counter--; // Mengurangi nilai
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedColorIndex = widget.selectedColorIndex;
    variants = widget.variants;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        var url = dotenv.env['URL'];
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Varian produk', style: TextStyle(fontSize: 18)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Image.network(
                      '${variants![_selectedColorIndex].imageUrl}',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variants![_selectedColorIndex]
                            .name!), // Menampilkan nama varian yang dipilih
                        Text('Rp${variants![_selectedColorIndex].price!}',
                            style: TextStyle(
                                fontSize:
                                    18)), // Menampilkan harga varian yang dipilih
                        Text('Stok: 1.140'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Varian:', style: TextStyle(fontSize: 16)),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children:
                      List<Widget>.generate(variants!.length, (int index) {
                    final variant = variants![index];
                    return ChoiceChip(
                      label: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(variant.name!),
                          Text('Rp${variant.price}'),
                        ],
                      ),
                      selected: _selectedColorIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedColorIndex = selected ? index : 0;
                        });
                        widget.onColorSelected(_selectedColorIndex);
                      },
                    );
                  }).toList(),
                ),
                Text('Jumlah: '),
                Row(
                  children: [
                    SizedBox(width: 10),
                    IconButton(
                      icon: _counter == 1
                          ? Icon(Icons.delete)
                          : Icon(Icons.remove),
                      onPressed: _decrementOrDelete,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$_counter',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _incrementCounter,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
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
                    // Add your onPressed code here!
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32),
                  ),
                  child: Text(
                    'Beli',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addToCart(context, variants![_selectedColorIndex],
                        _counter, widget.products);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    '+ Keranjang',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
