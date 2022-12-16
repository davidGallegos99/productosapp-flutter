import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/services/push_notification_service.dart';

class ProductsService extends ChangeNotifier {
  final String _baseurl = 'flutter-products-51550-default-rtdb.firebaseio.com';

  bool isLoading = false;
  List<Product> products = [];
  late Product selectedProduct;
  File? selectedImage;
  String imgOpt = '';

  clearProduct() {
    selectedProduct =
        Product(available: false, name: '', price: 0, picture: '', id: null);
  }

  ProductsService() {
    getAllProducts();
  }

  Future getAllProducts({bool pullToRefresh = false}) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseurl, '/products.json');
    final res = await http.get(url);
    if (res.body == "null") {
      isLoading = false;
      notifyListeners();
      return;
    }

    final Map<String, dynamic> productsMap = jsonDecode(res.body);
    if (pullToRefresh) products.clear();
    productsMap.forEach((key, value) {
      final objeto = Product.fromMap(value);
      objeto.id = key;
      products.add(objeto);
    });
    products = products.reversed.toList();
    isLoading = false;
    notifyListeners();
  }

  Future updateOrCreate(Product data) async {
    isLoading = true;
    notifyListeners();

    if (data.id == null) {
      // Crear
      await crear(data);
      await PushNotificationService.sendPushNotification();
    } else {
      // ACtualizar
      await update(data);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String> update(Product data) async {
    final url = Uri.https(_baseurl, '/products/${data.id}.json');
    await http.put(url, body: data.toJson());
    final index = products.indexWhere((element) => element.id == data.id);
    products[index] = data;
    return data.id!;
  }

  Future<bool> delete(String id) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseurl, '/products/$id.json');
    final res = await http.delete(url);
    if (res.statusCode != 200) return false;
    final index = products.indexWhere((element) => element.id == id);
    products.removeAt(index);
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<String> crear(Product data) async {
    final url = Uri.https(_baseurl, '/products.json');
    final res = await http.post(url, body: data.toJson());
    final producto = data;
    producto.id = jsonDecode(res.body)['name'];
    products = [producto, ...products];

    return data.id!;
  }

  updateSelectedImage(String url) {
    selectedImage = File.fromUri(Uri(path: url));
    notifyListeners();
  }

  Future<String?> uploadImg() async {
    if (selectedImage == null) return null;
    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/dhc2woszw/image/upload?upload_preset=n64jgeer");
    final uploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', selectedImage!.path);

    uploadRequest.files.add(file);

    final stream = await uploadRequest.send();
    final resp = await http.Response.fromStream(stream);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    final decodedData = jsonDecode(resp.body);
    selectedImage = null;

    return decodedData['secure_url'];
  }
}
