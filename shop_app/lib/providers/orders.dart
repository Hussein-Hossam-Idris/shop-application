import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders extends ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        "https://my-shop-application-e7db7-default-rtdb.firebaseio.com/orders.json");
    try {
      final response = await http.get(url);
      final List<OrderItem> tempOrders = [];
      final Map<String,dynamic>? extractedResponse =
      json.decode(response.body);
      if(extractedResponse == null){
        _orders = [];
        return;
      }
      extractedResponse.forEach((orderId, orderData) {
        tempOrders.add(
            OrderItem(
                orderId,
                double.parse(orderData['amount']),
                (orderData['products'] as List<dynamic>)
                    .map((cartItem) {
                      return CartItem(
                        id: cartItem['id'],
                        title: cartItem['title'],
                        quantity: cartItem['quantity'],
                        price: cartItem['price'],
                        productId: cartItem['productId']);}).toList(),
                DateTime.parse(orderData['dateTime'])));
      });
      _orders = tempOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://my-shop-application-e7db7-default-rtdb.firebaseio.com/orders.json");
    try {
      final date = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            "amount": total.toStringAsFixed(2),
            'dateTime': date.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                      'productId': e.productId,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              json.decode(response.body)['name'], total, cartProducts, date));
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
