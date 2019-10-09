import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  var _items = <Product>[];
  final String authToken;

  Products(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((p) => p.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://flutter-update-852f8.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://flutter-update-852f8.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite,
            },
          ));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('$error');
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((p) => p.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-update-852f8.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode(
            {
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
              'isFavorite': newProduct.isFavorite,
            },
          ));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update-852f8.firebaseio.com/products/$id.json?auth=$authToken';
    final exisitingProductIndex = _items.indexWhere((p) => p.id == id);
    var existingProduct = _items[exisitingProductIndex];

    _items.removeAt(exisitingProductIndex);
    notifyListeners();

    final resp = await http.delete(url);

    if (resp.statusCode >= 400) {
      _items.insert(exisitingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Cold not delete product.');
    }
    existingProduct = null;
  }
}
