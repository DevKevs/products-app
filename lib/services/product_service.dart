// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseURL = 'flutter-proyects-1b9d4-default-rtdb.firebaseio.com';
  late Product selectedProduct;
  final List<Product> products = [];
  final storage = const FlutterSecureStorage();
  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(
      _baseURL,
      'products.json',
      {'auth': await storage.read(key: 'idToken')},
    );
    final response = await http.get(url);

    final Map<String, dynamic> productsMap = jsonDecode(response.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrUpdate(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(
      _baseURL,
      'products/${product.id}.json',
      {'auth': await storage.read(key: 'idToken')},
    );
    final response = await http.put(url, body: product.toRawJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return response.body;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(
      _baseURL,
      'products.json',
      {'auth': await storage.read(key: 'idToken')},
    );
    final response = await http.post(url, body: product.toRawJson());

    final decodedData = jsonDecode(response.body);

    product.id = decodedData['name'];

    products.add(product);

    return product.id!;
  }

  void updateSelectedPicture(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dkejwgw1n/image/upload?upload_preset=tx9bah2f');

    final uploadRequest = http.MultipartRequest('POST', url);

    final uploadFile =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    uploadRequest.files.add(uploadFile);

    final streamResponse = await uploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    print(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('algo salio mal');
      print(response.body);
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(response.body);
    return decodedData['secure_url'];
  }
}
