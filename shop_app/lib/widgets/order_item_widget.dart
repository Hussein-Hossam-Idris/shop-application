import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemWidget(this.orderItem);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text("Order Date : ${DateFormat('yyyy-MM-dd').format(widget.orderItem.dateTime)}"),
            trailing: IconButton(
              icon: _expanded? Icon(Icons.expand_less):Icon(Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded)Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ...widget.orderItem.products.map((product){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.title, style: TextStyle(
                        fontSize: 18,
                      ),),
                      Text('${product.quantity}x  \$${product.price}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey
                      ),),
                    ],
                  );
                }).toList()
              ],
            ),
          )
        ],
      ),
    );
  }
}
