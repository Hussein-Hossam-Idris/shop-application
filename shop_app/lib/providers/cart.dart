import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.productId});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void increaseItemCount(String productId) {
    _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            quantity: existingItem.quantity + 1,
            price: existingItem.price,
            productId: existingItem.productId));
    notifyListeners();
  }

  void decreaseItemCount(String productId) {
    if (_items[productId]!.quantity <= 1) return;
    _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            quantity: existingItem.quantity - 1,
            price: existingItem.price,
            productId: existingItem.productId));
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    // if (_items.containsKey(productId)) {
    //   /// change quantity of entry
    //   _items.update(
    //       productId,
    //       (existingCartItem) => CartItem(
    //           id: existingCartItem.id,
    //           title: existingCartItem.title,
    //           quantity: existingCartItem.quantity + 1,
    //           price: existingCartItem.price,
    //           productId: productId));
    // } else {
    //   _items.putIfAbsent(
    //       productId,
    //       () => CartItem(
    //           id: DateTime.now().toString(),
    //           title: title,
    //           quantity: 1,
    //           price: price,
    //           productId: productId));
    // }
    _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price,
            productId: productId));
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
