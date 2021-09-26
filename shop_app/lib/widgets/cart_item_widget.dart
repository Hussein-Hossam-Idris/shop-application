import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String title;
  final String productId;
  final String id;
  final double price;
  final int quantity;

  CartItemWidget(
      {required this.title,
      required this.productId,
      required this.id,
      required this.price,
      required this.quantity});
  @override
  Widget build(BuildContext context) {
    final String imageUrl;
    final cart = Provider.of<Cart>(context);
    imageUrl = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((element) => element.id == productId)
        .imageUrl;
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      ///in case you want to do different function based on direction
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm Delete?'),
              content: Text('Press Yes to remove item from the cart'),
              elevation: 5,
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop(false);
                }, child: Text('No')),
                TextButton(onPressed: () {
                  Navigator.of(context).pop(true);
                }, child: Text('Yes'))
              ],
            );
          },
        );
      },
      background: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              )
            ],
          )),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                    height: 100,
                    width: 100,
                  ),
                ),
                Column(
                  children: [
                    Text(title),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            cart.decreaseItemCount(productId);
                          },
                          icon: Icon(Icons.remove_circle),
                          color: Colors.red,
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          onPressed: () {
                            cart.increaseItemCount(productId);
                          },
                          icon: Icon(Icons.add_circle),
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ],
                ),
                Text("\$${(price * quantity).toStringAsFixed(2)}")
              ],
            ),
          )),
    );
  }
}
