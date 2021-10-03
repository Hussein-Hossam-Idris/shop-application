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

class _OrderItemWidgetState extends State<OrderItemWidget> with SingleTickerProviderStateMixin{
  var _expanded = false;
  late AnimationController _controller;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _iconAnimation = Tween<double>(
      begin: 1.0,end: 0.0,
    ).animate(_controller);
    super.initState();
  }

  void _changeIcon(){
    _expanded? _controller.reverse() : _controller.forward();
    setState(() {
      _expanded  = !_expanded;
    });
  }

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
              icon: AnimatedIcon(
              icon: AnimatedIcons.arrow_menu,
              progress: _iconAnimation,
            ),
              onPressed: _changeIcon,
            ),
            // trailing: IconButton(
            //   icon: _expanded? Icon(Icons.expand_less):Icon(Icons.expand_more),
            //   onPressed: (){
            //     setState(() {
            //       _expanded = !_expanded;
            //     });
            //   },
            // ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _expanded? widget.orderItem.products.length * 40 + 40 : 0,
            padding: EdgeInsets.all(20),
            child: ListView(
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
            )
          )
        ],
      ),
    );
  }
}
