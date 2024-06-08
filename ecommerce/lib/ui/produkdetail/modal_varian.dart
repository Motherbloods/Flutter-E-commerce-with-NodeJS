import 'package:flutter/material.dart';

class VariantModal extends StatefulWidget {
  final int selectedColorIndex;
  final Function(int) onColorSelected;

  const VariantModal({
    required this.selectedColorIndex,
    required this.onColorSelected,
  });

  @override
  _VariantModalState createState() => _VariantModalState();
}

class _VariantModalState extends State<VariantModal> {
  late int _selectedColorIndex;
  final List<String> colorOptions = ['Red', 'blue', 'green'];

  @override
  void initState() {
    super.initState();
    _selectedColorIndex = widget.selectedColorIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
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
                      'https://via.placeholder.com/100',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WAVE-BLACK'),
                        Text('Rp132.500', style: TextStyle(fontSize: 18)),
                        Text('Stok: 1.140'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Warna:', style: TextStyle(fontSize: 16)),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children:
                      List<Widget>.generate(colorOptions.length, (int index) {
                    return ChoiceChip(
                      label: Text(colorOptions[index]),
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
                    // Add your onPressed code here!
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
