import 'package:flutter/material.dart';

class Deskripsi extends StatefulWidget {
  const Deskripsi({super.key});

  @override
  State<Deskripsi> createState() => _DeskripsiState();
}

class _DeskripsiState extends State<Deskripsi> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '''
        Sneakers Klasik dengan Sentuhan Modern

        Langkah dengan gaya yang tak tertandingi dengan Sepatu Sneakers Klasik kami, diciptakan untuk mereka yang mengutamakan kenyamanan dan gaya. Dirancang dengan perpaduan sempurna antara keandalan tradisional dan sentuhan modern yang inovatif, sepatu ini akan menambah kesan trendi pada setiap langkah Anda.

        Fitur Utama:
        1. Desain Klasik
        2. Kenyamanan Sepanjang Hari
        3. Tahan Lama
        4. Gaya Serbaguna

        Spesifikasi:
        - Bahan: Kulit sintetis premium
        - Warna: Hitam, Putih, Abu-abu
        - Ukuran: Tersedia dalam berbagai ukuran mulai dari 36 hingga 45
        - Desain Sol: Karet anti-slip untuk traksi yang optimal

        Dapatkan Sepatu Sneakers Klasik kami sekarang dan buat langkah Anda menjadi pusat perhatian dengan gaya yang tak tertandingi!
        ''',
          maxLines: _isExpanded ? null : 4,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Baca Lebih Sedikit' : 'Baca Selengkapnya',
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }
}
