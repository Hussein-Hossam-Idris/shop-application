import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders extends ChangeNotifier{
  List<OrderItem> _orders = [];
  
  List<OrderItem> get orders {
    return [..._orders];
  }
  
  void addOrder(List<CartItem> cartProducts, double total){
    _orders.insert(0, OrderItem(DateTime.now().toString(), total, cartProducts, DateTime.now()));
    notifyListeners();
  }

}