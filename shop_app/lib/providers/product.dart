import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String? token,String? userId) async {
    ///first optimistically change the is favorite and store its old value and change ui
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    ///then we change the value on the server

    final url = Uri.parse(
        "https://my-shop-application-e7db7-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token");
    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException("an error occurred, could not mark as favorite");
    }
  }
}
