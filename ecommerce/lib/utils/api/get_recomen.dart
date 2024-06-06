import 'package:ecommerce/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Product>> getProducts(String token) async {
  final api = dotenv.env['URL'] ?? '';
  String url = '${api}/api/home';

  var data = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    },
  );
  var jsonData = json.decode(data.body);
  List<Product> products = [];
  for (var item in jsonData) {
    products.add(Product.fromJson(item));
  }
  return products;
}
