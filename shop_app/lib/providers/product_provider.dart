import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
  ];
  String? authToken;
  String? userId;

  Products(this.authToken, this.userId,this._items);
  void updateUser(String? token, String? id) {
    this.userId = id;
    this.authToken = token;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          "https://my-shop-application-e7db7-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://my-shop-application-e7db7-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken");
    var existingProductIndex = _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];

    ///i first remove the item but keep a reference to it
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    ///i will handel any error greater than 400
    if (response.statusCode >= 400) {
      ///if it didn't work, i reinsert the product was deleted
      ///but this catch error wont work eventho we do catch an error, and thats
      ///because the delete method in flutter doesnt throw tatus codes
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could Not delete Product");
    }

    ///if the deletion was successful i remove that reference
    existingProduct.dispose();
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString = filterByUser? 'https://my-shop-application-e7db7-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"' :
    'https://my-shop-application-e7db7-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    final url = Uri.parse(filterString);
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      final List<Product> loadedProducts = [];
      if(extractedData!.length == 0){
        print('null');
        _items = [];
        return;
      }
      /// get favorites
      final favoriteResponse = await http.get(Uri.parse("https://my-shop-application-e7db7-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken"));
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        Product product = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            ///here we check if the response has any entries, if it doesnt have
            ///we return false, if it has entries but no entry for the specific product id
            ///we return also false, the last check is done using the ?? operator
            isFavorite: favoriteData == null? false : favoriteData[prodId]??false);
        loadedProducts.insert(0, product);
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://my-shop-application-e7db7-default-rtdb.firebaseio.com/products.json?auth=$authToken");
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description,
          id: json.decode(response.body)['name']);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
