import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_widget.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (context, index) {
          return OrderItemWidget(orders.orders[index]);
        },
      ),
    );
  }
}
